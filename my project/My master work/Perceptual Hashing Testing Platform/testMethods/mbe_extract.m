%{
专门处理提取逻辑的函数，将提取算法相应的函数作为一个参数输入
本函数专门负责处理提取的逻辑，关心的问题包括：
	1、用哪个算法提取
	2、提取之后的信息保存在哪儿
	3、图像，攻击，强度，提取算法，结果Hash值等如何保存

input:
	extractPlan
		extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});
			imdir
				保存testImages的路径，这个路径下面保存所有攻击产生的图片和索引信息（testImages）
			testImages
				mat文件的文件名，一般是“testImages.mat”，但也可能不是。
			outdir
				指定输出路径，保存extract过程产生的mat文件 extractedImages 的路径
				这个路径可以理解为对某个算法进行攻击的一个工作路径，今后所有的分析、画图、制表工作都在这个目录下展开
			customedOutName
				一个算法不同参数，不同测试目的可能会产生多个不同的 extractedImages 结构，这个名称用于标识这种不同。
				如果没有特殊要求，这个参数可以为空。因为extract过程会自动根据提取方式产生一个 名称。
			algfun
				提取算法的函数
			params
				算法函数可能需要的参数
			includeAttacks
				指定提取所针对的攻击
			includeImages
				针对的图像
output:
	savemat: 产生的输出，应该是保存相关信息的mat文件

调用规则举例：
	getInputs_mbe_extract
	savemat = MBE_extract(extractPlan);
%}
function [savemat] = mbe_extract(extractPlan)
%% test inputs
   getInputs_mbe_extract

%% get inputs
if ~isempty(extractPlan)
	imdir = extractPlan(1).imdir;
	testImages = extractPlan(1).testImages;
	outdir = extractPlan(1).outdir;
	customedOutName = extractPlan(1).customedOutName;
	algfun = extractPlan(1).algfun;
	params = extractPlan(1).params;
	includeAttacks = extractPlan(1).includeAttacks;
	includeImages = extractPlan(1).includeImages;
else
	error('输入');
end
% testImages可以是个向量，也可以是个mat文件
if isstruct(testImages) ~= 1
	testImages = fullfile(imdir,testImages);
	load(testImages);
end

%% build a struct to store data will be generated
hashAttacked = struct('attMethod',{},'attStrength',{},'imagefile',{},'hashVector',{});
extractedImages = struct('imOriginal',{},'extractMethod',{},'hashOriginal',{},'hashAttacked',struct('imagefile',{},'hashVector',{},'attMethod',{},'attStrength',{}));

%% extract hashes according to testImages  
% 在这一段里面主要解决的是存储的数据结构和hash提取过程逻辑问题，与hash提取无关。 hash提取在 extractby 中。
% 取得在 includeImages 中指定图片的index
[tBe, indexInclude, indexImages] = intersect(includeImages, {testImages.imOriginal});
iCounter = 0;
for i = sort(indexImages)
    i
		iCounter = iCounter + 1;	% print i to show the rate of progress
	imOriginal = fullfile(imdir,testImages(i).imOriginal);
	extractedImages = setfield(extractedImages, { uint16(iCounter) }, 'imOriginal',testImages(i).imOriginal);
	extractedImages = setfield(extractedImages, { uint16(iCounter) }, 'extractMethod',func2str(algfun));	% 记录函数名称
	
	hashVector = extractby(algfun,imOriginal,params);
	extractedImages = setfield(extractedImages,{ uint16(iCounter)},'hashOriginal',hashVector);
	clear hashVector;
	
	imAttacked = testImages(i).imAttacked;
	% 取得在 includeAttacks 中指定的攻击方法法的index
	% 因为每张图片的处理方式都是一样的。
	[tBe, indexInclude, indexImAttacked] = intersect(includeAttacks, {imAttacked.attMethod});
% 	if isempty(attBe);
% 		error('没有指定有效的攻击方式');
% 	end
	jCounter = 0;
	for j = sort(indexImAttacked)	
% 		[i j] % print j to show the rate of progress
		jCounter = jCounter + 1;
		hashAttacked = setfield(hashAttacked,{uint16( jCounter )},'attMethod',imAttacked(j).attMethod);
		hashAttacked = setfield(hashAttacked,{uint16( jCounter )},'attStrength',imAttacked(j).attStrength);			
		hashAttacked = setfield(hashAttacked,{uint16( jCounter )},'imagefile',imAttacked(j).imSaved);
		% 使用Cell来保存 hashvector 以适应各种可能的情况
		hashVector = cell(length(imAttacked(j).attStrength),1);
		for k = [1:length(imAttacked(j).attStrength)]
% 			k
			imSaved = fullfile(imdir,cell2mat(imAttacked(j).imSaved{k}));
			hashVector(k,1) = {extractby(algfun,imSaved,params)};
		end
		hashAttacked = setfield(hashAttacked,{uint16( jCounter )},'hashVector',hashVector);
	end
	extractedImages = setfield(extractedImages,{ uint16(iCounter)},'hashAttacked',hashAttacked);
    % 每 n_save 个图片保存一份
    n_save = 50;
    if mod(i,n_save) == 0
        %  保存并且将之前的清0
        % 第几份
        nFinished = floor(i/n_save);
        if ~isempty(customedOutName)
            savemat = fullfile(outdir,['extractBy-',func2str(algfun),'_',customedOutName,'_',num2str(nFinished)]);
        else
            savemat = fullfile(outdir,['extractBy-',func2str(algfun),'_',num2str(nFinished)]);
        end
        if isdir(outdir) ~= 1
            mkdir(outdir);
        end
        if exist(savemat,'file') ~= 0
            movefile(savemat, [savemat, '.bak']);
        end 
        save(savemat,'extractedImages');
        clear('extractedImages');
        extractedImages = struct('imOriginal',{},'extractMethod',{},'hashOriginal',{},'hashAttacked',struct('imagefile',{},'hashVector',{},'attMethod',{},'attStrength',{}));
        iCounter = 0;
    end        

end % end i
%% Save into a mat file 
% 如果没有被分为多份的话，这就是唯一的一份，或者是最后一份
if ~isempty(extractedImages)
    if ~isempty(customedOutName)
        savemat = fullfile(outdir,['extractBy-',func2str(algfun),'_',customedOutName]);
    else
        savemat = fullfile(outdir,['extractBy-',func2str(algfun)]);
    end
    if isdir(outdir) ~= 1
        mkdir(outdir);
    end
    if exist(savemat,'file') ~= 0
        movefile(savemat, [savemat, '.bak']);
    end 
    save(savemat,'extractedImages');
end
end % end function

%% extract by algfun
function [H] = extractby(fun,imfilename,params)
% 不能将空的params传递进去，否则会导致错误，这里是一个脆弱的设计，但是省了好多事情
	if isempty(params) ~= 1
		H = feval(fun,imfilename,params); 
	else
		H = feval(fun,imfilename); % 
	end
end
