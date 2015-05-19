function [B] = att_blur_core(imgin, imgout,strength,params)
%% 模糊核攻击
%{
攻击11: 模糊核
	这种模糊攻击对于图像是渐变的，其核心在于一个二维的卷积，通过一个二维的卷积5*5的模板(模糊核)，通过不同的模糊次数产生不同攻击的图片
    该模糊核为 1/44*[1 1 2 1 1;1 2 2 2 1;2 2 8 2 2;1 2 2 2 1;1 1 2 1 1],它对图像的破坏性随模糊次数线性增加的。

%}
%% check 
if(isempty(imgin) | isempty(imgout) | isempty(strength))
    error('输入参数非法');
end

% %获取原图文件名，因为存的是完整文件名所以这里要进行剖离
% [tpath tfile ext] = fileparts(imgout);
% %存攻击完成的图像名称(全路径)
% imgout = fullfile(tpath,[tfile,'.jpg']);
%% do
im = imread(imgin);

im = im2double(imgin); % 不能改变I，因为在后面I还有用
blur=1/44*[1 1 2 1 1;1 2 2 2 1;2 2 8 2 2;1 2 2 2 1;1 1 2 1 1];

for i = 1 : strength
	im = imfilter(im,blur,'replicate','same','corr');	% 这里使用相关或者卷积是一样的，因为mask是对称的
end
imwrite(im,outfile);   %这个写入过程会自动 * 255，转化为uint8类型的灰度图，也会损失信息。
	
end