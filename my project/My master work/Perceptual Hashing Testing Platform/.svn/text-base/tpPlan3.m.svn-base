
%% 
%
timebegin = datestr(now)
extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});

extractPlan(1).imdir = 'G:\bmpbase';
extractPlan(1).testImages = 'testImages';
extractPlan(1).outdir = 'E:\testLi\';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_li_LVQHash;
params = '';
extractPlan(1).params = params;

% 获得所有attMethods 和 images 的方法
load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};

extractPlan(1).includeAttacks = allAttacks(1:end);	% 选择针对的攻击类型, 保存的是cell    :end
extractPlan(1).includeImages = allImages(351:400); % 选择图像

mbe_extract(extractPlan)
timeend = datestr(now)
timebegin
clear
%}