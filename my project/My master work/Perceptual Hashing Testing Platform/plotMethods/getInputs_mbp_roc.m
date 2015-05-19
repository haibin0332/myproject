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

%% ͨ�����Եķ�ʽ��� StrengthAndMethods ������
why % �ϵ��������� F9���������
% F9 ����������Եõ���Ҫ�Ĺ�������
allmethods = intraClassTest.intraClassTestPlan.includeAttacks 
attIndex = 5; % ������ط���ָ��ѡ���Ĺ�������
StrengthAndMethods(1).attMethod = allmethods(attIndex)

% F9 ����Ŀ���ָ����Ӧ���������Ĺ���ǿ��
allstrength = intraClassTest.intraDistance(attIndex).attStrength 
StrengthAndMethods(1).attStrength = '';% allstrength(end);% '' % ���ǿ����Ϊ�գ���������ǿ�Ȼ�ͼ

% �ظ��������̣�������StrengthAndMethods(1)����ţ�����ͬʱָ���������ǿ�Ⱥͷ���
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
