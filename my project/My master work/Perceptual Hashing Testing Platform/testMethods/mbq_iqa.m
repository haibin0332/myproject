%{
这个函数使用各种图像质量评价方法计算每一个原图与受攻击之后的图之间的差距（这个差距就是相应的评价方法的打分）。
针对每种攻击建立一个矩阵，矩阵的行是所有图像，矩阵的列是每种攻击强度之下得到质量评价方法打分。

针对每种评价方法建立一个结构。该结构包含上面产生的矩阵。

输入：
	iqaPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'QaMethods',{},'includeAttacks',{},'includeImages',{});
		imdir
			保存 testImages 的路径
		testImages
			mat 文件名
		outdir
			指定输出路径，保存 iqa 过程产生的mat文件 imageQualityAssessment 
			这个路径可以是一个工作路径，与各个算法extract的 extractedImages 路径相独立
		customedOutName
			一般为空，但也可以用来表示特定目的
		QaMethods
			保存qa函数相关信息的结构体
		includeAttacks
			指定所针对的攻击
		includeImages
			指定所针对的图像


输出：
	保存结果 imageQualityAssessment 的mat文件，

Uses：

%}

%% 
function [savemat] = mbq_iqa(iqaPlan)
%% test inputs
getInputs_mbq_iqa

%% get inputs
imdir = iqaPlan.imdir;
testImages = fullfile(imdir,iqaPlan.testImages);
outdir = iqaPlan.outdir;
customedOutName = iqaPlan.customedOutName;
QaMethods = iqaPlan.QaMethods;
includeAttacks = iqaPlan.includeAttacks;
includeImages = iqaPlan.includeImages;

if ~isstruct(testImages)
	load(testImages);
end 
if ~ischar(imdir)
	error('need a dir!');
end
%% build a struct to store data will be generated
QaOnAttacks = struct('attMethod',{},'attStrength',{},'QaValues',{});
imageQualityAssessment = struct('QaMethod',{},'QaOnAttacks',struct('attMethod',{},'attStrength',{},'QaValues',{}));
iqaResult = struct('iqaPlan',{},'imageQualityAssessment',{});
iqaResult = setfield(iqaResult,{1},'iqaPlan',iqaPlan);
%% Preallocation
% 主要为 QaOnAttacks 分配空间，QaOnAttacks 将被产生多份，但是对于每幅图像，他的尺寸都是一样的。
% 取得index
[imBe, indexInclude, indexImages] = intersect(includeImages, {testImages.imOriginal});
[attBe, indexInclude, indexImAttacked] = intersect(includeAttacks, {testImages(1).imAttacked.attMethod});

kCounter = 0;
for k = sort(indexImAttacked)
	kCounter = kCounter + 1;
	QaOnAttacks = setfield(QaOnAttacks,{kCounter},'attMethod',testImages(1).imAttacked(k).attMethod);		% 这里只是用来分配空间
	QaOnAttacks = setfield(QaOnAttacks,{kCounter},'attStrength',testImages(1).imAttacked(k).attStrength);
	QaValues = zeros(length(indexImages),length(testImages(1).imAttacked(k).attStrength));
	QaOnAttacks = setfield(QaOnAttacks,{kCounter},'QaValues',QaValues);	
end % end for k
for k = 1:length(QaMethods)
	imageQualityAssessment = setfield(imageQualityAssessment,{k},'QaMethod',QaMethods(k).QaMethod); % 这是真正的赋值
	imageQualityAssessment = setfield(imageQualityAssessment,{k},'QaOnAttacks',QaOnAttacks);		% 这里只是用来分配空间
end % end for k
%{
	上面的预分配空间的过程得益于这样一个事实： 
	最外层： 针对每个Qa方法建立一个 imageQualityAssessment 结构体， 构成一个 imageQualityAssessment 数组
	中间和内层： 针对每个att方法建立一个QaOnAttacks，每个QaOnAttacks中保留一个矩阵，每行对应一个图片，每列对应一个攻击强度。
	对于每个图像而言，攻击方法和Qa方法都是一样的，
	对于每种攻击而言，攻击的图片和攻击强度都是一样的，
	对于每个Qa方法而言，Qa的图片和攻击方法还是一样的。
%}
%% image quality assessment
kCounter = 0;
for k = sort(indexImages)		% 为什么一定要把图像的遍历放在最外面，因为每幅图像都只需要打开一次，但是后面的多重循环还是破坏效率
	kCounter = kCounter + 1;
	imgOriginal = testImages(k).imOriginal;
	imgOriginal = fullfile(imdir,imgOriginal);
	for q = 1:length(QaMethods)
		qafun = QaMethods(q).QaFunction;
		params =  QaMethods(q).params;
		% QaMethod 已经赋值过了
		aCounter = 0;
		for a = sort(indexImAttacked)
			aCounter = aCounter + 1;
			imageQualityAssessment(q).QaOnAttacks(aCounter).attMethod = testImages(k).imAttacked(a).attMethod;
			imageQualityAssessment(q).QaOnAttacks(aCounter).attStrength = testImages(k).imAttacked(a).attStrength;
% 			testImages(k).imAttacked(a).attMethod
			for l = 1:length(testImages(k).imAttacked(a).attStrength)
				imgAttacked = cell2mat(testImages(k).imAttacked(a).imSaved{l});
				imgAttacked = fullfile(imdir,imgAttacked);
				if isempty(params)
					QaValue = feval(qafun,imgOriginal,imgAttacked);	
				else
					QaValue = feval(qafun,imgOriginal,imgAttacked,params);	
				end
				imageQualityAssessment(q).QaOnAttacks(aCounter).QaValues(kCounter,l) = QaValue;		% 每行对应一个图像，每列对应一个攻击强度。
				k
				qafun
				testImages(k).imAttacked(a).attMethod
			end % end for l
		end % end for a
	end % end for q
end % end for k
iqaResult = setfield(iqaResult,{1},'imageQualityAssessment',imageQualityAssessment);
%% save mat file
if isempty(customedOutName)
	savemat = fullfile(outdir,['iqaResult']);
else
	savemat = fullfile(outdir,['iqaResult-',customedOutName]);
end
if isdir(outdir) ~= 1
	mkdir(outdir);
end
if exist(savemat,'file') ~= 0
	movefile(savemat, [savemat, '.bak']);
end 
save(savemat,'iqaResult');
end % end function