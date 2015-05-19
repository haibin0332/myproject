%% getInputs_mbt_interclasstest
function [savemat] = mbt_interclasstest(interClassTestPlan)

interClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{});


interClassTestPlan(1).workdir = 'E:\PH1\mbe_yangbian';
interClassTestPlan(1).extractedImages = 'extractBy-mbe_bian.mat';
interClassTestPlan(1).customedOutName = '';
interClassTestPlan(1).algfun = 'extractBy-mbe_bian';
interClassTestPlan(1).matchfun = @match_yanan;
% interClassTestPlan(1).params = [2 64 0.71 1/4];	%method,n,r2,r1;
interClassTestPlan(1).normalizedDistRange = [0,1];

% %%
% 
 savemat = mbt_interclasstest(interClassTestPlan)

% %% 下面的示例演示如何使用 mbt_interclasstest 的结果绘制直方图
% workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\SVD';
% savemat = fullfile(workdir,'interTest-extractBy-mbe_VishalMonga_SVD.mat');
% load(savemat);
% % interClassTest = struct('interClassTestPlan',{},'interDistances',{});
% interDistances = interClassTest.interDistances;
% interClassTestPlan = interClassTest.interClassTestPlan;
% % 直方图
% figure;
% nbins = 100;	% 指定直方图精度
% % 一种方式
% [n,xout] = hist(interDistances,nbins)	% 这个可以得到分布的具体数值
% hist(interDistances,nbins)			% 这个画图
% if ~isempty(interClassTestPlan.normalizedDistRange)	% 如果归一化了，则调整坐标
% 	range = interClassTestPlan.normalizedDistRange;
% 	v = axis;
% 	v([1 2]) = range;
% 	axis(v);
% end
% grid on;
% 
% outPath = fullfile('E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\SVD','Plot-histeq-inter-mbe_VishalMonga_SVD');
% if isdir(outPath) ~= 1
% 	mkdir(outPath);
% end
% imfile = fullfile(outPath,'histeq-inter-mbe_VishalMonga_SVD');
% % 如果imfile中有点，matlab会将后面的部分看作后缀，由此，文件名和后缀将失效
% imfile = strrep(imfile, '.','_');
% saveas(gcf,imfile,'jpg');	
% 
% clear