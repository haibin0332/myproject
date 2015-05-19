%% Comments and References
%{ 
	ref: 
		Robust bit extraction form images
		Fridrich
		1998

	修改自 mbe_Fridrich_bitsextraction
	主要的改进与目的有：
		1、使用对比度掩蔽阈值矩阵加权 —— 引入HVS
		2、增加分块个数，随机分块，且分块大小不定（但是都是8的倍数，且与每一个DCT块对齐） -- 增加分块个数，保证区分性的提高；随机分块，增加一种安全考虑，且同时使得特征被以多个角度重复记录。
		3、减少每一个分块所对应的N值 -- N值太多没有实际价值。
		4、使用汉明距进行整体的匹配。
	上述改进的一个简化版本就是去掉随机分块部分，将第2步改成：增加分块个数，大小固定。
	两种改进都值得尝试一下。

	第一种改进导致编程的复杂度提高，可以考虑如下解决：
		因为随机分块是一个独立的模块，所以可以考虑如下技术：
		1、将一个DCT视为一个整体，在简化之后的矩阵上进行随机分块，从而得到随机分块的索引
		2、先进行随机分块，然后根据索引，在循环内部处理随机部分，随机矩阵即时产生，即时使用，即时扔掉。为了做到这一点，还需要：
		3、在进行加权之前，计算DCT变换矩阵和对比度掩蔽阈值矩阵，他们可以通过相同的索引引导

	imputs： 不定大小的 灰度 图 

	params：
		key		密钥
		M		分块个数
		N		hash长度 for each block
	
	hash形式： 
		复杂定义的二进制向量： M块，每块N个bit
	匹配：
		普通的汉明距
	调用： 
		param(1) = 1; param(2) = 16; param(3) = 50;
		h1 = mbe_Fridrich_bitsextraction_HVSWeighted('1.bmp',param)
%}
function [hashVector] = mbe_Fridrich_bitsextraction_HVSWeighted(imagefile,param)
%% test inputs
% nargin = 1;
% imagefile = 'E:\DoctorThesis\MBench\Plan\1.bmp';
% imagefile = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked\JPEG\001n-JPEG-70.jpg';
% 上面这个图片可以在最后的结果中看到复数。分析其结果是原图在DCT之后产生很多0.而由于Watson的问题，这些0会导致产生的Mask中有很多复数。
% imagefile = '001n.bmp';
%% get inputs
if nargin == 1
	key = 1010;
	M = 256;
	N = 25;
	method = 1;	% 用来测试与Fridrich的不同
else
	key = param(1);
	M = param(2);
	N = param(3);
	method = param(4);
end
sizeOfImage = 256;
I = imread(imagefile);
sizeI = size(I,1);
if sizeI ~= sizeOfImage 
	I = double(imresize(I,[sizeOfImage,sizeOfImage])); % resize以满足DCT变换，并且简化图像大小不同带来的处理过程
end 

%% 分块为M个
% M = sqrt(M);
%% DCT变换矩阵, 使用对比度掩蔽阈值矩阵加权
I = blkproc(I,[8 8],@dct2);
contrastThreshold = contrastMask(I);
%% 对加权后的矩阵进行随机分块
% 分块的大小不定（但行数和列数都是8的倍数），且与每个DCT块对齐，分为M块
% 分块是由密钥key控制的 rand('seed', key)
% rand: 均匀分布； randn：正态分布
if method == 1	%随机分块
	rand('seed',key);
% 	randn('seed',key);
	% sizeOfIndex 产生一个Index矩阵，这个矩阵中每一个点对应原图的一个8*8的块
	sizeOfIndex = sizeOfImage/8;
	% 产生M个顶点。这个顶点在0- 3*sizeOfIndex/4之间均匀分布，之所以选择3/4这个限定，是因为这是顶点，还要为分块留下空间
	rectVertexX = ceil((sizeOfIndex*3/4) * rand(M,1));		% 分块的顶点坐标：（rectVertexX, rectVertexY), 起点一定与DCT块对齐
	rectVertexY = ceil((sizeOfIndex*3/4) * rand(M,1));		% 分块的顶点是随机的，由密钥控制
	rectVertexX(rectVertexX == 0) = 1;
	rectVertexY(rectVertexY == 0) = 1;
	
	% 为每个顶点产生一个矩阵。矩阵的大小最小为原图的1/8，最大为原图的1/4。并在这个范围内正态分布
	for i = 1: M
