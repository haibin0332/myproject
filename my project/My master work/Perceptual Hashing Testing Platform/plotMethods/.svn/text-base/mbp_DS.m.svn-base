%{
这个函数对指定的数据绘图，可以指定攻击的种类，选用的样本图像。

横坐标为攻击强度，纵坐标为受攻击图像与原图的PH距离（比如汉民距等）

输入：
	intraClassTest 可以是个mat文件，也可以是个结构体。
	plotparameters 绘图参数。
		plotparameters = struct('showimage',{},'saveimageto',{},'meanlineonly',{},'saveformats',{});
			showimage
				是否在屏幕上显示fig图像
			saveimageto
				产生的图片保存到什么地方
			meanlineonly
				是否只显示平均的那条线
			saveformats
				指定保存的图像格式
输出：
	输出图像保存的路径

使用平均的方法，产生相应的图，不知道如何说明这么做的依据是什么。但是可以找到确定的参考文献：
Robust and Secure Image Hashing
06hash_TIFSaccept0602.pdf
%}
function [outPath,savemat] = mbp_DS(intraClassTest,plotparameters)
%% test input
% getInputs_mbp_DS

%% parse input parameter
if isstruct(intraClassTest) ~= 1 % 可以输入文件名，也可以输入struct
	load(intraClassTest);
end
showimage = plotparameters.showimage;
saveimageto  = plotparameters.saveimageto;
meanlineonly = plotparameters.meanlineonly;
saveformats = plotparameters.saveformats;
%% Plot all figures
intraDistance = intraClassTest.intraDistance;
for i = 1:length(intraDistance)
	i
	x = intraDistance(i).attStrength;
	for j = size(intraDistance(i).Distances,1)
		f = figure('Visible','off');
		% 求平均之后的线
		meanLine = sum(intraDistance(i).Distances)/size(intraDistance(i).Distances,1);
		p = plot(x,meanLine,'-b','LineWidth',2.5);
		if ~isempty(intraClassTest.intraClassTestPlan.normalizedDistRange)
			range = intraClassTest.intraClassTestPlan.normalizedDistRange;
			axis([min(x) max(x) range(1) range(2)]);
		end
		grid on;
		
		xlabel('Strength of Attack'); ylabel('PH Distance');
		algname = strrep(intraClassTest.intraClassTestPlan.algfun,'_','\_');
		attname = strrep(intraDistance(i).attMethod,'_','\_');
		title(['The Effect of ',attname,' on Algorithm ',algname]);
		
		if strcmp(meanlineonly,'off') == 1
			hold on;
			p = plot(x,intraDistance(i).Distances(:,:));
			hold off;
		end 
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
		
		
		imfile = fullfile(saveimageto, [intraClassTest.intraClassTestPlan.algfun, ' Vs ', intraDistance(i).attMethod]);
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
	end % end for j
end % end for i
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
end

