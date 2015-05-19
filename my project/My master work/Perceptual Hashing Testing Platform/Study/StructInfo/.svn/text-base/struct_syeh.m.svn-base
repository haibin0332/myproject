function [hashvector] = struct_syeh(imagefile,param)
%{
随机选块，原图均值，二值差分序列，汉明距：这就是最初的 mbe_zh_rdd 的 method 1
    目的： 确定最小尺寸
尺寸包括三个元素：numrects，ratio1，ratio2
%}
%% test inputs
% imagefile = '1.bmp';
%% param
I = imread(imagefile);
numrects = 16;  
key = 101;
numdiffTimes = 4;
rand('state',key);
%% 随机分块，原图均值
blocksInfo = randomBlockInfo(I,numrects,key,1/4,1/8,'',@avgblock);
%% 差分序列
diffvector = multiTimesDiff(blocksInfo,numdiffTimes);
%% 二值化
hashvector = zeros(size(diffvector));
hashvector = diffvector >= 0;
end % end function
%{
test 1:
 256 1/16 1/32
test 2:
 64 1/8 1/16
    比较Test 1 2，可以看出，虽然Test 2的点选得少了，但是性能下降很小，而且通过EER确定的阈值基本上也一样
test 3：
 32 1/4 1/8
    test 3, 块数取到32时依然很好
    但是EER阈值有变小的趋势。不知道是什么原因导致的
test 4：
 16 1/4 1/8
test 5:
 8 1/4 1/8
    即使到 8 。 4*8=32bits的hash值，区分性和鲁棒性依然十分好。天哪！！！
    另外，更加清楚的看出numrects越小，EER确定的阈值也越小
test 6:
    此前所有的测试都使用 numdiffTimes = 4;
    此处测试 numdiffTimes = 1 的情况下， numrects最小到多少能够保持较好的性能。
    有意思的事情是，即使bit数小到3，EER依然是相当不错的。所以，这里可以看出，匹配与否是一个概率事件。bit数的长短与表达空间的大小并没有必然的联系。
    这和传统密码学的hash表达空间有本质的区别。
    在传统密码学中，hash关心的是碰撞，而PH关心的是碰撞的概率。因此，有一种可能，碰撞的概率总是很小，即使hash很短，或者样本空间很大。
    那么，什么是表达能力强的PH算法？

    这个问题太有意思了。
    
    从信息的熵的角度来看这个问题呢？
%}