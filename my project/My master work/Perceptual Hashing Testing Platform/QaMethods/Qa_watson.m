%{
	Դ�ԡ���Ϣ���ؼ���ʵ��̡̳��ڰ���
	Watson: ��֪��������

����Watsonģ�ͣ�������������

���� �� 
	qaValue = Qa_watson(imgRef,imgTest)
����Ҫ��Ϊ�Ҷ�ͼ��
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
%% �ֿ�DCT�任�����ͼ��
T=dctmtx(8);
DCTcoefA=blkproc(A,[8 8],'P1*x*P2',T,T'); 
DCTcoefB=blkproc(B,[8 8],'P1*x*P2',T,T');
e=DCTcoefA-DCTcoefB;
%% ���϶
contrastThreshold = contrastMask(A,DCTcoefA);

[m,n]=size(e);
d=zeros([m,n]);
for i=1:m
    for j=1:n
        d(i,j)=e(i,j)/contrastThreshold(i,j);
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
qaValue = sqrt(sqrt(distortion));