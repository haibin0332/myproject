%% Comments and References
%{ 
	整理自 Vishal Monga 的 Hashing Via Singular Value Decomposition (SVD) [Kozat et al., 2004] 
	参考文献为： ROBUST PERCEPTUAL IMAGE HASHING VIA MATRIX INVARIANTS
    
	输入图像： 不定大小的 任意格式 图 

	params：
		numrects	'Number of random rectangles'
			default: 25
		rectsiz		'Size of each rectangle'
			default: 100
		key			'secret key'
			default: 101 随便指定一个
	
	hash形式： 
		独特定义的hash向量，需要专门的匹配方法： match_VishalMonga
	
	use:
		hashbySVD.m
%}
function [hashVector] = mbe_VishalMonga_SVD(imagefile,param)
% 关于参数 param，为了保持测试程序的接口一致，所有的算法函数的参数都改为param，在函数内部再根据需要作解析。
%% test: input
%% check input
if nargin == 1
	numrects = 25;
	rectsiz = 100;
	key = 101;
else
	numrects = param{1};
	rectsiz = param{2};
	key = param{3};	
end

I = imread(imagefile);
dim = size(I);
if length(dim) > 2 % 不是灰度图 
	I = rgb2gray(I);
end
if dim(1) ~= dim(2)
	I = imresize(I,[dim(1) dim(1)]); % 使原图长宽相等
end

%% 计算Hash
hashVector = hashbySVD(double(I),key,numrects,rectsiz);

