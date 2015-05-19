%{
演示直方图均衡化的原理，来源是冈萨雷斯的图像处理
原理简单来说就是：
    cumsum原图的每一个灰度级，得到灰度级的分布函数
    用分布函数的值替换原图相应灰度级的像素值
    注意归一化
%}
function II = zhHisteq(I)
%% test Inputs
% I = imread('1.bmp');
I = '1.bmp';
%%
if ischar(I)
    I = imread(I);
end
p = zeros(1,256);
for i = 0:255
    p(i+1) = sum(sum(I == i)); % 求每个灰度级上像素点的个数
end
% 观察
% figure;imhist(I);
% figure;plot(p, 'DisplayName', '原图直方图', 'YDataSource', 'p'); 
% figure;imhist(histeq(I));

II = zeros(size(I));

% 计算新的灰度级
g1 = cumsum(p)/(size(I,1) * size(I,2));
g1 = fix((g1-min(g1)) * 255);

% 置换原图
for i = 0:255
    II(I == i) = g1(i+1);
end
II = uint8(II);
% 观察
% figure;imhist(II);
