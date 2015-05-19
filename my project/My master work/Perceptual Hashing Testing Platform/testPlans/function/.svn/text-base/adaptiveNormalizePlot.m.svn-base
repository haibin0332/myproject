%% 画inter的直方图，然后通过观察，归一化，画归一化之后的inter直方图和DS图 
%{%}
function adaptiveNormalizePlot(workdir_Macro,matchfun,mbefun_Marco,histNbins,interHistOnly)
%{
mbefun_Marco = 'zh_rdd';
workdir_Macro = 'E:\outdir\500\mbe_zh_rdd\keyfree'; % 'E:\MBench\outdir\zh_rdd\test6\r4'; % fullfile(mbenchpath,'outdir','\substituate\zh_rdd_3'); %  % fullfile(mbenchpath,'\outdir\zh_rdd\test2');
histNbins = 500;
interHistOnly = 2;
matchfun = '';
%}
%% 归一化 inter和 inter 测试的结果


interMatfile = ['interTest-extractBy-',mbefun_Marco];
workdir = workdir_Macro;
%% 绘制归一化之前的直方图，并且初步观察，以得到归一化的参数：
%
% 这一段可能需要根据具体情况，具体分析一下，以得到正确的归一化范围
% 具体的操作逻辑是：根据原始的直方图，自动计算直方图分布的中心，然后观察，如果这个中心计算不准确的话，通过手动的调节，得到正确的center
load(fullfile(workdir,interMatfile));
interDistances = interClassTest.interDistances;
f1 = figure;
nbins = histNbins;	% 指定直方图精度
% [n,xout] = hist(interDistances,nbins)	% 这个可以得到分布的具体数值
hist(interDistances,nbins)			% 这个画图
f2 = figure;
ksdensity(interDistances,'npoints',nbins,'kernel','box');%'support','positive',
[f,xi,u] = ksdensity(interDistances,'npoints',nbins,'kernel','box');
peak = max(f);
index = find(f == peak);
center = xi(index(1));

why
% 保存图像

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
saveas(f2,imfile2,'fig');   % 这里保存原始数据（归一化之前）的intra的直方图
%}
if interHistOnly == 1
    return; % 一般都不需要归一化
end
%% 通过观察，调试，确定归一化的参数 这是一段可选的代码
% 记录获得分布中心的实验过程：在这个过程中，丢弃那些偏离太远的点，重新计算合理的center
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
% 保存丢弃偏离太远的点之后的直方图
imfile3 = fullfile(outPath,['histeq-adjusted-inter-',mbefun_Marco]);
imfile3 = strrep(imfile3, '.','_');
imfile4 = fullfile(outPath,['ksdensity-adjusted-inter-',mbefun_Marco]);
imfile4 = strrep(imfile4, '.','_');	
saveas(f3,imfile3,'jpg');
saveas(f4,imfile4,'jpg');
%}
%% 根据得到的center归一化inter和intra试验得到的数据
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
% 归一化inter
[saveinter saveintra] = normalizeDistanceMat(interMatfile, '', workdir,sampleNumber,from,to) % 归一化intra和inter数据

% 归一化intra
intraMatfile = ['intraTest-extractBy-',mbefun_Marco];
% 如果存在就是已经被合并过了的，如果不存在看看是不是没有合并
ls = dir(fullfile(workdir_Macro,[intraMatfile,'.mat']));
if isempty(ls)
% intra可能有很多份 
    ls = dir(fullfile(workdir_Macro,[intraMatfile,'*.mat']));
    ls = ls(1:end); % 这里的代码提供对ls进行选择的机会，因为并不一定都要用的
    intraClassTest = combineIntraMat(workdir_Macro,intraMatfile,ls); 
end
for i = 1:length(ls)
    intraMatfile = ls(i).name;
    [saveinter saveintra] = normalizeDistanceMat('', intraMatfile, workdir,sampleNumber,from,to) % 归一化intra和inter数据
end



%}

%% 利用归一化之后的数据，重新绘制DS图
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
