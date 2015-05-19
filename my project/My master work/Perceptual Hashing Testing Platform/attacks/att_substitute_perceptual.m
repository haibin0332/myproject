function [B] = att_substitute_perceptual( imgin, imgout,strength,params )
%% test inputs
% imgin = 'E:\DoctorThesis\MBench\outdir\imDatabase\OriginalImage\baby.bmp';
% imgout = 'E:\xx';
% strength = 500/3969;
%% ʹ��С������ĸ�֪��Ԫ�����滻
%{
ʹ����һ��ͼ���һ�������滻Ŀ��ͼ�����Ӧ����
Strength�� ��ʾ�滻��ʹ�õĸ�֪��Ԫ�ĸ���ռ���и�֪��Ԫ�ı��� 0-1��ʾ 1- 3969
��֪��Ԫ��512*512��ͼ�У���16*16��С��������32*32��Ϊ����ģ�31*31��Ϊoverlap�ģ�
�ο� Confusion/diffusion capabilities of some robust hash functions -- Baris Coskun 2006 �ķ�ʽ
Ҫ�������滻��ͼ�����ѡ��ģ��滻��λ�������ѡ���
��ƣ�
1�������滻��ͼ��ʹ��ͬ·��������ͼ�����ͬ·��û������ͼ��ʹ��Matlab���õ�ͼ��
2������ԣ���Ϊ����seed�����������Ҫseed��ͬ�ģ����ԣ�Ҫôÿ�����ʹ�ò�ͬ��seed��Ҫôʹ�ñ���������

������ƣ���¼��֪��Ԫ�ķֲ�����������ں������嵥Ԫ���ж�����ʱ��������嵥Ԫ�Ĺ���ǿ��
%}  
if(isempty(imgin) | isempty(imgout) | isempty(strength))
    B = -1;
    error('��������Ƿ�');
end
%%
% ��ȡԭͼ�ļ�·��
[tpath tfile ext] = fileparts(imgin);
% ���ѡ������һ���ļ�
ls = dir(fullfile(tpath,['*',ext]));
indexImgin = find(strcmp([tfile,ext],{ls.name}) == 1);
indexsImg = ceil((length(ls) - 1)*rand(1));
if indexsImg(1) == indexImgin % ���Imgin�����һ������ô��������ȣ�����������һ�����Ϳ��Լ�1
    indexsImg = indexImgin(1) + 1;
end
sImg = ls(indexsImg).name;
% ����
im = imread(imgin);
sm = imread(fullfile(tpath,sImg));
% ����С�������ˣ���ΪĿǰ�Ŀ���¶�Ӧ�����
%% ����ģ�壬ֻ��Ҫ����λ�õ����������λ���ܵ���С������
szI = size(sm);
% ����strength���滻ͼ�����ѡ���
pbnumbers = ceil(strength * 3969);
randomBlocks = randperm(3969);
pbselected = randomBlocks(1:pbnumbers);
% ֻ��Ҫ�����ļ�����pbselected�Ϳ��Իָ������û���������Ϣ
[outpath outfile ext] = fileparts(imgout);
save(fullfile(outpath,[outfile,'.mat']),'outfile','pbselected');
% ��pbselectedΪ��Ų���mask��
% �����Ƕ�������
maskSB = zeros(szI);
for i = 1:length(pbselected)
    cc = ceil(pbselected(i)/(32+31));
    ll = mod(pbselected(i),(32+31));
    if ll == 0
        ll = 63;
    end
    % ��һ�αȽϷ�˼��������һ�£�(32+31)^2=3969��������32^2+31^2=1985������һ������ص��ķ�ʽ����
    if cc <= 32 
        c = (cc - 1) * 16 + 1;
    else
        c = 8 + (cc - 32 - 1) * 16 + 1;
    end
    if ll <= 32
        l = (ll - 1) * 16 + 1;
    else
        l = 8 + (ll - 32 - 1) * 16 + 1;        
    end
    maskSB(c:c + 15,l:l + 15) = 1;
end    
% �滻
im(maskSB == 1) = sm(maskSB == 1);
% imshow(im);figure;imshow(sm);figure;imshow(maskSB);
%% �湥����ɵ�ͼ������(ȫ·��)
imwrite(im,imgout);
B=1;
end
