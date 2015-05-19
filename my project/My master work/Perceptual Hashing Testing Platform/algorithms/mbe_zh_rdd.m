%{
use：
    H = mbe_bian(imagefile, param) % 为了得到鲁棒的哈希
method 3 需要单独的匹配算法
    match_zh_rdd_method3.m
method 8 的匹配算法
    match_zh_rdd_method8.m
%}
function [hashvector] = mbe_zh_rdd(imagefile,param)
%% test: input
  imagefile = 'E:\PH1\1.bmp'; % 'F:\imDatabase\TestImages\Substitute with Signal Block\lena-SubSignal-0.2.bmp', % 
  nargin = 1;
%% check input
if nargin == 1
	numrects = 256; % 随机分块的个数
    numdiffTimes = 4; % 每个块差分的次数，
    numdiffOrders = 1;% 差分的级数。级数和次数是两个维度上的事情，级数是多级差分，差分基础上的差分；次数是一级差分时，一个块与多个块发生关系。
    n_key = 0; % n_key * n_key 为产生密钥使用的块数 如果为 0 表示使用固定的密钥
    method = 1;
else
	numrects = param{1}; 
    numdiffTimes = param{2}; 
    numdiffOrders = param{3};
    n_key = param{4};
    method = param{5};
end

I = imread(imagefile);
dim = size(I);
if length(dim) > 2 % 不是灰度图 
	I = rgb2gray(I);
end
%% 密钥控制，需要时，使用鲁棒哈希作为密钥
% 事实上，鲁棒哈西作为密钥还是不太可行的。所以这里使用密钥的代码只是在测试一些小想法时用一下。
if n_key == 0 % 使用固定的密钥，去掉鲁棒哈希的一次一密的性能
    key = 101;
else
%    这个分支处理鲁棒哈希来作为密钥来控制后面的随机过程。目前只支持method 1.程序原理上对后面所有的都支持，但是没有什么价值。
    keyvector = regularDiff(I,n_key,1);
    %{
    尝试使用很小的由bian的方法产生的key，其鲁棒性和区分性都赶不上差分的方法，没什么意义。
    最后尝试改成大块差分的方法
    %}
    key = 0; % 转换成一个数字作为key用作后面的输入，将 keyvector 视作二进制的编码
    if length(keyvector) > 28 
        lenkey = 30;
    else
        lenkey = length(keyvector);
    end
    for i = 1:lenkey
        key = key + keyvector(i) * i;
    end
%     key
    %{
    最初使用的方法是：将 keyvector 视作二进制的编码。这个方法不行，第一是太长，导致超出了rand定义的范围，二是没有必要，因为key只需要对相同的图一样
    直接求和也不行，因为这样可能会导致统计效应，即很多图片的key都是一样的。虽然后面差分过程可以解决区分问题，但是……？
    产生标量的key，这个key对相同图必须是一样的，对有变化的图没有必要对变化线性，因为后面的随机过程以这个key为输入，一点点key的不同，会导致完全不同的输出。
    If method is set to 'state' or 'twister', then s must be either a scalar integer value from 0 to 2^32-1 or the output of rand(method). 
    If method is set to 'seed', then s must be either a scalar integer value from 0 to 2^31-2 or the output of rand(method).
    %}
end  
    rand('state',key);
%% 各种方法
if method == 1  % numdiffTimes 有效，简单的二值差分编码，只记录翻转信息
    %% method 1
    % 次数的控制通过循环两个序列来控制，一个序列是原始的，另一个序列由循环左移产生，左移的次数决定了扩散的程度
    meanBlocks = randomBlockMean(I,key,numrects);
    
    iA = [1:numrects];
    hashvector = zeros(1,numrects * numdiffTimes);
    for i = 1:numdiffTimes
        for j = 1:numrects
            if i + j <= numrects
                iB(j) = iA(i+j);
            else
                iB(j) = iA(mod(j + i,numrects));
            end
        end
        % 差分
        hashvector((i-1)*numrects+1:(i*numrects)) = meanBlocks(iA) >= meanBlocks(iB);
    end
elseif method == 2 % numdiffOrders 有效，高阶不分组差分
    %% method 2
    % 对于多级差分的情况，每次都只左移一次
    meanBlocks = randomBlockMean(I,key,numrects);
    
%     hashvector = zeros(1,sum(numrects - numdiffOrders:numrects - 1));
    hashtp1 = meanBlocks;
    for i = 1:numdiffOrders
        iA = [1:length(hashtp1)];
        iB = [2:length(hashtp1),1];
        hashtp2 = hashtp1(iA) - hashtp1(iB);
        hashtp1 = hashtp2;
