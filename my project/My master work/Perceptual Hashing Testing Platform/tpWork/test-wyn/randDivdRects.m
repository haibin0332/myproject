%{
����������:�Ƕ�����ͼ��������[ָ��������ָ���ֿ��С]������ֿ�
Author: Luo Min
Date:   2008-7-12
%}
function [randRectBlocks] = randDivdRects(imMatrix, key, numRects, blockSize)
%{ 
    �������:
        imMatrix : ͼ����� 
        key: �����Կ����������
        numRects: ��Ҫ���������Ŀ���������
        blockSize: �������Ĵ�С�������8�ı���������ֻ֧�ַ�����blockSize = 8����˵���ֿ����������鶼��8*8���ش�С��
    �������:
        randRectBlocks : ��¼�����������������
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
%% ��������
rand('state',key);
[w c] = size(imMatrix);   % �����ά��
rectcoors = round((w - blockSize - 1) * rand(numRects, 2)) + 1;  % ��֤������ѡȡ���ᳬ���߽�
for i = 1:numRects
%{
    % ���ڻ�ͼ
    imMatrix(rectcoors(i,1),rectcoors(i,2):(rectcoors(i,2)+blockSize-1)) = 255;
    imMatrix(rectcoors(i,1)+blockSize-1,rectcoors(i,2):(rectcoors(i,2)+blockSize-1)) = 255;
    imMatrix(rectcoors(i,1):(rectcoors(i,1)+blockSize-1),rectcoors(i,2)) = 255;
    imMatrix(rectcoors(i,1):(rectcoors(i,1)+blockSize-1),rectcoors(i,2)+blockSize-1) = 255;
    imshow(imMatrix);
%}
    randRectBlocks(:,:,i) = imMatrix(rectcoors(i,1):(rectcoors(i,1)+blockSize-1),rectcoors(i,2):(rectcoors(i,2)+blockSize-1));    
end
