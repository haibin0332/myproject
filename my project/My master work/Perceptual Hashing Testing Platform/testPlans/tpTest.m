%%
%
timebegin = datestr(now)
extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});

extractPlan(1).imdir = 'F:\imDatabase\BMPBASE';
extractPlan(1).testImages = 'testImages';
extractPlan(1).outdir = 'E:\outdir\500\mbe_zh_rdd\letter';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_zh_rdd;
params(1) = {256};
params(2) = {4};
params(3) = {1};
params(4) = {0};
params(5) = {1};
extractPlan(1).params = params;

% 获得所有attMethods 和 images 的方法
load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};

extractPlan(1).includeAttacks = allAttacks(1:end);	% 选择针对的攻击类型, 保存的是cell    :end
extractPlan(1).includeImages = allImages(1:end); % 选择图像

mbe_extract(extractPlan)
timeend = datestr(now)
timebegin
clear
%%
%{
timebegin = datestr(now)
extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});

extractPlan(1).imdir = 'E:\MBench\outdir\imDatabase';
extractPlan(1).testImages = 'testImages';
extractPlan(1).outdir = 'E:\MBench\outdir\zh_rdd\test6\k8';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_zh_rdd;
params(1) = {256};
params(2) = {1};
params(3) = {1};
params(4) = {8};
params(5) = {5};
extractPlan(1).params = params;

% 获得所有attMethods 和 images 的方法
load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};

extractPlan(1).includeAttacks = allAttacks([1 2 3 4 6 10]);	% 选择针对的攻击类型, 保存的是cell    :end
extractPlan(1).includeImages = allImages(1:end); % 选择图像

mbe_extract(extractPlan)
timeend = datestr(now)
timebegin
clear
%}
%%
%{
timebegin = datestr(now)
extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});

extractPlan(1).imdir = 'E:\MBench\outdir\imDatabase';
extractPlan(1).testImages = 'testImages';
extractPlan(1).outdir = 'E:\MBench\outdir\zh_rdd\test6\m0';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_zh_rdd;
params(1) = {256};
params(2) = {1};
params(3) = {1};
params(4) = {0};
params(5) = {1};
extractPlan(1).params = params;

% 获得所有attMethods 和 images 的方法
load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};

extractPlan(1).includeAttacks = allAttacks([1 2 3 4 6 10]);	% 选择针对的攻击类型, 保存的是cell    :end
extractPlan(1).includeImages = allImages(1:end); % 选择图像

mbe_extract(extractPlan)
timeend = datestr(now)
timebegin
clear
%}