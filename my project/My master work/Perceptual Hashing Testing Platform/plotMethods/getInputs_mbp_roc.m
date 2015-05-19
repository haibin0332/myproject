% function [savemat,outPath] = mbp_roc(intraClassTest,interClassTest,StrengthAndMethods,plotparameters)
%
workdir_Macro = '\mbe_yangbian';
mbefun_Marco = 'mbe_bian'
%}
StrengthAndMethods = struct('attStrength',{},'attMethod',{});
plotparameters = struct('figtypes',{},'samplenumber',{},'showimage',{},'saveimageto',{},'saveformats',{});
%%	
workdir = fullfile(mbenchpath,workdir_Macro);
interClassTest = ['interTest-extractBy-',mbefun_Marco,'.mat'];
interClassTest = fullfile(workdir,interClassTest);

intraClassTest = ['intraTest-extractBy-',mbefun_Marco,'.mat'];
intraClassTest = fullfile(workdir,intraClassTest);
load(intraClassTest);

%% 通过调试的方式获得 StrengthAndMethods 的内容
why % 断点设在这里 F9下面的内容
% F9 下面两句可以得到想要的攻击方法
allmethods = intraClassTest.intraClassTestPlan.includeAttacks 
attIndex = 5; % 改这个地方是指定选定的攻击方法
StrengthAndMethods(1).attMethod = allmethods(attIndex)

% F9 下面的可以指定对应攻击方法的攻击强度
allstrength = intraClassTest.intraDistance(attIndex).attStrength 
StrengthAndMethods(1).attStrength = '';% allstrength(end);% '' % 如果强度设为空，则用所有强度绘图

% 重复上述过程，并递增StrengthAndMethods(1)的序号，可以同时指定多个攻击强度和方法
%% plotparameter
figtypes = ['roc';'det';'eer'; 'pdf'];
plotparameters(1).figtypes = figtypes;
plotparameters(1).samplenumber = 10;
plotparameters(1).showimage = 'off';
plotparameters(1).saveimageto = fullfile(workdir,['Plot-ROC-',mbefun_Marco]);
saveformats = ['jpg';'fig'];
plotparameters(1).saveformats = saveformats;
%%
% mbp_roc(interClassTest,intraClassTest,StrengthAndMethods,plotparameters)
