%{
这个函数用于绘图

横坐标为攻击强度，纵坐标为受攻击图像的IQA取值

输入：
	iqaResult 保存所有test images的IQA取值。
	interClassTest 保存 interClassTest 得到的距离。		% 因为输入有两个文件，所以在执行绘图之前需要有一个 intersect 的测试过程
	如果没有指定 interClassTest ，那么就对iqaResult中所有的图像画图
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

function [savemat,outPath] = mbp_QS(iqaResult,interClassTest,plotparameters)
%% test Inputs
getInputs_mbp_QS
%% parse input parameter
if isstruct(iqaResult) ~= 1 % 可以输入文件名，也可以输入struct
	load(iqaResult);
end
imageQualityAssessment = iqaResult.imageQualityAssessment;
if ~isempty(interClassTest)
	if ~isstruct(interClassTest)
		load(interClassTest);
	end
end
showimage = plotparameters.showimage;
saveimageto  = plotparameters.saveimageto;
meanlineonly = plotparameters.meanlineonly;
saveformats = plotparameters.saveformats;
%% intersect 测试， 获得两个输入中交叉的部分
if ~isempty(interClassTest)
	% 测试的内容包括两个部分，图片和攻击方法，攻击强度对所有的都是一样的。所有的信息均取自他们的plan
	im_iqa = iqaResult.iqaPlan.includeImages;
	im_inter = interClassTest.interClassTestPlan.includeImages;
	att_iqa = iqaResult.iqaPlan.includeAttacks;
	att_inter = interClassTest.interClassTestPlan.includeAttacks;

	[imBe, index_im_iqa, index_im_inter] = intersect(im_iqa, im_inter);
	[attBe, index_att_iqa, index_att_inter] = intersect(att_iqa,att_inter);

	if isempty(imBe) || isempty(attBe)
		error('没有找到用于绘图的数据');	% 交叉测试没有找到交集
	end
else
	index_im_iqa = 1:length(iqaResult.iqaPlan.includeImages);
	index_att_iqa = 1:length(iqaResult.iqaPlan.includeAttacks);
end
%% Plot All Figures
% 根据输入，每个QaMethod和每个Attack都要产生一个图。这个图是所有testImages的平均。
for i = 1:length(imageQualityAssessment)	% 每个QaMethod
	QaOnAttacks = imageQualityAssessment(i).QaOnAttacks;
	for j = uint8(sort(index_att_iqa))		% 1:length(QaOnAttacks)
		x = QaOnAttacks(j).attStrength;
		QaValues = QaOnAttacks(j).QaValues(index_im_iqa,:);
		sumQaValue = sum(QaOnAttacks(j).QaValues(index_im_iqa,:));
		meanLine = sumQaValue/length(index_im_iqa);
		
		f = figure('Visible','off');
		p = plot(x,meanLine,'-b','LineWidth',2.5);
		axis([min(x) max(x) min(min(QaValues)) max(max(QaValues))]);
		grid on;
		
		if strcmp(meanlineonly,'off') == 1
			hold on;
			p = plot(x,QaValues);
			hold off;
		end
		
		i
		j
		
		xlabel('Strength of Attack'); ylabel('Image Quality Assessment Value');
		qaname = strrep(imageQualityAssessment(i).QaMethod,'_','\_');
		attname = strrep(QaOnAttacks(j).attMethod,'_','\_');
		title([qaname, ' Vs ', attname]);
		
		if strcmp(showimage, 'on') == 1
			set(f,'Visible','on');
		end
		if isdir(saveimageto) ~= 1
			[s,mess] = mkdir(saveimageto);
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
		imfile = fullfile(saveimageto, [imageQualityAssessment(i).QaMethod, ' Vs ', QaOnAttacks(j).attMethod]);
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
savemat = fullfile(plotparameters.saveimageto,'QS_plotparameters');
if exist(savemat,'file') ~= 0
	movefile(savemat, [savemat, '.bak']);
end 
if isdir(outPath) ~= 1
	mkdir(outPath);
end
save(savemat,'plotparameters');
end % end function