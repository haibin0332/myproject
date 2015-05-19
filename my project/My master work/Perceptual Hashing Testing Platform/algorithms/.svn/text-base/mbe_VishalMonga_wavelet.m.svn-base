%% Comments and References
%{ 
	整理自 Vishal Monga 的 Discrete Wavelet Transform (DWT) Based Image Hash [Venkatesan et al., 2000] 
	参考文献为： ROBUST IMAGE HASHING
    
	输入图像： 不定大小的 任意格式 图 

	params：
		wavelet		'Wavelet basis'
			default: db4
		delta		'Quantizer step size'
			default: 100
		level		'Wavelet Decomposition Level'
			default: 3
		numrects	'Number of random rectangles'
			default: 150
		key			'secret key'
			default: 101 随便指定一个
	
	hash形式： 
		独特定义的hash向量，需要专门的匹配方法： match_VishalMonga
	
	use:
		wavelethash.m
%}
function [hashVector] = mbe_VishalMonga_wavelet(imagefile,param)
% 关于参数 param，为了保持测试程序的接口一致，所有的算法函数的参数都改为param，在函数内部再根据需要作解析。
%% test: input
%% check input
if nargin == 1
	wavelet = 'db4';
	delta = 100;
	level = 3;
	numrects = 150;
	key = 101;
else
	wavelet = param{1};
	delta = param{2};
	level = param{3};
	numrects = param{4};
	key = param{5};
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
hashVector = wavelethash(double(I), wavelet, delta, key, level, numrects);

