%% Comments and References
%{ 
	该算法由骆珉完成，考虑一种通过对Watson模型进行降维来实现PH编码的方法。
    该算法依然以 Vishal Monga 的 wavelet 方法为基础上，还是利用对比度掩蔽。但是编码的方法和思想都不同。
	参考文献：
		ROBUST IMAGE HASHING
		《信息隐藏技术实验教程》第八章
	
	源代码整理自：
		mbe_VishalMonga_wavelet
		wavelethash

	use:
		contrastMask
		luminanceMask
		Qa_watson
	    wavelethash.m

	输入图像： 因为用到8*8的DCT，所以需要长宽相等，大小为16的整数倍的 灰度  图 

	params：
		numrects	'Number of random rectangles'
			default: 150
		key			'secret key'
			default: 101 随便指定一个
增加参数：
		method		'两种方法，一种直接分块，一种用密钥产生随机分块（Vishal Monga）'
			default: 1
	
	hash形式： 
		独特定义的hash向量，需要专门的匹配方法： match_zh_descendingDimensionOfWatson
%}
function [hashVector] = mbe_zh_descendingDimensionOfWatson(imagefile,param)
% 关于参数 param，为了保持测试程序的接口一致，所有的算法函数的参数都改为param，在函数内部再根据需要作解析。
%% test: input
%  imagefile = '2.bmp';
%  nargin = 1;
%% check input
if nargin == 1
	numrects = 256;
	key = 101;
    method = 1;
else
% 	numrects = param(4);
% 	key = param(5);
	numrects = 256;
	key = 101;
    method = param(1);
end

I = imread(imagefile);
dim = size(I);
if length(dim) > 2 % 不是灰度图 
	I = rgb2gray(I);
end
%{
想法：
    设想Watson是一个完美的PH算法，它给出的Qa作为hash距离反映了最好的视觉特性。那么，参考它的PH算法将具有与Watson一样的视觉效果。
    但是Watson的计算是同时具有原图和参考图的，d = |(DCTcoefIo - DCTcoefIt)|/T(Io) 。而PH过程却要编码。
    因此，降维和视觉特性的保留将是一对矛盾，存在一个折中的问题。
方法：
    降维的方法：
        因为掩蔽表达的是图像所能够感知的最小变化，加上权值之后，表达所能够容忍的最大变化。
        这样，我们可以考虑使用一个分块中最小的掩蔽或者最大的容限代替整块的掩蔽或容限。
        在进一步，我们也可以考虑使用一个分块中的DC系数，或者最大的DC系数，或者DC系数均值来代替整块的原图特征。
        经过分析和选择，直接使用每块中所有DC系数和DC系数相应位置的掩蔽来代表分块的原图特征和掩蔽特征，然后使用Watson一样的公式进行距离计算。
    分块的方法：
        因为加权或者计算掩蔽的过程是在DCT域完成的，而DCT变换使用8*8的块，也因为敏感度表是8*8的。所以，Hash编码使用的分块和掩蔽计算用的分块可能不一样。
        结合具体的算法考虑分块的处理，但是还是有规律可言。
        规律就是尽量使用矩阵的操作，矩阵大小可能不一样，但是分块逻辑和形式却可能是一样的。
    改进算法：
        1、直接使用降维的信息作为编码
            每个8*8分块里都选取DC系数及其相应的掩蔽；
            对每个hash分块里面选取的DC系数和掩蔽分别取平均；
            最后按照Watson的方法合并误差。
        2、对已有基于整体灰度信息的算法的改进（比如 Vishal Monga ）
            参照直接降维的方法，得到降维之后的DC系数矩阵和掩蔽矩阵。
            然后按照一样的逻辑进入原来的方法。但是要注意原来方法中跟维度相关的内容也要做相应的调整。
%}
I = double(I);
DCTcoefI = blkproc(I,[8,8],@dct2);
contrastThreshold = contrastMask(I,DCTcoefI);
% 分别选取DC系数和相应的掩蔽
descending = @(x)x(1,1);
dDCTcoefI = blkproc(DCTcoefI,[8,8],descending);
dcontrastThreshold = blkproc(contrastThreshold,[8,8],descending);

if method == 1
%% method1
    % 按照16*16个分块划分，得到256的编码
    r = size(I,1)/16;
    c = size(I,2)/16;
    avgfun = @avgblock;
    hashDCTcoef = blkproc(dDCTcoefI,[r/8,c/8],avgfun);
    hashcontrastThreshold = blkproc(dcontrastThreshold,[r/8,c/8],avgfun);
    % hash值为一个结构
    hashVector.hashDCTcoef = hashDCTcoef;
    hashVector.hashcontrastThreshold = hashcontrastThreshold;
elseif method == 2
    [hashDCTcoef,hashcontrastThreshold] = randomBlockMean(dDCTcoefI, dcontrastThreshold, key, numrects);
end
% hash值为一个结构
hashVector.hashDCTcoef = hashDCTcoef;
hashVector.hashcontrastThreshold = hashcontrastThreshold;
    
function [meandDCTcoefI,meandcontrastThreshold] = randomBlockMean(dDCTcoefI, dcontrastThreshold, key, numrects)
% numrects 这个参数可以控制最后hash值的长度
%% Initialization of default parameters
ratio1 = 1/4; ratio2 = 1/8;

xsz = size(dDCTcoefI,2);
ysz = size(dDCTcoefI,1);

totallength = xsz*ysz;
meanlength = round(ratio1*ysz); % Round to nearest integer
varlength = round(ratio2*ysz);	% ratio1 ratio2 是干什么的？ 这个是用来控制方块大小的

hostvecdDCTcoefI = dDCTcoefI(:);
hostvecdcontrastThreshold = dcontrastThreshold(:);

rand('state',key); % 设置产生随机数的方法和种子
rectlengths = ceil(rand(numrects,1)*(2*varlength+1))  + meanlength - varlength - 1;
rectcoors = ceil(rand(numrects,2).*[ysz-rectlengths+1 xsz-rectlengths+1]); % 产生那些随机的方块

%preparing the random linear transformation matrix
T = zeros(numrects,totallength);

%uniform weights in the formation of the transform matrix at this point
for i=1:1:numrects,   
   dummat = zeros(ysz,xsz);
   dummat(rectcoors(i,1):(rectcoors(i,1)+rectlengths(i)-1),rectcoors(i,2):(rectcoors(i,2)+rectlengths(i)-1)) = 1;
   dummat = dummat / sum(sum(dummat)); % 按照方块产生一个掩模 用这个掩模乘以相应位置的系数矩阵，得到就是系数均值
   T(i,:) = (dummat(:))'; % T 的每一行是由系数矩阵降维所得，这样，T 构成了另一个掩模，每一行可以完成一次求系数均值的计算
end;
meandcontrastThreshold = T*hostvecdcontrastThreshold; % 使用掩模来求每一个方块均值
meandDCTcoefI = T*hostvecdDCTcoefI;
% delta = 100;
% meandDCTcoefI = round(avgdDCTcoefI/delta)*delta;  % 除以100 再乘以100 。这个是为了什么？
% meandcontrastThreshold = round(avgdcontrastThreshold/delta)*delta;
return;


