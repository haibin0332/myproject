%%
%{
这个函数求SSIM意义下的图像的亮度
在SSIM中，亮度其实是某个像素邻近区域的灰度均值，而它作为亮度分量用于计算SSIM index的其实是一个亮度均值序列。
类似的SSIM的对比度和结构都是针对某个像素而言的。
最后的pooling方法就是将他们点乘起来，取均值。

所以，该函数返回 一个和输入一样大小的矩阵

亮度：其实就是一个低通滤波
%}
function lumiI = ssimLuminance(I)
%% test inputs
% img = imread('1.bmp');
% figure;imshow(img);
%% function
window = fspecial('gaussian',11,1.5); % window = ones(8);
window = window/sum(sum(window));
img = double(img);
mu = filter2(window,img,'same');
% figure;imshow(uint8(mu));
lumiI = mu;
end % end function