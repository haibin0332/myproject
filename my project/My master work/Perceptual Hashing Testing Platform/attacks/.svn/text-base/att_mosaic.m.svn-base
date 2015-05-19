function [B] = att_mosaic(imgin, imgout,strength,params )
%% att_mosaic 马赛克

%{
攻击12: 马赛克
	对于图像的马赛克攻击，原理很简单，就是将一幅图像中的像素按照一定的大小的模板与相邻的像素一起取平均，再将这个值赋给模板的每一个像素，它模板大小的不同，对图像的攻击
也是强度不同的。
%}
if(isempty(imgin) | isempty(imgout) | isempty(strength))
    error('输入参数非法');
end
%% 获取原图文件名，因为存的是完整文件名所以这里要进行剖离
% [tpath tfile ext] = fileparts(imgout);
% %存攻击完成的图像名称(全路径)
% imgout = fullfile(tpath,[tfile,'.jpg']);
im = imread(imgin);
[M,N]=size(im);
lg = im2double(im);
for row=1:strength:M
	for col=1:strength:N
		lg(row:min(row+strength-1,M),col:min(col+strength-1,N))=mean2(lg(row:min(row+strength-1,M),col:min(col+strength-1,N)));
	end
end
imwrite(lg,imgout);   %这个写入过程会自动 * 255，转化为uint8类型的灰度图，也会损失信息。
B=1;
end