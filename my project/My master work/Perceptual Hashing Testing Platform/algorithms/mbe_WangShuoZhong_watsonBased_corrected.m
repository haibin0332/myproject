%% Comments and References
%{ 
	��������ͼ�����ο����׵ķ����Ĵ���
	������˼·Ϊ��
		ԭ�з����������Ǽ�Ȩ������ÿ��8��8���ص�С���ϣ�����ÿ���Ȩ��һ����������ȫ��Ӱ�첻�󣬵��¼�Ȩ���ò����ԣ�������
		�����ԭ���ǣ�Watsonģ�͵ķ����У���϶���Ǳ�ʾJND��Ӧ�ı䶯�Ĵ�С����Ƶ������ϵ��ֻ��һ���������ѡ�
		��˸�����˼·�ǣ�ʹ�ü�϶��Ȩ����֤ÿ��С��ļ�Ȩ����С�鱾�����Ϣ������صġ�
	�ο�����Ϊ�� 
		һ�ֻ����Ӿ����Ե�ͼ��ժҪ�㷨
		�����ش�����˷�е�
		�й�ͼ��ͼ��ѧ����2006.11��11��  
  
	����ͼ�� ������С�� �Ҷ� ͼ 

	params��
		key		��Կ
		N		hash����
	
	hash��ʽ�� 
		binary vector
	���ã� 
		param(1) = 1; param(2) = 8;
		h1 = mbe_WangShuoZhong_watsonBased('1.bmp',param)
%}
function [hashVector] = mbe_WangShuoZhong_watsonBased_corrected(imagefile,param)
%% test inputs
nargin = 1;
imagefile = 'E:\DoctorThesis\MBench\Plan\2.bmp';
%% get inputs
if nargin == 1
	key = 1;
	N = 64;
else
	key = param(1);
	N = param(2);
end
I = imread(imagefile);
sizeI = size(I,1);
if sizeI ~= 512 
	I = double(imresize(I,[512,512])); % resize������DCT�任�����Ҽ�ͼ���С��ͬ�����Ĵ������
end 
%% DCT�任����
I = blkproc(I,[8 8],@dct2);
% T = dctmtx(8);
% I = blkproc(I, [8 8], 'P1 * x * P2',T,T');
%{
'E:\DoctorThesis\MBench\Plan\outdir\imAttacked\NormalizedOriginalImage\007n.bmp' 
�����������ͼ���ܹ����������ִ���ʽ�����в�ͬ�����߳����������ǲ�֪��Ϊʲô��
%}
%% ������Կ����N����ͼ��I��С��ͬ��α�������
randn('seed',key);	% ʹ��seed����ʵ��ͼƬ����M����M�����Ľ��һ��������ʹ��state����M����M�����Ľ����������λ������
P = zeros([512 512 N]);
for k = 1:N
	P(:,:,k) = randn(512);
end
%% �޸����ڼ�Ȩ��M����
contrastThreshold = contrastMask(I);
M = contrastThreshold;

% %% Watsonģ��DCTƵ�����п����ĵ������ٳ���100
% M =	[71.43 99.01 86.21 60.24 41.67 29.16 20.88 15.24;
% 	99.01 68.97 75.76 65.79 50.00 36.90 27.25 20.28;
% 	86.21 75.76 44.64 38.61 33.56 27.47 21.74 17.01;
% 	60.24 65.79 38.61 26.53 21.98 18.87 15.92 13.16;
% 	41.67 50.00 33.56 21.98 16.26 13.14 11.48 9.83;
% 	29.16 36.90 27.47 18.87 13.14 10.40 8.64  7.40;
% 	20.88 27.25 21.74 15.92 11.48 8.64  6.90  5.78;
% 	15.24 20.28 17.01 13.16 9.83  7.40  5.78  4.73];
% % ��������
% M = padarray(M, [504,504],'circular','post');
%% ����ֵ���㲢����
H = zeros(1,N);
for k = 1:N
 	H(k) = sum(sum(I.*P(:,:,k).*M)); % �����ʽ�Ǹ��ؼ���
end
H(H>=0) = 1;
H(H<0) = 0;
hashVector = H(:);


