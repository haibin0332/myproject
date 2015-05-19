%% Comments and References
%{
Fan Gu Bian Yang and Xiamu Niu. Block mean value based image perceptual hashing. IEEE International
Conference on Intelligent Information Hiding and Multimedia Signal Processing, Pasadena,
USA, 2006.

Method 1：
取n*n 个块，16*16 = 256 个块。
without encryptiong with secret K
just for identification

Method 2:
Overlapped with half of the blocks.

这里的实现对图像大小和比例不做要求
%}

%% Function 
function H = mbe_bian(imagefile, param)
%% test: input file 
% imagefile = '001n.bmp';
% param(1) = {3};
% param(2) = {1};
%  imagefile = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked\Rotation & Cropping & Resize\001n-Rotation & Cropping & Resize-1.bmp';
%  Method = 1;
% I = rgb2gray(I);
% imshow(I)
%% check inputs
if ischar(imagefile)
    I = imread(imagefile);
else
    I = imagefile; % 某些时候，直接将图像数据传入，不必要读图像多次
end    
if nargin == 1
	n = 16; % 16 * 16 = 256
    method = 1;
else
    n = param{1};
    method = param{2};
end
%% algorithm
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
fun_median = @medianblock;
if method == 1
	B = blkproc(I,[r,c],fun_avg); % 分块处理
	%M = blkproc(I,[r,c],fun_median);
	%size(B)
elseif method == 2
	B = blkproc(I,[r,c],[r_d4,c_d4],fun_avg);	%overlapped, Note: Padding with zero on the boundary
    % (m+2*mborder)-by-(n+2*nborder) B = blkproc(A,[m n],[mborder nborder],fun)
	%M = blkproc(I,[r,c],[r_d4,c_d4],fun_median);	%overlapped, Note: Padding with zero on the boundary
end
Median = median(B(:)); %中值
H = B>=Median;	% Hash
H = H(:)'; % 行向量
%% method 3 4? 没怎么太看明白





