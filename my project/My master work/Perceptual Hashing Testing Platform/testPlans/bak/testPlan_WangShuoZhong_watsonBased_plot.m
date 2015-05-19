workdir_Macro = 'E:\DoctorThesis\MBench\Plan\outdir\mbe_WangShuoZhong_watsonBased\WithoutM'% 'E:\DoctorThesis\MBench\Plan\outdir\mbe_WangShuoZhong_watsonBased\Original' %
matchfun = '';  % @match_luomin_modifyVMWaveletWithLumimask_Euclidean
extractfunname = 'WangShuoZhong_watsonBased_WithoutM' % 'WangShuoZhong_watsonBased_corrected';% 'WangShuoZhong_watsonBased' %
%{
实验笔记：


%}
%
%% getInputs_mbt_interclasstest
% function [savemat] = mbt_interclasstest(interClassTestPlan)
interClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{},'includeAttacks',{},'includeImages',{});


interClassTestPlan(1).workdir = workdir_Macro;
interClassTestPlan(1).extractedImages = ['extractBy-mbe_',extractfunname];
interClassTestPlan(1).customedOutName = '';
interClassTestPlan(1).algfun = ['mbe_',extractfunname];
interClassTestPlan(1).matchfun = matchfun;
interClassTestPlan(1).params = '';
interClassTestPlan(1).normalizedDistRange = '';

load(fullfile(interClassTestPlan(1).workdir, interClassTestPlan(1).extractedImages));
allAttacks = {extractedImages(1).hashAttacked.attMethod};
allImages = {extractedImages.imOriginal};

interClassTestPlan(1).includeAttacks = allAttacks(1:end); % 选择攻击
interClassTestPlan(1).includeImages = allImages(1:end); % 选择图像

clear extractedImages allAttacks allImages

mbt_interclasstest(interClassTestPlan)

%
%% getInputs_mbt_intraclasstest
% function [savemat] = mbt_intraclasstest(intraClassTestPlan)
intraClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{});


intraClassTestPlan(1).workdir = workdir_Macro;
intraClassTestPlan(1).extractedImages = ['extractBy-mbe_',extractfunname];
intraClassTestPlan(1).customedOutName = '';
intraClassTestPlan(1).algfun = ['mbe_',extractfunname];
intraClassTestPlan(1).matchfun = matchfun;
intraClassTestPlan(1).params = '';
intraClassTestPlan(1).normalizedDistRange = '';

mbt_intraclasstest(intraClassTestPlan)

%
% mbp_DS 
% [outPath,savemat] = mbp_DS(interClassTest,plotparameters)
plotparameters = struct('showimage',{},'saveimageto',{},'meanlineonly',{},'saveformats',{});

workdir = workdir_Macro;
inmatfile = ['InterTest-extractBy-mbe_',extractfunname];
interClassTest = fullfile(workdir,inmatfile);

plotparameters(1).showimage = 'off';
plotparameters(1).saveimageto = fullfile(workdir,['Plot-DS-mbe_',extractfunname]);
plotparameters(1).meanlineonly = 'off';
saveformats = ['jpg';'fig'];
plotparameters(1).saveformats = saveformats;

mbp_DS(interClassTest,plotparameters)

%}

%%
%{
归一化 inter和 intra 测试的结果
%}
%
interMatfile = ['InterTest-extractBy-mbe_',extractfunname];
intraMatfile = ['IntraTest-extractBy-mbe_',extractfunname];
workdir = workdir_Macro;
%% 绘制图像，观察一下：
%
% 这一段可能需要根据具体情况，具体分析一下，以得到正确的归一化范围
load(fullfile(workdir,intraMatfile));
intraDistances = intraClassTest.intraDistances;
f1 = figure;
nbins = 100;	% 指定直方图精度
% [n,xout] = hist(intraDistances,nbins)	% 这个可以得到分布的具体数值
hist(intraDistances,nbins)			% 这个画图
f2 = figure;
ksdensity(intraDistances,'npoints',nbins,'support','positive','kernel','box');%'support','positive',
[f,xi,u] = ksdensity(intraDistances,'npoints',nbins,'support','positive','kernel','box');
peak = max(f);
index = find(f == peak)
center = xi(index)
%%
% 记录获得分布中心的实验过程：
%% 
% [n,xout] = hist(intraDistances,nbins);
% intra = intraDistances(intraDistances <= 200);
% f3 = figure;
% hist(intra,nbins);
% f4 = figure; 
% ksdensity(intra,'npoints',nbins,'support','positive','kernel','box');
% [f,xi,u] = ksdensity(intra,'npoints',nbins,'support','positive','kernel','box');
% peak = max(f);
% index = find(f == peak)
% center = xi(index)
% index =
%          17.00
% center =
%           0.18
why
%% 
% 保存图像
outPath = fullfile(workdir_Macro,['Plot-histeq-intra-',extractfunname]);
if isdir(outPath) ~= 1
	mkdir(outPath);
end
imfile1 = fullfile(outPath,['histeq-intra-',extractfunname]);
imfile1 = strrep(imfile1, '.','_');
imfile2 = fullfile(outPath,['ksdensity-intra-',extractfunname]);
imfile2 = strrep(imfile2, '.','_');
% imfile3 = fullfile(outPath,['histeq-adjusted-intra-',extractfunname]);
% imfile3 = strrep(imfile3, '.','_');
% imfile4 = fullfile(outPath,['ksdensity-adjusted-intra-',extractfunname]);
% imfile4 = strrep(imfile4, '.','_');	
saveas(f1,imfile1,'fig');
saveas(f2,imfile2,'fig');
% saveas(f3,imfile3,'jpg');
% saveas(f4,imfile4,'jpg');
%
%%
sampleNumber = 100;
from = [0,center];%  ''; % 
to =  [0 0.5]; % ''; % 
[saveIntra saveInter] = normalizeDistanceMat(intraMatfile, interMatfile, workdir,sampleNumber,from,to)
%
%% 利用归一化之后的数据，重新绘制DS图
%
% mbp_DS 
% [outPath,savemat] = mbp_DS(interClassTest,plotparameters)
plotparameters = struct('showimage',{},'saveimageto',{},'meanlineonly',{},'saveformats',{});

workdir = workdir_Macro;
inmatfile = ['normalized-InterTest-extractBy-mbe_',extractfunname];
interClassTest = fullfile(workdir,inmatfile);

plotparameters(1).showimage = 'off';
plotparameters(1).saveimageto = fullfile(workdir,['Plot-normalized-DS-mbe_',extractfunname]);
plotparameters(1).meanlineonly = 'off';
saveformats = ['jpg';'fig'];
plotparameters(1).saveformats = saveformats;

mbp_DS(interClassTest,plotparameters)
%}
clear
