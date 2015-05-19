%{
这个文件执行对 Fridrich_bitsextraction_HVSWeighted 的测试：）
%}


%{
步骤： 
1： 分别提取，保存到各自的文件夹
2： Inter和Intra测试
3： 分别绘制图形，保存到各自的文件夹
%}

%{
%% getInputs_mbe_extract
% function [savemat] = mbe_extract(extractPlan)
extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});

extractPlan(1).imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
extractPlan(1).testImages = 'testImages';
extractPlan(1).outdir = 'E:\DoctorThesis\MBench\Plan\outdir\Fridrich_HVSWeighted\method_2_normalBlocking';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_Fridrich_bitsextraction_HVSWeighted;
extractPlan(1).params = [1010 16 50 2];

% 获得所有attMethods 和 images 的方法
load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};

extractPlan(1).includeAttacks = allAttacks(1:end);	% 选择针对的攻击类型, 保存的是cell    
extractPlan(1).includeImages = allImages(1:38); % 选择图像 前38张都是自然图，但是没有航空图

clear testImages allAttacks allImages

mbe_extract(extractPlan)
clear
%}
%% function [savemat] = mbe_extract(extractPlan)
%{
extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});

extractPlan(1).imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
extractPlan(1).testImages = 'testImages';
extractPlan(1).outdir = 'E:\DoctorThesis\MBench\Plan\outdir\Fridrich_HVSWeighted\method_1_40_randomBlocking';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_Fridrich_bitsextraction_HVSWeighted;
extractPlan(1).params = [1010 40 20 1];

% 获得所有attMethods 和 images 的方法
load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};

extractPlan(1).includeAttacks = allAttacks(1:end);	% 选择针对的攻击类型, 保存的是cell    
extractPlan(1).includeImages = allImages(1:38); % 选择图像 前38张都是自然图，但是没有航空图

clear testImages allAttacks allImages

mbe_extract(extractPlan)
clear
%}
%% getInputs_mbe_extract
%{
% function [savemat] = mbe_extract(extractPlan)
extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});

extractPlan(1).imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
extractPlan(1).testImages = 'testImages';
extractPlan(1).outdir = 'E:\DoctorThesis\MBench\Plan\outdir\Fridrich_HVSWeighted\original';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_Fridrich_bitsextraction;
% extractPlan(1).params = [1 64];

% 获得所有attMethods 和 images 的方法
load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};

extractPlan(1).includeAttacks = allAttacks(1:end);	% 选择针对的攻击类型, 保存的是cell    
extractPlan(1).includeImages = allImages(1:38); % 选择图像 前38张都是自然图，但是没有航空图

clear testImages allAttacks allImages

mbe_extract(extractPlan)
clear
%}
%% function [savemat] = mbe_extract(extractPlan)
%
extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});

extractPlan(1).imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
extractPlan(1).testImages = 'testImages';
extractPlan(1).outdir = 'E:\DoctorThesis\MBench\Plan\outdir\Fridrich_HVSWeighted\method_1_256_randomBlocking';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_Fridrich_bitsextraction_HVSWeighted;
extractPlan(1).params = [1010 256 20 1];

% 获得所有attMethods 和 images 的方法
load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};

extractPlan(1).includeAttacks = allAttacks(1:end);	% 选择针对的攻击类型, 保存的是cell    
extractPlan(1).includeImages = allImages(1:38); % 选择图像 前38张都是自然图，但是没有航空图

clear testImages allAttacks allImages

mbe_extract(extractPlan)
clear
%}
%% function [savemat] = mbe_extract(extractPlan)
%{
extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});

extractPlan(1).imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
extractPlan(1).testImages = 'testImages';
extractPlan(1).outdir = 'E:\DoctorThesis\MBench\Plan\outdir\Fridrich_HVSWeighted\method_1_256_reciprocal';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_Fridrich_HVSWeighted_reciprocal;
extractPlan(1).params = [1010 256 20 1];

% 获得所有attMethods 和 images 的方法
load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};

extractPlan(1).includeAttacks = allAttacks(1:end);	% 选择针对的攻击类型, 保存的是cell    
extractPlan(1).includeImages = allImages(1:38); % 选择图像 前38张都是自然图，但是没有航空图

clear testImages allAttacks allImages

mbe_extract(extractPlan)
clear
%}
% %% function [savemat] = mbe_extract(extractPlan)
% %
% extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});
% 
% extractPlan(1).imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
% extractPlan(1).testImages = 'testImages';
% extractPlan(1).outdir = 'E:\DoctorThesis\MBench\Plan\outdir\Fridrich_HVSWeighted\method_1_200_HVSOnly';
% extractPlan(1).customedOutName = '';
% extractPlan(1).algfun = @mbe_Fridrich_HVSOnly;
% extractPlan(1).params = [1010 200 10 1];
% 
% % 获得所有attMethods 和 images 的方法
% load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
% allAttacks = {testImages(1).imAttacked.attMethod};
% allImages = {testImages.imOriginal};
% 
% extractPlan(1).includeAttacks = allAttacks(1:end);	% 选择针对的攻击类型, 保存的是cell    
% extractPlan(1).includeImages = allImages(1:38); % 选择图像 前38张都是自然图，但是没有航空图
% 
% clear testImages allAttacks allImages
% 
% mbe_extract(extractPlan)
% clear
% %}
%% function [savemat] = mbe_extract(extractPlan)
%{
extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});

extractPlan(1).imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
extractPlan(1).testImages = 'testImages';
extractPlan(1).outdir = 'E:\DoctorThesis\MBench\Plan\outdir\Fridrich_HVSWeighted\method_2_reciprocal';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_Fridrich_HVSWeighted_reciprocal;
extractPlan(1).params = [1010 200 10 2];

% 获得所有attMethods 和 images 的方法
load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};

extractPlan(1).includeAttacks = allAttacks(1:end);	% 选择针对的攻击类型, 保存的是cell    
extractPlan(1).includeImages = allImages(1:38); % 选择图像 前38张都是自然图，但是没有航空图

clear testImages allAttacks allImages

mbe_extract(extractPlan)
clear
%}