%{
	源自《信息隐藏技术实验教程》第八章
	基于csf_pqs的加权信噪比 WSNR Weighted Signal to Noise Ratio
use:
	csf_pqs.m
%} 
function wsnrvalue = Qa_WSNR(original, test)
%% test inputs
% original =  '7-NormalizedOriginalImage-.bmp';
% test = '7-jpg-20.jpg';

%% function
% 读取图像并处理到亮度关系 
A = imread(original);
if isgray(A) ~= 1 && isrgb(A) == 1
	I = rgb2gray(A);
elseif isgray(A) ==1
end
A = double(A);
B = imread(test);
if isgray(B) ~= 1 && isrgb(B) == 1
	I = rgb2gray(B);
elseif isgray(B) ==1
end
B = double(B);
% 检查Size
[m,n] = size(A);
[m2,n2] = size(B);
if m2~=m || n2~=n
	error('图像大小不一');
end 
if A == B
	error('图像完全一样，还要我干什么？玩我呢？');
end
% 计算失真度
e = A - B;
% CSF 滤波 
filtercoefficients = csf_pqs;
result = filter2(filtercoefficients, e);
% 计算信噪比
result2 = result^2;
wsnrvalue = 10*log10((255^2)/(mean(result2(:))));
disp(['待测图像的WNSR为: ', num2str(wsnrvalue), ' dB']);
% 待测图像的WNSR为: 52.0113+13.6438idB ？？ 为什么会产生复数呢 ？？
