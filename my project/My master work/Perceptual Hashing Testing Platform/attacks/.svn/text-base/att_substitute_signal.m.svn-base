function [B] = att_substitute_signal( imgin, imgout,strength,params )
%% test inputs
% imgin = 'E:\MBench\outdir\imDatabase\OriginalImage\baby.bmp';
% imgout = 'E:\MBench\';
% strength = 60/512;
%% 使用一个单独的块进行替换
%{
使用另一个图像的一部分来替换目标图像的相应部分
Strength： 表示替换部分占原图总面积的比例
要求：用于替换的图是随机选择的，替换的位置是随机选择的
设计：
1、用于替换的图像使用同路径的其它图像，如果同路径没有其它图像使用Matlab内置的图像
2、随机性，因为基于seed的随机性是需要seed不同的，所以，要么每次随机使用不同的seed，要么使用别的随机方法
3、模糊边界，以削弱明显边界带来的剧烈变化
%}  
if(isempty(imgin) | isempty(imgout) | isempty(strength))
    B = -1;
    error('输入参数非法');
end
%%
% 获取原图文件路径
[tpath tfile ext] = fileparts(imgin);
% 随机选择另外一个文件
ls = dir(fullfile(tpath,['*',ext]));
indexImgin = find(strcmp([tfile,ext],{ls.name}) == 1);
indexsImg = ceil((length(ls) - 1)*rand(1));
if indexsImg(1) == indexImgin % 如果Imgin是最后一个，那么不可能相等，如果不是最后一个，就可以加1
    indexsImg = indexImgin(1) + 1;
end
sImg = ls(indexsImg).name;
% 读入
im = imread(imgin);
sm = imread(fullfile(tpath,sImg));
% 检查大小，不做了，因为目前的框架下都应该相等
%% 产生模板，只需要考虑位置的随机，但是位置受到大小的限制
szI = size(sm);
szSB = floor(szI .* strength);
% 随机的方法，减掉那么多位置之后，随机取个顶点
point = ceil((szI - szSB) .* rand(1,2));
maskSB = zeros(szI);
maskSB(point(1):point(1) + szSB(1),point(2):point(2) + szSB(2)) = 1;
% 替换
im(maskSB == 1) = sm(maskSB == 1);
% 模糊的边界
if min(szSB) >= 12 % 太小的做这个替换意思不大
    for i = 10:-2:2 % 试图达到一个逐级模糊的效果
        maskBlur = zeros(szI);
        blurDegree = i; % 边界左右10个像素都参与模糊
        if ~(point(1) - 10 <= 1 || point(2) - 10 <= 1 || point(1) + szSB(1) + 10 >= szI(1) || point(2) + szSB(2) + 10 >= szI(2))
            maskBlur(point(1) - blurDegree:point(1) + blurDegree,point(2):point(2) + szSB(2)) = 1;
            maskBlur(point(1) + szSB(1) - blurDegree:point(1) + szSB(1) + blurDegree,point(2):point(2) + szSB(2)) = 1;
            maskBlur(point(1):point(1) + szSB(1),point(2) - blurDegree:point(2) + blurDegree) = 1;
            maskBlur(point(1):point(1) + szSB(1),point(2) + szSB(2) - blurDegree:point(2) + szSB(2) +blurDegree) = 1;
        end
        % imshow(im);
        % 模糊边缘
        bm = zeros(szI);
        bm(maskBlur == 1) = im(maskBlur == 1);
        % 模糊
        f = fspecial('disk',3);
        % for i = 1:4
            bm(maskBlur == 1) = imfilter(bm(maskBlur == 1),f,'replicate');
            bm(maskBlur == 1) = imfilter(bm(maskBlur == 1),f,'replicate');
        % end
    end

    im(maskBlur == 1) = uint8(bm(maskBlur == 1));
end
%  imshow(im);
%% 存攻击完成的图像名称(全路径)
imwrite(im,imgout);
B=1;
end
