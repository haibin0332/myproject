function [B] = att_substitute_signal( imgin, imgout,strength,params )
%% test inputs
% imgin = 'E:\MBench\outdir\imDatabase\OriginalImage\baby.bmp';
% imgout = 'E:\MBench\';
% strength = 60/512;
%% ʹ��һ�������Ŀ�����滻
%{
ʹ����һ��ͼ���һ�������滻Ŀ��ͼ�����Ӧ����
Strength�� ��ʾ�滻����ռԭͼ������ı���
Ҫ�������滻��ͼ�����ѡ��ģ��滻��λ�������ѡ���
��ƣ�
1�������滻��ͼ��ʹ��ͬ·��������ͼ�����ͬ·��û������ͼ��ʹ��Matlab���õ�ͼ��
2������ԣ���Ϊ����seed�����������Ҫseed��ͬ�ģ����ԣ�Ҫôÿ�����ʹ�ò�ͬ��seed��Ҫôʹ�ñ���������
3��ģ���߽磬���������Ա߽�����ľ��ұ仯
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
szSB = floor(szI .* strength);
% ����ķ�����������ô��λ��֮�����ȡ������
point = ceil((szI - szSB) .* rand(1,2));
maskSB = zeros(szI);
maskSB(point(1):point(1) + szSB(1),point(2):point(2) + szSB(2)) = 1;
% �滻
im(maskSB == 1) = sm(maskSB == 1);
% ģ���ı߽�
if min(szSB) >= 12 % ̫С��������滻��˼����
    for i = 10:-2:2 % ��ͼ�ﵽһ����ģ����Ч��
        maskBlur = zeros(szI);
        blurDegree = i; % �߽�����10�����ض�����ģ��
        if ~(point(1) - 10 <= 1 || point(2) - 10 <= 1 || point(1) + szSB(1) + 10 >= szI(1) || point(2) + szSB(2) + 10 >= szI(2))
            maskBlur(point(1) - blurDegree:point(1) + blurDegree,point(2):point(2) + szSB(2)) = 1;
            maskBlur(point(1) + szSB(1) - blurDegree:point(1) + szSB(1) + blurDegree,point(2):point(2) + szSB(2)) = 1;
            maskBlur(point(1):point(1) + szSB(1),point(2) - blurDegree:point(2) + blurDegree) = 1;
            maskBlur(point(1):point(1) + szSB(1),point(2) + szSB(2) - blurDegree:point(2) + szSB(2) +blurDegree) = 1;
        end
        % imshow(im);
        % ģ����Ե
        bm = zeros(szI);
        bm(maskBlur == 1) = im(maskBlur == 1);
        % ģ��
        f = fspecial('disk',3);
        % for i = 1:4
            bm(maskBlur == 1) = imfilter(bm(maskBlur == 1),f,'replicate');
            bm(maskBlur == 1) = imfilter(bm(maskBlur == 1),f,'replicate');
        % end
    end

    im(maskBlur == 1) = uint8(bm(maskBlur == 1));
end
%  imshow(im);
%% �湥����ɵ�ͼ������(ȫ·��)
imwrite(im,imgout);
B=1;
end
