%{
function [hashVector] = mbe_zh_descendingDimensionOfWatson(imagefile,param) 使用的匹配方法，就是Watson求距离的简化形式
%}
function distance = match_zh_descendingDimensionOfWatson(hashReference,hashTest,params)
e = hashReference.hashDCTcoef - hashTest.hashDCTcoef;
[m,n]=size(e);
d=zeros([m,n]);
for i=1:m
    for j=1:n
        d(i,j)=e(i,j)/hashReference.hashcontrastThreshold(i,j);
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
distance = sqrt(sqrt(distortion));