%{
这个文件执行对 WishalMonga 的 wavelet 和 SVD 的测试：）
目的1： 观察这两个算法对不同攻击的性能，进行比较。
目的2： 在比较的基础上，考虑对两个算法的error pooling。
%}


%{
步骤： 
1： 分别提取，保存到各自的文件夹
2： Inter和Intra测试
3： 分别绘制图形，保存到各自的文件夹
%}
%{
%% WishalMonga  wavelet
%% getInputs_mbe_extract
% function [savemat] = mbe_extract(extractPlan)
extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});

extractPlan(1).imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
extractPlan(1).testImages = 'testImages';
extractPlan(1).outdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\wavelet';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_VishalMonga_wavelet;
extractPlan(1).params = '';

% 获得所有attMethods 和 images 的方法
load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};

extractPlan(1).includeAttacks = allAttacks(1:end);	% 选择针对的攻击类型, 保存的是cell    
extractPlan(1).includeImages = allImages(1:end); % 选择图像

clear testImages allAttacks allImages

mbe_extract(extractPlan)
clear
%% getInputs_mbt_interclasstest
% function [savemat] = mbt_interclasstest(interClassTestPlan)
interClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{},'includeAttacks',{},'includeImages',{});


interClassTestPlan(1).workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\wavelet';
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
interClassTestPlan(1).includeImages = allImages(1:end); % 选择图像

clear extractedImages allAttacks allImages

mbt_interclasstest(interClassTestPlan)
clear
%% getInputs_mbt_intraclasstest
% function [savemat] = mbt_intraclasstest(intraClassTestPlan)
intraClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{});


intraClassTestPlan(1).workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\wavelet';
intraClassTestPlan(1).extractedImages = 'extractBy-mbe_VishalMonga_wavelet.mat';
intraClassTestPlan(1).customedOutName = '';
intraClassTestPlan(1).algfun = 'mbe_VishalMonga_wavelet';
intraClassTestPlan(1).matchfun = @match_VishalMonga;
intraClassTestPlan(1).params = '';
intraClassTestPlan(1).normalizedDistRange = '';

mbt_intraclasstest(intraClassTestPlan)
clear

%% WishalMonga  SVD
%% getInputs_mbe_extract
% function [savemat] = mbe_extract(extractPlan)
extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});

extractPlan(1).imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
extractPlan(1).testImages = 'testImages';
extractPlan(1).outdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\SVD';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @mbe_VishalMonga_SVD;
extractPlan(1).params = '';

% 获得所有attMethods 和 images 的方法
load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};

extractPlan(1).includeAttacks = allAttacks(1:end);	% 选择针对的攻击类型, 保存的是cell    
extractPlan(1).includeImages = allImages(1:end); % 选择图像

clear testImages allAttacks allImages

mbe_extract(extractPlan)
clear
%% getInputs_mbt_interclasstest
% function [savemat] = mbt_interclasstest(interClassTestPlan)
interClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{},'includeAttacks',{},'includeImages',{});


interClassTestPlan(1).workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\SVD';
interClassTestPlan(1).extractedImages = 'extractBy-mbe_VishalMonga_SVD.mat';
interClassTestPlan(1).customedOutName = '';
interClassTestPlan(1).algfun = 'mbe_VishalMonga_SVD';
interClassTestPlan(1).matchfun = @match_VishalMonga;
interClassTestPlan(1).params = '';
interClassTestPlan(1).normalizedDistRange = '';

load(fullfile(interClassTestPlan(1).workdir, interClassTestPlan(1).extractedImages));
allAttacks = {extractedImages(1).hashAttacked.attMethod};
allImages = {extractedImages.imOriginal};

interClassTestPlan(1).includeAttacks = allAttacks(1:end); % 选择攻击
interClassTestPlan(1).includeImages = allImages(1:end); % 选择图像

clear extractedImages allAttacks allImages

mbt_interclasstest(interClassTestPlan)
clear
%% getInputs_mbt_intraclasstest
% function [savemat] = mbt_intraclasstest(intraClassTestPlan)
intraClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{});


intraClassTestPlan(1).workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\SVD';
intraClassTestPlan(1).extractedImages = 'extractBy-mbe_VishalMonga_SVD.mat';
intraClassTestPlan(1).customedOutName = '';
intraClassTestPlan(1).algfun = 'mbe_VishalMonga_SVD';
intraClassTestPlan(1).matchfun = @match_VishalMonga;
intraClassTestPlan(1).params = '';
intraClassTestPlan(1).normalizedDistRange = '';

