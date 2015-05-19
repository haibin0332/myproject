%{
�������ʹ�ø���ͼ���������۷�������ÿһ��ԭͼ���ܹ���֮���ͼ֮��Ĳ�ࣨ�����������Ӧ�����۷����Ĵ�֣���
���ÿ�ֹ�������һ�����󣬾������������ͼ�񣬾��������ÿ�ֹ���ǿ��֮�µõ��������۷�����֡�

���ÿ�����۷�������һ���ṹ���ýṹ������������ľ���

���룺
	iqaPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'QaMethods',{},'includeAttacks',{},'includeImages',{});
		imdir
			���� testImages ��·��
		testImages
			mat �ļ���
		outdir
			ָ�����·�������� iqa ���̲�����mat�ļ� imageQualityAssessment 
			���·��������һ������·����������㷨extract�� extractedImages ·�������
		customedOutName
			һ��Ϊ�գ���Ҳ����������ʾ�ض�Ŀ��
		QaMethods
			����qa���������Ϣ�Ľṹ��
		includeAttacks
			ָ������ԵĹ���
		includeImages
			ָ������Ե�ͼ��


�����
	������ imageQualityAssessment ��mat�ļ���

Uses��

%}

%% 
function [savemat] = mbq_iqa(iqaPlan)
%% test inputs
getInputs_mbq_iqa

%% get inputs
imdir = iqaPlan.imdir;
testImages = fullfile(imdir,iqaPlan.testImages);
outdir = iqaPlan.outdir;
customedOutName = iqaPlan.customedOutName;
QaMethods = iqaPlan.QaMethods;
includeAttacks = iqaPlan.includeAttacks;
includeImages = iqaPlan.includeImages;

if ~isstruct(testImages)
	load(testImages);
end 
if ~ischar(imdir)
	error('need a dir!');
end
%% build a struct to store data will be generated
QaOnAttacks = struct('attMethod',{},'attStrength',{},'QaValues',{});
imageQualityAssessment = struct('QaMethod',{},'QaOnAttacks',struct('attMethod',{},'attStrength',{},'QaValues',{}));
iqaResult = struct('iqaPlan',{},'imageQualityAssessment',{});
iqaResult = setfield(iqaResult,{1},'iqaPlan',iqaPlan);
%% Preallocation
% ��ҪΪ QaOnAttacks ����ռ䣬QaOnAttacks ����������ݣ����Ƕ���ÿ��ͼ�����ĳߴ綼��һ���ġ�
% ȡ��index
[imBe, indexInclude, indexImages] = intersect(includeImages, {testImages.imOriginal});
[attBe, indexInclude, indexImAttacked] = intersect(includeAttacks, {testImages(1).imAttacked.attMethod});

kCounter = 0;
for k = sort(indexImAttacked)
	kCounter = kCounter + 1;
	QaOnAttacks = setfield(QaOnAttacks,{kCounter},'attMethod',testImages(1).imAttacked(k).attMethod);		% ����ֻ����������ռ�
	QaOnAttacks = setfield(QaOnAttacks,{kCounter},'attStrength',testImages(1).imAttacked(k).attStrength);
	QaValues = zeros(length(indexImages),length(testImages(1).imAttacked(k).attStrength));
	QaOnAttacks = setfield(QaOnAttacks,{kCounter},'QaValues',QaValues);	
end % end for k
for k = 1:length(QaMethods)
	imageQualityAssessment = setfield(imageQualityAssessment,{k},'QaMethod',QaMethods(k).QaMethod); % ���������ĸ�ֵ
	imageQualityAssessment = setfield(imageQualityAssessment,{k},'QaOnAttacks',QaOnAttacks);		% ����ֻ����������ռ�
end % end for k
%{
	�����Ԥ����ռ�Ĺ��̵���������һ����ʵ�� 
	����㣺 ���ÿ��Qa��������һ�� imageQualityAssessment �ṹ�壬 ����һ�� imageQualityAssessment ����
	�м���ڲ㣺 ���ÿ��att��������һ��QaOnAttacks��ÿ��QaOnAttacks�б���һ������ÿ�ж�Ӧһ��ͼƬ��ÿ�ж�Ӧһ������ǿ�ȡ�
	����ÿ��ͼ����ԣ�����������Qa��������һ���ģ�
	����ÿ�ֹ������ԣ�������ͼƬ�͹���ǿ�ȶ���һ���ģ�
	����ÿ��Qa�������ԣ�Qa��ͼƬ�͹�����������һ���ġ�
%}
%% image quality assessment
kCounter = 0;
for k = sort(indexImages)		% Ϊʲôһ��Ҫ��ͼ��ı������������棬��Ϊÿ��ͼ��ֻ��Ҫ��һ�Σ����Ǻ���Ķ���ѭ�������ƻ�Ч��
	kCounter = kCounter + 1;
	imgOriginal = testImages(k).imOriginal;
	imgOriginal = fullfile(imdir,imgOriginal);
	for q = 1:length(QaMethods)
		qafun = QaMethods(q).QaFunction;
		params =  QaMethods(q).params;
		% QaMethod �Ѿ���ֵ����
		aCounter = 0;
		for a = sort(indexImAttacked)
			aCounter = aCounter + 1;
			imageQualityAssessment(q).QaOnAttacks(aCounter).attMethod = testImages(k).imAttacked(a).attMethod;
			imageQualityAssessment(q).QaOnAttacks(aCounter).attStrength = testImages(k).imAttacked(a).attStrength;
% 			testImages(k).imAttacked(a).attMethod
			for l = 1:length(testImages(k).imAttacked(a).attStrength)
				imgAttacked = cell2mat(testImages(k).imAttacked(a).imSaved{l});
				imgAttacked = fullfile(imdir,imgAttacked);
				if isempty(params)
					QaValue = feval(qafun,imgOriginal,imgAttacked);	
				else
					QaValue = feval(qafun,imgOriginal,imgAttacked,params);	
				end
				imageQualityAssessment(q).QaOnAttacks(aCounter).QaValues(kCounter,l) = QaValue;		% ÿ�ж�Ӧһ��ͼ��ÿ�ж�Ӧһ������ǿ�ȡ�
				k
				qafun
				testImages(k).imAttacked(a).attMethod
			end % end for l
		end % end for a
	end % end for q
end % end for k
iqaResult = setfield(iqaResult,{1},'imageQualityAssessment',imageQualityAssessment);
%% save mat file
if isempty(customedOutName)
	savemat = fullfile(outdir,['iqaResult']);
else
	savemat = fullfile(outdir,['iqaResult-',customedOutName]);
end
if isdir(outdir) ~= 1
	mkdir(outdir);
end
if exist(savemat,'file') ~= 0
	movefile(savemat, [savemat, '.bak']);
end 
save(savemat,'iqaResult');
end % end function