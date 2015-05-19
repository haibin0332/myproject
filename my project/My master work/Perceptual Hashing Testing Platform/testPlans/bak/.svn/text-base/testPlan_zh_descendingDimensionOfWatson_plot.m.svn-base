workdir_zh_descendingDimensionOfWatson = 'E:\DoctorThesis\MBench\Plan\outdir\zh_descendingDimensionOfWatson\method1'
matchfun = @match_zh_descendingDimensionOfWatson;  % 
%{
实验笔记：
1、method 2：使用38张图片，实验所有内容：intra inter normalize ds hist 其中 normalize范围为：【0，15.46】 - 【0， 0.5】
2、观察，发现第9张图片过于奇异，在 extractBy-mbe_zh_descendingDimensionOfWatson.mat 中删掉第9张图片的信息，重新执行上一步：
3、得到normalize的范围为： [0,15.79] - [0,0.5]

4、 method 1：去掉第3 9张图片，实验所有内容：intra inter normalize ds hist 其中 normalize范围为：【0，21.26】 - 【0， 0.5】
%}
%{
%% getInputs_mbt_interclasstest
% function [savemat] = mbt_interclasstest(interClassTestPlan)
interClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{},'includeAttacks',{},'includeImages',{});


interClassTestPlan(1).workdir = workdir_zh_descendingDimensionOfWatson;
interClassTestPlan(1).extractedImages = 'extractBy-mbe_zh_descendingDimensionOfWatson.mat';
interClassTestPlan(1).customedOutName = '';
interClassTestPlan(1).algfun = 'mbe_zh_descendingDimensionOfWatson';
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

%}
%{
%% getInputs_mbt_intraclasstest
% function [savemat] = mbt_intraclasstest(intraClassTestPlan)
intraClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{});


intraClassTestPlan(1).workdir = workdir_zh_descendingDimensionOfWatson;
intraClassTestPlan(1).extractedImages = 'extractBy-mbe_zh_descendingDimensionOfWatson.mat';
intraClassTestPlan(1).customedOutName = '';
intraClassTestPlan(1).algfun = 'mbe_zh_descendingDimensionOfWatson';
intraClassTestPlan(1).matchfun = matchfun;
intraClassTestPlan(1).params = '';
intraClassTestPlan(1).normalizedDistRange = '';

mbt_intraclasstest(intraClassTestPlan)

%}
%%
%{
归一化 inter和 intra 测试的结果
%}
%{
interMatfile = 'InterTest-extractBy-mbe_zh_descendingDimensionOfWatson.mat';
intraMatfile = 'IntraTest-extractBy-mbe_zh_descendingDimensionOfWatson.mat';
workdir = workdir_zh_descendingDimensionOfWatson;
%% 绘制图像，观察一下：
%{
% 这一段可能需要根据具体情况，具体分析一下，以得到正确的归一化范围
load(fullfile(workdir,intraMatfile));
intraDistances = intraClassTest.intraDistances;
f1 = figure;
nbins = 100;	% 指定直方图精度
% [n,xout] = hist(intraDistances,nbins)	% 这个可以得到分布的具体数值
hist(intraDistances,nbins)			% 这个画图
f2 = figure;
ksdensity(intraDistances,'npoints',nbins,'support','positive','kernel','box');%'support','positive',
% [f,xi,u] = ksdensity(intraDistances,'npoints',nbins,'support','positive','kernel','box');
% peak = max(f);
% index = find(f == peak)
% center = xi(index)
%%
% 记录获得分布中心的实验过程：
%% method 2
[n,xout] = hist(intraDistances,nbins);
intra = intraDistances(intraDistances <= 200);
figure;ksdensity(intra,'npoints',nbins,'support','positive','kernel','box');
figure; hist(intra,nbins);
[f,xi,u] = ksdensity(intra,'npoints',nbins,'support','positive','kernel','box');
peak = max(f);
index = find(f == peak)
center = xi(index)
% index =
%           6.00
% center =
%          21.26
why
%}
%%
sampleNumber = 100;
from = [0,21.26];%  ''; % 
to =  [0 0.5]; % ''; % 
[saveIntra saveInter] = normalizeDistanceMat(intraMatfile, interMatfile, workdir,sampleNumber,from,to)
%}
%%
%{
绘制图像，获得测试数据
Plot-DS：用于说明鲁棒性和距离与攻击的关系
%}
%{
% mbp_DS 
% [outPath,savemat] = mbp_DS(interClassTest,plotparameters)
plotparameters = struct('showimage',{},'saveimageto',{},'meanlineonly',{},'saveformats',{});

workdir = workdir_zh_descendingDimensionOfWatson;
inmatfile = 'normalized-InterTest-extractBy-mbe_zh_descendingDimensionOfWatson.mat';
interClassTest = fullfile(workdir,inmatfile);

plotparameters(1).showimage = 'off';
plotparameters(1).saveimageto = fullfile(workdir,'Plot-normalized-DS-mbe_zh_descendingDimensionOfWatson');
plotparameters(1).meanlineonly = 'off';
saveformats = ['jpg';'fig'];
plotparameters(1).saveformats = saveformats;

mbp_DS(interClassTest,plotparameters)
%}
%{
% mbp_DS 
% [outPath,savemat] = mbp_DS(interClassTest,plotparameters)
plotparameters = struct('showimage',{},'saveimageto',{},'meanlineonly',{},'saveformats',{});

workdir = workdir_zh_descendingDimensionOfWatson;
inmatfile = 'InterTest-extractBy-mbe_zh_descendingDimensionOfWatson.mat';
interClassTest = fullfile(workdir,inmatfile);

plotparameters(1).showimage = 'off';
plotparameters(1).saveimageto = fullfile(workdir,'Plot-DS-mbe_zh_descendingDimensionOfWatson');
plotparameters(1).meanlineonly = 'off';
saveformats = ['jpg';'fig'];
plotparameters(1).saveformats = saveformats;

mbp_DS(interClassTest,plotparameters)
clear
%}