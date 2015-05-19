function [B] = att_histeq( imgin, imgout,strength,params )
%att_histeq 直方图均衡化攻击
%{
攻击6: Histogram Equalization
histeq enhances the contrast of images by transforming the values in an intensity image, or the values in the colormap of an indexed
image, so that the histogram of the output image approximately matches a specified histogram.
J = histeq(I);
imshow(I)
figure, imshow(J)
figure; imhist(I,64)
直方图均衡化有两种可以调节的参数，一种是预先指定的直方图模式。一种是n值。
其中n值表示表示均衡化之后，灰度值离散的等级（即灰度等级个数）。取值范围2-256，当为2时，表示二值化。n值越大，直方图与原图差别越小。

但是从攻击的角度来说，灰度的分布和灰度取值在每一个像素上都发生了变化。
%}  
if(isempty(imgin) | isempty(imgout) | isempty(strength))
    B = -1;
    error('输入参数非法');
end

% %获取原图文件名，因为存的是完整文件名所以这里要进行剖离
% [tpath tfile ext] = fileparts(imgout);
% %存攻击完成的图像名称(全路径)
% imgout = fullfile(tpath,[tfile,'.jpg']);
im = imread(imgin);
im = histeq(im,strength);
imwrite(im,imgout);
B=1;
end
