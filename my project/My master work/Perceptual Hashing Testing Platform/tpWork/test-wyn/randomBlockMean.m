% function [randRectBlocks] = randomBlockMean(dDCTcoefI, contrastThreshold, key, numrects)
function [hashValue] = randomBlockMean(dDCTcoefI, contrastThreshold, key, numrects)
% numrects 这个参数可以控制最后hash值的长度
%% input
if nargin == 0
    I = imread('1.bmp');
    I = double(I);
    dDCTcoefI = blkproc(I, [8 8], @dct2);
    contrastThreshold = contrastMask(I);
    key = 101;
    numrects = 256;
end
%% Initialization of default parameters
% key
% randn('seed', key); % 使用seed，对实验图片，有M和无M产生的结果一样，但是使用state，有M和无M产生的结果会有少数位的区别。
% P = zeros([blockSize blockSize numRects]);
% for i = 1:numRects
% 	P(:,:,i) = randn(blockSize);
% end

ratio1 = 1/4;   % 用来限制每个方块的大小不超过图片的1/16

xsz = size(dDCTcoefI,2);
ysz = size(dDCTcoefI,1);

varlength = round(ratio1*ysz);	% ratio1 ratio2 是干什么的？ 这个是用来控制方块大小的

rand('seed',key); % 设置产生随机数的方法和种子
rectlengthsx = ceil(varlength.* rand(numrects,1));
rectlengthsy = ceil(varlength.* rand(numrects,1));  % 分块的长宽都是随机的
% rectlengthsy = rectlengthsx;                      % 分块的长宽是相等的，也就是说都是方阵
rectcoors = ceil(rand(numrects,2).*[ysz-rectlengthsy+1 xsz-rectlengthsx+1]); % 产生那些随机的方块

%uniform weights in the formation of the transform matrix at this point
% I = imread('1.bmp');
randn('seed', key);
for i=1:numrects
%{
    % 用于画图
    I(rectcoors(i,1),rectcoors(i,2):(rectcoors(i,2)+rectlengths(i)-1)) = 255;
    I(rectcoors(i,1)+rectlengths(i)-1,rectcoors(i,2):(rectcoors(i,2)+rectlengths(i)-1)) = 255;
    I(rectcoors(i,1):(rectcoors(i,1)+rectlengths(i)-1),rectcoors(i,2)) = 255;
    I(rectcoors(i,1):(rectcoors(i,1)+rectlengths(i)-1),rectcoors(i,2)+rectlengths(i)-1) = 255;
%     imshow(I);
%}
    P = zeros([rectlengthsy(i), rectlengthsx(i)]);
    P = randn([rectlengthsy(i), rectlengthsx(i)]);
    randRectBlocks = dDCTcoefI(rectcoors(i,1):(rectcoors(i,1)+rectlengthsy(i)-1),rectcoors(i,2):(rectcoors(i,2)+rectlengthsx(i)-1));
    randBlockMask = contrastThreshold(rectcoors(i,1):(rectcoors(i,1)+rectlengthsy(i)-1),rectcoors(i,2):(rectcoors(i,2)+rectlengthsx(i)-1));
    hashValue(i) = sum(sum(randRectBlocks.* randBlockMask.* P));
end;

% imshow(I);