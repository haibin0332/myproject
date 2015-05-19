%% Comments and References
%{ 
	本程序试图纠正参考文献的方法的错误：
	纠正的思路为：
		原有方法的问题是加权作用在每个8×8像素的小块上，而且每块加权都一样，这样对全局影响不大，导致加权作用不明显（很弱）
		错误的原因是，Watson模型的方法中，间隙才是表示JND对应的变动的大小，而频率敏感系数只是一个基础而已。
		因此改正的思路是，使用间隙加权，保证每个小块的加权是与小块本身的信息特征相关的。
	参考文献为： 
		一种基于视觉特性的图像摘要算法
		作者秦川，王朔中等
		中国图象图形学报，2006.11第11期  
  
	输入图像： 不定大小的 灰度 图 

	params：
		key		密钥
		N		hash长度
	
	hash形式： 
		binary vector
	调用： 
		param(1) = 1; param(2) = 8;
		h1 = mbe_WangShuoZhong_watsonBased('1.bmp',param)
%}
function [hashVector] = mbe_WangShuoZhong_watsonBased_corrected(imagefile,param)
%% test inputs
nargin = 1;
imagefile = 'E:\DoctorThesis\MBench\Plan\2.bmp';
%% get inputs
if nargin == 1
	key = 1;
	N = 64;
else
	key = param(1);
	N = param(2);
end
I = imread(imagefile);
sizeI = size(I,1);
if sizeI ~= 512 
	I = double(imresize(I,[512,512])); % resize以满足DCT变换，并且简化图像大小不同带来的处理过程
end 
%% DCT变换矩阵
I = blkproc(I,[8 8],@dct2);
% T = dctmtx(8);
% I = blkproc(I, [8 8], 'P1 * x * P2',T,T');
%{
'E:\DoctorThesis\MBench\Plan\outdir\imAttacked\NormalizedOriginalImage\007n.bmp' 
对于上面这个图像，能够看出这两种处理方式还是有不同，后者程序会出错。但是不知道为什么。
%}
%% 根据密钥产生N个与图像I大小相同的伪随机矩阵
randn('seed',key);	% 使用seed，对实验图片，有M和无M产生的结果一样，但是使用state，有M和无M产生的结果会有少数位的区别。
P = zeros([512 512 N]);
for k = 1:N
	P(:,:,k) = randn(512);
end
%% 修改用于加权的M矩阵
contrastThreshold = contrastMask(I);
M = contrastThreshold;

% %% Watson模型DCT频率敏感库矩阵的倒数，再乘以100
% M =	[71.43 99.01 86.21 60.24 41.67 29.16 20.88 15.24;
% 	99.01 68.97 75.76 65.79 50.00 36.90 27.25 20.28;
% 	86.21 75.76 44.64 38.61 33.56 27.47 21.74 17.01;
% 	60.24 65.79 38.61 26.53 21.98 18.87 15.92 13.16;
% 	41.67 50.00 33.56 21.98 16.26 13.14 11.48 9.83;
% 	29.16 36.90 27.47 18.87 13.14 10.40 8.64  7.40;
% 	20.88 27.25 21.74 15.92 11.48 8.64  6.90  5.78;
% 	15.24 20.28 17.01 13.16 9.83  7.40  5.78  4.73];
% % 周期延拓
% M = padarray(M, [504,504],'circular','post');
%% 特征值计算并编码
H = zeros(1,N);
for k = 1:N
 	H(k) = sum(sum(I.*P(:,:,k).*M)); % 这个公式是个关键，
end
H(H>=0) = 1;
H(H<0) = 0;
hashVector = H(:);


