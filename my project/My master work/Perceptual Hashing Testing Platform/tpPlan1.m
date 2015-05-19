function tp_syeh()
%%
%{
timebegin = datestr(now)
extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});

extractPlan(1).imdir = 'F:\imDatabase\BMPBASE';
extractPlan(1).testImages = 'testImages';
extractPlan(1).outdir = 'E:\outdir\500\mbe_zh_rdd\letter_16_4';
extractPlan(1).customedOutName = '';
extractPlan(1).algfun = @struct_syeh;
params = '';
extractPlan(1).params = params;

% 获得所有attMethods 和 images 的方法
load(fullfile(extractPlan(1).imdir,extractPlan(1).testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};

extractPlan(1).includeAttacks = allAttacks(1:end);	% 选择针对的攻击类型, 保存的是cell    :end
extractPlan(1).includeImages = allImages(1:end); % 选择图像

mbe_extract(extractPlan)
timeend = datestr(now)
timebegin
clear
%}
%%
%%
workdir_Macro = 'E:\outdir\500\mbe_zh_rdd\letter_16_4'; %   fullfile(mbenchpath,'outdir','\substituate\zh_rdd_3')     E:\MBench\outdir\substituate\zh_rdd_4
mbefun_Marco = 'struct_syeh';
matchfun = ''; 
customedOutName = '';
% generalPlot(workdir_Macro,matchfun,mbefun_Marco,customedOutName)
%
histNbins = 500;
interHistOnly = 1;
adaptiveNormalizePlot(workdir_Macro,matchfun,mbefun_Marco,histNbins,interHistOnly)
%}
nbins = 500; 
normalized = 1;
generalRocPlot(workdir_Macro,mbefun_Marco,nbins,normalized)
end % end function