mbt_intraclasstest(intraClassTestPlan)
clear
%}

%{
归一化 inter和 intra 测试的结果
%}

interMatfile = 'InterTest-extractBy-mbe_VishalMonga_SVD.mat';
intraMatfile = 'IntraTest-extractBy-mbe_VishalMonga_SVD.mat';
workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\SVD';
sampleNumber = 100;
[saveIntra saveInter] = normalizeDistanceMat(intraMatfile, interMatfile, workdir,sampleNumber)

interMatfile = 'InterTest-extractBy-mbe_VishalMonga_wavelet.mat';
intraMatfile = 'IntraTest-extractBy-mbe_VishalMonga_wavelet.mat';
workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\wavelet';
sampleNumber = 100;
[saveIntra saveInter] = normalizeDistanceMat(intraMatfile, interMatfile, workdir,sampleNumber)
%}
%{
绘制图像，获得测试数据
histeq-intra: 用于说明区分性
Plot-DS：用于说明鲁棒性和距离与攻击的关系
%}
%{
%% WishalMonga  wavelet
%% VishalMonga_wavelet mbt_intraclasstest IntraClass vs Discriminability
workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\wavelet';
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

outPath = fullfile('E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\wavelet','Plot-histeq-intra-mbe_VishalMonga_wavelet');
if isdir(outPath) ~= 1
	mkdir(outPath);
end
imfile = fullfile(outPath,'histeq-normalized-intra-mbe_VishalMonga_wavelet');
% 如果imfile中有点，matlab会将后面的部分看作后缀，由此，文件名和后缀将失效
imfile = strrep(imfile, '.','_');
saveas(gcf,imfile,'jpg');	

clear
%% mbp_DS VishalMonga_wavelet
% [outPath,savemat] = mbp_DS(interClassTest,plotparameters)
plotparameters = struct('showimage',{},'saveimageto',{},'meanlineonly',{},'saveformats',{});

workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\wavelet';
inmatfile = 'normalized-InterTest-extractBy-mbe_VishalMonga_wavelet.mat';
interClassTest = fullfile(workdir,inmatfile);

plotparameters(1).showimage = 'off';
plotparameters(1).saveimageto = fullfile(workdir,'Plot-normalized-DS-mbe_VishalMonga_wavelet');
plotparameters(1).meanlineonly = 'off';
saveformats = ['jpg';'fig'];
plotparameters(1).saveformats = saveformats;

mbp_DS(interClassTest,plotparameters)
clear

%% WishalMonga  SVD
%% VishalMonga_SVD mbt_intraclasstest IntraClass vs Discriminability
workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\SVD';
savemat = fullfile(workdir,'normalized-IntraTest-extractBy-mbe_VishalMonga_SVD.mat');
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

outPath = fullfile('E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\SVD','Plot-histeq-intra-mbe_VishalMonga_SVD');
if isdir(outPath) ~= 1
	mkdir(outPath);
end
imfile = fullfile(outPath,'histeq-normalized-intra-mbe_VishalMonga_SVD');
% 如果imfile中有点，matlab会将后面的部分看作后缀，由此，文件名和后缀将失效
imfile = strrep(imfile, '.','_');
saveas(gcf,imfile,'jpg');	

clear
%% mbp_DS VishalMonga_SVD
% [outPath,savemat] = mbp_DS(interClassTest,plotparameters)
plotparameters = struct('showimage',{},'saveimageto',{},'meanlineonly',{},'saveformats',{});

workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\SVD';
inmatfile = 'normalized-InterTest-extractBy-mbe_VishalMonga_SVD.mat';
interClassTest = fullfile(workdir,inmatfile);

plotparameters(1).showimage = 'off';
plotparameters(1).saveimageto = fullfile(workdir,'Plot-normalized-DS-mbe_VishalMonga_SVD');
plotparameters(1).meanlineonly = 'off';
saveformats = ['jpg';'fig'];
plotparameters(1).saveformats = saveformats;

mbp_DS(interClassTest,plotparameters)
clear
%}

