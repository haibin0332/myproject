function [savemat] = mba_haibin_minkowski(channels,beta,outdir)
% ����㷨���ɼ����㷨�������ʹ������˹����
%{
��������ϲ������㷨��������㷨��hashvector�ǹ�һ���ģ���Щ���ǡ����Ե���������֮����Ҫ�����һ�������⡣
������ 
	channels
		һ�����󣬰�������ͨ���� matfile
	channels = struct('hashMatFile',{},'normlizedRange',{},'params',{});
	beta 
		��������˹������Ҫ�õ���beta
	outdir
		��������Ŀ¼

�ٶ�����ͨ���Ľṹ����һ����

��ĿǰΪֹ��ֻ֧������ͨ��������
һ����ʹ�ú�����ģ�BER
һ����ʹ��ŷʽ����ģ�����������ڲ������һ�������⡣
%	Euclidean distance
�ڶ�ŷʽ������й�һ����ʱ���ȶ��Ĳ����� IntraClassTest ��ã�intraclasstest ����ֲ������ľ���������ľ�������ֵ��
���Խ����һ���� 0 - 1 ֮�� ������Ҫһ��Intra���Ե����ݼ�
%	Hamming distance
���ں�������ԣ���һ��֮��Ŀ϶��� 0 - 1 ֮�䡣


�����������ȡ�ƻ��ǵ����ģ���Ϊ�������벻��ͼ����ȻҲ���Ըĳ�ͼ��ģ����Ǻ���û�б�Ҫ��ô�鷳
%}
%{
Ϊ�˼�������ֲ������ģ� 
Applying the mode function to a sample from that distribution is unlikely to provide a 
good estimate of the peak; it would be better to compute a histogram or density estimate 
and calculate the peak of that estimate. 
ʹ��mode������һ���õĹ��Ʒֲ���ֵ�İ취����Ϊ�ڷֲ���ֵ��������Ϊ�����Ĺ�ϵ���ܻ�����ü����ӽ��ķ�ֵ
���õİ취���ȼ���ֱ��ͼ�İ��磬Ȼ��ȡ���ֵ��

����ֱ��ͼ�İ������ʹ�ã�[f,xi,u] = ksdensity(intraDistances,'npoints',100)
ע���������� 'kernel' �Ի����õ�Ч��
%}
%% test inputs
beta = 4
outdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\minkowskiSum';
channels = struct('intraMat',{},'interMat',{},'normlizedRange',{},'params',{});
sampleNumber = 100;

matdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\SVD';
intraMat = 'IntraTest-extractBy-mbe_VishalMonga_SVD.mat';
intraMat = fullfile(matdir,intraMat);
channels = setfield(channels,{1},'intraMat',intraMat);
interMat = 'InterTest-extractBy-mbe_VishalMonga_SVD.mat';
interMat = fullfile(matdir,interMat);
channels = setfield(channels,{1},'interMat',interMat);
channels = setfield(channels,{1},'normlizedRange','Euclidean'); %Euclidean distance
load(intraMat);
x = intraClassTest.intraDistances;
[peak,center] = peakOfDistribution(x,sampleNumber);
channels = setfield(channels,{1},'params',center);

matdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\wavelet';
intraMat = 'IntraTest-extractBy-mbe_VishalMonga_wavelet.mat';
intraMat = fullfile(matdir,intraMat);
channels = setfield(channels,{2},'intraMat',intraMat);
interMat = 'InterTest-extractBy-mbe_VishalMonga_wavelet.mat';
interMat = fullfile(matdir,interMat);
channels = setfield(channels,{2},'interMat',interMat);
channels = setfield(channels,{2},'normlizedRange','Euclidean'); 
load(intraMat);
x = intraClassTest.intraDistances;
[peak,center] = peakOfDistribution(x,sampleNumber);
channels = setfield(channels,{2},'params',center);

%% build a struct to store data will be generated
intraClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
 						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{});
intraClassTest = struct('intraClassTestPlan',{},'intraDistances',{});

%% get inputs
if isempty(channels)
	error('empty channels');
