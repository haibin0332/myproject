%% Comments and References
%{ 
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
function [hashVector] = mbe_WangShuoZhong_watsonBased(imagefile,param)
%% test Inputs
% imagefile = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked\NormalizedOriginalImage\007n.bmp'
% nargin = 1;
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
%% Watson模型DCT频率敏感库矩阵的倒数，再乘以100
M =	[71.43 99.01 86.21 60.24 41.67 29.16 20.88 15.24;
	99.01 68.97 75.76 65.79 50.00 36.90 27.25 20.28;
	86.21 75.76 44.64 38.61 33.56 27.47 21.74 17.01;
	60.24 65.79 38.61 26.53 21.98 18.87 15.92 13.16;
	41.67 50.00 33.56 21.98 16.26 13.14 11.48 9.83;
	29.16 36.90 27.47 18.87 13.14 10.40 8.64  7.40;
	20.88 27.25 21.74 15.92 11.48 8.64  6.90  5.78;
	15.24 20.28 17.01 13.16 9.83  7.40  5.78  4.73];
% 周期延拓
M = padarray(M, [504,504],'circular','post');
%% 特征值计算并编码
H = zeros(1,N);
for k = 1:N
 	H(k) = sum(sum(I.*P(:,:,k).*M)); % 这个公式是个关键，
end
H(H>=0) = 1;
H(H<0) = 0;
hashVector = H(:);
%% 结论 
%{
这又是诸多搞笑算法中的一个。
在这个算法中，编码的关键是他的key的使用方式，这个值得学习。
Key的使用方式： 
	1、利用key作为种子，生成多个均值为0的矩阵。
	2、用它点乘原图的DCT变换矩阵，再求和（原图的DCT变换矩阵都是大于零的且有限的，而且其图像内容特征决定了它的一些特征）。
		因为它的均值为0，这一步相当于对DCT变换矩阵求均值，并归一化到0附近。大于零还是小于零这个决定于图像的结构信息（这一点与杨边的中值与均值比较类似）
	3、因此：key同时完成了两件事情：加密 和 归一化。
M的问题：
	M的使用存在很大的问题，实验： 
		H(k) = sum(sum(I.*P(k).*M)); 将这句中的.*M去掉，可以得到完全相同的编码。
	原因：
		正如key的使用的分析中所言，key的作用是归一化，而归一化的对象是图像的全局特征（8×8像素的分块对于整个图像而言不足道，而每个8×8的快都乘上相同的权M，相当于什么都没有干）。
		因此，用不用M加权，结果都是一样的。或许会在某些图像上有少许不同，但趋势不会变。
关于论文中给出的一个结论：
	N越大，精度越高
	这个结论也是扯蛋的。因为每个N都是随机的。根据其分布的偏移与原图的分布特性决定归一化后是否大于0.这样的逻辑两次和N次没有本质上的区别。
	? 如果上面的怀疑成立，那么取两个不同的密钥种子，结果应该是很接近的。但是实验证明并不是这样。那么这是为什么？或许对Key的理解还是不够。
继续测试，怀疑他的区分性！！！
%}

