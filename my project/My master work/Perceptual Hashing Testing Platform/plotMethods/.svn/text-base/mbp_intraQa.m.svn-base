%{
这个函数用于绘图
这个函数对图像库中所有不同的图像使用选定的Qa方法执行一次intraClass测试，并且画出相应的直方图。
目的是为了观察Qa方法对不同图像之间评分的结果的分布。确定其取值的有效边界。

输入：
	plotparameters 绘图参数。
		plotparameters = struct('imdir',{},'testImages',{},'QaMethods',{},'showimage',{},'saveimageto',{},'saveformats',{});
			showimage
				是否在屏幕上显示fig图像
			saveimageto
				产生的图片保存到什么地方
			saveformats
				指定保存的图像格式
输出：
	输出图像保存的路径

%}

function [savemat,outPath,minDistance,centerDistance] = mbp_intraQa(plotparameters)
%% test Inputs
getInputs_mbp_intraQa
%% parse input parameter
imdir = plotparameters.imdir;
testImages = fullfile(imdir,plotparameters.testImages);
QaMethods = plotparameters.QaMethods;
showimage = plotparameters.showimage;
saveimageto  = plotparameters.saveimageto;
saveformats = plotparameters.saveformats;
includeImages = plotparameters.includeImages;
if ~isstruct(testImages)
	load(testImages);
end 
if ~ischar(imdir)
	error('need a dir!');
end
qafun = QaMethods.QaFunction;
params =  QaMethods.params;
%% 
% intraDistance 是一个大的列向量，长度为n(n-1)
imCount = length(includeImages);
intraDistances = zeros(imCount*(imCount - 1)/2,1);
nCounter = 0;
for r = 1:imCount
	for c = r+1:imCount
		rimgOriginal = testImages(r).imOriginal;
		rimgOriginal = fullfile(imdir,rimgOriginal);	
		cimgOriginal = testImages(c).imOriginal;
		cimgOriginal = fullfile(imdir,cimgOriginal);
		%% 下面一段来自于不好的设计，在Watson的intra中，会出现图像大小不同的情况
		rimgOriginal = imread(rimgOriginal);
		if size(rimgOriginal) == [256,256]
			rimgOriginal = imresize(rimgOriginal,[512 512]);
		end
		cimgOriginal = imread(cimgOriginal);
		if size(cimgOriginal) == [256,256]
			cimgOriginal = imresize(cimgOriginal,[512 512]);
		end
		%%
		if isempty(params)
			QaValue = feval(qafun,rimgOriginal,cimgOriginal);	
		else
			QaValue = feval(qafun,rimgOriginal,rimgOriginal,params);	
		end
		nCounter = nCounter + 1
		intraDistances(nCounter) = QaValue;
	end % end for c
end % end for r
%% savemat
outPath = saveimageto;
if isdir(outPath) ~= 1
	mkdir(outPath);
end
savemat = fullfile(outPath,['IntraTest-',QaMethods.QaMethod]);

if exist(savemat,'file') ~= 0
	movefile(savemat, [savemat, '.bak']);
end 
save(savemat,'intraDistances');
%% 绘图并保存
f = figure('Visible','off');
% 一种方式
%nbins = 100;	% 指定直方图精度
% [n,xout] = hist(intraDistances,nbins)	% 这个可以得到分布的具体数值
% hist(intraDistances,nbins)			% 这个画图
ksdensity(intraDistances,'npoints',100,'support','positive','kernel','box');
[f,xi,u] = ksdensity(intraDistances,'npoints',100,'support','positive','kernel','box');
peak = max(f);
index = find(f == peak); 
center = xi(index);
%% 下面是针对Watson产生的数据分布较宽，而且极不均衡的情况单独设计的：
%{
1、需要获得信息：最小值，分布中心
2、方法：
	min(intraDistances); % = 336.1811

	递归求取分布中心，即先去掉数据集中很大很小的而且出现次数不多的数据，然后逐步缩小范围，知道能够看到分布的图形，并确定中心。
	对于 38 张图片的实验， 最后的结果是 828.7320
%}
%{
% 直接对原始数据画图
ksdensity(intraDistances,'npoints',100,'support','positive','kernel','box');
% 可以看到严重左偏，第一步粗略的求一下中心
[f,xi,u] = ksdensity(intraDistances,'npoints',100,'support','positive','kernel','box');
peak = max(f);
index = find(f == peak); % = 1
center = xi(index); % =  263.0820
% 因为严重左偏，index = 1 与 index = 2 相差很大，所以去掉 大于 2的所有数据
intra = intraDistances(intraDistances <= xi(2));
% 继续观察
ksdensity(intra,'npoints',100,'support','positive','kernel','box');
[f,xi,u] = ksdensity(intra,'npoints',100,'support','positive','kernel','box');
peak = max(f);
index = find(f == peak); % = 8
center = xi(index); % =  868.6944
% 观察图像，发现大于4000的已经平缓
intra2 = intra(intra <= 4000);
[f,xi,u] = ksdensity(intra2,'npoints',100,'support','positive','kernel','box');
ksdensity(intra2,'npoints',100,'support','positive','kernel','box');
peak = max(f);
index = find(f == peak); % = 13
center = xi(index); % =  828.7320
%}
minDistance = min(intraDistances);
centerDistance = center;
%% 下面是关于figure的常规处理
grid on;
if strcmp(showimage, 'on') == 1
	set(f,'Visible','on');
end
imfile = fullfile(outPath,'histeq-intra-',QaMethods.QaMethod);
% 如果imfile中有点，matlab会将后面的部分看作后缀，由此，文件名和后缀将失效
imfile = strrep(imfile, '.','_');
if isempty(saveformats) ~= 1
	for k = 1:size(saveformats,1)
		if strcmp(saveformats(k,:),'fig')	
			% 对于fig的情况，必须要显示再保存，否则的话，会导致存的图片打不开。因为openfig只返回句柄，如果fig invisible，那么就不显示
			% 事实上，配合后面的close all，matlab也不会真的显示这些。
			set(f,'Visible','on');
		end
		saveas(f,imfile,saveformats(k,:));				
	end
	close all;
end				