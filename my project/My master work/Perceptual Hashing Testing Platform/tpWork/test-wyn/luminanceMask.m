%{
	Դ�ԡ���Ϣ���ؼ���ʵ��̡̳��ڰ���
	Watson: �����ڱ�

���������ڱ���ֵ����

���� �� 
	luminanceThreshold = luminanceMask(img)
����Ҫ��Ϊ�Ҷ�ͼ��
%}
function luminanceThreshold = luminanceMask(img,DCTcoef)
%% get input
if ischar(img)
	A=imread(img);
else 
	A = img;
end
A=double(A);

%% �ֿ��dct����
if nargin == 1
% 	T=dctmtx(8);%ȡ8*8��ɢ���ұ任
% 	DCTcoef=blkproc(A,[8 8],'P1*x*P2',T,T');%������ͼ��ֿ飬����T����ת��T'��DCT����P1*x*P2�Ĳ���
	DCTcoef=blkproc(A,[8 8],@dct2);
end

%% ����ƽ����DCϵ��
[m,n]=size(DCTcoef);
meanDC=0;
count=0;
for i=0:ceil(m/8-1);%���еĿ���
    for j=0:ceil(n/8-1);
		meanDC=meanDC+DCTcoef(8*i+1,8*j+1);
		count=count+1;
    end
end
meanDC=meanDC/count;

%% ���������ڱ�
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
		%% ����ΪDCTcoefΪ����������Ϊ������ܻ�������Ϊ����
		if result(i,j) == 0
			result(i,j) = 1/meanDC^4;  % ���Ū����С������������㣬����Ҳ��֪��Ӧ��Ū����
		end
    end
end