function [B] = att_blur_disk( imgin, imgout,strength,params )
%att_blur_disk ģ������
%{
����5: ģ��
h = fspecial('disk',radius) returns a circular averaging filter (pillbox) within the square matrix of side 2*radius+1.
The default radius is 5.
����ǿ�ȸĳɴ��ڴ�С
%}
if(isempty(imgin) | isempty(imgout) | isempty(strength))
    error('��������Ƿ�');
end

% %��ȡԭͼ�ļ�������Ϊ����������ļ�����������Ҫ��������
% [tpath tfile ext] = fileparts(imgout);
% %�湥����ɵ�ͼ������(ȫ·��)
% imgout = fullfile(tpath,[tfile,'.jpg']);
im = imread(imgin);
f = fspecial('disk',strength);
im = imfilter(im,f,'replicate');

% ������ǰʹ��ģ�������ķ�ʽ������
% for i = 1 : strength
%     im = imfilter(im,f,'replicate');
% end
imwrite(im,imgout);
B = 1;
end
