%% intra �� inter ���飬����δ����һ����DSͼ
%{
    generalPlot
    �����������һ���Ե�����ͻ�ͼ
    ������һ����ֱ��DSͼ
%}
function generalPlot(workdir_Macro,matchfun,mbefun_Marco,customedOutName)
%{
workdir_Macro = 'E:\outdir\500\����ȡ��������_4��_³����ϣ������ϣ_sub'; %   fullfile(mbenchpath,'outdir','\substituate\zh_rdd_3')     E:\MBench\outdir\substituate\zh_rdd_4
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

% ����Ƕ��mat�ļ��Ļ��������ñȽϸ���
% 1�����ֻ��һ��mat�ļ�
% 2������ж��mat�ļ�
% 3��ͼƬֻ�ܹ���һ��mat�ļ���ѡ��
% ��Ҫ������Ϊmemory�����⣬�ֿ������ֿ�����
% ����ڻ�ͼ��ʱ��ֻ�ܹ��õ�һ��mat�����������Ļ���������ƴװ

ls = dir(fullfile(intraClassTestPlan(1).workdir,[intraClassTestPlan(1).extractedImages,'*.mat']));
% ����Ĵ����ṩ��ls����ѡ��Ļ��ᣬ��Ϊ����һ����Ҫ�õ�
ls = ls(1:end);

for i = 1:length(ls)
    intraClassTestPlan(1).extractedImages = ls(i).name;
    load(fullfile(intraClassTestPlan(1).workdir, ls(i).name));
    allAttacks = {extractedImages(1).hashAttacked.attMethod};
    allImages = {extractedImages.imOriginal};

    intraClassTestPlan(1).includeAttacks = allAttacks(1:end); % ѡ�񹥻�
    intraClassTestPlan(1).includeImages = allImages(1:end); % ѡ��ͼ��
%      intraClassTestPlan(1).includeImages = allImages(setdiff([1:length(allImages)],[1 3  20 21  29 32])); % ѡ��ͼ��
    
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
inter��ʵ��ֻ�õ�hashOriginalһ������������һ�ζ��룬������ṹ����
%}
ls = dir(fullfile(interClassTestPlan(1).workdir,[interClassTestPlan(1).extractedImages,'*.mat']));
ls = ls(1:end); % ѡ��
if length(ls) == 1
    load(fullfile(interClassTestPlan(1).workdir,ls(1).name));
    interClassTestPlan(1).extractedImages = extractedImages;
else
    load(fullfile(interClassTestPlan(1).workdir,ls(1).name));
    for i = 1:length(extractedImages)
        tpStruct(i).hashOriginal = extractedImages(i).hashOriginal;
    end        
end 
% ������mat�����
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
ls = ls(1:end); % ѡ��
intraClassTest = combineIntraMat(workdir,inmatfile,ls);  
        % intraMatCombined = combineIntraMat(workdir,intraMatfiles,ls) ��������ܹ�ͬʱ����������һ��������
        % ����Ҫע�⣬����õ��������࣬���ܻᵼ�³����ܲ���

plotparameters(1).showimage = 'off';
plotparameters(1).saveimageto = fullfile(workdir,['Plot-DS-',mbefun_Marco]);
plotparameters(1).meanlineonly = 'off';
saveformats = ['jpg';'fig'];
plotparameters(1).saveformats = saveformats;

mbp_DS(intraClassTest,plotparameters)

%}

