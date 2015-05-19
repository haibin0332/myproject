% function [savemat,outPath] = mbp_QS(imageQualityAssessment,interClassTest,plotparameters)
%% test input
plotparameters = struct('showimage',{},'saveimageto',{},'meanlineonly',{},'saveformats',{});

% dir1 = 'E:\DoctorThesis\MBench\Plan\outdir\mbe_yanan';
% inmatfile = 'InterTest-extractBy-mbe_yanan.mat';
interClassTest = '';	% fullfile(dir1,inmatfile);
dir2 = 'E:\DoctorThesis\MBench\Plan\outdir\iqa\';
inmatfile = 'iqaResult-Watson_38images-2-9-30.mat';
iqaResult = fullfile(dir2,inmatfile);

plotparameters(1).showimage = 'off';
plotparameters(1).saveimageto = fullfile(dir2,'Watson_38images\Plot-QS-Watson38-3-9-30');
plotparameters(1).meanlineonly = 'off';
saveformats = ['jpg';'fig'];
plotparameters(1).saveformats = saveformats;

% mbp_QS(imageQualityAssessment,interClassTest,plotparameters)