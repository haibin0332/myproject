function [B] = att_gaussian_mean( imgin, imgout,strength,params )
%att_gaussian_mean 高斯攻击
%{
攻击2\3：高斯噪声
h = fspecial('gaussian',hsize,sigma) returns a rotationally symmetric Gaussian lowpass filter of size hsize with 
standard deviation sigma (positive). hsize can be a vector specifying the number of rows and columns in h,
or it can be a scalar, in which case h is a square matrix. The default value for hsize is [3 3]; the default value for sigma is 0.5.
高斯噪声，size：3*3 ，standard deviation sigma: 0.5

几种实现方式：
    f = fspecial('gaussian',[3 3],0.5);
    Ig = imfilter(I,f,'replicate');
or
    Ig = filter2(f,I);
and or
    Ig = imnoise(I,'gaussian',m,v)  adds Gaussian white noise of mean m and variance v to the image I. The default is zero mean noise with 0.01 variance.

参数：
使用imnoise方法，参数为均值和方差，均值表达的是噪声的直流分量，方差表达的是噪声的幅度。
下面分别调解均值和方差，取值范围是：
Depending on type, you can specify additional  parameters to imnoise. All numerical parameters are normalized; they
correspond to operations with images with intensities ranging from 0 to 1
%}
if(isempty(imgin) | isempty(imgout) | isempty(strength))
    error('输入参数非法');
end

% %获取原图文件名，因为存的是完整文件名所以这里要进行剖离
% [tpath tfile ext] = fileparts(imgout);
% %存攻击完成的图像名称(全路径)
% imgout = fullfile(tpath,[tfile,'.jpg']);
% %Jpeg压缩

im = imread(imgin);
Ig = imnoise(im,'gaussian',0,strength);
imwrite(Ig,imgout);
B=1;
end
