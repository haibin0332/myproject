%{
修改自zh_rdd的method 8
匹配算法
    match_zh_tamperdetect1.m
%}
function [hashvector] = mbe_zh_tamperdetect1(imagefile,param)
%% test: input
%   imagefile = '1.bmp'; % 'F:\imDatabase\TestImages\Substitute with Signal Block\lena-SubSignal-0.2.bmp', % 
%   nargin = 1;
%% check input
if nargin == 1
	numrects = 256; % 随机分块的个数
    numdiffTimesGlobal = 4; % 每个大块差分的次数，
    numdiffTimesLocal = 1;
    numLocal = 3;       % method 1 时，小块取 3 或则 4其实在EER曲线上没有什么区别，只不过4更加光滑一些
    method = 3;
else
	numrects = param{1}; 
    numdiffTimesGlobal = param{2}; 
    numdiffTimesLocal = param{3};
    numLocal = param{4};
    method = param{5};
end

ratio = 1/16; % 用于测试  

key = 101;
rand('state',key);
    
I = imread(imagefile);
dim = size(I);
if length(dim) > 2 % 不是灰度图 
	I = rgb2gray(I);
end
%% 各种方法
if method == 1 
    %% method 1 随机选大块 规则选小块
    method = 1;
    hashvector = robustHashWithTamperDetect(I,key,numrects,numdiffTimesLocal,numdiffTimesGlobal,numLocal,method);
elseif method == 2
    %% method 2 规则选大块 规则选小块
    
elseif method == 3
    %% method 2 随机选大块 奇异选小块
    method = 2;
    hashvector = robustHashWithTamperDetect(I,key,numrects,numdiffTimesLocal,numdiffTimesGlobal,numLocal,method);
elseif method == 4
    %% method 2 规则选大块 奇异选小块
    
elseif method == 5
    %% method 5 用于测试小块的性能
    % 产生一个随机的小块，调节大小，观察他们的性能
    % 顶点坐标
    xo = 60;
    yo = 60;
    % 测试小块尺度
%     ratio = 1/16;
    xz = round(ratio*512);
    yz = round(ratio*512);
    ILocal = I(xo : xo + xz - 1,yo : yo + yz - 1);
    hashvector = localhashForTamperDetect(ILocal,numLocal,numdiffTimesLocal); %
elseif method ==6
    %% method 6 用于测试在小块内，奇异分块的性能 
    % 顶点坐标
    xo = 60;
    yo = 190;
    % 测试小块尺度
%     ratio = 1/16;
    xz = round(ratio*512);
    yz = round(ratio*512);
    ILocal = I(xo : xo + xz - 1,yo : yo + yz - 1);
    hashvector = oddityBlocking(ILocal); %
end
end %　end function

function hashvector = robustHashWithTamperDetect(I,key,numrects,numdiffTimesLocal,numdiffTimesGlobal,numLocal,method)
%% hashvector = robustHashWithTamperDetect(I,key,numrects)
    %{
    使用两级编码：
    第一级使用随机分块，差分编码。第二级使用规则分块，置乱差分编码。
    第一级鲁棒哈希，第二级在第一级的基础上精确定位tamper的位置，并确认tamper。应该说，第二级也是鲁棒哈希，但是因为它本身关注的是细节，所以避免了小块替换对整体影响不大的问题。
    %}
    %% 参数设定
%     numLocal = 3; % numLocal * numLocal 是在大块中划分的小块的个数。
    ratio1 = 1/16; ratio2 = 1/32; % 大块占原图的相对大小，最小为1/16，最大为1/32
%     numdiffTimesLocal = 1;
%     numdiffTimesGlobal = numdiffTimes;
    %% 大块的位置
    xsz = size(I,1);    % 行的大小
    ysz = size(I,2);    % 列的大小
    minlength1 = round(ratio2*xsz); % 这是随机块的最小直径
    maxlength1 = round(ratio1*xsz);	% 这是随机块的直径的变化范围
    minlength2 = round(ratio2*ysz); % 这是随机块的最小直径
    maxlength2 = round(ratio1*ysz);	% 这是随机块的直径的变化范围

    rand('state',key); % 设置产生随机数的方法和种子
    rectlengths1 = ceil(rand(numrects,1)*(maxlength1))  + minlength1; % [minlength,minlength + maxlength]
    rectlengths2 = ceil(rand(numrects,1)*(maxlength2))  + minlength2;
    rectcoors = ceil(rand(numrects,2).*[ xsz-rectlengths1+1 ysz-rectlengths2+1]); % 这里是起点坐标，左上角的点
    % 用一段代码来显示产生的随机分块
    %{
    tI = zeros(size(I));
    for i = 1:numrects
        I(rectcoors(i,1),rectcoors(i,2):rectcoors(i,2)+rectlengths2(i) - 1) = 256;
        I(rectcoors(i,1):rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2)) = 256;
        I(rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2):rectcoors(i,2)+rectlengths2(i) - 1) = 256;
        I(rectcoors(i,1):rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2)+rectlengths2(i) - 1) = 256;
    end
    figure;
    imshow(I);
    %}
    %% 大块的均值
    meanBlocks = zeros(1,numrects);
    if method == 1
        localhash = zeros(numrects,numdiffTimesLocal * numLocal * numLocal);
    elseif method == 2
        localhash = zeros(numrects,7);
    end
    for i = 1:numrects
        T = zeros(size(I));
        T(rectcoors(i,1):rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2):rectcoors(i,2)+rectlengths2(i) - 1) = 1;
        meanBlocks(i) = sum(sum(I(T == 1)))/sum(sum(T));
        %% 在处理每一个大块的同时， 处理大块自己的local哈希
        Il = I(rectcoors(i,1):rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2):rectcoors(i,2)+rectlengths2(i) - 1);
        if method == 1
            localhash(i,:) = localhashForTamperDetect(Il,numLocal,numdiffTimesLocal); % 每一行对应一块
        elseif method == 2
            localhash(i,:) = oddityBlocking(Il); % 每一行对应一块
        end
        clear Tl;
        %   figure;imshow(T);
    end    
    %% 基于大块得到的差分编码
    iA = [1:numrects];
    globalhash = zeros(1,numrects * numdiffTimesGlobal);
    for i = 1:numdiffTimesGlobal
        for j = 1:numrects
            if i + j <= numrects
                iB(j) = iA(i+j);
            else
                iB(j) = iA(mod(j + i,numrects));
            end
        end
        % 差分
        globalhash((i-1)*numrects+1:(i*numrects)) = meanBlocks(iA) >= meanBlocks(iB);
    end
    %% 最后得到组合的hash编码,是个结构，因为可能不整齐。
    hashvector.globalhash = globalhash;
    hashvector.localhash = localhash;
