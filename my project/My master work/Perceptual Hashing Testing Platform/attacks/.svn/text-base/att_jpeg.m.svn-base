%进行Jpeg压缩攻击
function [B] = att_jpeg(imgin, imgout,strength,params)
%{
攻击1：JPEG压缩
JPEG压缩，Quality从0到100。
'Quality'   A number between 0 and 100; higher numbers mean higher quality (less image degradation due to compression), but the resulting file size is larger.
'Bitdepth'  A scalar value indicating desired bitdepth; for grayscale images this can be 8, 12, or 16; for color images this can be 8 or 12. 
%}
if(isempty(imgin) | isempty(imgout) | isempty(strength))
    error('输入参数非法');
end

%获取原图文件名，因为存的是完整文件名所以这里要进行剖离
[tpath tfile ext] = fileparts(imgout);
%存攻击完成的图像名称(全路径)
imgout = fullfile(tpath,[tfile,'.jpg']);
%Jpeg压缩
im = imread(imgin);
imwrite(im,imgout,'Bitdepth',8,'Quality',strength);
B = 1;
end
                


