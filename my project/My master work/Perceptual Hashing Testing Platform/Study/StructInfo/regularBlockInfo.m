%% 规则分块均值 返回均值序列、顶点坐标序列、尺寸序列、
function [blocksInfo,rectcoors] = regularBlockInfo(I,numrects,varargin)
%{
规则分块，即将原图分成n*n的矩形块
inputs:
    I,numrects,overlap,preFun,infoFun
test:
    
%}
%% get inputs
if nargin == 2
    overlap = 0;
    preFun = '';
    infoFun = @avgblock;
elseif nargin == 3
    overlap = 0;
    preFun = varargin{1};
    infoFun = @avgblock;
elseif nargin == 4
    overlap = varargin{1};      
    preFun = varargin{2};
    infoFun = @avgblock;
elseif nargin == 5
    overlap = varargin{1};
    preFun = varargin{2};
    infoFun = varargin{3};
else
    error('参数不对');
end
%% function
% 分成 n*n 随机的块，每块取平均，记录顶点坐标
n = sqrt(numrects);
% 以下代码拷贝自 mbe_bian 
if fix(size(I,1)/n) == size(I,1)/n
	r = fix(size(I,1)/n);%比如282，分282/16 = 17.6，如果直接使用17，会产生多余的边，进一步就会因为blkproc的原因导致分块变大。
else
	r = fix(size(I,1)/n) + 1;
end
if fix(size(I,2)/n) == size(I,2)/n
	c = fix(size(I,2)/n);
else
	c = fix(size(I,2)/n) + 1;
end

r_d4 = fix(r/4);
c_d4 = fix(r/4);

if preFun ~= ''
    I = feval(preFun,I);
end

% fun_avg = @avgblock;	% 对块求平均
if overlap == 0
    % 直接分块
    B = blkproc(I,[r,c],infoFun); % 分块处理
else
    % 交叠处理
    B = blkproc(I,[r,c],[r_d4,c_d4],infoFun);	%overlapped, Note: Padding with zero on the boundary
end
blocksInfo = B(:);

% 得到各个分块的顶点坐标
for i = 1:n
    for j = 1:n
        rectcoorsC(i,j) = (i - 1) * c + 1;
        rectcoorsR(i,j) = (j - 1) * r + 1;        
    end 
end
rectcoors = [rectcoorsC(:) rectcoorsR(:)];
% 好，这个坐标好像是对的，绝对没有问题。先列后行，自左上开始。
end % function