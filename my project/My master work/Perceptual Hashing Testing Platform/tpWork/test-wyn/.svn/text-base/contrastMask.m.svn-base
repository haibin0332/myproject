%{
	源自《信息隐藏技术实验教程》第八章
	Watson: 对比度掩蔽

计算对比度掩蔽阈值矩阵
要注意，对比度阈值的计算是基于亮度阈值的

调用 ： 
	contrastThreshold = contrastMask(img)
输入要求为灰度图像
%}
function contrastThreshold = contrastMask(img,DCTcoef)
%% get input
if ischar(img)
	A=imread(img);
else 
	A = img;
end
A=double(A);
%% 分块DCT变换
if nargin ==1
% 	T=dctmtx(8);
% 	DCTcoef=blkproc(A,[8 8],'P1*x*P2',T,T');
	DCTcoef=blkproc(A,[8 8],@dct2);
end 
%% 调用函数计算亮度阈值
luminanceThreshold = luminanceMask(A,DCTcoef); % 这里通过参数设置可以提高效率，DCT只需要一次
%% 计算W(ij)的修正值
[m,n]=size(DCTcoef);
for i=1:m
    for j=1:n
        another(i,j)=(abs(DCTcoef(i,j))^0.7)*(luminanceThreshold(i,j)^0.3);
    end
end

contrastThreshold=zeros([m,n]);
for i=1:m
    for j=1:n
        if luminanceThreshold(i,j)<=another(i,j)
            contrastThreshold(i,j)=another(i,j);
        else
            contrastThreshold(i,j)=luminanceThreshold(i,j);
        end
    end
end