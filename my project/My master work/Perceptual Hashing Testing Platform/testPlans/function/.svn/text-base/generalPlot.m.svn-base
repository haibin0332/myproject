%% intra 和 inter 试验，并画未经归一化的DS图
%{
    generalPlot
    这个函数用于一般性的试验和画图
    不做归一化，直接DS图
%}
function generalPlot(workdir_Macro,matchfun,mbefun_Marco,customedOutName)
%{
workdir_Macro = 'E:\outdir\500\规则取块随机差分_4块_鲁棒哈希脆弱哈希_sub'; %   fullfile(mbenchpath,'outdir','\substituate\zh_rdd_3')     E:\MBench\outdir\substituate\zh_rdd_4
matchfun = ''; % @match_zh_rdd_method3;  %  @match_VishalMonga_fp; % @match_Fridrich_bitsextraction;  % @match_luomin_modifyVMWaveletWithLumimask_Euclidean  ;  mbe_VishalMonga_FP
mbefun_Marco = 'zh_rdd';
customedOutName = '';
%}
%
%% getInputs_mbt_intraclasstest
% function [savemat] = mbt_intraclasstest(intraClassTestPlan)
intraClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{},'includeAttacks',{},'includeImages',{});

intraClassTestPlan(1).workdir = workdir_Macro;
intraClassTestPlan(1).extractedImages = ['extractBy-',mbefun_Marco];
intraClassTestPlan(1).customedOutName = customedOutName;
intraClassTestPlan(1).algfun = [mbefun_Marco];
intraClassTestPlan(1).matchfun = matchfun;
intraClassTestPlan(1).params = '';
intraClassTestPlan(1).normalizedDistRange = '';

% 如果是多个mat文件的话，情况变得比较复杂
% 1、如果只有一个mat文件
% 2、如果有多个mat文件
% 3、图片只能够在一个mat文件中选择
% 主要还是因为memory的问题，分开处理，分开保存
% 如此在画图的时候，只能够得到一个mat的情况，多个的话，可以再拼装

ls = dir(fullfile(intraClassTestPlan(1).workdir,[intraClassTestPlan(1).extractedImages,'*.mat']));
% 这里的代码提供对ls进行选择的机会，因为并不一定都要用的
ls = ls(1:end);

for i = 1:length(ls)
    intraClassTestPlan(1).extractedImages = ls(i).name;
    load(fullfile(intraClassTestPlan(1).workdir, ls(i).name));
    allAttacks = {extractedImages(1).hashAttacked.attMethod};
    allImages = {extractedImages.imOriginal};

    intraClassTestPlan(1).includeAttacks = allAttacks(1:end); % 选择攻击
    intraClassTestPlan(1).includeImages = allImages(1:end); % 选择图像
%      intraClassTestPlan(1).includeImages = allImages(setdiff([1:length(allImages)],[1 3  20 21  29 32])); % 选择图像
    
    clear extractedImages allAttacks allImages

    mbt_intraclasstest(intraClassTestPlan)
end
%}    
%
%% getInputs_mbt_interclasstest
% function [savemat] = mbt_interclasstest(interClassTestPlan)
interClassTestPlan = struct('workdir',{},'extractedImages',{},'extractedImagesName',{},'customedOutName',...
						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{});


interClassTestPlan(1).workdir = workdir_Macro;
interClassTestPlan(1).extractedImages = ['extractBy-',mbefun_Marco];
interClassTestPlan(1).extractedImagesName = ['extractBy-',mbefun_Marco];
interClassTestPlan(1).customedOutName = customedOutName;
interClassTestPlan(1).algfun = [mbefun_Marco];
interClassTestPlan(1).matchfun = matchfun;
interClassTestPlan(1).params = '';
interClassTestPlan(1).normalizedDistRange = '';

%{
inter的实验只用到hashOriginal一个分量，所以一次读入，简化这个结构输入
%}
ls = dir(fullfile(interClassTestPlan(1).workdir,[interClassTestPlan(1).extractedImages,'*.mat']));
ls = ls(1:end); % 选择
if length(ls) == 1
    load(fullfile(interClassTestPlan(1).workdir,ls(1).name));
    interClassTestPlan(1).extractedImages = extractedImages;
else
    load(fullfile(interClassTestPlan(1).workdir,ls(1).name));
    for i = 1:length(extractedImages)
        tpStruct(i).hashOriginal = extractedImages(i).hashOriginal;
    end        
end 
% 处理多个mat的情况
if length(ls) >= 2
    for i = 2:length(ls)
        interClassTestPlan(1).extractedImages = ls(i).name;
        clear 'extractedImages';
        load(fullfile(interClassTestPlan(1).workdir,ls(i).name));
        for j = 1:length(extractedImages)
            tpStruct1(j).hashOriginal = extractedImages(j).hashOriginal;
        end 
        tpStruct = [tpStruct,tpStruct1];
        clear 'extractedImages','tpStruct1';
    end
    interClassTestPlan(1).extractedImages = tpStruct;
end
    
mbt_interclasstest(interClassTestPlan)

%}
%% mbp_DS 
% [outPath,savemat] = mbp_DS(intraClassTest,plotparameters)
plotparameters = struct('showimage',{},'saveimageto',{},'meanlineonly',{},'saveformats',{});

workdir = workdir_Macro;
inmatfile = ['intraTest-extractBy-',mbefun_Marco];

% intraClassTest = fullfile(workdir,inmatfile);  
ls = dir(fullfile(workdir,[inmatfile,'*.mat']));
ls = ls(1:end); % 选择
intraClassTest = combineIntraMat(workdir,inmatfile,ls);  
        % intraMatCombined = combineIntraMat(workdir,intraMatfiles,ls) 这个函数能够同时处理多个或者一个的问题
        % 但是要注意，如果用的样本过多，可能会导致程序受不了

plotparameters(1).showimage = 'off';
plotparameters(1).saveimageto = fullfile(workdir,['Plot-DS-',mbefun_Marco]);
plotparameters(1).meanlineonly = 'off';
saveformats = ['jpg';'fig'];
plotparameters(1).saveformats = saveformats;

mbp_DS(intraClassTest,plotparameters)

%}

