%{
函数的作用:是对任意图像矩阵进行[指定块数，指定分块大小]的随机分块
Author: Luo Min
Date:   2008-7-12
%}
function [randRectBlocks] = randDivdRects(imMatrix, key, numRects, blockSize)
%{ 
    输入参数:
        imMatrix : 图像矩阵 
        key: 随机密钥，任意整数
        numRects: 需要的随机矩阵的块数，整数
        blockSize: 随机矩阵的大小，最好是8的倍数。这里只支持方阵。如blockSize = 8，则说明分块后的随机矩阵块都是8*8像素大小的
    输出参数:
        randRectBlocks : 记录所有随机矩阵块的内容
%}
%% preprocessing
if nargin == 0
    imMatrix = imread('1.bmp');
    key = 101;
    numRects = 16*16;
    blockSize = 32;
elseif nargin == 1
    key = 101;
    numRects = 64*64;
    blockSize = 8;
end
%% 函数内容
rand('state',key);
[w c] = size(imMatrix);   % 矩阵的维数
rectcoors = round((w - blockSize - 1) * rand(numRects, 2)) + 1;  % 保证随机点的选取不会超出边界
for i = 1:numRects
%{
    % 用于画图
    imMatrix(rectcoors(i,1),rectcoors(i,2):(rectcoors(i,2)+blockSize-1)) = 255;
    imMatrix(rectcoors(i,1)+blockSize-1,rectcoors(i,2):(rectcoors(i,2)+blockSize-1)) = 255;
    imMatrix(rectcoors(i,1):(rectcoors(i,1)+blockSize-1),rectcoors(i,2)) = 255;
    imMatrix(rectcoors(i,1):(rectcoors(i,1)+blockSize-1),rectcoors(i,2)+blockSize-1) = 255;
    imshow(imMatrix);
%}
    randRectBlocks(:,:,i) = imMatrix(rectcoors(i,1):(rectcoors(i,1)+blockSize-1),rectcoors(i,2):(rectcoors(i,2)+blockSize-1));    
end
