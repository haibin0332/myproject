function [savemat] = mba_haibin_minkowski(channels,beta,outdir)
% 这个算法集成几个算法的输出，使用明科斯基和
%{
这个函数合并几个算法的输出。算法的hashvector是归一化的，有些不是。所以到这里面来之后还需要解决归一化的问题。
参数： 
	channels
		一个矩阵，包含各个通道的 matfile
	channels = struct('hashMatFile',{},'normlizedRange',{},'params',{});
	beta 
		计算明科斯基和需要用到的beta
	outdir
		结果保存的目录

假定所有通道的结构都是一样的

到目前为止，只支持两种通道的输入
一种是使用汉明距的，BER
一种是使用欧式距离的，在这个函数内部处理归一化的问题。
%	Euclidean distance
在对欧式距离进行归一化的时候，稳定的参量由 IntraClassTest 获得，intraclasstest 结果分布的中心就是有意义的距离的最大值。
可以将其归一化到 0 - 1 之间 但是需要一个Intra测试的数据集
%	Hamming distance
对于汉明距而言，归一化之后的肯定在 0 - 1 之间。


这个函数的提取计划是单独的，因为他的输入不是图像。虽然也可以改成图像的，但是好像没有必要这么麻烦
%}
%{
为了计算这个分布的中心： 
Applying the mode function to a sample from that distribution is unlikely to provide a 
good estimate of the peak; it would be better to compute a histogram or density estimate 
and calculate the peak of that estimate. 
使用mode并不是一个好的估计分布峰值的办法，因为在分布峰值附近，因为采样的关系可能会产生好几个接近的峰值
更好的办法是先计算直方图的包络，然后取其峰值。

计算直方图的包络可以使用：[f,xi,u] = ksdensity(intraDistances,'npoints',100)
注意调节其参数 'kernel' 以获得最好的效果
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
intraMat = load(channels(1).intraMat);		% 这么弄一下后面的动态赋值才有作用，也不知道更规范的方法是什么
interMat = load(channels(1).interMat);
for r = 1:length(channels)
	intraMat(r) = load(channels(r).intraMat);
	interMat(r) = load(channels(r).interMat);
end

%% intraClass test
% 归一化， 
for k = 1:length(channels)
	DisVect(k) = {intraMat(k).intraClassTest.intraDistances};
	if strcmp(channels(k).normlizedRange,'Euclidean')
		DisVect(k) = normlizeIt(DisVect{k},channels(k).params);		
	end
end % end for k

% 求和
minkowskiDistance = minkowskiSum(DisVect,beta);

% 保存起来 按照一般算法 inter 和 intra 的格式
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
% 归一化 求和
clear DisVect
for r = 1:length(interMat(1).interClassTest.interDistance)
	for k = 1:length(channels)
		DisVect(k) = {interMat(k).interClassTest.interDistance(r).Distances};	
		if strcmp(channels(k).normlizedRange,'Euclidean')
			DisVect(k) = normlizeIt(DisVect{k},channels(k).params);		
		end
	end 
	minkowskiDistance = minkowskiSum(DisVect,beta);
	% 保存起来 按照一般算法 inter 和 intra 的格式
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
interClassTestPlan(1).includeAttacks = interMat(1).interClassTest.interClassTestPlan.includeAttacks; % 这里的两个信息在后面的ROC中需要使用 
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
	outVector = {inVector./(2*denominator)}; % 对于汉明距的情况，需要注意的是归一化的目标应该是 0-0.5， 因为intra测试集中的点应该是0.5
end % end for function
