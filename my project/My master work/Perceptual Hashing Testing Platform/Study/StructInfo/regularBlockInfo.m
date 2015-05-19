%% ����ֿ��ֵ ���ؾ�ֵ���С������������С��ߴ����С�
function [blocksInfo,rectcoors] = regularBlockInfo(I,numrects,varargin)
%{
����ֿ飬����ԭͼ�ֳ�n*n�ľ��ο�
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
    error('��������');
end
%% function
% �ֳ� n*n ����Ŀ飬ÿ��ȡƽ������¼��������
n = sqrt(numrects);
% ���´��뿽���� mbe_bian 
if fix(size(I,1)/n) == size(I,1)/n
	r = fix(size(I,1)/n);%����282����282/16 = 17.6�����ֱ��ʹ��17�����������ıߣ���һ���ͻ���Ϊblkproc��ԭ���·ֿ���
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

% fun_avg = @avgblock;	% �Կ���ƽ��
if overlap == 0
    % ֱ�ӷֿ�
    B = blkproc(I,[r,c],infoFun); % �ֿ鴦��
else
    % ��������
    B = blkproc(I,[r,c],[r_d4,c_d4],infoFun);	%overlapped, Note: Padding with zero on the boundary
end
blocksInfo = B(:);

% �õ������ֿ�Ķ�������
for i = 1:n
    for j = 1:n
        rectcoorsC(i,j) = (i - 1) * c + 1;
        rectcoorsR(i,j) = (j - 1) * r + 1;        
    end 
end
rectcoors = [rectcoorsC(:) rectcoorsR(:)];
% �ã������������ǶԵģ�����û�����⡣���к��У������Ͽ�ʼ��
end % function