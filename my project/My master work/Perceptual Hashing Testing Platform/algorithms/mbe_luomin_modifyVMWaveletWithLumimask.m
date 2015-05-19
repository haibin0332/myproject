%% Comments and References
%{ 
	该算法由骆珉完成，考虑在 Vishal Monga 的 wavelet 方法的基础上增加亮度、对比度掩蔽或间隙的考虑。
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

	输入图像： 因为用到8*8的DCT，所以需要长宽相等，大小为8的整数倍的  图 

	params：
		wavelet		'Wavelet basis'
			default: db4
		delta		'Quantizer step size'
			default: 100
		level		'Wavelet Decomposition Level'
			default: 3
		numrects	'Number of random rectangles'
			default: 150
		key			'secret key'
			default: 101 随便指定一个
增加参数：
		power		'加权时使用的权重，乘以mask'
			default: 1
	
	hash形式： 
		独特定义的hash向量，需要专门的匹配方法： 
			match_luomin_modifyVMWaveletWithLumimask_Euclidean
			match_luomin_modifyVMWaveletWithLumimask_CountIntersection
%}
function [hashVector] = mbe_luomin_modifyVMWaveletWithLumimask(imagefile,param)
% 关于参数 param，为了保持测试程序的接口一致，所有的算法函数的参数都改为param，在函数内部再根据需要作解析。
%% test: input
%  imagefile = '2.bmp';
%  nargin = 1;
%% check input
if nargin == 1
	wavelet = 'db4';
	delta = 100;
	level = 3;
	numrects = 150;
	key = 101;
	power = 1;
else
% 	wavelet = param(1);
% 	delta = param(2);
% 	level = param(3);
% 	numrects = param(4);
% 	key = param(5);
	wavelet = 'db4';
	delta = 100;
	level = 3;
	numrects = 150;
	key = 101;
	power = param(1);
end

I = imread(imagefile);
dim = size(I);
if length(dim) > 2 % 不是灰度图 
	I = rgb2gray(I);
end
%{
改进的方法： 
	1、针对原图计算亮度、对比度掩蔽或者间隙，称为mask
	2、将原图DCT变换，在DCT域使用mask完成加权，加上或者减去mask（之所以在DCT域完成加权，是因为Watson模型的这些mask都是在DCT域内使用的）
	3、反变换。使用原来的方法分别得到三个编码

    加权的方法：
        plusDCTcoefI = DCTcoefI + contrastThreshold * power;
        minusDCTcoefI = DCTcoefI - contrastThreshold * power;
%}
%{
上面加权的方法是有问题的。
    根据Watson的代码，可以示意其距离公式为：d = |(DCTcoefIo - DCTcoefIt)|/T(Io) 记 (DCTcoefIo - DCTcoefIt) = △I
    则△I表示在容许变化程度为d的情况下，图像内容的变化容限。
    这里之所以取绝对值，是因为在后面合并的时候会取beta次方，而 beta = 4 。
    即使取了绝对值，也并不表示Watson模型的结果满足距离的定义，因为它还是有偏于Io的。结果d_ij ~= d_ji。
    但是有偏这件事情对于容限而言未必是坏事，因为容限本来就应该是相对于Io的。
    因此，变换公式得到，原图的变化容限为：
        △I = d*T(Io)

    基于上述考虑，加权（求取容限）的办法修改为：
    1、根据一个Watson模型的intraclass的实验，得到Watson模型的临界距离dmax。
    2、在0-dmax之内，根据应用的需要选择一个权值d。 代码中 power = d
    3、使用权值d计算△I，
    4、DCTcoefIo +/- △I 表示最大接受变化后的图像

    相应的，加权的概念也变得不是很合适，不如改为求取容限。
        
    而且FT阿，搞了这么久，只是把公式的物理意义解释得更加清楚一些了。具体做法却没有一点点改变。
%}
I = double(I);
DCTcoefI = blkproc(I,[8,8],@dct2);
contrastThreshold = contrastMask(I,DCTcoefI);
% luminanceThreshold = luminanceMask(I,DCTcoefI);
% 加权（求取容限）
deltaI = power * contrastThreshold;
plusDCTcoefI = DCTcoefI + deltaI;
minusDCTcoefI = DCTcoefI - deltaI; 
% 反变换
pI = blkproc(plusDCTcoefI,[8,8],@idct2);
mI = blkproc(minusDCTcoefI,[8,8],@idct2);
%% 计算Hash
hashVec1 = wavelethash(I, wavelet, delta, key, level, numrects);
hashVec2 = wavelethash(pI, wavelet, delta, key, level, numrects);
hashVec3 = wavelethash(mI, wavelet, delta, key, level, numrects);

hashVector = [hashVec1 hashVec2 hashVec3];
% ? 弄个图片试一下，发现这三个hash值之间差别并不大啊 只有一位两位的差别 而且上下还不一样又是为什么？

