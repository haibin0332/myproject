function [B] = att_blur_disk( imgin, imgout,strength,params )
%att_blur_disk 模糊攻击
%{
攻击5: 模糊
h = fspecial('disk',radius) returns a circular averaging filter (pillbox) within the square matrix of side 2*radius+1.
The default radius is 5.
攻击强度改成窗口大小
%}
if(isempty(imgin) | isempty(imgout) | isempty(strength))
    error('输入参数非法');
end

% %获取原图文件名，因为存的是完整文件名所以这里要进行剖离
% [tpath tfile ext] = fileparts(imgout);
% %存攻击完成的图像名称(全路径)
% imgout = fullfile(tpath,[tfile,'.jpg']);
im = imread(imgin);
f = fspecial('disk',strength);
im = imfilter(im,f,'replicate');

% 这是以前使用模糊次数的方式，不妥
% for i = 1 : strength
%     im = imfilter(im,f,'replicate');
% end
imwrite(im,imgout);
B = 1;
end
