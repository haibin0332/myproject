%{
��һ�����ߺ���������ͼƬ���ƣ����������͹���ǿ�ȣ���imAttack���ҵ���Ӧ���ܹ���֮���ͼƬ

			imdir
				����testImages��·�������·�����汣�����й���������ͼƬ��������Ϣ��testImages��
			testImages
				mat�ļ����ļ�����һ���ǡ�testImages.mat������Ҳ���ܲ��ǡ�

% �������attMethods �� images �ķ���

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
% testImages�����Ǹ�������Ҳ�����Ǹ�mat�ļ�
if isstruct(testImages) ~= 1
	testImages = fullfile(imdir,testImages);
	load(testImages);
end
[tBe, indexInclude, indexImages] = intersect(imgOrg, {testImages.imOriginal}); % �϶�ֻ��һ��
if indexInclude == 0
	error('���䵹');
end
imAttacked = testImages(indexImages).imAttacked;
[tBe, indexInclude, indexImAttacked] = intersect(attMethod, {imAttacked.attMethod}); % Ҳ�϶�ֻ��һ��
if indexInclude == 0
	error('���䵹');
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
	error('���䵹');
end
