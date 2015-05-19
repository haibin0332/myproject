%{
������������˵�ģ�ƥ��ķ����Ǽ���ÿ�����Ӧ��bit���г���ĸ������������������һ��ƽ����
���ܴ��ڵ������ǣ�
1�����ƽ������ͻᵼ���㷨³���Ժܺã������Թ���
2���ֿ�̫�ٱ���ᵼ���㷨³���Ժܺã������Թ���������bit���еĳ���N����������Ե�ȷ�а����Ļ������ܻ����������������Ҿ��ò���
%}
function [Distance] = match_Fridrich_bitsextraction(picId,hashReference, hashTest, param)
%% for test
if nargin == 1
	originalImage = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked\Cropping\001n-Cropping-1.2.bmp';
	testImage = strcat('E:\DoctorThesis\MBench\Plan\outdir\imAttacked\Cropping\001n-Cropping-', num2str(picId), '.bmp');
	hashTest = mbe_Fridrich_bitsextraction(testImage);
	hashReference = mbe_Fridrich_bitsextraction(originalImage);
end

%%
[M N] = size(hashReference);
if [M N] ~= size(hashTest)
	error('��ϣ���и�ʽ��ƥ��');
end

for i = 1:M % M��
	D(i) = sum(abs(hashReference(i,:) - hashTest(i,:)))/N;
end
Distance = sum(D)/M

%% save results
%
load('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\results-compare.mat', 'str');
sizeOfMat = size(str,2);
str = padarray(str,[0 1],'replicate','post');
str(1,sizeOfMat+1).originalImage = originalImage;
str(1,sizeOfMat+1).testImage = testImage;
str(1,sizeOfMat+1).distance = Distance;

delete('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\results-compare.mat'); 
save('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\results-compare.mat','str'); 
%}
%{
% initial
str.originalImage = originalImage;
str.testImage = testImage;
str.distance = Distance;
save('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\results-compare.mat', 'str');
%}

% ������������׻����е����һ����ֻ���൱�ڹ�һ����һ��
% ������Գ���һ�£��ǲ�����������ƽ���Ĺ����Ƕ��һ�٣�Ҳ����˵�ĳ����½����һ���ģ�
%{
Distance = sum(abs(hashReference(:) - hashTest(:)))/N/M;
%}
% �����һ���ģ������Ķ������������⣬�����Ǹ���ʺ�����ϲ��Ϲ˵������