%{
这个文件执行对 mbe_VishalMonga_wavelet 的测试：）
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
extractPlan(1).outdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\wavelet38-1-3-9-30-35';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_VishalMonga_wavelet;
extractPlan(1).params = '';

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
%% getInputs_mbt_interclasstest
% function [savemat] = mbt_interclasstest(interClassTestPlan)
interClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{},'includeAttacks',{},'includeImages',{});


interClassTestPlan(1).workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\wavelet38-1-3-9-30-35';
interClassTestPlan(1).extractedImages = 'extractBy-mbe_VishalMonga_wavelet.mat';
interClassTestPlan(1).customedOutName = '';
interClassTestPlan(1).algfun = 'mbe_VishalMonga_wavelet';
interClassTestPlan(1).matchfun = @match_VishalMonga;
interClassTestPlan(1).params = '';
interClassTestPlan(1).normalizedDistRange = '';

load(fullfile(interClassTestPlan(1).workdir, interClassTestPlan(1).extractedImages));
allAttacks = {extractedImages(1).hashAttacked.attMethod};
allImages = {extractedImages.imOriginal};

interClassTestPlan(1).includeAttacks = allAttacks(1:end); % 选择攻击
interClassTestPlan(1).includeImages = allImages([2 4:8 10:29 31:34 36:38]); % 选择图像

clear extractedImages allAttacks allImages

mbt_interclasstest(interClassTestPlan)
clear
%}
%
%% getInputs_mbt_intraclasstest
% function [savemat] = mbt_intraclasstest(intraClassTestPlan)
intraClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{});


intraClassTestPlan(1).workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\wavelet38-1-3-9-30-35';
intraClassTestPlan(1).extractedImages = 'extractBy-mbe_VishalMonga_wavelet.mat';
intraClassTestPlan(1).customedOutName = '';
intraClassTestPlan(1).algfun = 'mbe_VishalMonga_wavelet';
intraClassTestPlan(1).matchfun = @match_VishalMonga;
intraClassTestPlan(1).params = '';
intraClassTestPlan(1).normalizedDistRange = '';

mbt_intraclasstest(intraClassTestPlan)
clear
%}
%{
归一化 inter和 intra 测试的结果
%}

interMatfile = 'InterTest-extractBy-mbe_VishalMonga_wavelet.mat';
intraMatfile = 'IntraTest-extractBy-mbe_VishalMonga_wavelet.mat';
workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\wavelet38-1-3-9-30-35';
sampleNumber = 100;
from = '';
to = '';
[saveIntra saveInter] = normalizeDistanceMat(intraMatfile, interMatfile, workdir,sampleNumber,from,to)

%}
%{
绘制图像，获得测试数据
histeq-intra: 用于说明区分性
Plot-DS：用于说明鲁棒性和距离与攻击的关系
%}
%% mbt_intraclasstest IntraClass vs Discriminability
workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\wavelet38-1-3-9-30-35';
savemat = fullfile(workdir,'normalized-IntraTest-extractBy-mbe_VishalMonga_wavelet.mat');
load(savemat);
% intraClassTest = struct('intraClassTestPlan',{},'intraDistances',{});
intraDistances = intraClassTest.intraDistances;
intraClassTestPlan = intraClassTest.intraClassTestPlan;
% 直方图
figure;
nbins = 100;	% 指定直方图精度
% 一种方式
[n,xout] = hist(intraDistances,nbins)	% 这个可以得到分布的具体数值
hist(intraDistances,nbins)			% 这个画图
if ~isempty(intraClassTestPlan.normalizedDistRange)	% 如果归一化了，则调整坐标
	range = intraClassTestPlan.normalizedDistRange;
	v = axis;
	v([1 2]) = range;
	axis(v);
end
grid on;

outPath = fullfile('E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\wavelet38-1-3-9-30-35','Plot-histeq-intra-mbe_VishalMonga_wavelet');
if isdir(outPath) ~= 1
	mkdir(outPath);
end
imfile = fullfile(outPath,'histeq-normalized-intra-mbe_VishalMonga_wavelet');
% 如果imfile中有点，matlab会将后面的部分看作后缀，由此，文件名和后缀将失效
imfile = strrep(imfile, '.','_');
saveas(gcf,imfile,'jpg');	

clear
%% mbt_intraclasstest IntraClass vs Discriminability
workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\wavelet38-1-3-9-30-35';
savemat = fullfile(workdir,'IntraTest-extractBy-mbe_VishalMonga_wavelet.mat');
load(savemat);
% intraClassTest = struct('intraClassTestPlan',{},'intraDistances',{});
intraDistances = intraClassTest.intraDistances;
intraClassTestPlan = intraClassTest.intraClassTestPlan;
% 直方图
figure;
nbins = 100;	% 指定直方图精度
% 一种方式
[n,xout] = hist(intraDistances,nbins)	% 这个可以得到分布的具体数值
hist(intraDistances,nbins)			% 这个画图
if ~isempty(intraClassTestPlan.normalizedDistRange)	% 如果归一化了，则调整坐标
	range = intraClassTestPlan.normalizedDistRange;
	v = axis;
	v([1 2]) = range;
	axis(v);
end
grid on;

outPath = fullfile('E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\wavelet38-1-3-9-30-35','Plot-histeq-intra-mbe_VishalMonga_wavelet');
if isdir(outPath) ~= 1
	mkdir(outPath);
end
imfile = fullfile(outPath,'histeq-intra-mbe_VishalMonga_wavelet');
% 如果imfile中有点，matlab会将后面的部分看作后缀，由此，文件名和后缀将失效
imfile = strrep(imfile, '.','_');
saveas(gcf,imfile,'jpg');	

clear
%% mbp_DS 
% [outPath,savemat] = mbp_DS(interClassTest,plotparameters)
plotparameters = struct('showimage',{},'saveimageto',{},'meanlineonly',{},'saveformats',{});

workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\wavelet38-1-3-9-30-35';
inmatfile = 'normalized-InterTest-extractBy-mbe_VishalMonga_wavelet.mat';
interClassTest = fullfile(workdir,inmatfile);

plotparameters(1).showimage = 'off';
plotparameters(1).saveimageto = fullfile(workdir,'Plot-normalized-DS-mbe_VishalMonga_wavelet');
plotparameters(1).meanlineonly = 'off';
saveformats = ['jpg';'fig'];
plotparameters(1).saveformats = saveformats;

mbp_DS(interClassTest,plotparameters)
clear

%% mbp_DS 
% [outPath,savemat] = mbp_DS(interClassTest,plotparameters)
plotparameters = struct('showimage',{},'saveimageto',{},'meanlineonly',{},'saveformats',{});

workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\wavelet38-1-3-9-30-35';
inmatfile = 'InterTest-extractBy-mbe_VishalMonga_wavelet.mat';
interClassTest = fullfile(workdir,inmatfile);

plotparameters(1).showimage = 'off';
plotparameters(1).saveimageto = fullfile(workdir,'Plot-DS-mbe_VishalMonga_wavelet');
plotparameters(1).meanlineonly = 'off';
saveformats = ['jpg';'fig'];
plotparameters(1).saveformats = saveformats;

mbp_DS(interClassTest,plotparameters)
clear