end % end function
%% 规则分块置乱差分
function localhash = localhashForTamperDetect(Il,numLocal,numdiffTimesLocal)
%% localhash = localhashForTamperDetect(Il,numLocal,numdiffTimesLocal)
n = numLocal;
I = Il;
% 这里的切分方法会忽略一些没有办法整除的边界
if fix(size(I,1)/n) == size(I,1)/n
	r = fix(size(I,1)/n);%比如282，分282/16 = 17.6，如果直接使用17，会产生多余的边，进一步就会因为blkproc的原因导致分块变大。
else
	r = fix(size(I,1)/n) + 1;
end
if fix(size(I,2)/n) == size(I,2)/n
	c = fix(size(I,2)/n);
else
	c = fix(size(I,2)/n) + 1;
end

r_d4 = fix(r/4);
c_d4 = fix(r/4);
fun_avg = @avgblock;	% 对块求平均
% fun_median = @medianblock;
% B = blkproc(I,[r,c],fun_avg); % 分块处理
B = blkproc(I,[r,c],[r_d4,c_d4],fun_avg); % overlap 处理

numrects = length(B(:));
% 置乱一下，基本上这个做完就知道差分的方法要块大还是块小了
% 为了保证randperm每次都按一样的顺序排序，只需要在调用前加上：
% rand('state',101); % 这个这里不需要，因为在主函数中已经用过了。
hashtp = zeros(1,numrects);
for i = 1:numdiffTimesLocal
    index1 = randperm(numrects);
    hashtp = B(1:numrects) >= B(index1);
    if i == 1
        hashvector = hashtp;
    else
        hashvector = [hashvector,hashtp];
    end
end
localhash = hashvector;
end % function
%% 奇异分块的差分
function localhash = oddityBlocking(ILocal)
%% localhash = oddityBlocking(ILocal,numLocal,numdiffTimesLocal)
% n = numLocal;
I = ILocal;
% mask 1 上下左右
% 先求中点
center = fix(size(I)/2);
mask1(1:center(1),1:center(2)) = 1;
mask1(center(1) + 1:size(I,1), 1:center(2)) = 2;
mask1(1:center(1),center(2) + 1 : size(I,2)) = 3;
mask1(center(1) + 1:size(I,1),center(2) + 1 : size(I,2)) = 4;
% mask 2 里外
I1 = drawCircle(I,center(1)+0.5,center(2)+0.5,fix(min(center)/2),1);
I2 = drawCircle(I,center(1)+0.5,center(2)+0.5,fix(min(center)),1);
mask2 = I1 + I2;
% 按照上下，左右，斜对，里外 求得7bits的hash
meanBlocks(1) = sum(ILocal(mask1 == 1))/sum(sum(mask1 == 1));     % 左上
meanBlocks(2) = sum(ILocal(mask1 == 2))/sum(sum(mask1 == 2));     % 左下
meanBlocks(3) = sum(ILocal(mask1 == 3))/sum(sum(mask1 == 3));     % 右上
meanBlocks(4) = sum(ILocal(mask1 == 4))/sum(sum(mask1 == 4));     % 右下
meanBlocks(5) = sum(ILocal(mask2 == 1))/sum(sum(mask2 == 1));     % 外
meanBlocks(6) = sum(ILocal(mask2 == 2))/sum(sum(mask2 == 2));     % 里

localhash(1) = meanBlocks(1) >= meanBlocks(2);
localhash(2) = meanBlocks(3) >= meanBlocks(4);
localhash(3) = meanBlocks(1) >= meanBlocks(3);
localhash(4) = meanBlocks(2) >= meanBlocks(4);
localhash(5) = meanBlocks(1) >= meanBlocks(4);
localhash(6) = meanBlocks(2) >= meanBlocks(3);
localhash(7) = meanBlocks(5) >= meanBlocks(6);

end % end function