%{
绘制图像，获得测试数据  minkowskiSum
histeq-intra: 用于说明区分性
Plot-DS：用于说明鲁棒性和距离与攻击的关系
%}
%{
%% WishalMonga  minkowski
%% WishalMonga  minkowski mbt_intraclasstest IntraClass vs Discriminability
workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\minkowskiSum';
savemat = fullfile(workdir,'IntraTest-minkowski.mat');
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

outPath = fullfile('E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\minkowskiSum','Plot-histeq-minkowski');
if isdir(outPath) ~= 1
	mkdir(outPath);
end
imfile = fullfile(outPath,'histeq-intra-minkowski');
% 如果imfile中有点，matlab会将后面的部分看作后缀，由此，文件名和后缀将失效
imfile = strrep(imfile, '.','_');
saveas(gcf,imfile,'jpg');	

clear
%% mbp_DS VishalMonga_minkowski
% [outPath,savemat] = mbp_DS(interClassTest,plotparameters)
plotparameters = struct('showimage',{},'saveimageto',{},'meanlineonly',{},'saveformats',{});

workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\minkowskiSum';
inmatfile = 'InterTest-minkowski.mat';
interClassTest = fullfile(workdir,inmatfile);

plotparameters(1).showimage = 'off';
plotparameters(1).saveimageto = fullfile(workdir,'Plot-DS-minkowski');
plotparameters(1).meanlineonly = 'off';
saveformats = ['jpg';'fig'];
plotparameters(1).saveformats = saveformats;

mbp_DS(interClassTest,plotparameters)
clear
%}

%{
绘制图像，获得测试数据  minkowskiSum
Roc 用于说明区分性
%}

%% ROC mbe_VishalMonga_SVD
% function [savemat,outPath] = mbp_roc(intraClassTest,interClassTest,StrengthAndMethods,plotparameters)
StrengthAndMethods = struct('attStrength',{},'attMethod',{});
plotparameters = struct('figtypes',{},'samplenumber',{},'showimage',{},'saveimageto',{},'saveformats',{});
%	
workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\SVD';
intraClassTest = 'normalized-IntraTest-extractBy-mbe_VishalMonga_SVD.mat';
intraClassTest = fullfile(workdir,intraClassTest);

interClassTest = 'normalized-InterTest-extractBy-mbe_VishalMonga_SVD.mat';
interClassTest = fullfile(workdir,interClassTest);
load(interClassTest);

% 通过调试的方式获得 StrengthAndMethods 的内容
why % 断点设在这里 F9下面的内容
% F9 下面两句可以得到想要的强度和攻击方法
% allmethods = interClassTest.interClassTestPlan.includeAttacks
% allstrength = interClassTest.interDistance(1).attStrength 

% F9 下面的可以指定想要绘图的强度和攻击方法
StrengthAndMethods(1).attMethod = {'Rotation & Cropping'};
StrengthAndMethods(1).attStrength = 20;
StrengthAndMethods(2).attMethod = {'Rotation & Cropping'};
StrengthAndMethods(2).attStrength = 10;
StrengthAndMethods(3).attMethod = {'Rotation & Cropping'};
StrengthAndMethods(3).attStrength = 5;
StrengthAndMethods(4).attMethod = {'Rotation & Cropping'};
StrengthAndMethods(4).attStrength = 2;
StrengthAndMethods(5).attMethod = {'Gaussian Noise(variance)'};
StrengthAndMethods(5).attStrength = 0.1;
StrengthAndMethods(6).attMethod = {'Gaussian Noise(variance)'};
StrengthAndMethods(6).attStrength = 0.2;
StrengthAndMethods(7).attMethod = {'Gaussian Noise(variance)'};
StrengthAndMethods(7).attStrength = 0.3;
% plotparameter
figtypes = ['pdf'];		% ;'det';'eer'; 'pdf'
plotparameters(1).figtypes = figtypes;
plotparameters(1).samplenumber = 20;
plotparameters(1).showimage = 'off';
plotparameters(1).saveimageto = fullfile(workdir,'Plot-ROC-mbe_VishalMonga_SVD');
saveformats = ['jpg';'fig'];
plotparameters(1).saveformats = saveformats;

[savemat,outPath] = mbp_roc(intraClassTest,interClassTest,StrengthAndMethods,plotparameters)
clear

%% ROC mbe_VishalMonga_wavelet
% function [savemat,outPath] = mbp_roc(intraClassTest,interClassTest,StrengthAndMethods,plotparameters)
StrengthAndMethods = struct('attStrength',{},'attMethod',{});
plotparameters = struct('figtypes',{},'samplenumber',{},'showimage',{},'saveimageto',{},'saveformats',{});
%	
workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\wavelet';
intraClassTest = 'normalized-IntraTest-extractBy-mbe_VishalMonga_wavelet.mat';
intraClassTest = fullfile(workdir,intraClassTest);

interClassTest = 'normalized-InterTest-extractBy-mbe_VishalMonga_wavelet.mat';
interClassTest = fullfile(workdir,interClassTest);
load(interClassTest);

