%% getInputs_mbt_intraclasstest
% function [savemat] = mbt_intraclasstest(intraClassTestPlan)
intraClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{},'includeAttacks',{},'includeImages',{});


intraClassTestPlan(1).workdir = 'E:\PH1\mbe_yangbian';
intraClassTestPlan(1).extractedImages = 'extractBy-mbe_bian';
intraClassTestPlan(1).customedOutName = '';
intraClassTestPlan(1).algfun = 'extractBy-mbe_bian';
intraClassTestPlan(1).matchfun = @match_yanan;
% intraClassTestPlan(1).params = [2 64 0.71 1/4];	%method,n,r2,r1;
intraClassTestPlan(1).normalizedDistRange = [0,1];

load(fullfile(intraClassTestPlan(1).workdir, intraClassTestPlan(1).extractedImages));
allAttacks = {extractedImages(1).hashAttacked.attMethod};
allImages = {extractedImages.imOriginal};

intraClassTestPlan(1).includeAttacks = allAttacks(1:end); % Ñ¡Ôñ¹¥»÷
intraClassTestPlan(1).includeImages = allImages(1:end); % Ñ¡ÔñÍ¼Ïñ

clear extractedImages allAttacks allImages


