function distance = match_zh_tamperdetect1(hashReference, hashTest, param)
    %{
        这个匹配因为有两个输出，所以是需要param的。但是目前关于测试的param部分，我其实编得并不好。
        因此，暂时通过在程序中固化相应部分对付一下

        params(1) = {256};
        params(2) = {4};
        params(3) = {1};
        params(4) = {3};
        params(5) = {1};
        h0 = mbe_zh_tamperdetect1(fullfile('F:\imDatabase\TestImages\OriginalImage','baboon.bmp'),params);
        h1 = mbe_zh_tamperdetect1(fullfile('F:\imDatabase\TestImages\Substitute with Signal Block\','baboon-SubSignal-0.046875.bmp'),params);
        h2 = mbe_zh_tamperdetect1(fullfile('F:\imDatabase\TestImages\Substitute with Perceptual Units','baboon-SubPerceptual-0.016125.bmp'),params);
        h3 = mbe_zh_tamperdetect1(fullfile('F:\imDatabase\TestImages\Gaussian Noise(mean)\','baboon-GNoiseMean-0.2.bmp'),params);
        h4 = mbe_zh_tamperdetect1(fullfile('F:\imDatabase\TestImages\JPEG','baboon-JPEG-70.jpg'),params); 

        param(1) = {256};
        param(2) = {4};
        param(3) = {1};
        param(4) = {'F:\imDatabase\TestImages'};
        param(5) = {'F:'};
        param(6) = {'Substitute with Signal Block\baboon-SubSignal-0.046875.bmp'}
        match_zh_tamperdetect1(h0,h1,param)
        param(6) = {'Substitute with Perceptual Units\baboon-SubPerceptual-0.016125.bmp'};        
        match_zh_tamperdetect1(h0,h2,param)
        param(6) = {'Gaussian Noise(mean)\baboon-GNoiseMean-0.2.bmp'};  
        match_zh_tamperdetect1(h0,h3,param)
        param(6) = {'JPEG\baboon-JPEG-70.jpg'};  
        match_zh_tamperdetect1(h0,h4,param)
    %}
%% test inputs
    
%% get inputs
    if nargin == 2;
        numrects = 256; % 随机分块的个数
        numdiffTimesGlobal = 4; % 每个大块差分的次数，
        method = 1;     % method 1 随机选大块
        indir = 'F:\imDatabase\TestImages';
        outdir = 'F:';        % 把query的图像另存，标注位置
        imageQueried =  'Substitute with Signal Block\baboon-SubSignal-0.046875.bmp';  % 'F:\imDatabase\TestImages\Gaussian Noise(mean)\baboon-GNoiseMean-0.2.bmp'; % query的图像，用于标注位置 
    else
        numrects = param{1}; 
        numdiffTimesGlobal = param{2}; 
        method = param{3};
        indir = param{4};
        outdir = param{5};       
        imageQueried = param{6};
    end
    key = 101; % 要有密钥才能够产生相同的块的划分
    Tlocal = 0.1;   % 这个阈值是通过试验确定的，用于区分local是否变化的
	ratio1 = 1/16; ratio2 = 1/32; % 大块占原图的相对大小，最小为1/16，最大为1/32
    
    I = imread(fullfile(indir,imageQueried));
    [pathstr, name, ext] = fileparts(imageQueried);
    saveImage = fullfile(outdir,pathstr,name);
    noted = 0;
    
%% 获得鲁棒距离
% 用作鲁棒哈希的编码部分，直接使用globalhash或者直接使用所有的bits，因为归一化了，虽然没有测试，两种效果应该差不多。
% 但是用来作为进一步分析的提示的感知哈希，必须使用globalhash，所以这里用这个。
    distance = sum(abs(hashReference.globalhash - hashTest.globalhash))/size(hashTest.globalhash,2);
    diffblocks = (abs(hashReference.globalhash - hashTest.globalhash));
%% 对鲁棒距离中的每一个差异进行进一步的分析
if method == 1 
    %% method = 1 随机选大块的情况
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
    figure;
    tI = zeros(xsz,ysz);
    for i = 1:numrects
        tI(rectcoors(i,1),rectcoors(i,2):rectcoors(i,2)+rectlengths2(i) - 1) = 256;
        tI(rectcoors(i,1):rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2)) = 256;
        tI(rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2):rectcoors(i,2)+rectlengths2(i) - 1) = 256;
        tI(rectcoors(i,1):rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2)+rectlengths2(i) - 1) = 256;
    end
%     figure;
    imshow(tI);
    %}   
    %% 根据有差的地方，确定两个被怀疑的块
    iA = [1:numrects];
    iS = zeros(1,numrects);
    for i = 1:numdiffTimesGlobal
        for j = 1:numrects
            if i + j <= numrects
                iB(j) = iA(i+j);
            else
                iB(j) = iA(mod(j + i,numrects));
            end
        end
        % 差分
%         globalhash((i-1)*numrects+1:(i*numrects)) = meanBlocks(iA) >= meanBlocks(iB);
        iCounter = 0;
        for k = (i-1)*numrects+1:(i*numrects)
            iCounter = iCounter + 1;
            if diffblocks(k) == 1
                s(1) = iCounter;
                s(2) = iB(iCounter);
                iS(s(1)) = iS(s(1)) + 1; % 记录所有被怀疑的块
                iS(s(2)) = iS(s(2)) + 1;
            end
        end
        for j = 1:numrects
                %% 处理被怀疑的块，match，标注
            if iS(j) > 0 % 这里相当于是个阈值。即如果只被怀疑一次，这样的块不处理。
                disLocal = sum(abs(hashReference.localhash(j,:) - hashTest.localhash(j,:)))/size(hashTest.localhash,2);
                if disLocal >= Tlocal % 设定的局部判断的阈值
                    % 标注
                    I(rectcoors(j,1),rectcoors(j,2):rectcoors(j,2)+rectlengths2(j) - 1) = 256;
                    I(rectcoors(j,1):rectcoors(j,1)+rectlengths1(j) - 1,rectcoors(j,2)) = 256;
                    I(rectcoors(j,1)+rectlengths1(j) - 1,rectcoors(j,2):rectcoors(j,2)+rectlengths2(j) - 1) = 256;
                    I(rectcoors(j,1):rectcoors(j,1)+rectlengths1(j) - 1,rectcoors(j,2)+rectlengths2(j) - 1) = 256;

                    noted = 1;
                end
            end
        end
    end
%     figure;plot(iS, 'DisplayName', 'iS', 'YDataSource', 'iS');
        figure;imshow(I);
%     if noted == 1
%         imwrite(I,saveImage);
%     end
elseif method == 2 
    %% method = 2 规则选大块的情况
end
end % end function