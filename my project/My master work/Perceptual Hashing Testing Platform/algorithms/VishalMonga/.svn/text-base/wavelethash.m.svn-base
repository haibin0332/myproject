
function [hashVec] = wavelethash(imgin, wavelet, delta, key, level, numrects)

% WAVELETHASH Image Hashing by quantization of pseudo-random
%           statistics of wavelet coefficients
%  Description
%  [hashVec] = wavelethash(imgin, wavelet, delta, key, level, numrects) extracts
%  hash vector hashVec from input image "imgin". The image is divided into
%  random rectangles using the secret key "key". A wavelet decomposition to
%  level "level" is obatined, "wavelet" specifies which wavelet basis to
%  use. numrects in the number of random rectangles used. Inner product of
%  pseudo-random weights generated using the secret key with the DC sub-band 
%  of the wavelet decomposition of each random rectangle generates the components  
%  of the hash. Details can be found in the reference below.
%
%	See also HASHBYSVD, FEATUREPOINTHASH
%
%	Ref: 
%   R. Venkatesan, S. M. Koon, M. H. Jakubowski, and
%   P. Moulin, "Robust image hashing", Proc. IEEE Conf.
%   on Image Processing, pp. 664-666, Sept. 2000.

% Authored 2005 by Vishal Monga
% Copyright (c) 1999-2005 The University of Texas
% All Rights Reserved.

% commented by 张慧
% 	params：
% 		wavelet		'Wavelet basis'
% 			default: db4
% 		delta		'Quantizer step size'
% 			default: 100
% 		level		'Wavelet Decomposition Level'
% 			default: 3
% 		numrects	'Number of random rectangles'
% 			default: 150
% 		key			'secret key'
% 			default: 101 随便指定一个
%% Initialization of default parameters
ratio1 = 1/4; ratio2 = 1/8;

image = double(imgin);

xszbig = size(image,2);
yszbig = size(image,1);
xsz = xszbig/(2^level);	% level表示小波分解的次数，level次之后，得到的每个通道的尺寸为原图大小的1/(2^level)
ysz = yszbig/(2^level);

% totallength = xsz*ysz;
% meanlength = round(ratio1*ysz); % Round to nearest integer
% varlength = round(ratio2*ysz);	% ratio1 ratio2 是干什么的？ 这个是用来控制方块大小的

dwtmode('per','notext');
%{
dwtmode: Discrete wavelet transform extension mode
设置 DWT 的extensiion模式，也就是填充模式
The extension modes represent different ways of handling the problem of border distortion in signal and image analysis. 
dwtmode('per') sets the DWT mode to periodization.
This mode produces the smallest length wavelet decomposition. But, the extension mode used for IDWT must be the same to ensure a perfect reconstruction.
%}

indata = image;

for i=1:1:level,
	dwtmode('per','notext');
    [ca,ch,cv,cd] = dwt2(indata,wavelet);
    indata = ca;
end;
%{
Multilevel 2-D wavelet decomposition
[C,S] = wavedec2(indata,3,wavelet)
%}

hostmat = indata;
hostvec = indata(:);

minlength1 = round(ratio2*xsz); % 这是随机块的最小直径
maxlength1 = round(ratio1*xsz);	% 这是随机块的直径的变化范围

rand('state',key); % 设置产生随机数的方法和种子
rectlengths = ceil(rand(numrects,1)*(maxlength1))  + minlength1; % [minlength,minlength + maxlength]
rectcoors = ceil(rand(numrects,2).*[ xsz-rectlengths+1 ysz-rectlengths+1]); % 这里是起点坐标，左上角的点
save('ordinaris.mat','rectlengths','rectcoors')

meanBlocks = zeros(1,numrects);
T = zeros(size(indata));
for i = 1:numrects
    T = zeros(size(indata));
    T(rectcoors(i,1):rectcoors(i,1)+rectlengths(i) - 1,rectcoors(i,2):rectcoors(i,2)+rectlengths(i) - 1) = 1;
    meanBlocks(i) = sum(sum(indata(T == 1)))/sum(sum(T));
%   figure;imshow(T);
end
hashVec = meanBlocks;
hashVec = round(hashVec/delta)*delta;  % 除以100 再乘以100 。这个是为了什么？
hashVec = hashVec(:);
%{
除了随机方块的部分
小波就算是个滤波
如果只取ca得话，就相当于低通滤波
进一步，编码的方法就是系数均值
距离比较方法他自定义的，但肯定不是汉明距就是了

除了距离比较方法之外，上述算法可以简化成： 
低通滤波 分块 灰度均值 编码

%}

return;

