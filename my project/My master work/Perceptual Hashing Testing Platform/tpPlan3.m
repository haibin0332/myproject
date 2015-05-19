
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

% �������attMethods �� images �ķ���
load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};

extractPlan(1).includeAttacks = allAttacks(1:end);	% ѡ����ԵĹ�������, �������cell    :end
extractPlan(1).includeImages = allImages(351:400); % ѡ��ͼ��

mbe_extract(extractPlan)
timeend = datestr(now)
timebegin
clear
%}