%{
function [hashVector] = mbe_zh_descendingDimensionOfWatson(imagefile,param) ʹ�õ�ƥ�䷽��������Watson�����ļ���ʽ
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
%% ���ϲ�
distortion=0;
for i=1:m
    for j=1:n
        d(i,j)=d(i,j)^4;
        distortion=distortion+d(i,j);
    end
end
distance = sqrt(sqrt(distortion));