%{
绘制ROC、DET和EER、PDF 四 个曲线
ROC： Receiver Operating Characteristics
DET:  Detection Error Tradeoff
EER:  等错误率 Equal Error Rate EER有助于直观的观察阈值对性能的影响
PDF:  概率密度函数曲线，probability density function， 这里提供两个条件概率的密度曲线

这个函数的适用范围：任意取值空间的intra和Inter实验，但是inter的距离应该要比intra的大。

这三个曲线都基于对测试集的两个条件概率的分析，所以可以一起画。

输入：
	interClassTest 保存 interClassTest 得到的距离。
	intraClassTest 保存 intraClassTest 得到的距离。		
	StrengthAndMethods
	StrengthAndMethods = struct('attStrength',{},'attMethod',{});
		一个结构或者结构数组，指定针对哪种攻击的哪种强度绘图
		这里的信息通过对 intraClassTest 分析得来。
        也可以不指定攻击强度，即所有强度攻击得到的图像都一样的放在intra测试集中。这种方式虽然不科学，但却是大家都用的方法。
	plotparameters 绘图参数。
	plotparameters = struct('figtypes',{},'samplenumber',{},'showimage',{},'saveimageto',{},'saveformats',{});
		figtypes
			绘制哪种图 roc det eer pdf
		samplenumber
			直方图分析的时候使用的样本点数，这个东西决定了绘图的精度。但是，如果样本数目太小，点数过多，反而会使得效果不好。
		showimage
			是否在屏幕上显示fig图像
		saveimageto
			产生的图片保存到什么地方
		saveformats
			指定保存的图像格式

输出
	savemat
	outPath

关于ROC的好的参考文献
Ecrypt: D.WVL.12 Applications, Application Requirements and Metrics
%}

function [savemat,outPath] = mbp_roc(interClassTest,intraClassTest,StrengthAndMethods,plotparameters)
%% test inputs
 getInputs_mbp_roc
%% get inputs
figtypes = plotparameters(1).figtypes;
samplenumber = plotparameters(1).samplenumber;
showimage = plotparameters(1).showimage ;
saveimageto = plotparameters(1).saveimageto;
saveformats = plotparameters(1).saveformats;
if ~isstruct(interClassTest)
	load(interClassTest);
end
if ~isstruct(intraClassTest)
	load(intraClassTest);
end
%% interClassTest 的数据
interDistances = interClassTest.interDistances;
%% 画图吧
for c = 1:length(StrengthAndMethods) % 针对每个指定的 方法和强度 
	method = StrengthAndMethods(c).attMethod;
	strength = StrengthAndMethods(c).attStrength;
	%% 获得相关数据，指定攻击和强度条件下的所有图像的intraClass测试结果
	% 拿 Method 去 find
	indexMethod = find(strcmp(intraClassTest.intraClassTestPlan.includeAttacks,method), 1);
	if isempty(indexMethod)
		error(['搞错了吧，intraClassTest中没有关于攻击 ',method,' 的数据']);	% 使用Plan虽然方便，但是导致程序结构依赖性增强
    end
    if isempty(strength)
        indexStrength = '';
    else
        indexStrength = find(intraClassTest.intraDistance(indexMethod).attStrength == strength);
    end
	intraMatrix = intraClassTest.intraDistance(indexMethod).Distances;
	% 取其中一列，或者全部
    if isempty(indexStrength)
        intraDistances = intraMatrix(:);
        strength = 'all';
    else
        intraDistances = intraMatrix(:,indexStrength);
        strength = num2str(strength);
    end
	
	%% 两个条件概率 f(p|H_0) f(p|H_1)
	%{
		两个条件分别是 本真和本假 ，对应着 intraclasstest和 interclasstest
		概率为归一化的事件发生的次数，这里的事件是： 
			1、如果为汉明距的情况，则 BER = i/n 表示一个二项实验中成功的次数。
			2、如果为其它距离测度，则 distance 也可以近似表示一次试验得到的某个距离。
		总之， 次数和距离的某个取值表示某个事件，相应的，统计事件发生的次数就是所谓概率。
		上述过程就是统计直方图的过程。
	%}
	[f_intra,x_intra] = hist(intraDistances,samplenumber);
	[f_inter,x_inter] = hist(interDistances,samplenumber);
    % 需要注意的是，x_intra和x_inter记录的是直方图的划分点，它之前是最小的distance，之后是最大的distance
    % 他们一起，表达了distance的取值范围，这个值不一定是0-1，可以是任意的。
	% normalization  次数除以总次数
	f_intra_nor = f_intra/sum(f_intra);
	f_inter_nor = f_inter/sum(f_inter);
	%% FAR FRR
	%{
		FAR 和 FRR 分别是对上述两个条件概率的积分，只是要注意积分区间的区别。
		积分就是求和
	%}
	FAR = cumsum(f_inter)/sum(f_inter);
	FRR = 1 - cumsum(f_intra)/sum(f_intra);
	% 补上 0 和 1  不知道为什么要这样，求完和之后，为什么最后一个数不是1呢 ？
	FAR = [0, FAR];
	FRR = [1, FRR];
	
	% 画图
	if isempty(figtypes)
		error('玩我？');
	end
	%%
	for r = 1:size(figtypes,1)
		%%
		switch figtypes(r,:)
			case {'roc'}
				f = figure('Visible','off');
				p = plot(FRR, 1- FAR);
				grid on;
				
				xlabel('FRR'); ylabel('1 - FAR');
				algname = strrep(intraClassTest.intraClassTestPlan.algfun,'_','\_');
				plottitle = ['ROC Curve of ', algname,' on ',method{1}, ' with Strength ', strength];
				title(plottitle);
				filename = strcat('roc-',intraClassTest.intraClassTestPlan.algfun,'-',method,'-',strength);
				
				saveimageto = saveimages(f,filename{1},showimage,saveimageto,saveformats);
