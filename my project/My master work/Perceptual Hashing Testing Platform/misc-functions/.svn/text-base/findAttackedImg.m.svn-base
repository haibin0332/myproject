%{
编一个工具函数，给定图片名称，攻击方法和攻击强度，在imAttack中找到相应的受攻击之后的图片

			imdir
				保存testImages的路径，这个路径下面保存所有攻击产生的图片和索引信息（testImages）
			testImages
				mat文件的文件名，一般是“testImages.mat”，但也可能不是。

% 获得所有attMethods 和 images 的方法

%}
function imAtt = findAttackedImg(imdir,testImages,imgOrg,attMethod,attStrength);
%% test inputs
% imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
% testImages = 'testImages';
% load(fullfile(imdir,testImages));
% allAttacks = {testImages(1).imAttacked.attMethod};
% allImages = {testImages.imOriginal};
% imgOrg = allImages(2);
% imgOrg = imgOrg{1};
% attMethod = allAttacks(2);
% attStrength = 0.5;
%% function
imAtt = '';
b = 0;
% testImages可以是个向量，也可以是个mat文件
if isstruct(testImages) ~= 1
	testImages = fullfile(imdir,testImages);
	load(testImages);
end
[tBe, indexInclude, indexImages] = intersect(imgOrg, {testImages.imOriginal}); % 肯定只有一个
if indexInclude == 0
	error('米落倒');
end
imAttacked = testImages(indexImages).imAttacked;
[tBe, indexInclude, indexImAttacked] = intersect(attMethod, {imAttacked.attMethod}); % 也肯定只有一个
if indexInclude == 0
	error('米落倒');
end
allStrength = imAttacked(indexImAttacked).attStrength;
for i = 1:length(allStrength)
	if attStrength == allStrength(i)
		imAtt = imAttacked(indexImAttacked).imSaved(i);
		imAtt = imAtt{1,1};
		b = 1;
		break;
	end
end
if b == 0
	error('米落倒');
end
