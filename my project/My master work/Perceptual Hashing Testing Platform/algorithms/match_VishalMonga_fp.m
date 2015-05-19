%{
Ŀ�ģ� 
	���� mbe_VishalMonga_FP �õ���hashvector�ľ���
������ 
	param �������ͼ�Ͳο�ͼ�ĳߴ�
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
	% ͨ�����ַ�ʽ�����ų�����������Ϊ�յ����
% 	param = ''; % ��ʵ���������û������
end

%% ��������Ϣ�Ƶ���ȡʱ�趨��OK
% A.szx = param(1,1);
% A.szy = param(1,2);
% B.szx = param(2,1);
% B.szy = param(2,2);

%% Calculating initial distance between points
Distance = hausdorff(A,B);
