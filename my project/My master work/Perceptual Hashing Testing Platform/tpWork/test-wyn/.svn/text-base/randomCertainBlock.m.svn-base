function [hashValue] = randomCertainBlock(I, key, numrects)
% numrects 这个参数可以控制最后hash值的长度
%% input
if nargin == 0
    I = imread('1.bmp');
    I = double(I);
    key = 1010;
    numrects = 256;
end
%% Initialization of default parameters
% key
% randn('seed', key); % 使用seed，对实验图片，有M和无M产生的结果一样，但是使用state，有M和无M产生的结果会有少数位的区别。
% P = zeros([blockSize blockSize numRects]);
% for i = 1:numRects
% 	P(:,:,i) = randn(blockSize);
% end
dDCTcoefI = blkproc(I, [8 8], @dct2);
contrastThreshold = contrastMask(I);

xsz = size(dDCTcoefI,2);
ysz = size(dDCTcoefI,1);

varlength = round(ysz / 8);	% ratio1 ratio2 是干什么的？ 这个是用来控制方块大小的

rand('seed',key); % 设置产生随机数的方法和种子
rectVertexX = ceil((varlength - 1) * rand(numrects,1)) * 8 + 1;
rectVertexY = ceil((varlength - 1) * rand(numrects,1)) * 8 + 1;   % 分块的顶点是随机的
for i = 1: numrects
    rectBlockNx(i) = ceil((mod(ceil((xsz - rectVertexX(i))/8), 15)) * rand(1)); %每个块不能大于整个图像的1/(4*4)
    rectBlockNy(i) = ceil((mod(ceil((ysz - rectVertexY(i))/8), 15)) * rand(1));
% 	  rectBlockNx(i) = ceil((ceil((xsz - rectVertexX(i))/8)) * rand(1)); %每个块不能大于整个图像的1/(4*4)
%     rectBlockNy(i) = ceil((ceil((ysz - rectVertexY(i))/8)) * rand(1));
    if rectBlockNx(i) == 0
        rectBlockNx(i) = 1;
    end
    if rectBlockNy(i) == 0
        rectBlockNy(i) = 1;
	end
end
% rectBlockNx = min(rectBlockNx, rectBlockNy);
% rectBlockNy = rectBlockNx;

% I = imread('1.bmp');  %用于画图
randn('seed', key);
for i=1:numrects
%{
    % 用于画图
    I(rectVertexY(i),rectVertexX(i):(rectVertexX(i) + rectBlockNx(i) * 8 -1)) = 255;
    I((rectVertexY(i) + rectBlockNy(i) * 8 - 1),rectVertexX(i):(rectVertexX(i) + rectBlockNx(i) * 8 -1)) = 255;
    I(rectVertexY(i):(rectVertexY(i) + rectBlockNy(i) * 8 - 1),rectVertexX(i)) = 255;
    I(rectVertexY(i):(rectVertexY(i) + rectBlockNy(i) * 8 - 1),(rectVertexX(i) + rectBlockNx(i) * 8 -1)) = 255;
%     imshow(I);
%}
    P = zeros([rectBlockNy(i) * 8, rectBlockNx(i) * 8]);
    P = randn([rectBlockNy(i) * 8, rectBlockNx(i) * 8]);
    randRectBlocks = dDCTcoefI(rectVertexY(i):(rectVertexY(i) + rectBlockNy(i) * 8 - 1),rectVertexX(i):(rectVertexX(i) + rectBlockNx(i) * 8 -1));
    randBlockMask = contrastThreshold(rectVertexY(i):(rectVertexY(i)+rectBlockNy(i) * 8 - 1),rectVertexX(i):(rectVertexX(i) + rectBlockNx(i) * 8 -1));
%     hashValue(i) = sum(sum(randRectBlocks.* randBlockMask.* P));
    hashValue(i) = sum(sum(randRectBlocks.* randBlockMask));	%without P2
% 	hashValue(i) = sum(sum(randRectBlocks.* P));		%without HVS, which DOES NOT mean without P1
end;

% imshow(I);