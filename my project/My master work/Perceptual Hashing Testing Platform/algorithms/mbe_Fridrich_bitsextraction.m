%% Comments and References
%{ 
	ref: 
		Robust bit extraction form images
		Fridrich
		1998
		
	imputs： 不定大小的 灰度 图 

	params：
		key		密钥
		M		分块个数
		N		hash长度 for each block
	
	hash形式： 
		复杂定义的二进制向量： M块，每块N个bit
	匹配：
		match_Fridrich_bitsextraction
        不需要这个，只需要用汉明距匹配就可以了。这里编的好像是些测试用的东西。我已经忘了：）
	调用： 
		param(1) = 1; param(2) = 16; param(3) = 50;
		h1 = mbe_Fridrich_bitsextraction('1.bmp',param)
%}
function [hashVector] = mbe_Fridrich_bitsextraction(imagefile,param)
%% test inputs
nargin = 1;
imagefile = 'E:\PH1\1.bmp';

%% get inputs
if nargin == 1
	key = 1010;
	M = 16;
	N = 50;
else
	key = param{1};
	M = param{2};
	N = param{3};
end
sizeOfImage = 256;
I = imread(imagefile);
sizeI = size(I,1);
if sizeI ~= sizeOfImage 
	I = double(imresize(I,[sizeOfImage,sizeOfImage])); % resize以满足DCT变换，并且简化图像大小不同带来的处理过程
end 

%% 分块为M*M个
M = sqrt(M);
%% DCT变换矩阵
I = blkproc(I,[8 8],@dct2);
%% 使用密钥key对每个分块产生N个随机矩阵，满足【0，1】的均匀分布 
% 矩阵的大小为 (512/M)*(512/M) 随机矩阵的个数为N*M*M
% 使用randn产生正态分布的矩阵，使用rand产生均匀分布的矩阵
%randn('seed',key);	% 使用seed，对实验图片，有M和无M产生的结果一样，但是使用state，有M和无M产生的结果会有少数位的区别。
rand('seed',key);
P = zeros([sizeOfImage/M sizeOfImage/M N*M*M]);
for k = 1:N*M*M
	P(:,:,k) = rand(sizeOfImage/M);
end
%% 对随机矩阵进行低通滤波，得到光滑的随机模板
h = fspecial('gaussian'); % average
for k = 1:N*M*M
	P(:,:,k) = imfilter(P(:,:,k),h,'replicate','same','corr');
end
%% 每个模板都减去它们的均值，得到DC-free的模板（以0为分布中心）
for k = 1:N*M*M
	P(:,:,k) = P(:,:,k) - sum(sum(P(:,:,k)))/((sizeOfImage/M)*(sizeOfImage/M));
end
%% 将每一个分块都投影到随机模板上，并对结果求和（原始文献说的是Absolute Value，但是不知确切所指）
H = zeros(M*M,N);
for i = 1:M*M % 对每个分块
	% 取得这个分块的矩阵
	iCount = ceil(i/M); % 行
	jCount = mod(i,M);  % 列
	if jCount == 0
		jCount = M;
	end
	iCount = iCount - 1;
	jCount = jCount - 1;

	Imm = I((iCount*sizeOfImage/M)+1:(iCount*sizeOfImage/M)+sizeOfImage/M,(jCount*sizeOfImage/M)+1:(jCount*sizeOfImage/M)+sizeOfImage/M);
	for j = 1:N % 对每个随机矩阵
		H(i,j) = sum(sum(Imm.*P(:,:,i*j)));
	end
end
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

id = find([sum1 sum2 sum3]==min([sum1 sum2 sum3])); % 找到最小那一个
if size(id,2) > 1
	id = id(1);
end
hashVector = hashVec(id,:);
if (sum(sum(hashVector)) - length(H(:))/2) > length(H(:)) * 0.1
	warning('太偏了') % 有些时候太偏了，不管了，但是还是做一个小小的改进
end

%{
load('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\results.mat');
sizeOfMat = size(str,2);
str = padarray(str,[0 1],'replicate','post');
str(1,sizeOfMat+1).imagefile = imagefile;
str(1,sizeOfMat+1).m = m;
str(1,sizeOfMat+1).H = H;
str(1,sizeOfMat+1).frequencyOfOne = frequencyOfOne;

delete('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\results.mat'); 
save('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\results.mat','str'); 
%}
%{
% initial
str.imagefile = imagefile;
str.m = m;
str.H = H;
str.frequencyOfOne = frequencyOfOne;
save('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\results.mat', 'str');
%}
%% 结论 
%{
%}
