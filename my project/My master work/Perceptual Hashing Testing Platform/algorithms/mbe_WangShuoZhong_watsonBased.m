%% Comments and References
%{ 
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
function [hashVector] = mbe_WangShuoZhong_watsonBased(imagefile,param)
%% test Inputs
% imagefile = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked\NormalizedOriginalImage\007n.bmp'
% nargin = 1;
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
	I = double(imresize(I,[512,512])); % resize������DCT�任�����Ҽ�ͼ���С��ͬ�����Ĵ�������
end 

%% DCT�任����
I = blkproc(I,[8 8],@dct2);
% T = dctmtx(8);
% I = blkproc(I, [8 8], 'P1 * x * P2',T,T');
%{
'E:\DoctorThesis\MBench\Plan\outdir\imAttacked\NormalizedOriginalImage\007n.bmp' 
�����������ͼ���ܹ����������ִ�����ʽ�����в�ͬ�����߳������������ǲ�֪��Ϊʲô��
%}
%% ������Կ����N����ͼ��I��С��ͬ��α�������
randn('seed',key);	% ʹ��seed����ʵ��ͼƬ����M����M�����Ľ��һ��������ʹ��state����M����M�����Ľ����������λ������
P = zeros([512 512 N]);
for k = 1:N
	P(:,:,k) = randn(512);
end
%% Watsonģ��DCTƵ�����п����ĵ������ٳ���100
M =	[71.43 99.01 86.21 60.24 41.67 29.16 20.88 15.24;
	99.01 68.97 75.76 65.79 50.00 36.90 27.25 20.28;
	86.21 75.76 44.64 38.61 33.56 27.47 21.74 17.01;
	60.24 65.79 38.61 26.53 21.98 18.87 15.92 13.16;
	41.67 50.00 33.56 21.98 16.26 13.14 11.48 9.83;
	29.16 36.90 27.47 18.87 13.14 10.40 8.64  7.40;
	20.88 27.25 21.74 15.92 11.48 8.64  6.90  5.78;
	15.24 20.28 17.01 13.16 9.83  7.40  5.78  4.73];
% ��������
M = padarray(M, [504,504],'circular','post');
%% ����ֵ���㲢����
H = zeros(1,N);
for k = 1:N
 	H(k) = sum(sum(I.*P(:,:,k).*M)); % �����ʽ�Ǹ��ؼ���
end
H(H>=0) = 1;
H(H<0) = 0;
hashVector = H(:);
%% ���� 
%{
����������Ц�㷨�е�һ����
������㷨�У�����Ĺؼ�������key��ʹ�÷�ʽ�����ֵ��ѧϰ��
Key��ʹ�÷�ʽ�� 
	1������key��Ϊ���ӣ����ɶ����ֵΪ0�ľ���
	2���������ԭͼ��DCT�任��������ͣ�ԭͼ��DCT�任�����Ǵ�����������޵ģ�������ͼ��������������������һЩ��������
		��Ϊ���ľ�ֵΪ0����һ���൱�ڶ�DCT�任�������ֵ������һ����0�����������㻹��С�������������ͼ��Ľṹ��Ϣ����һ������ߵ���ֵ���ֵ�Ƚ����ƣ�
	3����ˣ�keyͬʱ������������飺���� �� ��һ����
M�����⣺
	M��ʹ�ô��ںܴ�����⣬ʵ�飺 
		H(k) = sum(sum(I.*P(k).*M)); ������е�.*Mȥ�������Եõ���ȫ��ͬ�ı��롣
	ԭ��
		����key��ʹ�õķ��������ԣ�key�������ǹ�һ��������һ���Ķ�����ͼ���ȫ��������8��8���صķֿ��������ͼ����Բ��������ÿ��8��8�Ŀ춼������ͬ��ȨM���൱��ʲô��û�иɣ���
		��ˣ��ò���M��Ȩ���������һ���ġ���������ĳЩͼ������������ͬ�������Ʋ���䡣
���������и�����һ�����ۣ�
	NԽ�󣬾���Խ��
	�������Ҳ�ǳ����ġ���Ϊÿ��N��������ġ�������ֲ���ƫ����ԭͼ�ķֲ����Ծ�����һ�����Ƿ����0.�������߼����κ�N��û�б����ϵ�����
	? �������Ļ��ɳ�������ôȡ������ͬ����Կ���ӣ����Ӧ���Ǻܽӽ��ġ�����ʵ��֤����������������ô����Ϊʲô��������Key�����⻹�ǲ�����
�������ԣ��������������ԣ�����
%}
