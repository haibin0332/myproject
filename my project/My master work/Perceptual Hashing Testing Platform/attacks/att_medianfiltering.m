function [B ] = att_medianfiltering( imgin, imgout,strength,params )
%att_medianfiltering ��ֵ�˲�
%{
����4: ��ֵ�˲�
Median filtering is a nonlinear operation often used in image processing
to reduce "salt and pepper" noise. Median filtering is more effective than
convolution when the goal is to simultaneously reduce noise and preserve edges.

B = medfilt2(A) performs median filtering of the matrix A using the default 3-by-3 neighborhood.
ǿ�ȸĳɴ��ڴ�С����ǰ�ô���������
%}
if(isempty(imgin) | isempty(imgout) | isempty(strength))
    error('��������Ƿ�');
end

% %��ȡԭͼ�ļ�������Ϊ����������ļ�����������Ҫ��������
% [tpath tfile ext] = fileparts(imgout);
% %�湥����ɵ�ͼ������(ȫ·��)
% imgout = fullfile(tpath,[tfile,'.jpg']);
im = imread(imgin);
im = medfilt2(im,[strength strength]);
% for i = 1 : strength
%     
% end
    imwrite(im,imgout);
B = 1;
end
