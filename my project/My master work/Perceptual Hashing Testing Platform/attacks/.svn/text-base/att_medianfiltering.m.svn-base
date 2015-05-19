function [B ] = att_medianfiltering( imgin, imgout,strength,params )
%att_medianfiltering 中值滤波
%{
攻击4: 中值滤波
Median filtering is a nonlinear operation often used in image processing
to reduce "salt and pepper" noise. Median filtering is more effective than
convolution when the goal is to simultaneously reduce noise and preserve edges.

B = medfilt2(A) performs median filtering of the matrix A using the default 3-by-3 neighborhood.
强度改成窗口大小，以前用次数不合适
%}
if(isempty(imgin) | isempty(imgout) | isempty(strength))
    error('输入参数非法');
end

% %获取原图文件名，因为存的是完整文件名所以这里要进行剖离
% [tpath tfile ext] = fileparts(imgout);
% %存攻击完成的图像名称(全路径)
% imgout = fullfile(tpath,[tfile,'.jpg']);
im = imread(imgin);
im = medfilt2(im,[strength strength]);
% for i = 1 : strength
%     
% end
    imwrite(im,imgout);
B = 1;
end
