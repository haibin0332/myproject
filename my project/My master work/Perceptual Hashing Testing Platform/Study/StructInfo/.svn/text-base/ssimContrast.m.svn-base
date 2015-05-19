%%
%{
这个函数求SSIM意义下的图像的对比度
在SSIM中，亮度其实是某个像素邻近区域的灰度均值，而它作为亮度分量用于计算SSIM index的其实是一个亮度均值序列。

对比度就是每个像素减去均值之后的方差序列

类似的SSIM的对比度和结构都是针对某个像素而言的。
最后的pooling方法就是将他们点乘起来，取均值。

所以，该函数返回 一个和输入一样大小的矩阵

亮度：其实就是方差的低通滤波
%}
function contrastI = ssimContrast(I)
%% test inputs
% img = imread('2.bmp');
% figure;imshow(img);
%% function
window = fspecial('gaussian',11,1.5); % window = ones(8);
window = window/sum(sum(window));
img = double(img);
mu = filter2(window,img,'same');
% figure;imshow(uint8(mu));

mu_sq = mu.*mu;
sigma_sq = filter2(window,img.*img,'same') - mu_sq; 
% 这是参照 ssim_index 的仿真来的，但是和他的文章里的有些不一样
% 按照文章的描述，正确的应该是：
% sigma_sq = filter2(window, (img - mu).*(img - mu),'same');
% 但是比照一下效果，文章的效果不如他仿真的效果好。
constrastI = sqrt(sigma_sq);

% figure;imshow(uint8(constrastI));
end % end function