% 				set(f,'Visible','on');
			%%
			case {'det'}
				f = figure('Visible','off');
				p = plot(FAR,FRR);
				grid on;

				xlabel('FAR'); ylabel('FRR');
				algname = strrep(intraClassTest.intraClassTestPlan.algfun,'_','\_');
				plottitle = ['DET Curve of ', algname,' on ',method{1}, ' with Strength ', strength];
				title(plottitle);
				filename = strcat('det-',intraClassTest.intraClassTestPlan.algfun,'-',method,'-',strength);
				
				saveimageto = saveimages(f,filename{1},showimage,saveimageto,saveformats);
% 				set(f,'Visible','on');
			%%
			case {'eer'}
				f = figure('Visible','off');
% 				x = [0:1/samplenumber:1];
				p = plot([min(intraDistances),x_intra],FRR,'-b','DisplayName','FRR');
				hold on;
				p = plot([x_inter,max(interDistances)],FAR,'-r','DisplayName','FAR');
				hold off;
				legend('show');
				grid on;
                
                % 找到FAR = FRR的位置和取值 妈的，这个好像不好编啊
%                 if max(x_intra) < min(x_inter)
%                     EER = 0;
%                 else
%                     for k = length(x_intra):-1:1
%                        indexInter = find((x_inter - x_intra(k)) == min(x_inter - x_intra(k)),'first');
%                        indexEER = find((x_inter(
%                     end
                        
                
				xlabel('\rho'); ylabel('FAR and FRR');
				algname = strrep(intraClassTest.intraClassTestPlan.algfun,'_','\_');
				plottitle = ['EER Curve of ', algname,' on ',method{1}, ' with Strength ', strength];
				title(plottitle);
				filename = strcat('eer-',intraClassTest.intraClassTestPlan.algfun,'-',method,'-',strength);
				
				saveimageto = saveimages(f,filename{1},showimage,saveimageto,saveformats);
% 				set(f,'Visible','on');
			%%
			case {'pdf'}
				f = figure('Visible','off');
				p = plot(x_intra,f_intra_nor,'-b','DisplayName','f(\rho|H_0)');
				hold on;
				p = plot(x_inter,f_inter_nor,'-r','DisplayName','f(\rho|H_1)');
				hold off;
				legend('show');
				grid on;
				
				xlabel('\rho'); ylabel('f(\rho)');
				algname = strrep(intraClassTest.intraClassTestPlan.algfun,'_','\_');
				plottitle = ['PDF Curve of ', algname,' on ',method{1}, ' with Strength ', strength];
				title(plottitle);
				filename = strcat('pdf-',intraClassTest.intraClassTestPlan.algfun,'-',method,'-',strength);
				
				saveimageto = saveimages(f,filename{1},showimage,saveimageto,saveformats);
% 				set(f,'Visible','on');
		end % end switch
	end % end for r
end % end for c
%% save out files
outPath = saveimageto;
savemat = fullfile(plotparameters.saveimageto,'DS_plotparameters');
if exist(savemat,'file') ~= 0
	movefile(savemat, [savemat, '.bak']);
end 
if isdir(outPath) ~= 1
	mkdir(outPath);
end
save(savemat,'plotparameters');
end % function

%% save images
function [saveimageto] = saveimages(f,filename,showimage,saveimageto,saveformats)

if strcmp(showimage, 'on') == 1
	set(f,'Visible','on');
end
if isdir(saveimageto) ~= 1
	[s, mess] = mkdir(saveimageto);
	if s ~= 1
		mkdir(cd,'SavedImage');
		warning(['Save to: ', fullfile(cd,'SavedImage')]);
		saveimageto = fullfile(cd,'SavedImage');
	end
else
	if isempty(saveimageto) == 1
		mkdir(cd,'SavedImage');
		warning(['Save to: ', fullfile(cd,'SavedImage')]);
		saveimageto = fullfile(cd,'SavedImage');			
	end
end

imfile = fullfile(saveimageto, filename);
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
end
