% function [randRectBlocks] = randomBlockMean(dDCTcoefI, contrastThreshold, key, numrects)
function [hashValue] = randomBlockMean(dDCTcoefI, contrastThreshold, key, numrects)
% numrects ����������Կ������hashֵ�ĳ���
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
% randn('seed', key); % ʹ��seed����ʵ��ͼƬ����M����M�����Ľ��һ��������ʹ��state����M����M�����Ľ����������λ������
% P = zeros([blockSize blockSize numRects]);
% for i = 1:numRects
% 	P(:,:,i) = randn(blockSize);
% end

ratio1 = 1/4;   % ��������ÿ������Ĵ�С������ͼƬ��1/16

xsz = size(dDCTcoefI,2);
ysz = size(dDCTcoefI,1);

varlength = round(ratio1*ysz);	% ratio1 ratio2 �Ǹ�ʲô�ģ� ������������Ʒ����С��

rand('seed',key); % ���ò���������ķ���������
rectlengthsx = ceil(varlength.* rand(numrects,1));
rectlengthsy = ceil(varlength.* rand(numrects,1));  % �ֿ�ĳ����������
% rectlengthsy = rectlengthsx;                      % �ֿ�ĳ�������ȵģ�Ҳ����˵���Ƿ���
rectcoors = ceil(rand(numrects,2).*[ysz-rectlengthsy+1 xsz-rectlengthsx+1]); % ������Щ����ķ���

%uniform weights in the formation of the transform matrix at this point
% I = imread('1.bmp');
randn('seed', key);
for i=1:numrects
%{
    % ���ڻ�ͼ
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