% 		rectBlockNx(i) = ceil(sizeOfIndex * (1/4 - 1/16) * rand(1));	% 每个块占多少列（以8为单位，因为要与DCT块对齐）
% 		rectBlockNy(i) = ceil(sizeOfIndex * (1/4 - 1/16) * rand(1));	% 每个块占多少行
		
		rectBlockNx(i) = ceil(sizeOfIndex * (1/4 - 1/16) * rand(1)) + sizeOfIndex / 16;	% 每个块占多少列（以8为单位，因为要与DCT块对齐）
		rectBlockNy(i) = ceil(sizeOfIndex * (1/4 - 1/16) * rand(1)) + sizeOfIndex / 16;	% 每个块占多少行
		
		rectBlockNx(i) = rectBlockNx(i) * 8;
		rectBlockNy(i) = rectBlockNy(i) * 8;
		
	end
	rectVertexX = rectVertexX * 8;
	rectVertexY = rectVertexY * 8;
else
	% 普通分块 分成M块，这样一来，就相当于把Fridrich直接加了一个HVS，但是这里对M是有限制的
	% 这里假定M = 16，目的是和Fridrich的算法可以相互比较。当然也可以改成其他值
	M = 16;
	N = 50;
	M = sqrt(M);
% 	rectVertexX = zeros([1, M*M]);
% 	rectVertexY = zeros([1, M*M]);
	for i = 0:M-1
		rectVertexX(i*M+1:i*M+M) = [1:sizeOfImage/M:sizeOfImage];
	end
	for i = 1:M:M*M
			rectVertexY(i:i+M-1) = rectVertexX(ceil(i/M));
	end
	rectBlockNx(1:M*M) = sizeOfImage/M;  %%++
	rectBlockNy = rectBlockNx;
	M = 16;
end
	
%% 使用密钥key对每个分块产生N个随机矩阵，满足【0，1】的均匀分布 
% 矩阵分块的大小不定（但是都是8的倍数，且与每一个DCT块对齐）随机矩阵的个数为N*M
% 使用randn产生正态分布的矩阵，使用rand产生均匀分布的矩阵
%randn('seed',key);	% 使用seed，对实验图片，有M和无M产生的结果一样，但是使用state，有M和无M产生的结果会有少数位的区别。
rand('seed',key);
H = zeros(M, N);	% 二值化前的hash值矩阵
% for test
% II = zeros([256, 256]);

