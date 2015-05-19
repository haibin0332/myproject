function [B] = att_rotation_cropping_resize( imgin, imgout,strength,params )
%att_rotation_cropping_resize 旋转攻击 Loose
%{
攻击7/8: Rotation
B = imrotate(A,angle,method,bbox)

{'nearest'}Nearest-neighbor interpolation 
 'bilinear'Bilinear interpolation
'bicubic'Bicubic interpolation

'crop'Make output image B the same size as the input image A, cropping the rotated image to fit 
{'loose'}Make output image B large enough to contain the entire rotated image. B is generally larger than A.
   
这里有两种方式的攻击存在，一种是crop，会产生黑边，一种是loose，会使原图变大。
crop的方式，是纯粹的旋转，但是黑边会影响某些算法，导致算法的评测失真。
loose的方法，会使原图变大，但是依然保留黑边，我们希望的是旋转加放大以消除黑边。
但是如何求得最大的内接正方形是个巨搞的问题。弄不出来，拉倒。
%}
if(isempty(imgin) | isempty(imgout) | isempty(strength))
    error('输入参数非法');
end

% %获取原图文件名，因为存的是完整文件名所以这里要进行剖离
% [tpath tfile ext] = fileparts(imgout);
% %存攻击完成的图像名称(全路径)
% imgout = fullfile(tpath,[tfile,'.jpg']);
im = imread(imgin);
[M M] = size(im);    %原图大小
%内接正方形边长
% 计算角度
theta = (pi/2)*(fix((strength*2*pi/360)/(pi/2))) + (strength*2*pi/360);
N = abs(fix(M/(cos(theta) + sin(theta))));
%旋转yuan图
im = imrotate(im,strength,'bilinear','crop');
%坐标原点
x = fix((M - N)/2) + 1;
im = im(x:M-x,x:M-x);
im = imresize(im,[M,M],'bilinear'); % 确保回到正确的大小，因为fix会产生一两位的偏差
imwrite(im,imgout);
B=1;
end