%         if i == 1
            hashvector = hashtp1;   % 试验表明这种多级差分的意义并不大
%         else
%             hashvector = [hashvector;hashtp1];  % 这个分支试图同时记录多阶，可以观察规律
%         end
        % 观察级数增加时，差分数据的变化规律
%          figure;plot(hashvector, 'DisplayName', 'hashvector', 'YDataSource', 'hashvector');
%          title(['numdiffOrders = ',num2str(i)]);
    end 

    % 量化差分值
    hashvector(hashvector >= 0) = 1;
    hashvector(hashvector < 0) = 0;
elseif method == 3 % numdiffTimes 有效，对差分值做自适应的量化，取4个量化等级，中间两个等级表示没有变化，两端两个等级表示发生了翻转
    %% method 3
    % 编码的方法：直接将量化结果作为编码，匹配时，求差的绝对值。需要专门的匹配函数 match_zh_rdd_method3.m
    meanBlocks = randomBlockMean(I,key,numrects);
    iA = [1:numrects];
    hashvector = zeros(1,numrects * numdiffTimes);
    for i = 1:numdiffTimes
        for j = 1:numrects
            if i + j <= numrects
                iB(j) = iA(i+j);
            else
                iB(j) = iA(mod(j + i,numrects));
            end
        end
        % 差分
        hashvector((i-1)*numrects+1:(i*numrects)) = meanBlocks(iA) - meanBlocks(iB);
    end
    % 量化为4个等级，其中中间两个等级小，两边的大
%     hashvector = Quantize2fourlevels(hashvector,1/4);

elseif method == 4 % 求和，越小的差分占有越重的分量，越大的差分占有越轻的分量 
    %% method 4 
    % sum = 1/(1/x + 1/y)，求和使用的差分值个数越多，每个差分的影响越小，但是影响的范围越大
    meanBlocks = randomBlockMean(I,key,numrects);
    iA = [1:numrects];
    tphash1 = meanBlocks;
    for i = 1:numdiffTimes
        for j = 1:numrects
            if i + j <= numrects
                iB(j) = iA(i+j);
            else
                iB(j) = iA(mod(j + i,numrects));
            end
        end
        % 差分
        tphash1 = meanBlocks(iA) - meanBlocks(iB);
        if i == 1
            tphash2 = tphash1;
        else
            tphash2 = [tphash2;tphash1];
        end            
    end
    beta = 1;
    hashvector = 1./(sum(((1./tphash2)).^beta));   
elseif method == 5 % numdiffOrders 有效，高阶分组差分
    %% method 5
    % 对于多级差分的情况，每次都只左移一次
    % 分组长度暂时固定为 8
    meanBlocks = randomBlockMean(I,key,numrects);
    lenGroup = 8;
    numGroup = numrects/lenGroup;
    hashtp1 = meanBlocks;
    
    for i = 1:numdiffOrders
        for j = 1:numGroup
            tpmb = hashtp1((j-1) * lenGroup + 1 : (j) * lenGroup);
            iA = [1:length(tpmb)];
            iB = [2:length(tpmb),1];
            md1 = tpmb(iA) - tpmb(iB);
            
            if j == 1
                md2 = md1;
            else
                md2 = [md2 md1];
            end
        end
        hashtp1 = md2;
        if i == 1
            hashvector = hashtp1;   % 试验表明这种多级差分的意义并不大
        else
            hashvector = [hashvector;hashtp1];  % 这个分支试图同时记录多阶，可以观察规律
        end
        % 观察级数增加时，差分数据的变化规律
%          figure;plot(hashvector, 'DisplayName', 'hashvector', 'YDataSource', 'hashvector');
%          title(['numdiffOrders = ',num2str(i)]);
    end 

    % 量化差分值
%     hashvector(hashvector >= 0) = 1;
%     hashvector(hashvector < 0) = 0;    
elseif method == 6 % 使用规则分块，然后使用密钥控制的置乱，然后规则块与随机块两个序列求差分，观察与 method 1 的性能差异
    %% method 6
    % [meanBlocks,rectcoors] = regularBlockMean(I,numrects);
    % 直接将meanBlocks置乱，然后用置乱的序列和原序列进行差分
    % 一个38张图的测试证明 method 6 与 1 效果差不多好
    [meanBlocks,rectcoors] = regularBlockMean(I,numrects);
    
    iA = [1:numrects];
