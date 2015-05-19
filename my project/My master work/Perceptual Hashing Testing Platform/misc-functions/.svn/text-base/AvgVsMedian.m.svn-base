%{
这个文件用于测试，主要目的是观察图像分块之后，亮度均值与中值的关系
试图理解： 
	1、为什么这个关系是稳定的？
	2、是什么东西决定了这个关系的存在？
	3、这个关系受到那些因素的影响？
	4、统计角度如何解释这些事情？

方法： 
	分块，mask，求均值和中值，并且以图表的形式尽量多的给出相关信息，便于分析和理解
%}
function AvgVsMedian(img,block)
%% test inputs
img = fullfile(cd,'016n.bmp');
block = 16; % 16*16 = 256

%% get inputs
I = imread(img);
% 判断整除的情况，在试验情况下，稍微注意一下配合就可以了。故此略去
%% mask generation
maskN = zeros(size(I));
m = size(I,1)/block;
n = size(I,2)/block;	%m,n表示的是每块的大小	
for r = 1:size(I,1)
	for c =  1:size(I,2)
	 	x = ceil(r/m);
		y = ceil(c/n);
		maskN(r,c) = (x - 1) * block + y;
	end
end
%% calculate
% 对每一个分块求中值和均值
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
%% 画图，标记分块和相应的中值均值等信息
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


