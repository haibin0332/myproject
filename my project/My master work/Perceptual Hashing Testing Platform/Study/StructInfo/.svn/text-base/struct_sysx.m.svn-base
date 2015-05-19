function [hashvector] = struct_sysx(imagefile,param)
%{
随机选块，原图均值，实数差分序列，相关距离
    目的：观察计算相关的性能特征
    匹配方法：SSIM的匹配方式 match_SSIM_lumi()
%}
%% test inputs
% imagefile = '1.bmp';
%% param
I = imread(imagefile);
numrects = 8;  
key = 101;
numdiffTimes = 4;
rand('state',key);
%% 随机分块，原图均值
blocksInfo = randomBlockInfo(I,numrects,key,1/4,1/16,'',@avgblock);
%% 差分序列
hashvector = multiTimesDiff(blocksInfo,numdiffTimes);

end % end function
%{
match_SSIM_struct：
test 1:
    256 1/16 1/32
test 2:
    256 1/4 1/16
test 3:
    8 1/4 1/16
这三个测试揭示的规律与 struct_syeh 类似。即：
块越少精度越低，但是即使到 8 * 4 = 32 bits长度，性能依然很好
块越大EER确定的阈值越低
match_SSIM_lumi：
同上三个测试，性能很好，稍差于Struct的。
match_SSIM_sumlumi：
这个的测试结果很扯蛋。

问题：SSIM中，距离的计算方式到底是什么？该如何理解？


%}