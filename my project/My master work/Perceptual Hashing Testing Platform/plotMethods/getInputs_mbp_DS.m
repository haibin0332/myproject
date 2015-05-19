%% mbp_DS
% [outPath,savemat] = mbp_DS(interClassTest,plotparameters)
plotparameters = struct('showimage',{},'saveimageto',{},'meanlineonly',{},'saveformats',{});

workdir = 'E:\PH1\mbe_yangbian';
inmatfile = 'intraTest-extractBy-mbe_bian.mat';
interClassTest = fullfile(workdir,inmatfile);

plotparameters(1).showimage = 'off';
plotparameters(1).saveimageto = fullfile(workdir,'Plot-DS-mbe_bian');
plotparameters(1).meanlineonly = 'off';
saveformats = ['fig'];				% �������ͼ���ʽҪ�ã���Ҫ�ã�['jpg';'fig']
plotparameters(1).saveformats = saveformats;

mbp_DS(interClassTest,plotparameters)