
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

% commented by �Ż�
% 	params��
% 		wavelet		'Wavelet basis'
% 			default: db4
% 		delta		'Quantizer step size'
% 			default: 100
% 		level		'Wavelet Decomposition Level'
% 			default: 3
% 		numrects	'Number of random rectangles'
% 			default: 150
% 		key			'secret key'
% 			default: 101 ���ָ��һ��
%% Initialization of default parameters
ratio1 = 1/4; ratio2 = 1/8;

image = double(imgin);

xszbig = size(image,2);
yszbig = size(image,1);
xsz = xszbig/(2^level);	% level��ʾС���ֽ�Ĵ�����level��֮�󣬵õ���ÿ��ͨ���ĳߴ�Ϊԭͼ��С��1/(2^level)
ysz = yszbig/(2^level);

% totallength = xsz*ysz;
% meanlength = round(ratio1*ysz); % Round to nearest integer
% varlength = round(ratio2*ysz);	% ratio1 ratio2 �Ǹ�ʲô�ģ� ������������Ʒ����С��

dwtmode('per','notext');
%{
dwtmode: Discrete wavelet transform extension mode
���� DWT ��extensiionģʽ��Ҳ�������ģʽ
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

minlength1 = round(ratio2*xsz); % ������������Сֱ��
maxlength1 = round(ratio1*xsz);	% ����������ֱ���ı仯��Χ

rand('state',key); % ���ò���������ķ���������
rectlengths = ceil(rand(numrects,1)*(maxlength1))  + minlength1; % [minlength,minlength + maxlength]
rectcoors = ceil(rand(numrects,2).*[ xsz-rectlengths+1 ysz-rectlengths+1]); % ������������꣬���Ͻǵĵ�
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
hashVec = round(hashVec/delta)*delta;  % ����100 �ٳ���100 �������Ϊ��ʲô��
hashVec = hashVec(:);
%{
�����������Ĳ���
С�������Ǹ��˲�
���ֻȡca�û������൱�ڵ�ͨ�˲�
��һ��������ķ�������ϵ����ֵ
����ȽϷ������Զ���ģ����϶����Ǻ����������

���˾���ȽϷ���֮�⣬�����㷨���Լ򻯳ɣ� 
��ͨ�˲� �ֿ� �ҶȾ�ֵ ����

%}

return;

