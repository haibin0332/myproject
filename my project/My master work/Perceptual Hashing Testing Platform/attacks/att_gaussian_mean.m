function [B] = att_gaussian_mean( imgin, imgout,strength,params )
%att_gaussian_mean ��˹����
%{
����2\3����˹����
h = fspecial('gaussian',hsize,sigma) returns a rotationally symmetric Gaussian lowpass filter of size hsize with 
standard deviation sigma (positive). hsize can be a vector specifying the number of rows and columns in h,
or it can be a scalar, in which case h is a square matrix. The default value for hsize is [3 3]; the default value for sigma is 0.5.
��˹������size��3*3 ��standard deviation sigma: 0.5

����ʵ�ַ�ʽ��
    f = fspecial('gaussian',[3 3],0.5);
    Ig = imfilter(I,f,'replicate');
or
    Ig = filter2(f,I);
and or
    Ig = imnoise(I,'gaussian',m,v)  adds Gaussian white noise of mean m and variance v to the image I. The default is zero mean noise with 0.01 variance.

������
ʹ��imnoise����������Ϊ��ֵ�ͷ����ֵ������������ֱ����������������������ķ��ȡ�
����ֱ�����ֵ�ͷ��ȡֵ��Χ�ǣ�
Depending on type, you can specify additional  parameters to imnoise. All numerical parameters are normalized; they
correspond to operations with images with intensities ranging from 0 to 1
%}
if(isempty(imgin) | isempty(imgout) | isempty(strength))
    error('��������Ƿ�');
end

% %��ȡԭͼ�ļ�������Ϊ����������ļ�����������Ҫ��������
% [tpath tfile ext] = fileparts(imgout);
% %�湥����ɵ�ͼ������(ȫ·��)
% imgout = fullfile(tpath,[tfile,'.jpg']);
% %Jpegѹ��

im = imread(imgin);
Ig = imnoise(im,'gaussian',0,strength);
imwrite(Ig,imgout);
B=1;
end
