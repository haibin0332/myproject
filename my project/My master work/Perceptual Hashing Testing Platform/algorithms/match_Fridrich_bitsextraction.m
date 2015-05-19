%{
按照文献中所说的，匹配的方法是计算每个块对应的bit序列出错的个数，最后对这个个数做一个平均。
可能存在的问题是：
1、这个平均本身就会导致算法鲁棒性很好，区分性过差
2、分块太少本身会导致算法鲁棒性很好，区分性过差，但是如果bit序列的长度N如果对区分性的确有帮助的话，可能会有所补偿。但是我觉得不会
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
	error('哈希序列格式不匹配');
end

for i = 1:M % M块
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

% 这里输出和文献还是有点儿不一样，只是相当于归一化了一下
% 这里可以尝试一下，是不是最后这个求平均的过程是多次一举？也就是说改成如下结果是一样的：
%{
Distance = sum(abs(hashReference(:) - hashTest(:)))/N/M;
%}
% 如果是一样的，是我阅读能力出了问题，还是那个狗屎本身就喜欢瞎说？？？