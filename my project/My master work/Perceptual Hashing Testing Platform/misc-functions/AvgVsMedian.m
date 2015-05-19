%{
����ļ����ڲ��ԣ���ҪĿ���ǹ۲�ͼ��ֿ�֮�����Ⱦ�ֵ����ֵ�Ĺ�ϵ
��ͼ��⣺ 
	1��Ϊʲô�����ϵ���ȶ��ģ�
	2����ʲô���������������ϵ�Ĵ��ڣ�
	3�������ϵ�ܵ���Щ���ص�Ӱ�죿
	4��ͳ�ƽǶ���ν�����Щ���飿

������ 
	�ֿ飬mask�����ֵ����ֵ��������ͼ�����ʽ������ĸ��������Ϣ�����ڷ��������
%}
function AvgVsMedian(img,block)
%% test inputs
img = fullfile(cd,'016n.bmp');
block = 16; % 16*16 = 256

%% get inputs
I = imread(img);
% �ж����������������������£���΢ע��һ����ϾͿ����ˡ��ʴ���ȥ
%% mask generation
maskN = zeros(size(I));
m = size(I,1)/block;
n = size(I,2)/block;	%m,n��ʾ����ÿ��Ĵ�С	
for r = 1:size(I,1)
	for c =  1:size(I,2)
	 	x = ceil(r/m);
		y = ceil(c/n);
		maskN(r,c) = (x - 1) * block + y;
	end
end
%% calculate
% ��ÿһ���ֿ�����ֵ�;�ֵ
Avg = zeros(block);
M = zeros(block);
for r = 1:block
	for c = 1:block
		k = (r - 1) * block + c;
		Avg(r,c) = sum(sum(I(maskN == k)))/sum(sum(maskN == k));
% 		M(r,c) = median(median(I(maskN == k)));		
	end % end for c
end % end for r
M = median(median(Avg));
diff = Avg - M;
%% ��ͼ����Ƿֿ����Ӧ����ֵ��ֵ����Ϣ
figure; 
imshow(I);
axis([1 size(I,1) 1 size(I,2)])
axis on;
grid on;
h = gca;
set(h,'XTick',[1:m:size(I,1)]);
set(h,'XColor','white');
set(h,'YTick',[1:n:size(I,2)]);
set(h,'YColor','white');

% colormap gray
% colormap('default')

figure;
imagesc(Avg);
% colormap gray

figure;
imagesc(M);
% colormap gray

figure;
imagesc(diff);
% colormap gray

why