%     rand('state',key);
    for i = 1:numdiffTimes % numdiffTimes 这里表示的置乱多少次
    	iB = randperm(numrects);
        tphash = meanBlocks(iA) >= meanBlocks(iB);
        if i == 1
            hashvector = tphash;
        else
            hashvector = [hashvector; tphash];
        end
    end        
elseif method == 7 % 考虑将距离用来编码
    %% method 7
    %{
    将取到的差分进行量化，然后排序，然后看距离，
    小的差分，如果距离很小，表示相邻块，如果距离很大，表示相远块；大的差分，如果距离很小，表示变化大，如果距离很大，表示正常。由此可以产生一个2*2的关系表。
    可以观察：
    1，差分排序之后，距离的分布规律
    2、距离排序之后，差分的分布规律
    如果是均匀的，可以用来编码，如果是有偏的，可以用来揭示规律
    
    这个方法使用固定的分块
    
    在观察距离与差分的关系的基础上：
    距离可以代表一种尺度信息，差分表示在这个尺度下图像的频率（变化）特性。那么，距离如何借鉴小波或者多分辨率分析的思想，提出一种新的图像结构信息的记录方式？
    这件事情稍后再做
    %}
    % [meanBlocks,rectcoors] = regularBlockMean(I,numrects);
    [meanBlocks,rectcoors] = regularBlockMean(I,numrects);
    
    iA = [1:numrects];
    
    iB = randperm(numrects);
    diffvector = abs(meanBlocks(iA) - meanBlocks(iB));
    distvector = sqrt((rectcoors(iA,1) - rectcoors(iB,1)).^2 + (rectcoors(iA,2) - rectcoors(iB,2)).^2 );
    
    [srtF,iF] = sort(diffvector);   % 差分排序
    [srtD,iD] = sort(distvector);   % 距离排序
    srtFD = distvector(iF);         % 差分排序之后的距离
    srtDF = diffvector(iD);         % 距离排序之后的差分
elseif method == 8 % 整体与局部两级编码，局部编码用于定位tamper，需要专门的匹配方法
    %% method 8
    hashvector = robustHashWithTamperDetect(I,key,numrects,numdiffTimes);
end    
end % function

%% 随机分块的均值序列
function [meanBlocks] = randomBlockMean(I,key, numrects)
%% [meanBlocks] = randomBlockMean(I,key, numrects)
% 这个函数在一个任意尺寸的图像矩阵中，随机产生一些块，并取这些块的均值构成序列输出
xsz = size(I,1);    % 行的大小
ysz = size(I,2);    % 列的大小

% 随机包含两个因素，一个是尺寸，一个是中点坐标。但是每个块都是正方的。
% 使用均匀分布的随机，所以首先需要求得均匀分布的范围：
% 以前的随机控制方式存在问题：就是小的块可能太小，不直接。
% 修改一下，minlength 表示最小的直径大小，maxlength表示在最大的直径
ratio1 = 1/16; ratio2 = 1/32; % 这两个参数控制图像分块占原图的相对大小，最小为1/16，最大为1/4
% ratio1 = 1/2;ratio2 = 1/4;
minlength1 = round(ratio2*xsz); % 这是随机块的最小直径
maxlength1 = round(ratio1*xsz);	% 这是随机块的直径的变化范围
minlength2 = round(ratio2*ysz); % 这是随机块的最小直径
maxlength2 = round(ratio1*ysz);	% 这是随机块的直径的变化范围

% rand('state',key); % 设置产生随机数的方法和种子
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
meanBlocks = zeros(1,numrects);
% T = zeros(size(I));
for i = 1:numrects
    T = zeros(size(I));
    T(rectcoors(i,1):rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2):rectcoors(i,2)+rectlengths2(i) - 1) = 1;
    meanBlocks(i) = sum(sum(I(T == 1)))/sum(sum(T));
%   figure;imshow(T);
end
% delta = 100;
% meanI = round(avgI/delta)*delta;  % 除以100 再乘以100 。这个是为了什么？
return;
end % function
%% 规则取块的均值序列
function [meanBlocks,rectcoors] = regularBlockMean(I,numrects)
%% [meanBlocks,rectcoors] = regularBlockMean(I,numrects)
% 分成 n*n 随机的块，每块取平均，记录顶点坐标
n = sqrt(numrects);
% 以下代码拷贝自 mbe_bian 
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
% 直接分块
B = blkproc(I,[r,c],fun_avg); % 分块处理
% 交叠处理
% B = blkproc(I,[r,c],[r_d4,c_d4],fun_avg);	%overlapped, Note: Padding with zero on the boundary
meanBlocks = B(:);

