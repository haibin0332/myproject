%{
	源自《信息隐藏技术实验教程》第八章
	Watson: 感知质量度量

仿真Watson模型，给出质量度量

调用 ： 
	qaValue = Qa_watson(imgRef,imgTest)
输入要求为灰度图像
%}
function qaValue = Qa_watson(imgRef,imgTest)
%% test inputs
% imgRef = '1.bmp';
% imgTest = '2.bmp';
%% get inputs
if ischar(imgRef)
	A = imread(imgRef);
else 
	A = imgRef;
end
A=double(A);
if ischar(imgTest)
	B = imread(imgTest);
else 
	B = imgTest;
end
B=double(B);
%% 分块DCT变换求错误图像
T=dctmtx(8);
DCTcoefA=blkproc(A,[8 8],'P1*x*P2',T,T'); 
DCTcoefB=blkproc(B,[8 8],'P1*x*P2',T,T');
e=DCTcoefA-DCTcoefB;
%% 求间隙
contrastThreshold = contrastMask(A,DCTcoefA);

[m,n]=size(e);
d=zeros([m,n]);
for i=1:m
    for j=1:n
        d(i,j)=e(i,j)/contrastThreshold(i,j);
    end
end
%% 误差合并
distortion=0;
for i=1:m
    for j=1:n
        d(i,j)=d(i,j)^4;
        distortion=distortion+d(i,j);
    end
end
qaValue = sqrt(sqrt(distortion));