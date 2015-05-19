%% Comments and References
%{ 
	MBE_YANAN 取圆周分块编码，相关最大
	1、取圆周	内外径：r1,r2
	2、分块	块数：ｎ　(或者还有　ｍ　)

	Note: 需要专门的匹配算法
		匹配的逻辑是：先求相关，相关最大者的距离为hash距离

	方法5是论文里的方法3
    
    Method:
    1. 普通取n分块算法
    2. 2n长度编码，前n位由method 1产生，后n位有相应的初始偏转角度
%}
function [Hn] = mbe_yanan(imagefile,param)
% 关于参数 param，为了保持测试程序的接口一致，所有的算法函数的参数都改为param，在函数内部再根据需要作解析。
%% test: input
% if nargin == 0
%     imagefile = fullfile(cd, '3.tiff');
%     I = imread(imagefile);
%     r1 = fix((0.1 * size(I,1))/2);	
%     r2 = fix((0.71 * size(I,1))/2);	
%     n = 32;
%     method = 1;
% end
%% check input
%{
error(nargchk(3, 4, nargin, 'string'));
if nargin == 4
	if ndims(varargin) ~= 1
		error('error with data type of argument m')
	elseif isnumeric(varargin) ~= 1
		error('error with data type of argument m')
	end
	m = varargin;
end
%}

if nargin == 1
	method = 2;
	n = 64;
	r2 = 0.71;
	r1 = 1/4;
	channel = 1;
else
	method = param(1);
	n = param(2);
	r2 = param(3);
	r1 = param(4);
	channel = param(5);
end				

I = imread(imagefile);
r1 = fix((r1 * size(I,1))/2);
r2 = fix((r2 * size(I,1))/2);	
% I = rgb2gray(I);
%% 这一段为了测试SSIM三个通道的问题

window = fspecial('gaussian', 11, 1.5);
window = window/sum(sum(window));
img1 = double(I);

mu1_samesize = filter2(window, img1, 'same');
luminance1 = mu1_samesize;
mu1_sq_samesize = mu1_samesize.*mu1_samesize;
sigma1_sq_samesize = filter2(window, img1.*img1, 'same') - mu1_sq_samesize;

sigma1 = sqrt(sigma1_sq_samesize);
contrast1 = sigma1;
structure1 = (img1 - mu1_samesize)./sigma1;	% 按照论文的定义编写，不知道会不会有除零的情况，应该会有，少见吧。可以加上一个小的常数来解决。

if channel == 1
	I = luminance1;
elseif channel == 2
	I = contrast1;
elseif channel == 3
	I = structure1;
end

%%
if method == 1	% 普通方法
%% Build a mask templet
MaskN = zeros(size(I));		% 针对输入的n建立的模板
% index = [1:size(I,1) 1:size(I,2)]; %#ok<NASGU>
for r = 1:size(I,1)
	for c =  1:size(I,2)
		x = c - (size(I,2) + 1)/2;
		y = (size(I,1) + 1)/2 - r;
		% 检查半径 > r2 < r1
		if (x^2 + y^2 > r1^2) && (x^2 + y^2 < r2^2)
			% 检查角度，并赋值，Note: 起始位置在9点钟方向，因为atan2的原因，逆时针。
% 			theta = atan2(y, x) + (pi/n);
            theta = atan2(y, x);
			MaskN(r,c) = fix( (theta + pi) / (2*pi/n) ) + 1; % 从1-N 其余都为0
		end
	end
end
% imshow(MaskN,[]);

%% 计算hash
Hn = zeros(1, n);
M = Hn;
for k = [1:n]
	Hn(k) = sum(sum(I(MaskN == k)))/sum(sum(MaskN == k));	% 分块取均值
		
% 	Tp = im2uint8(MaskN ~= k);	% 转换成非逻辑图
% 	Tp(Tp == 255) = 1;			% 1*var = var 0*var = 0
% 	Tp = I - Tp.*I;
% 	imshow(Tp);					%调试 看图说话
	
	M(k) = median(median(I(MaskN == k)));			%分块取中值
