%% Comments and References
%{ 
	整理自 Vishal Monga 的 Feature Point Based Image Hashing [Monga & Evans, 2004-06]
		整理自作者提供的m文件： runFPHash imagauth featurepointhash MakeFeatures createstruct 
		它又直接或间接的需要如下文件： 
			findCornerStep1 findCornerStep2 choseImpPointsWithoutZeros hausdorff hgicf2im hmscarp2 whscarp
	参考文献为： 
		ROBUST PERCEPTUAL IMAGE HASHING USING FEATURE POINTS
		% Ref:
		% 1.) V. Monga, D. Vats and B. L. Evans, ``Image Authentication Under Geometric 
		% Attacks Via Structure Matching'', Proc. IEEE Int. Conf. on Multimedia and Expo, 
		% pp. 200-203, Netherlands, 2005.
		% 2.) W. J. Rucklidge, "Locating objects using the hausdorff distance," IEEE
		% Int. Conf. on Computer Vision, 1995.
    
	输入图像： 不定大小的 任意格式 图 

	params：
		nsp		'Number of Feature points'
			default: 64
		M		'MEAN computation size:'
			default: 2
		r		'SIGN change size:'
			default: 4
		s		'Distance to STRAIGHT lines'
			default: 1
		da		'ANGLE difference allowance'
			default: 7
		ds		'STRAIGHTNESS allowance'
			default: 3
		t		'MIN distance between SPS points'
			default: 8
	
	hash形式： 
		独特定义的hash向量，数据类型为结构体，需要专门的匹配方法： match_VishalMonga_fp
		hash 结构中包含了图像尺寸信息，这个在匹配时用得上
	
	use:
		findCornerStep1.m
		findCornerStep2.m
%}
function [hashVector] = mbe_VishalMonga_FP(imagefile,param)
% 关于参数 param，为了保持测试程序的接口一致，所有的算法函数的参数都改为param，在函数内部再根据需要作解析。
%% test: input
%% check input
if nargin == 1
	nsp = 64;
	M = 2;
	r = 4;
	s = 1;
	da = 7;
	ds = 3;
	t = 8;
else
	nsp = param{1};
	M = param{2};
	r = param{3};
	s = param{4};
	da = param{5};
	ds = param{6};
	t = param{7};
end

I = imread(imagefile);
dim = size(I);
if length(dim) > 2 % 不是灰度图 
	I = rgb2gray(I);
end
% 这个方法不需要原图长宽相等
% if dim(1) ~= dim(2)
% 	I = imresize(I,[dim(1) dim(1)]); % 使原图长宽相等
% end

%% 计算Hash
[HGF,C,HM,ANG,POS1,POS2] = findCornerStep1(double(I),1,M,1,r);
[SP_POINTS] = findCornerStep2(double(I),1,nsp,HGF,C,HM,ANG,M,r,s,da,ds,t);

% Show feature points
% f_img 是记录了特征点的图
f_img = 1- SP_POINTS;
f_img = im2uint8(f_img);
hashVector = createstruct(f_img,dim);

function [point] = createstruct(A,dim)
%%
% CREATESTRUCT  Computes the Hausdorff Distance between two sets of feature
%            points A1 and B1
%
% Description
% [point] = createstruct(A) -> Returns a structure of
% position of feature points: x y co-oridnates
% distance to the origin

% Authored January 2005 by Divyanshu Vats, modified by Vishal Monga
% Copyright (c) 1999-2005 The University of Texas
% All Rights Reserved.

[x y] = find(A==0);
x = x;
y = y;

point.x = x;
point.y = y;
point.szx = dim(1);
point.szy = dim(2);
