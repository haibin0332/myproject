
%% 细分攻击强度
% attMethods = struct('attMethod',{},'attFunction',{},'strength',{},'params',{});
% attMethods = setfield(attMethods,{1},'attMethod','Gaussian Noise(variance)');	% - Gaussian Noise(variance)
% attMethods = setfield(attMethods,{1},'attFunction',@att_gaussian_var);
% attMethods = setfield(attMethods,{1},'strength', [0.01:0.01:0.25]);
% attMethods = setfield(attMethods,{1},'params','');
% 
%% 攻击：
% % attMethods = struct('attMethod',{},'attFunction',{},'strength',{},'params',{});
% attackPlan = struct('indir',{},'outdir',{},'attMethods',{},'testImages',{});
% %% testImages为空的情况
% indir = 'E:\DoctorThesis\MBench\Plan\indir\misc';
% outdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked\Detail_GaussianNoiseVariance';
% % getInputs_allAttMethods;		% attMethods 中保留有所有的攻击方式
% % attMethods = attMethods(1:end);	% 选择几个 
% 
% testImages = '';
% %load(fullfile(outdir , 'testImages.mat'));%test for append
% 
% attackPlan(1).indir = indir;
% attackPlan(1).outdir = outdir;
% attackPlan(1).attMethods = attMethods;
% attackPlan(1).testImages = testImages;
% 
% mba_attack(attackPlan)
% clear
%% 提取：
% 参数
% power = 0.1
% %
% extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});
% 
% extractPlan(1).imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked\Detail_GaussianNoiseVariance';
% extractPlan(1).testImages = 'testImages';
% extractPlan(1).outdir = 'E:\DoctorThesis\MBench\Plan\outdir\luomin_modifyVMWaveletWithLumimask\Detail_GaussianNoiseVariance';
% extractPlan(1).customedOutName = '0_1';
% extractPlan(1).algfun = @mbe_luomin_modifyVMWaveletWithLumimask;
% extractPlan(1).params = power;
% 
% % 获得所有attMethods 和 images 的方法
% load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
% allAttacks = {testImages(1).imAttacked.attMethod};
% allImages = {testImages.imOriginal};
% 
% extractPlan(1).includeAttacks = allAttacks(1:end);	% 选择针对的攻击类型, 保存的是cell    :end
% extractPlan(1).includeImages = allImages([2 4:8 10:29 31:34 36:38]); % 选择图像
% 
% clear testImages allAttacks allImages
% mbe_extract(extractPlan)
% clear
%% 原始算法
% %
% extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});
% 
% extractPlan(1).imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked\Detail_GaussianNoiseVariance';
% extractPlan(1).testImages = 'testImages';
% extractPlan(1).outdir = 'E:\DoctorThesis\MBench\Plan\outdir\luomin_modifyVMWaveletWithLumimask\Detail_GaussianNoiseVariance';
% extractPlan(1).customedOutName = 'mbe_VishalMonga_wavelet';
% extractPlan(1).algfun = @mbe_VishalMonga_wavelet;
% extractPlan(1).params = '';
% 
% % 获得所有attMethods 和 images 的方法
% load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
% allAttacks = {testImages(1).imAttacked.attMethod};
% allImages = {testImages.imOriginal};
% 
% extractPlan(1).includeAttacks = allAttacks(1:end);	% 选择针对的攻击类型, 保存的是cell    :end
% extractPlan(1).includeImages = allImages([2 4:8 10:29 31:34 36:38]); % 选择图像
% 
% clear testImages allAttacks allImages
% mbe_extract(extractPlan)
% clear
%% 画图
% % function [savemat] = mbt_interclasstest(interClassTestPlan)
% interClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
% 						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{},'includeAttacks',{},'includeImages',{});
% 
% 
% interClassTestPlan(1).workdir = 'E:\DoctorThesis\MBench\Plan\outdir\luomin_modifyVMWaveletWithLumimask\Detail_GaussianNoiseVariance';
% interClassTestPlan(1).extractedImages = 'extractBy-mbe_VishalMonga_wavelet.mat';
% interClassTestPlan(1).customedOutName = '';
% interClassTestPlan(1).algfun = 'mbe_VishalMonga_wavelet';
% interClassTestPlan(1).matchfun = @match_VishalMonga;
% interClassTestPlan(1).params = '';	%method,n,r2,r1;
% interClassTestPlan(1).normalizedDistRange = '';
% 
% load(fullfile(interClassTestPlan(1).workdir, interClassTestPlan(1).extractedImages));
% allAttacks = {extractedImages(1).hashAttacked.attMethod};
% allImages = {extractedImages.imOriginal};
% 
% interClassTestPlan(1).includeAttacks = allAttacks(1:end); % 选择攻击
% interClassTestPlan(1).includeImages = allImages(1:end); % 选择图像
% 
% clear extractedImages allAttacks allImages
% mbt_interclasstest(interClassTestPlan)
% % [outPath,savemat] = mbp_DS(interClassTest,plotparameters)
% plotparameters = struct('showimage',{},'saveimageto',{},'meanlineonly',{},'saveformats',{});
% 
% workdir = 'E:\DoctorThesis\MBench\Plan\outdir\luomin_modifyVMWaveletWithLumimask\Detail_GaussianNoiseVariance';
% inmatfile = 'InterTest-extractBy-mbe_VishalMonga_wavelet.mat';
% interClassTest = fullfile(workdir,inmatfile);
% 
% plotparameters(1).showimage = 'off';
% plotparameters(1).saveimageto = fullfile(workdir,'Plot-DS');
% plotparameters(1).meanlineonly = 'off';
% saveformats = ['jpg';'fig'];				% 区隔多个图像格式要用；不要用，['jpg';'fig']
% plotparameters(1).saveformats = saveformats;
% 
% mbp_DS(interClassTest,plotparameters)
%% Normalize It
% extractfunname = 'VishalMonga_wavelet'
% workdir_Macro = 'E:\DoctorThesis\MBench\Plan\outdir\luomin_modifyVMWaveletWithLumimask\Detail_GaussianNoiseVariance';
% %{
% 归一化 inter和 intra 测试的结果
% %}
% %
% interMatfile = ['InterTest-extractBy-mbe_',extractfunname];
% intraMatfile = ['IntraTest-extractBy-mbe_',extractfunname];
% workdir = workdir_Macro;
% %% 绘制图像，观察一下：
% %
% % 这一段可能需要根据具体情况，具体分析一下，以得到正确的归一化范围
% load(fullfile(workdir,intraMatfile));
% intraDistances = intraClassTest.intraDistances;
% f1 = figure;
% nbins = 100;	% 指定直方图精度
% % [n,xout] = hist(intraDistances,nbins)	% 这个可以得到分布的具体数值
% hist(intraDistances,nbins)			% 这个画图
% f2 = figure;
% ksdensity(intraDistances,'npoints',nbins,'support','positive','kernel','box');%'support','positive',
% [f,xi,u] = ksdensity(intraDistances,'npoints',nbins,'support','positive','kernel','box');
% peak = max(f);
% index = find(f == peak)
% center = xi(index)
% %%
% % 记录获得分布中心的实验过程：
% %% 
% % [n,xout] = hist(intraDistances,nbins);
% % intra = intraDistances(intraDistances <= 200);
% % f3 = figure;
% % hist(intra,nbins);
% % f4 = figure; 
% % ksdensity(intra,'npoints',nbins,'support','positive','kernel','box');
% % [f,xi,u] = ksdensity(intra,'npoints',nbins,'support','positive','kernel','box');
% % peak = max(f);
% % index = find(f == peak)
% % center = xi(index)
% % index =
% %          17.00
% % center =
% %           0.18
% why
% %% 
% % 保存图像
% outPath = fullfile(workdir_Macro,['Plot-histeq-intra-',extractfunname]);
% if isdir(outPath) ~= 1
% 	mkdir(outPath);
% end
% imfile1 = fullfile(outPath,['histeq-intra-',extractfunname]);
% imfile1 = strrep(imfile1, '.','_');
% imfile2 = fullfile(outPath,['ksdensity-intra-',extractfunname]);
% imfile2 = strrep(imfile2, '.','_');
% % imfile3 = fullfile(outPath,['histeq-adjusted-intra-',extractfunname]);
% % imfile3 = strrep(imfile3, '.','_');
% % imfile4 = fullfile(outPath,['ksdensity-adjusted-intra-',extractfunname]);
% % imfile4 = strrep(imfile4, '.','_');	
% saveas(f1,imfile1,'fig');
% saveas(f2,imfile2,'fig');
% % saveas(f3,imfile3,'jpg');
% % saveas(f4,imfile4,'jpg');
% %
% %%
% sampleNumber = 100;
% from = [0,center];%  ''; % 
% to =  [0 0.5]; % ''; % 
% [saveIntra saveInter] = normalizeDistanceMat(intraMatfile, interMatfile, workdir,sampleNumber,from,to)
%% Plot Normalized
% % [outPath,savemat] = mbp_DS(interClassTest,plotparameters)
% extractfunname = 'luomin_modifyVMWaveletWithLumimask_1'
% workdir_Macro = 'E:\DoctorThesis\MBench\Plan\outdir\luomin_modifyVMWaveletWithLumimask\Detail_GaussianNoiseVariance';
% plotparameters = struct('showimage',{},'saveimageto',{},'meanlineonly',{},'saveformats',{});
% 
% workdir = 'E:\DoctorThesis\MBench\Plan\outdir\luomin_modifyVMWaveletWithLumimask\Detail_GaussianNoiseVariance';
% inmatfile = ['InterTest-extractBy-mbe_',extractfunname];
% interClassTest = fullfile(workdir,inmatfile);
% 
% plotparameters(1).showimage = 'off';
% plotparameters(1).saveimageto = fullfile(workdir,'Plot-DS-normalized');
% plotparameters(1).meanlineonly = 'off';
% saveformats = ['jpg';'fig'];				% 区隔多个图像格式要用；不要用，['jpg';'fig']
% plotparameters(1).saveformats = saveformats;
% 
% mbp_DS(interClassTest,plotparameters)



