% test input
I = '.\Qass\1.bmp';
I = imread(I);



%% 测试关于模糊的攻击算法

[M,N]=size(I);
I = double(I)/255;	
% 变成double类型可以获得更大的数据精度，/255归一化到0-1之间， 如果没有这个过程，后面的卷积过程将产生小数，
% 导致矩阵变成不可识别的图像类型。这个可以从 im2double
% 看出，这个函数将uint8的图像转换成0-1之间的double数组，正如上面的命令完成的。
% 与这个相反的命令是 mat2gray ，可以在需要将大于double型数据转化为0-1之间的灰度时使用。
% 而 im2uint8 将0-1 之间double数据类型的灰度图转化为0-255的灰度图。

% 总之，灰度图在0-1之间保存为double型，在0-255之间保存为整形

% 但是后面的imwrite为什么可以如此聪明可以自动将0-1的double图转化为0-255的灰度图呢？ 

B = reshape(I,M,N);		% 原书中的代码，其实对A的尺寸没有影响，但是这个指令也不同于B=A，因为matlab中，赋值命令并不马上产生拷贝。但是虽然不产生拷贝，也不会对后面的赋值产生影响，写书这小子zhurou吃多了？想不透
blur=1/44*[1 1 2 1 1;1 2 2 2 1;2 2 8 2 2;1 2 2 2 1;1 1 2 1 1];

for i = 1:1 % 模糊3次
	Xe=zeros(M+4,N+4);	% 扩充原图，并填充边缘
	Xe(3:M+2,3:N+2)=B;
	Xe(1,3:N+2)=B(1,1:N);
	Xe(2,3:N+2)=B(1,1:N);
	Xe(M+3,3:N+2)=B(M,1:N);
	Xe(M+4,3:N+2)=B(M,1:N);
	Xe(3:M+2,1)=B(1:M,1);
	Xe(3:M+2,2)=B(1:M,1);
	Xe(3:M+2,N+3)=B(1:M,N);
	Xe(3:M+2,N+4)=B(1:M,N);
	Xe(1:2,1:2)=B(1,1);
	Xe(M+3:M+4,N+3:N+4)=B(M,1);
	Xe(1:2,N+3:N+4)=B(1,N);
	C=conv2(Xe,blur,'valid');	% 图像大小会变化，但是刚好变回到原图大小
	B=C;
	figure;
	imshow(B);
end
imwrite(B,'.\Qass\1-blur.bmp');	%这个写入过程会自动 * 255，转化为uint8类型的灰度图，也会损失信息。
Bblur = imread('.\Qass\1-blur.bmp');
whos Bblur

%% 上述 测试关于模糊的攻击算法 过程使用imfilter来处理应该更为简单
D = reshape(I,M,N);		% 原书中的代码，其实对A的尺寸没有影响，但是这个指令也不同于B=A，因为matlab中，赋值命令并不马上产生拷贝。但是虽然不产生拷贝，也不会对后面的赋值产生影响，写书这小子zhurou吃多了？想不透
blur=1/44*[1 1 2 1 1;1 2 2 2 1;2 2 8 2 2;1 2 2 2 1;1 1 2 1 1];

D = imfilter(I,blur,'replicate','same','corr');
figure; imshow(D);
whos D