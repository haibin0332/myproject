%% 随机分块均值，返回均值序列、顶点坐标序列、尺寸序列、
%{
均值是某种信息的均值，或者原图的，或者是对比度的，或者是亮度的，或者是结构（SSIM）的
均值也不一定就是均值，也可以是中值
等等所有可能的
%}
function [blocksInfo,rectcoors,rectlengths] = randomBlockInfo(I,numrects,varargin)
%{
inputs : 
I,numrects,key, ratioMax,ratioMin, preFun,infoFun，

test:
    randomBlockInfo(I,1,101,1,1) 这个调用通不过
    randomBlockInfo(I,2,101,1/2,1/2) 这个调用正常
    复杂的调用
    [blocksInfo,rectcoors,rectlengths] = randomBlockInfo(I,3,101,1/2,1/2,@ssimLuminace,@avgblock)
%}
%% get inputs
if nargin == 2
    key = 101;
    ratioMax = 1/16;
    ratioMin = 1/32;
    preFun = '';
    infoFun = @avgblock;
elseif nargin == 3
    key = varargin{1};
    ratioMax = 1/16;
    ratioMin = 1/32;    
    preFun = '';
    infoFun = @avgblock;
elseif nargin == 5
    key = varargin{1};
    ratioMax = varargin{2};
    ratioMin = varargin{3};       
    preFun = '';
    infoFun = @avgblock;
elseif nargin == 6
    key = varargin{1};
    ratioMax = varargin{2};
    ratioMin = varargin{3};       
    preFun =varargin{4};
    infoFun = @avgblock;
elseif nargin == 7
    key = varargin{1};
    ratioMax = varargin{2};
    ratioMin = varargin{3};       
    preFun =varargin{4};
    infoFun = varargin{5};    
else
    error('参数不对');
end
%% function
% 这个函数在一个任意尺寸的图像矩阵中，随机产生一些块，并取这些块的均值构成序列输出
xsz = size(I,1);    % 行的大小
ysz = size(I,2);    % 列的大小

% 随机包含两个因素，一个是尺寸，一个是顶点坐标。
% 使用均匀分布的随机，所以首先需要求得均匀分布的范围：
% minlength 表示最小的直径大小，maxlength表示在最大的直径
% ratioMax = 1/16; ratioMin = 1/32; % 这两个参数控制图像分块占原图的相对大小，最小为1/16，最大为1/4

minlength1 = round(ratioMin*xsz); % 这是随机块的最小直径
maxlength1 = round(ratioMax*xsz);	% 这是随机块的直径的变化范围
minlength2 = round(ratioMin*ysz); % 这是随机块的最小直径
maxlength2 = round(ratioMax*ysz);	% 这是随机块的直径的变化范围

% rand('state',key); % 设置产生随机数的方法和种子
rectlengths1 = ceil(rand(numrects,1)*(maxlength1))  + minlength1; % 宽度序列
rectlengths2 = ceil(rand(numrects,1)*(maxlength2))  + minlength2; % 高度序列
rectlengths = [rectlengths1 rectlengths2];
rectcoors = ceil(rand(numrects,2).*[ xsz-rectlengths1+1 ysz-rectlengths2+1]); % 这里是起点坐标，左上角的点

% 用一段代码来显示产生的随机分块
%{
tI = zeros(size(I));
for i = 1:numrects
    I(rectcoors(i,1),rectcoors(i,2):rectcoors(i,2)+rectlengths2(i) - 1) = 256;
    I(rectcoors(i,1):rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2)) = 256;
    I(rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2):rectcoors(i,2)+rectlengths2(i) - 1) = 256;
    I(rectcoors(i,1):rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2)+rectlengths2(i) - 1) = 256;
end
figure;
imshow(I);
%}
blocksInfo = zeros(1,numrects);
if preFun ~= '';
    I = feval(preFun,I);
end
% T = zeros(size(I));
for i = 1:numrects
    TT = zeros(rectlengths1(i),rectlengths2(i));
    TT = I(rectcoors(i,1):rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2):rectcoors(i,2)+rectlengths2(i) - 1);
    blocksInfo(i) = feval(infoFun,TT);
%   figure;imshow(T);
end

return;
end % end function