end
intraMat = load(channels(1).intraMat);		% ��ôŪһ�º���Ķ�̬��ֵ�������ã�Ҳ��֪�����淶�ķ�����ʲô
interMat = load(channels(1).interMat);
for r = 1:length(channels)
	intraMat(r) = load(channels(r).intraMat);
	interMat(r) = load(channels(r).interMat);
end

%% intraClass test
% ��һ���� 
for k = 1:length(channels)
	DisVect(k) = {intraMat(k).intraClassTest.intraDistances};
	if strcmp(channels(k).normlizedRange,'Euclidean')
		DisVect(k) = normlizeIt(DisVect{k},channels(k).params);		
	end
end % end for k

% ���
minkowskiDistance = minkowskiSum(DisVect,beta);

% �������� ����һ���㷨 inter �� intra �ĸ�ʽ
intraClassTestPlan(1).workdir = '';
intraClassTestPlan(1).extractedImages = '';
intraClassTestPlan(1).customedOutName = '';
intraClassTestPlan(1).algfun = 'mba_haibin_minkowski';
intraClassTestPlan(1).matchfun = '';
intraClassTestPlan(1).params = '';
intraClassTestPlan(1).normalizedDistRange = '';

intraClassTest(1).intraClassTestPlan = intraClassTestPlan;
intraClassTest(1).intraDistances = minkowskiDistance;

%% save outfile
savemat = fullfile(outdir,['IntraTest-minkowski']);
if exist(savemat,'file') ~= 0
	movefile(savemat, [savemat, '.bak']);
end 
if isdir(outdir) ~= 1
	mkdir(outdir);
end
save(savemat,'intraClassTest');
%% build a struct to store data will be generated
interClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{},'includeAttacks',{},'includeImages',{});
interDistance = struct('attMethod',{},'attStrength',{},'Distances',{});
interClassTest = struct('interClassTestPlan',{},...
						'interDistance',struct('attMethod',{},'attStrength',{},'Distances',{}));
%% interClass test
% ��һ�� ���
clear DisVect
for r = 1:length(interMat(1).interClassTest.interDistance)
	for k = 1:length(channels)
		DisVect(k) = {interMat(k).interClassTest.interDistance(r).Distances};	
		if strcmp(channels(k).normlizedRange,'Euclidean')
			DisVect(k) = normlizeIt(DisVect{k},channels(k).params);		
		end
	end 
	minkowskiDistance = minkowskiSum(DisVect,beta);
	% �������� ����һ���㷨 inter �� intra �ĸ�ʽ
	interDistance(r).attMethod = interMat(1).interClassTest.interDistance(r).attMethod;
	interDistance(r).attStrength = interMat(1).interClassTest.interDistance(r).attStrength; 
	interDistance(r).Distances = minkowskiDistance;
end % end for r
interClassTestPlan(1).workdir = '';
interClassTestPlan(1).extractedImages = '';
interClassTestPlan(1).customedOutName = '';
interClassTestPlan(1).algfun = 'mba_haibin_minkowski';
interClassTestPlan(1).matchfun = '';
interClassTestPlan(1).params = '';
interClassTestPlan(1).normalizedDistRange = '';
interClassTestPlan(1).includeAttacks = interMat(1).interClassTest.interClassTestPlan.includeAttacks; % �����������Ϣ�ں����ROC����Ҫʹ�� 
interClassTestPlan(1).includeImages = interMat(1).interClassTest.interClassTestPlan.includeImages;

interClassTest(1).interClassTestPlan = interClassTestPlan;
interClassTest(1).interDistance = interDistance;

savemat = fullfile(outdir,['InterTest-minkowski']);
if exist(savemat,'file') ~= 0
	movefile(savemat, [savemat, '.bak']);
end 
if isdir(outdir) ~= 1
	mkdir(outdir);
end
save(savemat,'interClassTest');
end % end for function

function [outVector] = normlizeIt(inVector,denominator)
	outVector = {inVector./(2*denominator)}; % ���ں�������������Ҫע����ǹ�һ����Ŀ��Ӧ���� 0-0.5�� ��Ϊintra���Լ��еĵ�Ӧ����0.5
end % end for function
