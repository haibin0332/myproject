%{
    Author: Wang
    Date:   2008-7-13
    Function: 基于Waston模型，引入密钥，进行随机分块，和密钥作用后，求和，生成HASH值
    输入参数:
        imagefile : 图像 
        param:      随机分块算法参数
            imMatrix    : 图像矩阵 
            key         : secret key
            numRects    : 需要的随机矩阵的块数，整数
            blockSize   : 随机矩阵的大小，最好是8的倍数。这里只支持方阵。如blockSize = 8，则说明分块后的随机矩阵块都是8*8像素大小的
    输出参数:
        hashVector  : 生成的HASH值，形式为二进制编码
%}
function [hashVector] = mbe_wang_AuthenticationPHBasedWaston(imagefile,param)
% 关于参数 param，为了保持测试程序的接口一致，所有的算法函数的参数都改为param，在函数内部再根据需要作解析。
%% test: input
%  imagefile = '2.bmp';
%  nargin = 1;
%% check input
if nargin == 0
    imagefile = '3.tiff';
    method = 4;
	numRects = 256;
	key = 1010;
elseif nargin == 1
    method = 3;
	numRects = 256;
	key = 1010;
else
    method = param(1);
	key = param(2);
	numRects = param(3);
end

%% preprocessing
I = imread(imagefile);
dim = size(I);
if length(dim) > 2 % 不是灰度图 
	I = rgb2gray(I);
end
I = imresize(I, [512 512]);
I = double(I);
Idct = blkproc(I,[8 8],@dct2);
contrastThreshold = contrastMask(I);

%% algorithm
%% method1
if method == 1
% 随机分块，但是分的都是方阵
    randn('seed', key); % 使用seed，对实验图片，有M和无M产生的结果一样，但是使用state，有M和无M产生的结果会有少数位的区别。
    P = zeros([blockSize blockSize numRects]);
    for i = 1:numRects
        P(:,:,i) = randn(blockSize);
    end
    randRectBlocks = randDivdRects(Idct, key, numRects, blockSize);
    for i = 1: numRects
        tempBlockI(:,:) = randRectBlocks(:,:,i);
        h(i) = sum(sum(tempBlockI.* contrastThreshold.* P(:,:,i)));
    end

%% method2
% 分块不固定的情况
elseif method == 2
    h = randomBlockMean(Idct, contrastThreshold, key, numRects);
    
elseif method == 3
    h = randomCertainBlock(I, key, numRects);
	
elseif method == 4
	% Fridrich
	h = PHofFridrich(I, key, numRects);
end
%% coding
hMean = mean(h);
for i = 1:numRects
    if h(i) >= hMean
%     if h(i) >= 0
        h(i) = 1;
    else
        h(i) = 0;
    end
end
hashVector = h;