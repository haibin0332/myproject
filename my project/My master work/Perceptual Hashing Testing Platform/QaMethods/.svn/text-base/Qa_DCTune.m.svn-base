%% 用于计算DCTune
%{
uses：
	.\dctune2.0\dctune2.0.exe
%}
%% function
function [dctune] = Qa_DCTune(A,B)
% test input
% A = '.\dctune2.0\pic1.ppm';
% B = '.\dctune2.0\pic2.ppm';
% 如果是文件名，读入图像，如果不是文件名，直接处理
if ischar(A)
    A=imread(A);
end;
if ischar(B)
    B=imread(B);
end;
% 检查大小
if size(A,1) ~= size(B,1) || size(A,2) ~= size(B,2)
	% Dimensions of reference and test images must be the same
	dctune = -inf;
	return;
end
where=[fileparts(which(mfilename)) '\dctune2.0'];
imwrite(A,[where,'\pic1.ppm']);
imwrite(B,[where,'\pic2.ppm']);
command = '.\dctune2.0\dctune2.0.exe -error .\dctune2.0\pic1.ppm .\dctune2.0\pic2.ppm';
[s,w] = dos(command);
if s ~= 1
	dctune = -inf;
	return;
else
	if ~ischar(w)
		dctune = -inf;
		return;
	end
	[s, f] = regexp(w,'Perceptual Error: ');
	if ~isempty([s,f])
		numStr = w(f:length(w));
		dctune = str2double(numStr);
		return;
	else
		dctune = -inf;
		return;
	end
end
end % end for function

% whos w
%   Name      Size             Bytes  Class    Attributes
% 
%   w         1x228              456  char    
