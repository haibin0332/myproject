% function [savemat,outPath] = mbp_roc(intraClassTest,interClassTest,StrengthAndMethods,plotparameters)
%% 绘制ROC系列图
%{%}
function generalRocPlot(workdir_Macro,mbefun_Marco,nbins,normalized)
%{
workdir_Macro = 'E:\outdir\500\mbe_zh_rdd\keyfree'; %  'E:\MBench\outdir\zh_rdd\test6\r4'; % fullfile(mbenchpath,'outdir','\substituate\zh_rdd_3'); %  % fullfile(mbenchpath,'\outdir\VishalMonga\wavelet');
mbefun_Marco = 'zh_rdd'
nbins = 500;
normalized = 1;
%}
StrengthAndMethods = struct('attStrength',{},'attMethod',{});
plotparameters = struct('figtypes',{},'samplenumber',{},'showimage',{},'saveimageto',{},'saveformats',{});
%%	
workdir = workdir_Macro;
if normalized == 1
    interClassTest = ['normalized-interTest-extractBy-',mbefun_Marco,'.mat'];
else
    interClassTest = ['interTest-extractBy-',mbefun_Marco,'.mat'];
end
interClassTest = fullfile(workdir,interClassTest);
if normalized == 1
    intraClassTest = ['normalized-intraTest-extractBy-',mbefun_Marco,'.mat'];
else
    intraClassTest = ['intraTest-extractBy-',mbefun_Marco,'.mat'];
end
intraClassTest = fullfile(workdir,intraClassTest);
load(intraClassTest);

%% 通过调试的方式获得 StrengthAndMethods 的内容
why % 断点设在这里 F9下面的内容
% F9 下面两句可以得到想要的攻击方法
allmethods = intraClassTest.intraClassTestPlan.includeAttacks 
% attIndex = [1 2 3 4 5 6 10]; % 改这个地方是指定选定的攻击方法
for attIndex = 1:length(allmethods)
    StrengthAndMethods(1).attMethod = allmethods(attIndex)

    % F9 下面的可以指定对应攻击方法的攻击强度
    allstrength = intraClassTest.intraDistance(attIndex).attStrength 
    StrengthAndMethods(1).attStrength = '';% allstrength(end);% '' % 如果强度设为空，则用所有强度绘图
    plotROC(StrengthAndMethods,nbins,workdir,mbefun_Marco,intraClassTest,interClassTest,normalized)
end
end
% 重复上述过程，并递增StrengthAndMethods(1)的序号，可以同时指定多个攻击强度和方法
%% plotparameter
function plotROC(StrengthAndMethods,nbins,workdir,mbefun_Marco,intraClassTest,interClassTest,normalized)
figtypes = ['roc';'det';'eer'; 'pdf'];
plotparameters(1).figtypes = figtypes;
plotparameters(1).samplenumber = nbins;
plotparameters(1).showimage = 'off';
if normalized == 1
    plotparameters(1).saveimageto = fullfile(workdir,['Plot-normalized-ROC-',mbefun_Marco]);
else
   	plotparameters(1).saveimageto = fullfile(workdir,['Plot-ROC-',mbefun_Marco]);
end
saveformats = ['jpg';'fig'];
plotparameters(1).saveformats = saveformats;
%%
mbp_roc(interClassTest,intraClassTest,StrengthAndMethods,plotparameters)
end
