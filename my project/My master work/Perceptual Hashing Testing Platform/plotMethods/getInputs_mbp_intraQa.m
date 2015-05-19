% function [savemat,outPath] = mbp_intraQa(iqaResult,plotparameters)
%% test input
plotparameters = struct('imdir',{},'testImages',{},'QaMethods',{},'includeImages',{},'showimage',{},'saveimageto',{},'saveformats',{});
plotparameters(1).imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
plotparameters(1).testImages = 'testImages';

getInputs_allQaMethods
plotparameters(1).QaMethods = QaMethods([12]); % 选择Qa方法       1:8 10:end

plotparameters(1).showimage = 'on';
plotparameters(1).saveimageto = fullfile('E:\DoctorThesis\MBench\Plan\outdir\iqa','Plot-intraQa-Watson38-3-9-30');
saveformats = ['jpg';'eps'];
plotparameters(1).saveformats = saveformats;

load(fullfile(plotparameters(1).imdir,plotparameters(1).testImages));
allImages = {testImages.imOriginal};
plotparameters(1).includeImages = allImages([1 2 4:8 10:29 31:38]); % 选择图像

clear testImages QaMethods allImages
