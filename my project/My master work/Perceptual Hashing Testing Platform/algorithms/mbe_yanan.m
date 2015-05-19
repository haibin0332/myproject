%% Comments and References
%{ 
	MBE_YANAN ȡԲ�ֿܷ���룬������
	1��ȡԲ��	���⾶��r1,r2
	2���ֿ�	�������(���߻��С���)

	Note: ��Ҫר�ŵ�ƥ���㷨
		ƥ����߼��ǣ�������أ��������ߵľ���Ϊhash����

	����5��������ķ���3
    
    Method:
    1. ��ͨȡn�ֿ��㷨
    2. 2n���ȱ��룬ǰnλ��method 1��������nλ����Ӧ�ĳ�ʼƫת�Ƕ�
%}
function [Hn] = mbe_yanan(imagefile,param)
% ���ڲ��� param��Ϊ�˱��ֲ��Գ���Ľӿ�һ�£����е��㷨�����Ĳ�������Ϊparam���ں����ڲ��ٸ�����Ҫ��������
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
%% ��һ��Ϊ�˲���SSIM����ͨ��������

window = fspecial('gaussian', 11, 1.5);
window = window/sum(sum(window));
img1 = double(I);

mu1_samesize = filter2(window, img1, 'same');
luminance1 = mu1_samesize;
mu1_sq_samesize = mu1_samesize.*mu1_samesize;
sigma1_sq_samesize = filter2(window, img1.*img1, 'same') - mu1_sq_samesize;

sigma1 = sqrt(sigma1_sq_samesize);
contrast1 = sigma1;
structure1 = (img1 - mu1_samesize)./sigma1;	% �������ĵĶ����д����֪���᲻���г���������Ӧ�û��У��ټ��ɡ����Լ���һ��С�ĳ����������

if channel == 1
	I = luminance1;
elseif channel == 2
	I = contrast1;
elseif channel == 3
	I = structure1;
end

%%
if method == 1	% ��ͨ����
%% Build a mask templet
MaskN = zeros(size(I));		% ��������n������ģ��
% index = [1:size(I,1) 1:size(I,2)]; %#ok<NASGU>
for r = 1:size(I,1)
	for c =  1:size(I,2)
		x = c - (size(I,2) + 1)/2;
		y = (size(I,1) + 1)/2 - r;
		% ���뾶 > r2 < r1
		if (x^2 + y^2 > r1^2) && (x^2 + y^2 < r2^2)
			% ���Ƕȣ�����ֵ��Note: ��ʼλ����9���ӷ�����Ϊatan2��ԭ����ʱ�롣
% 			theta = atan2(y, x) + (pi/n);
            theta = atan2(y, x);
			MaskN(r,c) = fix( (theta + pi) / (2*pi/n) ) + 1; % ��1-N ���඼Ϊ0
		end
	end
end
% imshow(MaskN,[]);

%% ����hash
Hn = zeros(1, n);
M = Hn;
for k = [1:n]
	Hn(k) = sum(sum(I(MaskN == k)))/sum(sum(MaskN == k));	% �ֿ�ȡ��ֵ
		
% 	Tp = im2uint8(MaskN ~= k);	% ת���ɷ��߼�ͼ
% 	Tp(Tp == 255) = 1;			% 1*var = var 0*var = 0
% 	Tp = I - Tp.*I;
% 	imshow(Tp);					%���� ��ͼ˵��
	
	M(k) = median(median(I(MaskN == k)));			%�ֿ�ȡ��ֵ
end
Hn = Hn >= M;	% ����ֵ��ֵ��
elseif method == 2 % ��ʼ�Ƕ�
%%
    MaskN = zeros(size(I));		% ��������n������ģ��
    for r = 1:size(I,1)
        for c =  1:size(I,2)
            x = c - (size(I,2) + 1)/2;
            y = (size(I,1) + 1)/2 - r;
            % ���뾶 > r2 < r1
            if (x^2 + y^2 > r1^2) && (x^2 + y^2 < r2^2)
                % ���Ƕȣ�����ֵ��Note: ��ʼλ����9���ӷ�����Ϊatan2��ԭ����ʱ�롣
                theta = atan2(y, x);
    			MaskN(r,c) = fix( (theta + pi) / (2*pi/n) ) + 1; % ��1-N ���඼Ϊ0
            end
        end
    end
%     figure, imshow(MaskN,[]);

    Hn = zeros(1, 2*n);
    M = Hn;
    for k = [1:n]
        Hn(k) = sum(sum(I(MaskN == k)))/sum(sum(MaskN == k));	% �ֿ�ȡ��ֵ
        M(k) = median(median(I(MaskN == k)));			%�ֿ�ȡ��ֵ
    end
    Hn = Hn >= M;	% ����ֵ��ֵ��

    MaskN = zeros(size(I));		% ��������n������ģ��
    for r = 1:size(I,1)
        for c =  1:size(I,2)
            x = c - (size(I,2) + 1)/2;
            y = (size(I,1) + 1)/2 - r;
            % ���뾶 > r2 < r1
            if (x^2 + y^2 > r1^2) && (x^2 + y^2 < r2^2)
                % ���Ƕȣ�����ֵ��Note: ��ʼλ����9���ӷ�����Ϊatan2��ԭ����ʱ�롣
                theta = atan2(y, x) + (pi/n);
                if fix( (theta + pi) / (2*pi/n) ) == n
                    MaskN(r,c) = 1;
                else
                    MaskN(r,c) = fix( (theta + pi) / (2*pi/n) ) + 1; % ��1-N ���඼Ϊ0
                end
            end
        end
    end