% 通过调试的方式获得 StrengthAndMethods 的内容
why % 断点设在这里 F9下面的内容
% F9 下面两句可以得到想要的强度和攻击方法
% allmethods = interClassTest.interClassTestPlan.includeAttacks
% allstrength = interClassTest.interDistance(1).attStrength 

% F9 下面的可以指定想要绘图的强度和攻击方法
StrengthAndMethods(1).attMethod = {'Rotation & Cropping'};
StrengthAndMethods(1).attStrength = 20;
StrengthAndMethods(2).attMethod = {'Rotation & Cropping'};
StrengthAndMethods(2).attStrength = 10;
StrengthAndMethods(3).attMethod = {'Rotation & Cropping'};
StrengthAndMethods(3).attStrength = 5;
StrengthAndMethods(4).attMethod = {'Rotation & Cropping'};
StrengthAndMethods(4).attStrength = 2;
StrengthAndMethods(5).attMethod = {'Gaussian Noise(variance)'};
StrengthAndMethods(5).attStrength = 0.1;
StrengthAndMethods(6).attMethod = {'Gaussian Noise(variance)'};
StrengthAndMethods(6).attStrength = 0.2;
StrengthAndMethods(7).attMethod = {'Gaussian Noise(variance)'};
StrengthAndMethods(7).attStrength = 0.3;
% plotparameter
figtypes = ['pdf'];		% ;'det';'eer'; 'pdf'
plotparameters(1).figtypes = figtypes;
plotparameters(1).samplenumber = 20;
plotparameters(1).showimage = 'off';
plotparameters(1).saveimageto = fullfile(workdir,'Plot-ROC-mbe_VishalMonga_wavelet');
saveformats = ['jpg';'fig'];
plotparameters(1).saveformats = saveformats;

[savemat,outPath] = mbp_roc(intraClassTest,interClassTest,StrengthAndMethods,plotparameters)
clear
%}
%% ROC mbe_haibin_minkowski
% function [savemat,outPath] = mbp_roc(intraClassTest,interClassTest,StrengthAndMethods,plotparameters)
StrengthAndMethods = struct('attStrength',{},'attMethod',{});
plotparameters = struct('figtypes',{},'samplenumber',{},'showimage',{},'saveimageto',{},'saveformats',{});
%	
workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\minkowskiSum';
intraClassTest = 'IntraTest-minkowski.mat';
intraClassTest = fullfile(workdir,intraClassTest);

interClassTest = 'InterTest-minkowski.mat';
interClassTest = fullfile(workdir,interClassTest);
load(interClassTest);

% 通过调试的方式获得 StrengthAndMethods 的内容
why % 断点设在这里 F9下面的内容
% F9 下面两句可以得到想要的强度和攻击方法
% allmethods = interClassTest.interClassTestPlan.includeAttacks
% allstrength = interClassTest.interDistance(1).attStrength 

% F9 下面的可以指定想要绘图的强度和攻击方法
StrengthAndMethods(1).attMethod = {'Rotation & Cropping'};
StrengthAndMethods(1).attStrength = 20;
StrengthAndMethods(2).attMethod = {'Rotation & Cropping'};
StrengthAndMethods(2).attStrength = 10;
StrengthAndMethods(3).attMethod = {'Rotation & Cropping'};
StrengthAndMethods(3).attStrength = 5;
StrengthAndMethods(4).attMethod = {'Rotation & Cropping'};
StrengthAndMethods(4).attStrength = 2;
StrengthAndMethods(5).attMethod = {'Gaussian Noise(variance)'};
StrengthAndMethods(5).attStrength = 0.1;
StrengthAndMethods(6).attMethod = {'Gaussian Noise(variance)'};
StrengthAndMethods(6).attStrength = 0.2;
StrengthAndMethods(7).attMethod = {'Gaussian Noise(variance)'};
StrengthAndMethods(7).attStrength = 0.3;
% plotparameter
figtypes = ['pdf'];		% ;'det';'eer'; 'pdf'
plotparameters(1).figtypes = figtypes;
plotparameters(1).samplenumber = 20;
plotparameters(1).showimage = 'off';
plotparameters(1).saveimageto = fullfile(workdir,'Plot-ROC-mbe_haibin_minkowski');
saveformats = ['jpg';'fig'];
plotparameters(1).saveformats = saveformats;

[savemat,outPath] = mbp_roc(intraClassTest,interClassTest,StrengthAndMethods,plotparameters)
clear














