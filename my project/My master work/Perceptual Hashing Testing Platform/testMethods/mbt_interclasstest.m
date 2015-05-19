%{
�����ȡ��hashִ�� interclass ����
interclass������Ϊ������ͼ��������ԣ����ԣ���Ҫ�Ǽ���������ͬ��ͼ֮��ľ��롣
����ԭͼ���������ֻ��ԭͼ֮����в��ԵĻ���һ��ͼ������ͼ֮��ıȽ��ܹ��� n(n-1)�Ρ�
��������ܹ���֮���ͼҲ��Ϊinterclass���Ե��������������ǿ��Եģ�����ʵ��������ȱ�㣺
	1������ǿ�Ȳ����ͼ֮��ıȽϣ���ԭͼ��ֱ�ӱȽ�û������
	2������ǿ��̫���ͼ�п��ܻ����̫����ٽ�hashֵ���ƻ����ݵ������

interClass���ԵĽ���������ô���
	1��ֱ�����ڹ۲����ķֲ������ڹ�һ���ĺ����ࣨBER�������������ֲ�Ӧ����0.5Ϊ���ķֲ������Ի���
��Ӧ��ֱ��ͼ�����ֱ��ͼ�������ڹ۲������ԡ�
	2������ROC���ߵĻ���

����interclass������������ROC���������Ҫ���ǵ������У� 
	1��ROC�������ĳ�ֹ�����ĳ��ǿ�Ƚ��л��ƣ�interclass������Դ��interclass���������е�ĳһ�У�
���ж��ٷ�ͼ�������ԣ����ж��ٸ��������ݡ�����interclass��������ȴ�͹���������ǿ���޹أ�ֻ��
��ȡ��ʽ���㷨����ء�
	2��interclass����������Ϊn��interclass������Ϊn(n-1)���������������⣬����
interclass���ݻ�̫�١���Ȼ��ˣ� ��interclass�Ĳ����У���Ȼ����Ҫѡ��ͼ����Ϊͼ����ܻ�û��ġ�
	3��interclassֻ����ȡ������أ����ԣ�interclass�����ݿ����ڸ���ROC���ߵĻ����и��á�

Ϊ�˱������̫���ӣ����ڴ˴���interclass�����ɢ��ͼ����ֱ��ͼ�������� getInputs_mbt_interclasstest  �и���ʾ��

���룺 
	interClassTestPlan
		interClassTestPlan = struct('workdir',{},'extractedImages',{},'extractedImagesName',{},'customedOutName',{},...
								'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{});
			workdir
				���� extractedImages ��·�������·�������������ĳһ���㷨���в��ԵĹ���·�����������Ľ��������������
			extractedImages
				mat �ļ����� ���磺��extractBy-mbe_yanan��
			customedOutName
				��ͬ����Ŀ�Ŀ��ܻ���������ͬ�� interClassTest �ṹ������������ڱ�ʶ���ֲ�ͬ��
				���û������Ҫ�������������Ϊ�ա���Ϊ ���̻��Զ�����һ�� ���ơ�
			algfun
				�㷨�ĺ��������磺 mbe_yanan 
			matchfun
				����ָ�룺 @match_yanan ���������ͨ�ĺ����࣬��ô����Ϊ�գ���Ӧ��DistRangeΪ��0��1��
			params
				ƥ�亯��������Ҫʹ�õĲ���
			normalizedDistRange
				��ʾmatchfun�ķ����Ƿ񾭹���normalize�����Ϊ�գ���ʾû�о���Normalize,�����Ϊ�գ�Ӧ��ָ����С��Χ���磺 [0,1]
�����
	savemat: �����������Ӧ���Ǳ��������Ϣ��mat�ļ�
%}

function [savemat] = mbt_interclasstest(interClassTestPlan)
%% test input
%  getInputs_mbt_interclasstest

%% get inputs
workdir = interClassTestPlan(1).workdir;
extractedImages = interClassTestPlan(1).extractedImages;
customedOutName = interClassTestPlan(1).customedOutName;
matchfun = interClassTestPlan(1).matchfun;
params = interClassTestPlan(1).params;
% includeAttacks = interClassTestPlan(1).includeAttacks;
% includeImages = interClassTestPlan(1).includeImages;
if ~isstruct(extractedImages)
    hashmatfile = fullfile(workdir,extractedImages);
    load(hashmatfile);
end

%% 
interClassTest = struct('interClassTestPlan',{},'interDistances',{});
% interDistance ��һ�����������������Ϊn(n-1)
% interDistances = zeros(length(extractedImages)*(length(extractedImages) -
% 1)/2,1);
nCounter = 0;
for r = 1:length(extractedImages)
	for c = r+1:length(extractedImages)
		rhashOriginal = extractedImages(r).hashOriginal;
		chashOriginal = extractedImages(c).hashOriginal;
		nCounter = nCounter + 1
		interDistances(nCounter) = findDistance(rhashOriginal,chashOriginal,matchfun,params);
	end % end for c
end % end for r
%% 
interClassTest = setfield(interClassTest,{1},'interClassTestPlan',interClassTestPlan);
interClassTest = setfield(interClassTest,{1},'interDistances',interDistances);
%% save outfile
if isempty(customedOutName)
	savemat = fullfile(workdir,['interTest-',interClassTestPlan(1).extractedImages]);
else
	savemat = fullfile(workdir,['interTest-',interClassTestPlan(1).extractedImages,'_',customedOutName]);
end
if exist(savemat,'file') ~= 0
	movefile(savemat, [savemat, '.bak']);
end 
save(savemat,'interClassTest');
end % end for function
%% find the distance between two hash values
function [NormalizedDistance] = findDistance(hashReference,hashTest,matchfun,params)
	if isempty(matchfun) % ���ھ��󲿷��������������������
		NormalizedDistance = sum(abs(hashReference - hashTest))/length(hashTest);
	else
		NormalizedDistance = matchfun(hashReference,hashTest,params);
	end
end