for i = 1:M
	% 通过key来生成P矩阵，P是均匀分布的，对于每个块【m，n】，对应一个P【m，n，N】
	P = zeros([rectBlockNx(i), rectBlockNy(i), N]);
	P = rand([rectBlockNx(i), rectBlockNy(i), N]);

	%% 对随机矩阵进行低通滤波，得到光滑的随机模板
	h = fspecial('gaussian'); % average
	for k = 1:N
		P(:,:,k) = imfilter(P(:,:,k),h,'replicate','same','corr');
	end
	
	%% 每个模板都减去它们的均值，得到DC-free的模板（以0为分布中心）
	for k = 1:N
		P(:,:,k) = P(:,:,k) - sum(sum(P(:,:,k)))/((size(P,1)*(size(P,2))));
	end
	
	%% 将每一个分块都投影到随机模板上，并对结果求和（原始文献说的是Absolute Value，但是不知确切所指）
	% 取得这个分块的矩阵
	randRectBlocks = I(rectVertexX(i):(rectVertexX(i) + rectBlockNx(i) - 1),rectVertexY(i):(rectVertexY(i) + rectBlockNy(i)  - 1));
    randBlockMask = contrastThreshold(rectVertexX(i):(rectVertexX(i)+rectBlockNx(i) - 1),rectVertexY(i):(rectVertexY(i) + rectBlockNy(i) - 1));

	%{
	% for test random blocking
% 	II = I;
	II(rectVertexX(i), rectVertexY(i):(rectVertexY(i) + rectBlockNy(i) - 1)) = 255;
	II(rectVertexX(i):(rectVertexX(i) + rectBlockNx(i) - 1), rectVertexY(i)) = 255;
	II((rectVertexX(i) + rectBlockNx(i) - 1), rectVertexY(i):(rectVertexY(i) + rectBlockNy(i) - 1)) = 255;
	II(rectVertexX(i):(rectVertexX(i) + rectBlockNx(i) - 1), (rectVertexY(i) + rectBlockNy(i) - 1)) = 255;
% 	II(rectVertexX(i):(rectVertexX(i) + rectBlockNx(i) * 8 - 1),rectVertexY(i):(rectVertexY(i) + rectBlockNy(i) * 8 - 1)) = 255;

	%}
	
	for k = 1:N
		H(i, k) = sum(sum(randRectBlocks.* (randBlockMask).* P(:,:,k))); % 针对 001n-JPEG-70.jpg 在i=3,k = 2时可以看到复数的产生。
	end
end
% 	imshow(II);

%% 二值化
% 下面是简单的二值化方法
%{
H(H>=0) = 1;
H(H<0) = 0;
hashVector = H;
%}
% 适应性的二值化方法是：设定阈值初值为0，如果0、1数目的差超过总数的10%，则对阈值做适应性的调节，直到降到10%以内为止
% 容易误会的是：可能会以为，取中值或者均值就能够直接得到0、1各半的效果，事实上不是这样的。
% 但是事实上，当样本数目较多的时候，中值基本上能够达到这样的效果
hashVec = zeros(3,length(H(:)));

m = median(H(:));
tp(H >= m) = 1;
tp(H < m) = 0;
hashVec(1,:) = tp;
sum1 = abs(sum(sum(hashVec(1,:)))- length(H(:))/2);

m = 0;
tp(H >= m) = 1;
tp(H < m) = 0;
hashVec(2,:) = tp;
sum2 = abs(sum(sum(hashVec(2,:)))- length(H(:))/2);

m = mean(mean(H));
tp(H >= m) = 1;
tp(H < m) = 0;
hashVec(3,:) = tp;
sum3 = abs(sum(sum(hashVec(3,:)))- length(H(:))/2);

id = find([sum1 sum2 sum3]==min([sum1 sum2 sum3])) % 找到最小那一个
if size(id,2) > 1
	id = id(1)
end
hashVector = hashVec(id,:);
if (sum(sum(hashVector)) - length(H(:))/2) > length(H(:)) * 0.1
	warning('太偏了') % 有些时候太偏了，不管了，但是还是做一个小小的改进
end


%% 用来记录结果
%{
frequencyOfOne = sum(sum(hashVector))/length(H(:));
load('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\resultsOfFridrich_withHVS.mat');
sizeOfMat = size(str,2);
str = padarray(str,[0 1],'replicate','post');
str(1,sizeOfMat+1).imagefile = imagefile;
str(1,sizeOfMat+1).M = M;
str(1,sizeOfMat+1).N = N;
str(1,sizeOfMat+1).key = key;
str(1,sizeOfMat+1).hashVector = hashVector;
str(1,sizeOfMat+1).frequencyOfOne = frequencyOfOne;
str(1,sizeOfMat+1).method = method;

delete('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\resultsOfFridrich_withHVS.mat'); 
save('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\resultsOfFridrich_withHVS.mat','str'); 
%}
%{
% initial
str.imagefile = imagefile;
str.M = M;
str.N = N;
str.key = key;
str.hashVector = hashVector;
str.frequencyOfOne = frequencyOfOne;
str.method = method;
save('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\resultsOfFridrich_withHVS.mat', 'str');
%}

%% 结论 
%{
%}

