function distance = match_zh_rdd_method8(hashReference, hashTest, param)
    %{
        ���ƥ����Ϊ�������������������Ҫparam�ġ�����Ŀǰ���ڲ��Ե�param���֣�����ʵ��ò����á�
        ��ˣ���ʱͨ���ڳ����й̻���Ӧ���ֶԸ�һ��

        params(1) = {256};
        params(2) = {8};
        params(3) = {0};
        params(4) = {0};
        params(5) = {8};
        h0 = mbe_zh_rdd(fullfile('F:\imDatabase\TestImages\OriginalImage','baboon.bmp'),params);
        h1 = mbe_zh_rdd(fullfile('F:\imDatabase\TestImages\Substitute with Signal Block\','baboon-SubSignal-0.046875.bmp'),params);
        h2 = mbe_zh_rdd(fullfile('F:\imDatabase\TestImages\Substitute with Perceptual Units','baboon-SubPerceptual-0.1.bmp'),params);
        h3 = mbe_zh_rdd(fullfile('F:\imDatabase\TestImages\Gaussian Noise(mean)\','baboon-GNoiseMean-0.2.bmp'),params);
%         h4 = mbe_zh_rdd(fullfile('F:\imDatabase\TestImages\JPEG','baboon-JPEG-10.jpg'),params); 
        param(1) = {256};
        param(2) = {8};
        param(3) = {fullfile('F:\imDatabase\TestImages\Substitute with Signal Block\','baboon-SubSignal-0.046875.bmp')};
        param(4) = {'F:'};
        match_zh_rdd_method8(h0,h1,param)
        param(3) = {fullfile('F:\imDatabase\TestImages\Substitute with Perceptual Units','baboon-SubPerceptual-0.1.bmp')};        
        match_zh_rdd_method8(h0,h2,param)
        param(3) = {fullfile('F:\imDatabase\TestImages\Gaussian Noise(mean)\','baboon-GNoiseMean-0.2.bmp')};  
        match_zh_rdd_method8(h0,h3,param)
        param(3) = {fullfile('F:\imDatabase\TestImages\JPEG','baboon-JPEG-10.jpg')};  
%         match_zh_rdd_method8(h0,h4,param)
    %}
%% test inputs
    
%% get inputs
    if nargin == 2
        numrects = 256; % ����ֿ�ĸ���
        numdiffTimesGlobal = 8; % ���Ӱ���ֵĲ���
        imageQueried =  'F:\imDatabase\TestImages\Substitute with Signal Block\baboon-SubSignal-0.046875.bmp';  % 'F:\imDatabase\TestImages\Gaussian Noise(mean)\baboon-GNoiseMean-0.2.bmp'; % query��ͼ�����ڱ�עλ�� 
        outdir = 'F:';        % ��query��ͼ�����棬��עλ��
    else
        numrects = param{1}; 
        numdiffTimesGlobal = param{2}; 
        imageQueried = param{3};
        outdir = param{4};
    end
    key = 101; % Ҫ����Կ���ܹ�������ͬ�Ŀ�Ļ���
    Tlocal = 0.3;   % �����ֵ��ͨ������ȷ���ģ���������local�Ƿ�仯��
	ratio1 = 1/16; ratio2 = 1/32; % ���ռԭͼ����Դ�С����СΪ1/16�����Ϊ1/32
    
    I = imread(imageQueried);
    [pathstr, name, ext] = fileparts(imageQueried);
    saveImage = fullfile(outdir,[name,ext]);
    
%% ���³������
% ����³����ϣ�ı��벿�֣�ֱ��ʹ��globalhash����ֱ��ʹ�����е�bits����Ϊ��һ���ˣ���Ȼû�в��ԣ�����Ч��Ӧ�ò�ࡣ
% ����������Ϊ��һ����������ʾ�ĸ�֪��ϣ������ʹ��globalhash�����������������
    distance = sum(abs(hashReference.globalhash - hashTest.globalhash))/size(hashTest.globalhash,2);
    diffblocks = (abs(hashReference.globalhash - hashTest.globalhash));

%% ��³�������е�ÿһ��������н�һ���ķ���

    %% ����λ��
    xsz = size(I,1);    % �еĴ�С
    ysz = size(I,2);    % �еĴ�С
    minlength1 = round(ratio2*xsz); % ������������Сֱ��
    maxlength1 = round(ratio1*xsz);	% ����������ֱ���ı仯��Χ
    minlength2 = round(ratio2*ysz); % ������������Сֱ��
    maxlength2 = round(ratio1*ysz);	% ����������ֱ���ı仯��Χ

    rand('state',key); % ���ò���������ķ���������
    rectlengths1 = ceil(rand(numrects,1)*(maxlength1))  + minlength1; % [minlength,minlength + maxlength]
    rectlengths2 = ceil(rand(numrects,1)*(maxlength2))  + minlength2;
    rectcoors = ceil(rand(numrects,2).*[ xsz-rectlengths1+1 ysz-rectlengths2+1]); % ������������꣬���Ͻǵĵ�
    % ��һ�δ�������ʾ����������ֿ�
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
    
    %% �����в�ĵط���ȷ�����������ɵĿ�
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
        % ���
%         globalhash((i-1)*numrects+1:(i*numrects)) = meanBlocks(iA) >= meanBlocks(iB);
        iCounter = 0;
        for k = (i-1)*numrects+1:(i*numrects)
            iCounter = iCounter + 1;
            if diffblocks(k) == 1
                s(1) = iCounter;
                s(2) = iB(iCounter);
                iS(s(1)) = iS(s(1)) + 1; % ��¼���б����ɵĿ�
                iS(s(2)) = iS(s(2)) + 1;
            end
        end
        for j = 1:numrects
                %% ���������ɵĿ飬match����ע
            if iS(j) > 1 % �����൱���Ǹ���ֵ�������ֻ������һ�Σ������Ŀ鲻������
                disLocal = sum(abs(hashReference.localhash(j,:) - hashTest.localhash(j,:)))/size(hashTest.localhash,2);
                if disLocal >= Tlocal % �趨�ľֲ��жϵ���ֵ
                    % ��ע
                    I(rectcoors(j,1),rectcoors(j,2):rectcoors(j,2)+rectlengths2(j) - 1) = 256;
                    I(rectcoors(j,1):rectcoors(j,1)+rectlengths1(j) - 1,rectcoors(j,2)) = 256;
                    I(rectcoors(j,1)+rectlengths1(j) - 1,rectcoors(j,2):rectcoors(j,2)+rectlengths2(j) - 1) = 256;
                    I(rectcoors(j,1):rectcoors(j,1)+rectlengths1(j) - 1,rectcoors(j,2)+rectlengths2(j) - 1) = 256;

                    saveImage = fullfile(outdir,[name,'_noted',ext]);    
                end
            end
        end
    end
%     figure;plot(iS, 'DisplayName', 'iS', 'YDataSource', 'iS');
        figure;imshow(I);
%         imwrite(I,saveImage);
end % end function