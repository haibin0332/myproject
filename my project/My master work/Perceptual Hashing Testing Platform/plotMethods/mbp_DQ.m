%{
这个函数用于绘图

横坐标为受攻击图像的IQA取值，纵坐标为PH取值
在线上标注攻击强度 好像没有必要？？

输入：
	iqaResult 保存所有test images的IQA取值。
	interClassTest 保存 interClassTest 得到的距离。		% 因为输入有两个文件，所以在执行绘图之前需要有一个 intersect 的测试过程
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

function [savemat,outPath] = mbp_DQ(iqaResult,interClassTest,plotparameters)
%% test input
getInputs_mbp_DQ

%% parse input parameter
if isstruct(iqaResult) ~= 1 % 可以输入文件名，也可以输入struct
	load(iqaResult);
end
imageQualityAssessment = iqaResult.imageQualityAssessment;
if ~isstruct(interClassTest)
	load(interClassTest);
end

showimage = plotparameters.showimage;
saveimageto  = plotparameters.saveimageto;
meanlineonly = plotparameters.meanlineonly;
saveformats = plotparameters.saveformats;
%% intersect 测试， 获得两个输入中交叉的部分
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
%% Plot All Figures
for i = 1:length(imageQualityAssessment)	% 每个QaMethod
	QaOnAttacks = imageQualityAssessment(i).QaOnAttacks;
	interDistance = interClassTest.interDistance;
	for j = uint8(sort(index_att_iqa))		%1:length(QaOnAttacks) % interDistance 和 QaOnAttacks 是一样的长度。
		% 获取交集中的用于绘图的信息
		QaValues = QaOnAttacks(j).QaValues(index_im_iqa,:);
		indexAttack = find(strcmp(interClassTest.interClassTestPlan.includeAttacks,iqaResult.iqaPlan.includeAttacks(j))); % 这是为了找到对应的attack
		disValues = interDistance(indexAttack).Distances(index_im_inter,:);
		
		% 这个meanLineX是所有Quality的平均
		meanLineX = sum(QaValues)/length(index_im_iqa);
		% 这个meanLineY是所有Distance的平均
		meanLineY = sum(disValues)/length(index_im_inter);
		
 		f = figure('Visible','off');
		p = plot(meanLineX,meanLineY,'-b','LineWidth',2.5);
%		axis([min(interDistance(j).NormalizedDistances) max(interDistance(j).NormalizedDistances)...
%			min(QaOnAttacks(j).QaValues) max(QaOnAttacks(j).QaValues)])
		grid on;
		%% 
		if strcmp(meanlineonly,'off') == 1
			hold on;
			% 每一张图片都有一个对应的DQ图
			for k =	uint8(sort(index_im_iqa));		% 1:size(QaOnAttacks(j).QaValues,1)
				QaValue = QaOnAttacks(j).QaValues(k,:);
				indexImage = find(strcmp(interClassTest.interClassTestPlan.includeImages,iqaResult.iqaPlan.includeImages(k))); % 这是为了找到对应的image
				disValue = interDistance(indexAttack).Distances(indexImage,:);
				p = plot(QaValue,disValue);
			end
			hold off;
		end
		%%
		xlabel('Image Quality Assessment Value'); ylabel('PH Distance');
		qaname = strrep(imageQualityAssessment(i).QaMethod,'_','\_');
		attname = strrep(interDistance(j).attMethod,'_','\_');
		algname = strrep(interClassTest.interClassTestPlan.algfun,'_','\_');
		title(['The Effect of ',attname,' on Algorithm ',algname, ', Against ',qaname]);
		
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
		imfile = fullfile(saveimageto, [interClassTest.interClassTestPlan.algfun, ' Vs ', QaOnAttacks(j).attMethod,...
			' Against ',imageQualityAssessment(i).QaMethod]);
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
savemat = fullfile(plotparameters.saveimageto,'DQ_plotparameters');
if exist(savemat,'file') ~= 0
	movefile(savemat, [savemat, '.bak']);
end 
if isdir(outPath) ~= 1
	mkdir(outPath);
end
save(savemat,'plotparameters');
end % end function