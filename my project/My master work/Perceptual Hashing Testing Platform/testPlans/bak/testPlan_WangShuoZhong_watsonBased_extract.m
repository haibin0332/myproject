%{
这个文件执行对 mbe_WangShuoZhong_watsonBased 的测试：）
仅提取
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
extractPlan(1).outdir = 'E:\DoctorThesis\MBench\Plan\outdir\mbe_WangShuoZhong_watsonBased\Original';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_WangShuoZhong_watsonBased;
extractPlan(1).params = [1 64];

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
%{
%% getInputs_mbe_extract
% function [savemat] = mbe_extract(extractPlan)
extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});

extractPlan(1).imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
extractPlan(1).testImages = 'testImages';
extractPlan(1).outdir = 'E:\DoctorThesis\MBench\Plan\outdir\mbe_WangShuoZhong_watsonBased\Corrected';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_WangShuoZhong_watsonBased_corrected;
extractPlan(1).params = [1 64];

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

%
%% getInputs_mbe_extract
% function [savemat] = mbe_extract(extractPlan)
extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});

extractPlan(1).imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
extractPlan(1).testImages = 'testImages';
extractPlan(1).outdir = 'E:\DoctorThesis\MBench\Plan\outdir\mbe_WangShuoZhong_watsonBased\WithoutM';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_WangShuoZhong_watsonBased_WithoutM;
extractPlan(1).params = [1 64];

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
%



