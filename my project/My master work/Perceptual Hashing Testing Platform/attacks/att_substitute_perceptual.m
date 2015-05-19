function [B] = att_substitute_perceptual( imgin, imgout,strength,params )
%% test inputs
% imgin = 'E:\DoctorThesis\MBench\outdir\imDatabase\OriginalImage\baby.bmp';
% imgout = 'E:\xx';
% strength = 500/3969;
%% 使用小的随机的感知单元进行替换
%{
使用另一个图像的一部分来替换目标图像的相应部分
Strength： 表示替换所使用的感知单元的个数占所有感知单元的比例 0-1表示 1- 3969
感知单元在512*512的图中，是16*16的小框，其中有32*32个为最初的，31*31个为overlap的，
参考 Confusion/diffusion capabilities of some robust hash functions -- Baris Coskun 2006 的方式
要求：用于替换的图是随机选择的，替换的位置是随机选择的
设计：
1、用于替换的图像使用同路径的其它图像，如果同路径没有其它图像使用Matlab内置的图像
2、随机性，因为基于seed的随机性是需要seed不同的，所以，要么每次随机使用不同的seed，要么使用别的随机方法

额外设计：记录感知单元的分布情况，便于在后面语义单元进行度量的时候产生语义单元的攻击强度
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
% 根据strength在替换图中随机选择块
pbnumbers = ceil(strength * 3969);
randomBlocks = randperm(3969);
pbselected = randomBlocks(1:pbnumbers);
% 只需要保存文件名和pbselected就可以恢复攻击置换的所有信息
[outpath outfile ext] = fileparts(imgout);
save(fullfile(outpath,[outfile,'.mat']),'outfile','pbselected');
% 以pbselected为序号产生mask。
% 首先是顶点坐标
maskSB = zeros(szI);
for i = 1:length(pbselected)
    cc = ceil(pbselected(i)/(32+31));
    ll = mod(pbselected(i),(32+31));
    if ll == 0
        ll = 63;
    end
    % 这一段比较费思量，想象一下，(32+31)^2=3969并不等于32^2+31^2=1985，想象一下这个重叠的方式：）
    if cc <= 32 
        c = (cc - 1) * 16 + 1;
    else
        c = 8 + (cc - 32 - 1) * 16 + 1;
    end
    if ll <= 32
        l = (ll - 1) * 16 + 1;
    else
        l = 8 + (ll - 32 - 1) * 16 + 1;        
    end
    maskSB(c:c + 15,l:l + 15) = 1;
end    
% 替换
im(maskSB == 1) = sm(maskSB == 1);
% imshow(im);figure;imshow(sm);figure;imshow(maskSB);
%% 存攻击完成的图像名称(全路径)
imwrite(im,imgout);
B=1;
end
