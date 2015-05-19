function [saveinter saveintra] = normalizeDistanceMat(interMatfile, intraMatfile, workdir,sampleNumber,from, to)
% 这个函数用于将intra 和 inter 测试产生的结果归一化
%{
对于欧式距离，归一化的方法就是将inter测试的结果的分布中心作为上界，与归一化的汉明距相比，这个上界应该对应在 0.5 上

所有归一化的问题都可以转换为两个区间的映射：[x1 y1]到[x2 y2]，设a、b分别属于这两个区间，且互相对应，则归一化关系为：
	(a - x1)/(y1 - x1) = (b - x2)/(y2 - x2)

这个函数的输入：
	如果指定from to，则直接转换
	如果没有指定，那么是欧式距离的情况
%}

%% test input
% intraMatfile = 'intraTest-extractBy-mbe_VishalMonga_SVD.mat';
% interMatfile = 'interTest-extractBy-mbe_VishalMonga_SVD.mat';
% workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\SVD';
% sampleNumber = 100;

%% get input
if ~isempty(intraMatfile)
    intraMat = load(fullfile(workdir,intraMatfile));
end
if ~isempty(interMatfile)
    interMat = load(fullfile(workdir,interMatfile));
end

if ~isempty(interMatfile)
%% build a struct to store data will be generated
    interClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
                            {},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{});
    interClassTest = struct('interClassTestPlan',{},'interDistances',{});
%% 遍历 归一化 保存

    x = interMat.interClassTest.interDistances;
    if isempty(from) %如果from为空，表示为欧式距离的情况，from to由inter测试结果计算得到
        [peak,center] = peakOfDistribution(x,sampleNumber);
        from = [0,center];
        to = [0, 0.5];
    end
    normarlizedinterDistance = normlizeIt(x,from,to);
    % copy
    interClassTestPlan(1).workdir = interMat.interClassTest.interClassTestPlan.workdir;
    interClassTestPlan(1).extractedImages = interMat.interClassTest.interClassTestPlan.extractedImages;
    interClassTestPlan(1).customedOutName = 'NormalizedBy-normalizeDistanceMat';
    interClassTestPlan(1).algfun = interMat.interClassTest.interClassTestPlan.algfun;
    interClassTestPlan(1).matchfun = interMat.interClassTest.interClassTestPlan.matchfun;
    interClassTestPlan(1).params = interMat.interClassTest.interClassTestPlan.params;
    interClassTestPlan(1).normalizedDistRange = '';

    interClassTest(1).interClassTestPlan = interClassTestPlan;
    interClassTest(1).interDistances = normarlizedinterDistance{1};

    % save
    saveinter = fullfile(workdir,['normalized-',interMatfile]);
    if exist(saveinter,'file') ~= 0
        movefile(saveinter, [saveinter, '.bak']);
    end 
    if isdir(workdir) ~= 1
        mkdir(workdir);
    end
    save(saveinter,'interClassTest');
else
    saveinter = '';
end
if ~isempty(intraMatfile)
%% build a struct to store data will be generated
    intraClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
                            {},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{},'includeAttacks',{},'includeImages',{});
    intraDistance = struct('attMethod',{},'attStrength',{},'Distances',{});
    intraClassTest = struct('intraClassTestPlan',{},...
                            'intraDistance',struct('attMethod',{},'attStrength',{},'Distances',{}));

%% 遍历 归一化 保存
    for k = 1:length(intraMat.intraClassTest.intraDistance)
        normalizedintraDistances =  normlizeIt(intraMat.intraClassTest.intraDistance(k).Distances,from,to);
        intraDistance(k).attMethod = intraMat.intraClassTest.intraDistance(k).attMethod;
        intraDistance(k).attStrength = intraMat.intraClassTest.intraDistance(k).attStrength;
        intraDistance(k).Distances = normalizedintraDistances{1};
    end % end for k

    intraClassTestPlan(1).workdir = intraMat.intraClassTest.intraClassTestPlan.workdir;
    intraClassTestPlan(1).extractedImages = intraMat.intraClassTest.intraClassTestPlan.extractedImages;
    intraClassTestPlan(1).customedOutName = 'NormalizedBy-normalizeDistanceMat';
    intraClassTestPlan(1).algfun = intraMat.intraClassTest.intraClassTestPlan.algfun;
    intraClassTestPlan(1).matchfun = intraMat.intraClassTest.intraClassTestPlan.matchfun;
    intraClassTestPlan(1).params = intraMat.intraClassTest.intraClassTestPlan.params;
    intraClassTestPlan(1).normalizedDistRange = '';
    intraClassTestPlan(1).includeAttacks = intraMat.intraClassTest.intraClassTestPlan.includeAttacks;
    intraClassTestPlan(1).includeImages = intraMat.intraClassTest.intraClassTestPlan.includeImages;

    intraClassTest(1).intraClassTestPlan = intraClassTestPlan;
    intraClassTest(1).intraDistance = intraDistance;

    saveintra = fullfile(workdir,['normalized-',intraMatfile]);
    if exist(saveintra,'file') ~= 0
        movefile(saveintra, [saveintra, '.bak']);
    end 
    if isdir(workdir) ~= 1
        mkdir(workdir);
    end
    save(saveintra,'intraClassTest');
else
    saveintra = '';
end
end
%% normlizeIt					
function [outVector] = normlizeIt(inVector,from,to)
% (a - x1)/(y1 - x1) = (b - x2)/(y2 - x2) 
% b = (a - x1)(y2 - x2)/(y1 - x1) + x2
	x1 = from(1);
	y1 = from(2);
	x2 = to(1);
	y2 = to(2);
	outVector = {(inVector - x1).*(y2 - x2)./(y1 - x1) + x2}; % 对于汉明距的情况，需要注意的是归一化的目标应该是 0-0.5， 因为inter测试集中的点应该是0.5
end % end for function