%     figure, imshow(MaskN,[]);

    Hn2 = zeros(1, n);
    M = Hn2;
    for k = [1:n]
        Hn2(k) = sum(sum(I(MaskN == k)))/sum(sum(MaskN == k));	% �ֿ�ȡ��ֵ
        M(k) = median(median(I(MaskN == k)));			%�ֿ�ȡ��ֵ
    end
    Hn(n+1:2*n) = Hn2 >= M;	% ����ֵ��ֵ��
   
elseif method == 3	% ���ڷ���1�ĵ���
%%  
	MaskN = zeros(size(I));		% ��������n������ģ��
    for r = 1:size(I,1)
        for c =  1:size(I,2)
            x = c - (size(I,2) + 1)/2;
            y = (size(I,1) + 1)/2 - r;
            % ���뾶 > r2 < r1
            if (x^2 + y^2 > r1^2) && (x^2 + y^2 < r2^2)
                % ���Ƕȣ�����ֵ��Note: ��ʼλ����9���ӷ�����Ϊatan2��ԭ����ʱ�롣
                theta = atan2(y, x);
    			MaskN(r,c) = fix( (theta + pi) / (pi/n) ) + 1; % ��1-N ���඼Ϊ0
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
            Hn(k) = Hn(k) + sum(sum(I(MaskN == blockK)));	% �ֿ�ȡ��ֵ
            number(k) = number(k) + sum(sum(MaskN == blockK));
        end
        Hn(k) = Hn(k)/number(k);
        M(k) = median(median(I(MaskN == k)));			%�ֿ�ȡ��ֵ
    end
    Hn = Hn >= M;	% ����ֵ��ֵ��
elseif method == 4		% ֻ�ǵõ�Method 2 �ĺ��ε�hash
%% 
    MaskN = zeros(size(I));		% ��������n������ģ��
    for r = 1:size(I,1)
        for c =  1:size(I,2)
            x = c - (size(I,2) + 1)/2;
            y = (size(I,1) + 1)/2 - r;
            % ���뾶 > r2 < r1
            if (x^2 + y^2 > r1^2) && (x^2 + y^2 < r2^2)
                % ���Ƕȣ�����ֵ��Note: ��ʼλ����9���ӷ�����Ϊatan2��ԭ����ʱ�롣
                theta = atan2(y, x) + (pi/n);
                if fix( (theta + pi) / (2*pi/n) ) == n
                    MaskN(r,c) = 1;
                else
                    MaskN(r,c) = fix( (theta + pi) / (2*pi/n) ) + 1; % ��1-N ���඼Ϊ0
                end
            end
        end
    end
%     figure, imshow(MaskN,[]);

    Hn = zeros(1, n);
    M = Hn;
    for k = [1:n]
        Hn(k) = sum(sum(I(MaskN == k)))/sum(sum(MaskN == k));	% �ֿ�ȡ��ֵ
        M(k) = median(median(I(MaskN == k)));			%�ֿ�ȡ��ֵ
    end
    Hn = Hn >= M;	% ����ֵ��ֵ��
elseif method == 5              %���ڷ���2�ĵ��ӷ���
    MaskN = zeros(size(I));		% ��������n������ģ��
    for r = 1:size(I,1)
        for c =  1:size(I,2)
            x = c - (size(I,2) + 1)/2;
            y = (size(I,1) + 1)/2 - r;
            % ���뾶 > r2 < r1
            if (x^2 + y^2 > r1^2) && (x^2 + y^2 < r2^2)
                % ���Ƕȣ�����ֵ��Note: ��ʼλ����9���ӷ�����Ϊatan2��ԭ����ʱ�롣
                theta = atan2(y, x);
    			MaskN(r,c) = fix( (theta + pi) / (pi/n) ) + 1; % ��1-N ���඼Ϊ0
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
            Hn(k) = Hn(k) + sum(sum(I(MaskN == blockK)));	% �ֿ�ȡ��ֵ
            number(k) = number(k) + sum(sum(MaskN == blockK));
        end
        Hn(k) = Hn(k)/number(k);
        M(k) = median(median(I(MaskN == k)));			%�ֿ�ȡ��ֵ
    end
    Hn = Hn >= M;	% ����ֵ��ֵ��
    
    MaskN = zeros(size(I));		% ��������n������ģ��
    for r = 1:size(I,1)
        for c =  1:size(I,2)
            x = c - (size(I,2) + 1)/2;
            y = (size(I,1) + 1)/2 - r;
            % ���뾶 > r2 < r1
            if (x^2 + y^2 > r1^2) && (x^2 + y^2 < r2^2)
                % ���Ƕȣ�����ֵ��Note: ��ʼλ����9���ӷ�����Ϊatan2��ԭ����ʱ�롣
                theta = atan2(y, x) + (pi/n);
                if fix( (theta + pi) / (pi/n) ) == n
                    MaskN(r,c) = 1;
                else
                    MaskN(r,c) = fix( (theta + pi) / (pi/n) ) + 1; % ��1-N ���඼Ϊ0
                end
            end
        end
    end
%     figure, imshow(MaskN,[]);

    Hn2 = zeros(1, n);
    M = Hn2;
    for k = [1:n]
        Hn2(k) = sum(sum(I(MaskN == k)))/sum(sum(MaskN == k));	% �ֿ�ȡ��ֵ
        M(k) = median(median(I(MaskN == k)));			%�ֿ�ȡ��ֵ
    end
    Hn(n+1:2*n) = Hn2 >= M;	% ����ֵ��ֵ��
end

end

