%{
���裺 
1�� �ֱ���ȡ�����浽���Ե��ļ���
2�� Inter��Intra����
3�� �ֱ����ͼ�Σ����浽���Ե��ļ���
%}
%
%% getInputs_mbe_extract
% function [savemat] = mbe_extract(extractPlan)
extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});

extractPlan(1).imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
extractPlan(1).testImages = 'testImages';
extractPlan(1).outdir = 'E:\DoctorThesis\MBench\Plan\outdir\luoming_modifyVMWaveletWithLumimask\power1_with_contrastThreshold';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_luoming_modifyVMWaveletWithLumimask;
extractPlan(1).params = '';

% �������attMethods �� images �ķ���
load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};

extractPlan(1).includeAttacks = allAttacks(1:end);	% ѡ����ԵĹ�������, �������cell    
extractPlan(1).includeImages = allImages(1:38); % ѡ��ͼ�� ǰ38�Ŷ�����Ȼͼ������û�к���ͼ

clear testImages allAttacks allImages

mbe_extract(extractPlan)
clear
%}
%
%% getInputs_mbe_extract
% function [savemat] = mbe_extract(extractPlan)
extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});

extractPlan(1).imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
extractPlan(1).testImages = 'testImages';
extractPlan(1).outdir = 'E:\DoctorThesis\MBench\Plan\outdir\luoming_modifyVMWaveletWithLumimask\power50_with_contrastThreshold';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_luoming_modifyVMWaveletWithLumimask;
extractPlan(1).params = 50;

% �������attMethods �� images �ķ���
load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};

extractPlan(1).includeAttacks = allAttacks(1:end);	% ѡ����ԵĹ�������, �������cell    
extractPlan(1).includeImages = allImages(1:38); % ѡ��ͼ�� ǰ38�Ŷ�����Ȼͼ������û�к���ͼ

clear testImages allAttacks allImages

mbe_extract(extractPlan)
clear
%}
%
%% getInputs_mbe_extract
% function [savemat] = mbe_extract(extractPlan)
extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});

extractPlan(1).imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
extractPlan(1).testImages = 'testImages';
extractPlan(1).outdir = 'E:\DoctorThesis\MBench\Plan\outdir\WatsonAsPH';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_WatsonAsPH;
extractPlan(1).params = '';

% �������attMethods �� images �ķ���
load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};

extractPlan(1).includeAttacks = allAttacks(1:end);	% ѡ����ԵĹ�������, �������cell    
extractPlan(1).includeImages = allImages(1:38); % ѡ��ͼ�� ǰ38�Ŷ�����Ȼͼ������û�к���ͼ

clear testImages allAttacks allImages

mbe_extract(extractPlan)
clear
%}