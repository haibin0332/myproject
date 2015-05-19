function [B] = att_scaling( imgin, imgout,strength,params )
%att_scaling Scaling攻击
%{
攻击9: Scaling	图像大小会发生变化
  B = imresize(A, scale) returns image B that is scale times the size of A. The input image
 A can be a grayscale, RGB, or binary image. If scale is between 0 and 1.0, B is smaller than A.
 If scale is greater than 1.0, B is larger than A.
     
	取值 1.2 - 4 step .1
%}
if(isempty(imgin) | isempty(imgout) | isempty(strength))
    error('输入参数非法');
end

% %获取原图文件名，因为存的是完整文件名所以这里要进行剖离
% [tpath tfile ext] = fileparts(imgout);
% %存攻击完成的图像名称(全路径)
% imgout = fullfile(tpath,[tfile,'.jpg']);
im = imread(imgin);
Ig = imresize(im,strength,'bicubic');
imwrite(Ig,imgout);	
B=1;
end
