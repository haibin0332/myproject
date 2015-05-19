%{
只处理偶数size的图像，比如256*256
%}
function [hashvector] = mbe_Wumin_flyMellin(imagefile,param)
%% test inputs
% imagefile = '1.bmp';
% key = 101;
% radii = [0.05:0.01:0.99];
% method = 1;
% bitlength = 4;
% nargin = 1;
%% check input
I = imread(imagefile);
if nargin == 1
    key = 101;
    radii = [1/255:1/255:1];   % 圈圈的半径 最多也就这样了，256个全用，对于方法一，这个个数就是hash的长度
    method = 2;     % 
    bitlength = 3;  % 量化时使用的，标识一个feature量化得到的binary vector的长度，3^2 = 9
    groupsNumber = 256; % 对于方法2，hash的长度需要通过指定，等于groupsNumber * radiisInGroup
    radiisInGroup = 6;    % 对于方法2，需要指定每个半径分组中半径的个数。
    
else
    key = param{1};
    radii = param{2};
    method = param{3};
    bitlength = param{4};
    groupsNumber = param{5};
    radiisInGroup = param{6};   
end
%% preprocessing: low-pass filter
% 不滤波也罢
%% preprocessing: histEqul
% 应该均衡化到什么程度呢？
%% Fourier transform
II = fft2(I);
IIc = fftshift(II);
Irc = abs(IIc);
Ilrc = log(1+Irc);
% imshow(Ilrc,[]);

%% convert into polar co-ordinates
% 不需要做这一部分，因为她其实就是在一个圆周上求和
%% Feature generation:
% 她所谓的特征就是一个圆周上的求和
% 两个参数：一个是取多少个半径，一个是每个圆周上多少个点
% 从公式5可以看出，她每一个rho都产生了一个不同的随机序列
% Irc = Ilrc;
randn('seed',key);
% kSample = 365; % 文章里说用365，怎么可能做得到？即使用了插值，那又能有什么意义？
% 因为取不到精确的圆周，所以需要近似处理。
if method == 1
    for j = 1:length(radii)
        % 产生一个指定半径的圆周
        Cmark = drawCircle(Irc,size(Irc,1)/2 + 0.5,size(Irc,2)/2 + 0.5,floor((min(size(Irc))/2)*radii(j)));
        % 用这个圆周取得特征数据
        featureVector = Irc(Cmark == 1);
        % 在得到圆之后才得到featureVector的大小，针对这个产生随机数，然后用她的公式求和，这个和原文做法不同，但是更加简单且更加有效
        % 求和的时候要做归一化，这样保证得到的结果不受到周长的影响
        beta = randn(size(featureVector));
        h(j) = sum(beta .* abs(featureVector))/length(featureVector);   % 这是Method 1 
    end    
elseif method == 2
    % 在radii中随机选择一些构成一组，一共有j组，每组和一个随机数相乘求和，一个随机数对应于一组，j组对应于j个hash
    beta = randn(groupsNumber,radiisInGroup); % 产生j个随机数 
    for j = 1:groupsNumber
        % 产生radiisInGroup个随机数，构成一组,均匀分布，选择均匀
        radiiGroup = rand(radiisInGroup,1);
        % 产生radiiGroup个指定半径的圆周
        for i = 1:radiisInGroup
            Cmark = drawCircle(Irc,size(Irc,1)/2 + 0.5,size(Irc,2)/2 + 0.5,floor((floor(min(size(Irc))/2) - 1) * radiiGroup(i) + 1));
            % 用这个圆周取得特征数据
            featureVector = Irc(Cmark == 1);
            % 在得到圆之后才得到featureVector的大小，针对这个产生随机数，然后用她的公式求和，这个和原文做法不同，但是更加简单且更加有效
            % 求和的时候要做归一化，这样保证得到的结果不受到周长的影响
            hh(i) = sum(abs(featureVector))/length(featureVector);   % 直接求和，不随机加权 
        end
        h(j) = sum(beta(j,:) .* hh);
    end
end
%% 量化 quantize
% 如她在文章里说的，我们使用她的Reference 5的方法 
% A Tool For Robust Audio Information Hiding: A Perceptual Audio Hashing Algorithm
hashvector = adaptiveQuantizer(h,bitlength,key);

%% 
%{
这是天底下最无耻最可笑的算法，腐败啊！！！
起码的区分性都没有

h1 = mbe_Wumin_flyMellin('1.bmp');
h2 = mbe_Wumin_flyMellin('2.bmp');
h3 = mbe_Wumin_flyMellin('3.tiff');
h4 = mbe_Wumin_flyMellin('95.bmp');
d12 = sum(abs(h1 - h2))
d13 = sum(abs(h1 - h3))
d23 = sum(abs(h2 - h3))
d14 = sum(abs(h1 - h4))
d34 = sum(abs(h3 - h4))

%}



