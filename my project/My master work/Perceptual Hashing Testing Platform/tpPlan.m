%%
workdir_Macro = 'E:\outdir\500\mbe_Fridrich_bitsextraction'; %   fullfile(mbenchpath,'outdir','\substituate\zh_rdd_3')     E:\MBench\outdir\substituate\zh_rdd_4
mbefun_Marco = 'Fridrich_bitsextraction';
matchfun = ''; % @match_Fridrich_bitsextraction;  % @match_zh_rdd_method3;  %  @match_VishalMonga_fp; % @match_Fridrich_bitsextraction;  % @match_luomin_modifyVMWaveletWithLumimask_Euclidean  ;  mbe_VishalMonga_FP
customedOutName = '';

generalPlot(workdir_Macro,matchfun,mbefun_Marco,customedOutName)

%%
histNbins = 500;
interHistOnly = 1;

adaptiveNormalizePlot(workdir_Macro,mbefun_Marco,histNbins,interHistOnly)

%%

nbins = 500; 
normalized = 1;
generalRocPlot(workdir_Macro,mbefun_Marco,nbins,normalized)