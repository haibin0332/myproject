%{
目的： 
	计算 mbe_VishalMonga_FP 得到的hashvector的距离
参数： 
	param 保存测试图和参考图的尺寸
		img = imread(img1);
		p1 = size(img);
		p2 = p1;
		param = [p1; p2];
		clear img;

use:
	hausdorff.m
%}
function [ Distance ] = match_VishalMonga_fp(hashVec1, hashVec2, param)

A = hashVec1;
B = hashVec2;

if nargin == 2
	% 通过这种方式可以排除第三个参数为空的情况
% 	param = ''; % 事实上这个参数没有用了
end

%% 将如下信息移到提取时设定就OK
% A.szx = param(1,1);
% A.szy = param(1,2);
% B.szx = param(2,1);
% B.szy = param(2,2);

%% Calculating initial distance between points
Distance = hausdorff(A,B);
