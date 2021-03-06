%% getInputs_mbe_extract
% function [savemat] = mbe_extract(extractPlan)
extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});

extractPlan(1).imdir = 'E:\PH\TestImages';
extractPlan(1).testImages = 'testImages';
extractPlan(1).outdir = 'E:\PH\mbe_yanan';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_yanan;
extractPlan(1).params = '';
% extractPlan(1).params = [2 64 0.71 1/4 1];		%method,n,r2,r1,channel

% 获得所有attMethods 和 images 的方法
load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};

extractPlan(1).includeAttacks = allAttacks(1:end);	% 选择针对的攻击类型, 保存的是cell    :end
extractPlan(1).includeImages = allImages(1:end); % 选择图像

clear testImages allAttacks allImages

%% 
% clear