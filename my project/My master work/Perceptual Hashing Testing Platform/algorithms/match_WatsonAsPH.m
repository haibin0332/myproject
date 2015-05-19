%{
    mbe_WatsonAsPH 的匹配函数
    在这个函数里面，事实上执行的就是Watson的图像质量度量过程
%}
function [qaAsPHDistance] = match_WatsonAsPH(hashreference, hashtest, param)
%% 求误差图像e
e = hashreference.DCTcoef - hashtest.DCTcoef;
 
[m,n]=size(e);
d=zeros([m,n]);
for i=1:m
    for j=1:n
        d(i,j)=e(i,j)/hashreference.contrastThreshold(i,j);
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
qaAsPHDistance = sqrt(sqrt(distortion));