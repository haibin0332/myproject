%% ��inter��ֱ��ͼ��Ȼ��ͨ���۲죬��һ��������һ��֮���interֱ��ͼ��DSͼ 
%{%}
function adaptiveNormalizePlot(workdir_Macro,matchfun,mbefun_Marco,histNbins,interHistOnly)
%{
mbefun_Marco = 'zh_rdd';
workdir_Macro = 'E:\outdir\500\mbe_zh_rdd\keyfree'; % 'E:\MBench\outdir\zh_rdd\test6\r4'; % fullfile(mbenchpath,'outdir','\substituate\zh_rdd_3'); %  % fullfile(mbenchpath,'\outdir\zh_rdd\test2');
histNbins = 500;
interHistOnly = 2;
matchfun = '';
%}
%% ��һ�� inter�� inter ���ԵĽ��


interMatfile = ['interTest-extractBy-',mbefun_Marco];
workdir = workdir_Macro;
%% ���ƹ�һ��֮ǰ��ֱ��ͼ�����ҳ����۲죬�Եõ���һ���Ĳ�����
%
% ��һ�ο�����Ҫ���ݾ���������������һ�£��Եõ���ȷ�Ĺ�һ����Χ
% ����Ĳ����߼��ǣ�����ԭʼ��ֱ��ͼ���Զ�����ֱ��ͼ�ֲ������ģ�Ȼ��۲죬���������ļ��㲻׼ȷ�Ļ���ͨ���ֶ��ĵ��ڣ��õ���ȷ��center
load(fullfile(workdir,interMatfile));
interDistances = interClassTest.interDistances;
f1 = figure;
nbins = histNbins;	% ָ��ֱ��ͼ����
% [n,xout] = hist(interDistances,nbins)	% ������Եõ��ֲ��ľ�����ֵ
hist(interDistances,nbins)			% �����ͼ
f2 = figure;
ksdensity(interDistances,'npoints',nbins,'kernel','box');%'support','positive',
[f,xi,u] = ksdensity(interDistances,'npoints',nbins,'kernel','box');
peak = max(f);
index = find(f == peak);
center = xi(index(1));

why
% ����ͼ��

outPath = fullfile(workdir_Macro,['Plot-histeq']);
if isdir(outPath) ~= 1
	mkdir(outPath);
end
%
imfile1 = fullfile(outPath,['histeq-inter-',mbefun_Marco]);
imfile1 = strrep(imfile1, '.','_');
imfile2 = fullfile(outPath,['ksdensity-inter-',mbefun_Marco]);
imfile2 = strrep(imfile2, '.','_');
saveas(f1,imfile1,'fig');
saveas(f2,imfile2,'fig');   % ���ﱣ��ԭʼ���ݣ���һ��֮ǰ����intra��ֱ��ͼ
%}
if interHistOnly == 1
    return; % һ�㶼����Ҫ��һ��
end
%% ͨ���۲죬���ԣ�ȷ����һ���Ĳ��� ����һ�ο�ѡ�Ĵ���
% ��¼��÷ֲ����ĵ�ʵ����̣�����������У�������Щƫ��̫Զ�ĵ㣬���¼�������center
%{
[n,xout] = hist(interDistances,nbins);
inter = interDistances(interDistances <= 1.5);
f3 = figure;
hist(inter,nbins);
f4 = figure; 
ksdensity(inter,'npoints',nbins,'support','positive','kernel','box');
[f,xi,u] = ksdensity(inter,'npoints',nbins,'support','positive','kernel','box');
peak = max(f);
index = find(f == peak)
center = xi(index)
% ���涪��ƫ��̫Զ�ĵ�֮���ֱ��ͼ
imfile3 = fullfile(outPath,['histeq-adjusted-inter-',mbefun_Marco]);
imfile3 = strrep(imfile3, '.','_');
imfile4 = fullfile(outPath,['ksdensity-adjusted-inter-',mbefun_Marco]);
imfile4 = strrep(imfile4, '.','_');	
saveas(f3,imfile3,'jpg');
saveas(f4,imfile4,'jpg');
%}
%% ���ݵõ���center��һ��inter��intra����õ�������
%
D_diff = center
extractedImages = ['extractBy-',mbefun_Marco,'*.mat'];
extractedImages = dir(fullfile(workdir,extractedImages));
extractedImages = load(fullfile(workdir,extractedImages(1).name));
aHashvector = extractedImages.extractedImages(1).hashOriginal;
if isempty(matchfun)
    D_same = sum(abs(aHashvector - aHashvector))/length(aHashvector)
else
    param = '';
    D_same = feval(matchfun,aHashvector,aHashvector,param)
end
sampleNumber = histNbins;
from = [D_same,D_diff];%  ''; % 
to =  [0 0.5]; % ''; % 
% ��һ��inter
[saveinter saveintra] = normalizeDistanceMat(interMatfile, '', workdir,sampleNumber,from,to) % ��һ��intra��inter����

% ��һ��intra
intraMatfile = ['intraTest-extractBy-',mbefun_Marco];
% ������ھ����Ѿ����ϲ����˵ģ���������ڿ����ǲ���û�кϲ�
ls = dir(fullfile(workdir_Macro,[intraMatfile,'.mat']));
if isempty(ls)
% intra�����кܶ�� 
    ls = dir(fullfile(workdir_Macro,[intraMatfile,'*.mat']));
    ls = ls(1:end); % ����Ĵ����ṩ��ls����ѡ��Ļ��ᣬ��Ϊ����һ����Ҫ�õ�
    intraClassTest = combineIntraMat(workdir_Macro,intraMatfile,ls); 
end
for i = 1:length(ls)
    intraMatfile = ls(i).name;
    [saveinter saveintra] = normalizeDistanceMat('', intraMatfile, workdir,sampleNumber,from,to) % ��һ��intra��inter����
end



%}

%% ���ù�һ��֮������ݣ����»���DSͼ
%
% mbp_DS 
% [outPath,savemat] = mbp_DS(intraClassTest,plotparameters)
plotparameters = struct('showimage',{},'saveimageto',{},'meanlineonly',{},'saveformats',{});

workdir = workdir_Macro;
inmatfile = ['normalized-intraTest-extractBy-',mbefun_Marco];
intraClassTest = fullfile(workdir,inmatfile);

plotparameters(1).showimage = 'off';
plotparameters(1).saveimageto = fullfile(workdir,['Plot-normalized-DS-',mbefun_Marco]);
plotparameters(1).meanlineonly = 'off';
saveformats = ['jpg';'fig'];
plotparameters(1).saveformats = saveformats;

mbp_DS(intraClassTest,plotparameters)
%}
