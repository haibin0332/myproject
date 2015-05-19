%% attack with
%{
使用多种方式攻击原始图像
通过目录+文件名来表示攻击方式和强度。
输入路径indir与输出路径outdir一样，但是outdir下会产生多个子目录，目录名称为攻击方式。

每一种攻击产生一个子目录，但是不同强度的图片都在一个子目录之内，这样方便排序观察。
攻击强度的不同通过文件的命名规则可以得到。

选择长宽相等的图，并且将图处理成512*512或256*256灰度图。

基本上所有的攻击都不改变原图大小，
只有
	Scaling
改变了原图大小

参数： 
	attackPlan:		参见 getInputs_mba_attack
%}

function [ savemat ]= mba_attack(attackPlan)
%% test inputs
% getInputs_mba_attack
% generalAttack
indir = attackPlan.indir;
outdir = attackPlan.outdir;
attMethods = attackPlan.attMethods;
testImages = attackPlan.testImages;
%% 判断两种情况，得到相同的运行逻辑起点
if ~isempty(testImages)
	if ischar(testImages)
		load(testImages);
	end
    %处理交集（删除全部信息）
    attExisted = intersect({attMethods.attMethod},{testImages(1).imAttacked.attMethod});
    if ~isempty(attExisted)
        for i = 1 : length(attExisted)
            for j = 1 : length(testImages(1).imAttacked)
                if strcmp(attExisted{i}, testImages(1).imAttacked(j).attMethod)
                    aeIndex = j; %交集中，相应攻击在testImages中的索引
                    break;
                end
            end
            for k = 1 : length(testImages)
                pathExisted = fullfile(outdir,testImages(k).imAttacked(aeIndex).attMethod); 
                delete([pathExisted, '/*']);%删除攻击方法交集的所有原始生成文件
               % rmdir(pathExisted);
                testImages(k).imAttacked(aeIndex) = [];%除去该项
            end
        end
    end
else
%% get inputs
	if isdir(indir) == 1
		infiles = imdir(indir); %ls(indir)
	else
		error('indir isnot exist!');
	end
	if isdir(outdir) ~= 1
		mkdir(outdir);		%确保存在
	end 	

if isdir(outdir) ~= 1
	mkdir(outdir);
end
% 这个代码比较危险 而且根本就删不掉：） 
% if isempty(dir(outdir))
% 	delete *.*;
% end
%% save info in mat file
	structMethod = struct('attMethod',{},'attStrength',{},'imSaved',{}); 
	testImages = struct('imOriginal',{},'imAttacked',struct('attMethod',{},'attStrength',{},'imSaved',{}));
%% Normalize the input images
%{
读入图像，将图像都处理成512*512或256*256灰度图。
%}
	iCounter = 0;
	for i = 1:length(infiles)
		I = imread(fullfile(indir, infiles(i).name));
		[M,N,K] = size(I);
		if M ~= N
			continue;
		end
		if M > 512
			I = imresize(I,[512 512],'bicubic');
		end
		if M < 512 && M > 256
			I = imresize(I,[256 256],'bicubic');
		end
		if M < 256
			continue;
		end
% 		保证是8bit灰度图
		if isgray(I) ~= 1 && isrgb(I) == 1
			I = rgb2gray(I);
		elseif isgray(I) ==1
		else
			continue;
		end
		%% 保存原始图像，但是格式经过了归一化

		if isdir(fullfile(outdir, 'OriginalImage')) ~= 1
			mkdir(fullfile(outdir, 'OriginalImage'));
		end
		[tpath, tfile, ext] = fileparts(infiles(i).name(1:length(infiles(i).name)));
		outfile = fullfile(outdir, 'OriginalImage', [tfile, '.bmp']);
		imwrite(I,outfile);

		iCounter = iCounter + 1;	
		testImages = setfield(testImages, { uint16(iCounter) },'imOriginal',['OriginalImage/',tfile,'.bmp']);
	end % end for for i = 1:length(infiles);
end % end for if isempty(testImages)

%% 循环处理所有的攻击
% 所有的攻击都是针对归一化之后的图像进行处理
for r = 1:length(testImages) % 每一张图片
	imgin = fullfile(outdir,testImages(r).imOriginal)
	for c = 1:length(attMethods)
        [r c]
        toutdir = fullfile(outdir, attMethods(c).attMethod);
        if ~isdir(toutdir)
            mkdir(toutdir);
        end
        structMethod(c).attMethod = attMethods(c).attMethod;
        structMethod(c).attShortName = attMethods(c).shortName;
		for k = 1:length(attMethods(c).strength) 
			%{ 
				这里关系到攻击函数的设计：
				每一个攻击函数都希望能够用到普通的情况，关注的是功能
				这里关心的是逻辑，对于testImages来说，逻辑就是 testImages = struct('imOriginal',{},'imAttacked',struct('attMethod',{},'attStrength',{},'imSaved',{}));
				因此，攻击函数设计为：输入参数为：imgin, imgout,strength,params 输出为bool，这个bool在今后更为完善的设计中，可以表示失效的 testImages 文件。
			%}
            [tpath, tfile] = fileparts(testImages(r).imOriginal);
			fun = attMethods(c).attFunction;
			if strcmp(attMethods(c).attMethod, 'JPEG')
				imgout = fullfile(toutdir, [tfile,'-', attMethods(c).shortName, '-',num2str(attMethods(c).strength(k)),'.jpg']);
			else
				imgout = fullfile(toutdir, [tfile,'-', attMethods(c).shortName, '-',num2str(attMethods(c).strength(k)),'.bmp']);
			end
			strength = attMethods(c).strength(k);
			params = attMethods(c).params;
			B = feval(fun,imgin,imgout,strength,params); 
%             B = 1;
			switch B  %失败：-1；成功：正数(1:扩展名为bmp； 2：扩展名为jpg；3：根据情况具体设置......)
                case 0
                    error(['Stop at:',attMethods(c).shortName, num2str(attMethods(c).strength(k))]);
                case 1
					structMethod(c).attStrength(k) = attMethods(c).strength(k);
					[tpath, tfile, ext] = fileparts(imgout);	% 产生相对路径
					imgout = fullfile(attMethods(c).attMethod,[tfile, ext]);
					structMethod(c).imSaved{k} = {imgout};  
				otherwise
                    error('错误的返回类型！');
			end       
		end % end for k
	end % end for c
    testImages(r).imAttacked = [testImages(r).imAttacked,structMethod];
end % end for r 

%% Save into a mat file
savemat = fullfile(outdir,'testImages');
save(savemat,'testImages');

end % end function

%%
function [Ls] = imdir(indir)
infiles = dir(indir);
iCounter = 1;
for i = 1:length(infiles)
	[pathstr, name, ext] = fileparts(infiles(i).name);
	if (strcmpi(ext,'.bmp') | strcmpi(ext,'.jpg') | strcmpi(ext,'.tiff') | strcmpi(ext,'.ppm') | strcmpi(ext,'.tif')) == 1
		if infiles(i).isdir == 0
			Ls(iCounter) = infiles(i);
			iCounter = iCounter + 1;
		end 
	end
end
end % end function