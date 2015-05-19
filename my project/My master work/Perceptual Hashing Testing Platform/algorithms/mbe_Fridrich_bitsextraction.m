%% Comments and References
%{ 
	ref: 
		Robust bit extraction form images
		Fridrich
		1998
		
	imputs�� ������С�� �Ҷ� ͼ 

	params��
		key		��Կ
		M		�ֿ����
		N		hash���� for each block
	
	hash��ʽ�� 
		���Ӷ���Ķ����������� M�飬ÿ��N��bit
	ƥ�䣺
		match_Fridrich_bitsextraction
        ����Ҫ�����ֻ��Ҫ�ú�����ƥ��Ϳ����ˡ������ĺ�����Щ�����õĶ��������Ѿ����ˣ���
	���ã� 
		param(1) = 1; param(2) = 16; param(3) = 50;
		h1 = mbe_Fridrich_bitsextraction('1.bmp',param)
%}
function [hashVector] = mbe_Fridrich_bitsextraction(imagefile,param)
%% test inputs
nargin = 1;
imagefile = 'E:\PH1\1.bmp';

%% get inputs
if nargin == 1
	key = 1010;
	M = 16;
	N = 50;
else
	key = param{1};
	M = param{2};
	N = param{3};
end
sizeOfImage = 256;
I = imread(imagefile);
sizeI = size(I,1);
if sizeI ~= sizeOfImage 
	I = double(imresize(I,[sizeOfImage,sizeOfImage])); % resize������DCT�任�����Ҽ�ͼ���С��ͬ�����Ĵ�������
end 

%% �ֿ�ΪM*M��
M = sqrt(M);
%% DCT�任����
I = blkproc(I,[8 8],@dct2);
%% ʹ����Կkey��ÿ���ֿ����N������������㡾0��1���ľ��ȷֲ� 
% ����Ĵ�СΪ (512/M)*(512/M) �������ĸ���ΪN*M*M
% ʹ��randn������̬�ֲ��ľ���ʹ��rand�������ȷֲ��ľ���
%randn('seed',key);	% ʹ��seed����ʵ��ͼƬ����M����M�����Ľ��һ��������ʹ��state����M����M�����Ľ����������λ������
rand('seed',key);
P = zeros([sizeOfImage/M sizeOfImage/M N*M*M]);
for k = 1:N*M*M
	P(:,:,k) = rand(sizeOfImage/M);
end
%% �����������е�ͨ�˲����õ��⻬�����ģ��
h = fspecial('gaussian'); % average
for k = 1:N*M*M
	P(:,:,k) = imfilter(P(:,:,k),h,'replicate','same','corr');
end
%% ÿ��ģ�嶼��ȥ���ǵľ�ֵ���õ�DC-free��ģ�壨��0Ϊ�ֲ����ģ�
for k = 1:N*M*M
	P(:,:,k) = P(:,:,k) - sum(sum(P(:,:,k)))/((sizeOfImage/M)*(sizeOfImage/M));
end
%% ��ÿһ���ֿ鶼ͶӰ�����ģ���ϣ����Խ����ͣ�ԭʼ����˵����Absolute Value�����ǲ�֪ȷ����ָ��
H = zeros(M*M,N);
for i = 1:M*M % ��ÿ���ֿ�
	% ȡ������ֿ�ľ���
	iCount = ceil(i/M); % ��
	jCount = mod(i,M);  % ��
	if jCount == 0
		jCount = M;
	end
	iCount = iCount - 1;
	jCount = jCount - 1;

	Imm = I((iCount*sizeOfImage/M)+1:(iCount*sizeOfImage/M)+sizeOfImage/M,(jCount*sizeOfImage/M)+1:(jCount*sizeOfImage/M)+sizeOfImage/M);
	for j = 1:N % ��ÿ���������
		H(i,j) = sum(sum(Imm.*P(:,:,i*j)));
	end
end
%% ��ֵ��
% �����Ǽ򵥵Ķ�ֵ������
%{
H(H>=0) = 1;
H(H<0) = 0;
hashVector = H;
%}
% ��Ӧ�ԵĶ�ֵ�������ǣ��趨��ֵ��ֵΪ0�����0��1��Ŀ�Ĳ��������10%�������ֵ����Ӧ�Եĵ��ڣ�ֱ������10%����Ϊֹ
% ���������ǣ����ܻ���Ϊ��ȡ��ֵ���߾�ֵ���ܹ�ֱ�ӵõ�0��1�����Ч������ʵ�ϲ��������ġ�
% ������ʵ�ϣ���������Ŀ�϶��ʱ����ֵ�������ܹ��ﵽ������Ч��
hashVec = zeros(3,length(H(:)));

m = median(H(:));
tp(H >= m) = 1;
tp(H < m) = 0;
hashVec(1,:) = tp;
sum1 = abs(sum(sum(hashVec(1,:)))- length(H(:))/2);

m = 0;
tp(H >= m) = 1;
tp(H < m) = 0;
hashVec(2,:) = tp;
sum2 = abs(sum(sum(hashVec(2,:)))- length(H(:))/2);

m = mean(mean(H));
tp(H >= m) = 1;
tp(H < m) = 0;
hashVec(3,:) = tp;
sum3 = abs(sum(sum(hashVec(3,:)))- length(H(:))/2);

id = find([sum1 sum2 sum3]==min([sum1 sum2 sum3])); % �ҵ���С��һ��
if size(id,2) > 1
	id = id(1);
end
hashVector = hashVec(id,:);
if (sum(sum(hashVector)) - length(H(:))/2) > length(H(:)) * 0.1
	warning('̫ƫ��') % ��Щʱ��̫ƫ�ˣ������ˣ����ǻ�����һ��СС�ĸĽ�
end

%{
load('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\results.mat');
sizeOfMat = size(str,2);
str = padarray(str,[0 1],'replicate','post');
str(1,sizeOfMat+1).imagefile = imagefile;
str(1,sizeOfMat+1).m = m;
str(1,sizeOfMat+1).H = H;
str(1,sizeOfMat+1).frequencyOfOne = frequencyOfOne;

delete('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\results.mat'); 
save('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\results.mat','str'); 
%}
%{
% initial
str.imagefile = imagefile;
str.m = m;
str.H = H;
str.frequencyOfOne = frequencyOfOne;
save('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\results.mat', 'str');
%}
%% ���� 
%{
%}