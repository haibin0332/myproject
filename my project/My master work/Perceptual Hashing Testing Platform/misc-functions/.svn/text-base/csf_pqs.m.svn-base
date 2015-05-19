%{
	源自《信息隐藏技术实验教程》第八章
	PQS的CSF滤波器设计

调用 ： 
	filtercoefficients = csf_pqs;
	result = filter2(filtercoefficients, I);
%}
function [filtercoefficients] = csf_pqs()
%% 
% 计算频率响应矩阵
Fmatrix = csfmat;
% 画出频率响应
% figure(1); mesh(Fmatrix), title('频率响应'),xlabel('水平方向空间频率');ylabel('垂直方向空间频率');zlabel('CSF频率响应');
% 利用 fsample2 函数计算频率系数
filtercoefficients  = fsamp2(Fmatrix);
why

%% 子函数：计算频率响应矩阵
function Fmatrix = csfmat()
%%
u = -20:1:20;
v = -20:1:20;
n = length(u);
Z = zeros(n);
for r = 1:n
	for c = 1:n
		Z(r,c) = csffun(u(r),v(c)); % 调用子函数计算响应空间频率下的频响
	end
end
Fmatrix = Z;

%% 子函数：计算u，v下的频率响应
function Sa = csffun(u,v)
%% csf 频率响应
sigma = 2;
f = sqrt(u.*u + v.*v);
w = 2*pi*f/60;
Sw = 1.5*exp(-sigma^2 * w^2/2) - exp(-2 * sigma^2 * w^2/2);
% 高频修正
theta = atan(v./(u + eps)); % eps = 2^{-52}, 是避免0的一种修正
beta = 8;
f0 = 11.13;
w0 = 2 * pi * f0/60;
Ow = (1 + exp(beta * (w - w0)) * (cos(2 * theta))^4) / ( 1 + exp(beta * (w - w0)));
% 最终结果
Sa = Sw * Ow;

