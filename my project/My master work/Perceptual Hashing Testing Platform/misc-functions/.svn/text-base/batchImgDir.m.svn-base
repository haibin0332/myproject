%% 批处理一个目录中所有的图片
function batchImgDir(indir,outdir,fun)
%% test inputs
%
indir = 'E:\MBench\indir\imageOrig';
outdir = 'E:\MBench\indir\grayImageOrig';
fun = @resizeAndGray
%}
%% function
infiles = imdir(indir);
for i = 1:length(infiles)
    i
    I = imread(fullfile(indir,infiles(i).name));
    feval(fun,outdir,infiles(i).name,I); %
end
why
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

%%
function resizeAndGray(outdir,infilename,img)
I = imresize(img,[512 512],'bicubic');
I = rgb2gray(I);
imwrite(I,fullfile(outdir,infilename));
end % end function