end
Hn = Hn >= M;	% 依中值二值化
elseif method == 2 % 初始角度
%%
    MaskN = zeros(size(I));		% 针对输入的n建立的模板
    for r = 1:size(I,1)
        for c =  1:size(I,2)
            x = c - (size(I,2) + 1)/2;
            y = (size(I,1) + 1)/2 - r;
            % 检查半径 > r2 < r1
            if (x^2 + y^2 > r1^2) && (x^2 + y^2 < r2^2)
                % 检查角度，并赋值，Note: 起始位置在9点钟方向，因为atan2的原因，逆时针。
                theta = atan2(y, x);
    			MaskN(r,c) = fix( (theta + pi) / (2*pi/n) ) + 1; % 从1-N 其余都为0
            end
        end
    end
%     figure, imshow(MaskN,[]);

    Hn = zeros(1, 2*n);
    M = Hn;
    for k = [1:n]
        Hn(k) = sum(sum(I(MaskN == k)))/sum(sum(MaskN == k));	% 分块取均值
        M(k) = median(median(I(MaskN == k)));			%分块取中值
    end
    Hn = Hn >= M;	% 依中值二值化

    MaskN = zeros(size(I));		% 针对输入的n建立的模板
    for r = 1:size(I,1)
        for c =  1:size(I,2)
            x = c - (size(I,2) + 1)/2;
            y = (size(I,1) + 1)/2 - r;
            % 检查半径 > r2 < r1
            if (x^2 + y^2 > r1^2) && (x^2 + y^2 < r2^2)
                % 检查角度，并赋值，Note: 起始位置在9点钟方向，因为atan2的原因，逆时针。
                theta = atan2(y, x) + (pi/n);
                if fix( (theta + pi) / (2*pi/n) ) == n
                    MaskN(r,c) = 1;
                else
                    MaskN(r,c) = fix( (theta + pi) / (2*pi/n) ) + 1; % 从1-N 其余都为0
                end
            end
        end
    end
%     figure, imshow(MaskN,[]);

    Hn2 = zeros(1, n);
    M = Hn2;
    for k = [1:n]
        Hn2(k) = sum(sum(I(MaskN == k)))/sum(sum(MaskN == k));	% 分块取均值
        M(k) = median(median(I(MaskN == k)));			%分块取中值
    end
    Hn(n+1:2*n) = Hn2 >= M;	% 依中值二值化
   
elseif method == 3	% 基于方法1的叠加
%%  
	MaskN = zeros(size(I));		% 针对输入的n建立的模板
    for r = 1:size(I,1)
        for c =  1:size(I,2)
            x = c - (size(I,2) + 1)/2;
            y = (size(I,1) + 1)/2 - r;
            % 检查半径 > r2 < r1
            if (x^2 + y^2 > r1^2) && (x^2 + y^2 < r2^2)
                % 检查角度，并赋值，Note: 起始位置在9点钟方向，因为atan2的原因，逆时针。
                theta = atan2(y, x);
    			MaskN(r,c) = fix( (theta + pi) / (pi/n) ) + 1; % 从1-N 其余都为0
            end
        end
    end
%     figure, imshow(MaskN,[]);

    Hn = zeros(1, n);
    number = zeros(1, n);
    M = Hn;
    for k = [1:n]
        Hn(k) = 0;
        number(k) = 0;
        for i = 0:3
            blockK = 2 * (k - 1) + i;
            if blockK == 0
                blockK = n;
            end
            Hn(k) = Hn(k) + sum(sum(I(MaskN == blockK)));	% 分块取均值
            number(k) = number(k) + sum(sum(MaskN == blockK));
        end
        Hn(k) = Hn(k)/number(k);
        M(k) = median(median(I(MaskN == k)));			%分块取中值
    end
    Hn = Hn >= M;	% 依中值二值化
