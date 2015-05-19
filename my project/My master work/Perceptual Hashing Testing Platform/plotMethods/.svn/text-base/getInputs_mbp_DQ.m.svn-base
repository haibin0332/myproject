%% test input
plotparameters = struct('showimage',{},'saveimageto',{},'meanlineonly',{},'saveformats',{});

dir1 = 'E:\DoctorThesis\MBench\Plan\outdir\mbe_yanan';
inmatfile = 'InterTest-extractBy-mbe_yanan.mat';
interClassTest = fullfile(dir1,inmatfile);
dir2 = 'E:\DoctorThesis\MBench\Plan\outdir\iqa';
inmatfile = 'iqaResult.mat';
iqaResult = fullfile(dir2,inmatfile);

plotparameters(1).showimage = 'off';
plotparameters(1).saveimageto = fullfile(dir1,'Plot-DQ-mbe_yanan');
plotparameters(1).meanlineonly = 'off';
saveformats = ['jpg'];
plotparameters(1).saveformats = saveformats;

% mbp_DQ(imageQualityAssessment,interClassTest,plotparameters) 