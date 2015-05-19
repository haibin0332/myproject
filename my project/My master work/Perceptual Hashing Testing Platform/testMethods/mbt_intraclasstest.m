%{
�����ȡ��hashִֵ�� intraclass ���ԣ�
��ͬһ��ͼ�� ����ԭͼ���ܹ���֮���ͼ��֮��� ����
��������ע intraclass test ���߼��������� 
	1��ƥ���㷨
	2�����Խ������
	3�������Щͼ���㷨������ִ�в���

input:
	intraClassTestPlan
		intraClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',{},...
								'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{},'includeAttacks',{},'includeImages',{});
			workdir
				���� extractedImages ��·�������·�������������ĳһ���㷨���в��ԵĹ���·�����������Ľ��������������
			extractedImages
				mat �ļ����� ���磺��extractBy-mbe_yanan��
			customedOutName
				��ͬ����Ŀ�Ŀ��ܻ���������ͬ�� intraClassTest �ṹ������������ڱ�ʶ���ֲ�ͬ��
				���û������Ҫ�������������Ϊ�ա���Ϊ ���̻��Զ�����һ�� ���ơ�
			algfun
				�㷨�ĺ��������磺 mbe_yanan 
			matchfun
				����ָ�룺 @match_yanan ���������ͨ�ĺ����࣬��ô����Ϊ�գ���Ӧ��DistRangeΪ��0��1��
			params
				ƥ�亯��������Ҫʹ�õĲ���,
                Ϊ����Ӧ���ֲ�ͬ�������͵���Ҫ�� params Ӧ����һ��cell���飬��ƥ�亯���н���cell�Ĵ�����Ŀǰ��û���õ��ⷽ��Ĺ���
			normalizedDistRange
				��ʾmatchfun�ķ����Ƿ񾭹���normalize�����Ϊ�գ���ʾû�о���Normalize,�����Ϊ�գ�Ӧ��ָ����С��Χ���磺 [0,1]
                ���������������Ӧ����Ϊ�˱�֤��ͼ�Ĺ淶�����Ǻ������˶Բ������ݵĹ�һ���������������ûʲô���ˡ���������ˡ�
			includeAttacks
				׼�������Ĺ����������б�
			includeImages
				׼��������ͼ����б�
output:
	savemat: �����������Ӧ���Ǳ��������Ϣ��mat�ļ�
���ã�
	getInputs_MBT_intraclasstest
	savemat = mbt_intraclasstest(intraClassTestPlan);
%}
 
function [savemat] = mbt_intraclasstest(intraClassTestPlan)
%% test input
  getInputs_mbt_intraclasstest

%% get inputs
workdir = intraClassTestPlan(1).workdir;
extractedImages = intraClassTestPlan(1).extractedImages;
customedOutName = intraClassTestPlan(1).customedOutName;
matchfun = intraClassTestPlan(1).matchfun;
params = intraClassTestPlan(1).params;
includeAttacks = intraClassTestPlan(1).includeAttacks;
includeImages = intraClassTestPlan(1).includeImages;

hashmatfile = fullfile(workdir,extractedImages);
load(hashmatfile);

%% Preallocation
intraDistance = struct('attMethod',{},'attStrength',{},'Distances',{});
intraClassTest = struct('intraClassTestPlan',{},...
						'intraDistance',struct('attMethod',{},'attStrength',{},'Distances',{}));
% ���ÿ�ֹ�������һ�����󣬾������������ͼ�񣬾��������ÿ�ֹ���ǿ��֮�¼���õ���Distance��
[imBe, indexInclude, indexImages] = intersect(includeImages, {extractedImages.imOriginal});

intraClassTest = setfield(intraClassTest,{1},'intraClassTestPlan',intraClassTestPlan);

for r = sort(indexImages)
	hashAttacked = extractedImages(r).hashAttacked;
	[attBe, indexInclude, indexAttacks] = intersect(includeAttacks, {hashAttacked.attMethod});
	
	cCounter = 0;
	for c = sort(indexAttacks)
		cCounter = cCounter + 1;
		intraDistance = setfield(intraDistance,{cCounter},'attMethod',hashAttacked(c).attMethod);
		intraDistance = setfield(intraDistance,{cCounter},'attStrength',hashAttacked(c).attStrength);	
		Distances = zeros(length(imBe),length(hashAttacked(c).attStrength)); % ÿ�ж�Ӧһ��ͼ��ÿ�ж�Ӧһ������ǿ�ȡ�
		intraDistance = setfield(intraDistance,{cCounter},'Distances',Distances);
	end
	intraClassTest = setfield(intraClassTest,{1},'intraDistance',intraDistance);
	break;
end
%% Calculate the Distance between two hash values
rCounter = 0;
for r = sort(indexImages)
	rCounter = rCounter + 1;
	hashAttacked = extractedImages(r).hashAttacked;
	[attBe, indexInclude, indexAttacks] = intersect(includeAttacks, {hashAttacked.attMethod});
	
	hashOriginal = extractedImages(r).hashOriginal;
	hashAttacked = extractedImages(r).hashAttacked;
	
	cCounter = 0;
	for c = sort(indexAttacks)
		cCounter = cCounter + 1;
		for k = 1:length(hashAttacked(c).attStrength)
			hashVector = cell2mat(hashAttacked(c).hashVector(k));
			Distance = findDistance(hashOriginal,hashVector,matchfun,params);
			intraClassTest.intraDistance(cCounter).Distances(rCounter,k) = Distance; % ÿ�ж�Ӧһ��ͼ��ÿ�ж�Ӧһ������ǿ�ȡ�
		end
	end
	r  % ��ӡ���ȣ������ż�
end
%% save outfile
if isempty(customedOutName)
	savemat = fullfile(workdir,['intraTest-',intraClassTestPlan(1).extractedImages]);
else
	savemat = fullfile(workdir,['intraTest-',intraClassTestPlan(1).extractedImages,'_',customedOutName]);
end
if exist(savemat,'file') ~= 0
	movefile(savemat, [savemat, '.bak']);
end 
save(savemat,'intraClassTest');
end % end for function

%% find the distance between two hash values
function [NormalizedDistance] = findDistance(hashReference,hashTest,matchfun,params)
	if isempty(matchfun) % ���ھ��󲿷��������������������
		NormalizedDistance = sum(abs(hashReference - hashTest))/length(hashTest);
	else
		NormalizedDistance = matchfun(hashReference,hashTest,params);
	end
end