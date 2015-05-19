%{
	源自《信息隐藏技术实验教程》第八章
	Watson: 亮度掩蔽

计算亮度掩蔽阈值矩阵

调用 ： 
	luminanceThreshold = luminanceMask(img)
输入要求为灰度图像
%}
function luminanceThreshold = luminanceMask(img,DCTcoef)
%% get input
if ischar(img)
	A=imread(img);
else 
	A = img;
end
A=double(A);

%% 分块的dct计算
if nargin == 1
% 	T=dctmtx(8);%取8*8离散余弦变换
% 	DCTcoef=blkproc(A,[8 8],'P1*x*P2',T,T');%对整个图像分块，矩阵T及其转置T'是DCT函数P1*x*P2的参数
	DCTcoef=blkproc(A,[8 8],@dct2);
end

%% 计算平均的DC系数
[m,n]=size(DCTcoef);
meanDC=0;
count=0;
for i=0:ceil(m/8-1);%所有的块数
    for j=0:ceil(n/8-1);
		meanDC=meanDC+DCTcoef(8*i+1,8*j+1);
		count=count+1;
    end
end
meanDC=meanDC/count;

%% 计算亮度掩蔽
fun=@blocklum;
luminanceThreshold = blkproc(DCTcoef,[8 8],fun,meanDC);

function result=blocklum(DCTcoef,meanDC)
%%
t=[1.40 1.01 1.16 1.66 2.40 3.43 4.79 6.56
   1.01 1.45 1.32 1.52 2.00 2.71 3.67 4.93
   1.16 1.32 2.24 2.59 2.98 3.64 4.60 5.88
   1.66 1.52 2.59 3.77 4.55 5.30 6.28 7.60
   2.40 2.00 2.98 4.55 6.15 7.46 8.71 10.17
   3.43 2.71 3.64 5.30 7.46 9.62 11.58 13.51
   4.79 3.67 4.60 6.28 8.71 11.58 14.50 17.29
   6.56 4.93 5.88 7.60 10.17 13.51 17.29 21.15];

for i=1:8
    for j=1:8
        result(i,j)=t(i,j)*(DCTcoef(1,1)/meanDC)^0.649;
		%% 处理为DCTcoef为零的情况，因为后面可能会用来作为除数
		if result(i,j) == 0
			result(i,j) = 1/meanDC^4;  % 随便弄个很小的数，避免除零，但我也不知道应该弄多少
		end
    end
end