% 得到各个分块的顶点坐标
for i = 1:n
    for j = 1:n
        rectcoorsC(i,j) = (i - 1) * c + 1;
        rectcoorsR(i,j) = (j - 1) * r + 1;        
    end 
end
rectcoors = [rectcoorsC(:) rectcoorsR(:)];
% 好，这个坐标好像是对的，绝对没有问题。先列后行，自左上开始。
end % function
%% 量化为4个等级
function binaryHash = Quantize2fourlevels(featureVector,radio)
%% binaryHash = Quantize2fourlevels(featureVector,radio)
% 修改自 adaptiveQuantizer
% 一些调节参数
levelsNumber = 4;
% radio控制中间两个等级的宽度
% Sort
fv = sort(featureVector);
lfv = length(fv);
% 等分
halfpoint = fix(length(featureVector)/2);
levels = [halfpoint - floor(halfpoint * radio), halfpoint, halfpoint + fix(halfpoint * radio)];
% levels的最后一个不需要记，大于levels(end - 1)的就是最后一级
levels = fv(levels);
%% 使用levels量化出一堆等级
q = zeros(1,length(featureVector));
for i = 1:length(featureVector)
    for j = 1:length(levels) - 1
        if featureVector(i) <= levels(j + 1) && featureVector(i) > levels(j)
            q(i) = j;
        end
    end
    if featureVector(i) <= levels(1)
        q(i) = 0;
    end
    if featureVector(i) > levels(end)
        q(i) = length(levels);
    end
end    
%% 量化结果直接作为编码
binaryHash = q;
return;
end % end function
%% 规则分块置乱差分
function hash = regularDiff(I,n,numdiffTimes)
%% hash = regularDiff(I,n,numdiffTimes)
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
B = blkproc(I,[r,c],[r_d4,c_d4],fun_avg);

numrects = length(B(:));
% 置乱一下，基本上这个做完就知道差分的方法要块大还是块小了
% 为了保证randperm每次都按一样的顺序排序，只需要在调用前加上：
% rand('state',101);
index1 = randperm(numrects);

% iA = [1:numrects];
hashvector = zeros(1,numrects);

hashvector = B([1:numrects]) >= B(index1);
hash = hashvector;
end % end function

%% method 8 function
function hashvector = robustHashWithTamperDetect(I,key,numrects,numdiffTimes)
%% hashvector = robustHashWithTamperDetect(I,key,numrects)
    %{
    使用两级编码：
    第一级使用随机分块，差分编码。第二级使用规则分块，置乱差分编码。
    第一级鲁棒哈希，第二级在第一级的基础上精确定位tamper的位置，并确认tamper。应该说，第二级也是鲁棒哈希，但是因为它本身关注的是细节，所以避免了小块替换对整体影响不大的问题。
    %}
    %% 参数设定
    numLocal = 3; % numLocal * numLocal 是在大块中划分的小块的个数。
    ratio1 = 1/16; ratio2 = 1/32; % 大块占原图的相对大小，最小为1/16，最大为1/32
    numdiffTimesLocal = 1;
    numdiffTimesGlobal = numdiffTimes;
    %% 大块的位置
    xsz = size(I,1);    % 行的大小
    ysz = size(I,2);    % 列的大小
    minlength1 = round(ratio2*xsz); % 这是随机块的最小直径
    maxlength1 = round(ratio1*xsz);	% 这是随机块的直径的变化范围
    minlength2 = round(ratio2*ysz); % 这是随机块的最小直径
    maxlength2 = round(ratio1*ysz);	% 这是随机块的直径的变化范围

%     rand('state',key); % 设置产生随机数的方法和种子
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
    localhash = zeros(numrects,numdiffTimesLocal * numLocal * numLocal);
    for i = 1:numrects
        T = zeros(size(I));
        T(rectcoors(i,1):rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2):rectcoors(i,2)+rectlengths2(i) - 1) = 1;
        meanBlocks(i) = sum(sum(I(T == 1)))/sum(sum(T));
        %% 在处理每一个大块的同时， 处理大块自己的local哈希
        Il = I(rectcoors(i,1):rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2):rectcoors(i,2)+rectlengths2(i) - 1);
        localhash(i,:) = localhashForTamperDetect(Il,numLocal,numdiffTimesLocal); % 每一行对应一块
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
%% 规则分块置乱差分 for method 8
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