elseif method == 4		% 只是得到Method 2 的后半段的hash
%% 
    MaskN = zeros(size(I));		% 针对输入的n建立的模板
    for r = 1:size(I,1)
        for c =  1:size(I,2)
            x = c - (size(I,2) + 1)/2;
            y = (size(I,1) + 1)/2 - r;
            % 检查半径 > r2 < r1
            if (x^2 + y^2 > r1^2) && (x^2 + y^2 < r2^2)
                % 检查角度，并赋值，Note: 起始位置在9点钟方向，因为atan2的原因，逆时针。
                theta = atan2(y, x) + (pi/n);
                if fix( (theta + pi) / (2*pi/n) ) == n
                    MaskN(r,c) = 1;
                else
                    MaskN(r,c) = fix( (theta + pi) / (2*pi/n) ) + 1; % 从1-N 其余都为0
                end
            end
        end
    end
%     figure, imshow(MaskN,[]);

    Hn = zeros(1, n);
    M = Hn;
    for k = [1:n]
        Hn(k) = sum(sum(I(MaskN == k)))/sum(sum(MaskN == k));	% 分块取均值
        M(k) = median(median(I(MaskN == k)));			%分块取中值
    end
    Hn = Hn >= M;	% 依中值二值化
elseif method == 5              %基于方法2的叠加方法
    MaskN = zeros(size(I));		% 针对输入的n建立的模板
    for r = 1:size(I,1)
        for c =  1:size(I,2)
            x = c - (size(I,2) + 1)/2;
            y = (size(I,1) + 1)/2 - r;
            % 检查半径 > r2 < r1
            if (x^2 + y^2 > r1^2) && (x^2 + y^2 < r2^2)
                % 检查角度，并赋值，Note: 起始位置在9点钟方向，因为atan2的原因，逆时针。
                theta = atan2(y, x);
    			MaskN(r,c) = fix( (theta + pi) / (pi/n) ) + 1; % 从1-N 其余都为0
            end
        end
    end
%     figure, imshow(MaskN,[]);

    Hn = zeros(1, n);
    number = zeros(1, n);
    M = Hn;
    for k = [1:n]
        Hn(k) = 0;
        number(k) = 0;
        for i = 0:3
            blockK = 2 * (k - 1) + i;
            if blockK == 0
                blockK = n;
            end
            Hn(k) = Hn(k) + sum(sum(I(MaskN == blockK)));	% 分块取均值
            number(k) = number(k) + sum(sum(MaskN == blockK));
        end
        Hn(k) = Hn(k)/number(k);
        M(k) = median(median(I(MaskN == k)));			%分块取中值
    end
    Hn = Hn >= M;	% 依中值二值化
    
    MaskN = zeros(size(I));		% 针对输入的n建立的模板
    for r = 1:size(I,1)
        for c =  1:size(I,2)
            x = c - (size(I,2) + 1)/2;
            y = (size(I,1) + 1)/2 - r;
            % 检查半径 > r2 < r1
            if (x^2 + y^2 > r1^2) && (x^2 + y^2 < r2^2)
                % 检查角度，并赋值，Note: 起始位置在9点钟方向，因为atan2的原因，逆时针。
                theta = atan2(y, x) + (pi/n);
                if fix( (theta + pi) / (pi/n) ) == n
                    MaskN(r,c) = 1;
                else
                    MaskN(r,c) = fix( (theta + pi) / (pi/n) ) + 1; % 从1-N 其余都为0
                end
            end
        end
    end
%     figure, imshow(MaskN,[]);

    Hn2 = zeros(1, n);
    M = Hn2;
    for k = [1:n]
        Hn2(k) = sum(sum(I(MaskN == k)))/sum(sum(MaskN == k));	% 分块取均值
        M(k) = median(median(I(MaskN == k)));			%分块取中值
    end
    Hn(n+1:2*n) = Hn2 >= M;	% 依中值二值化
end

end

