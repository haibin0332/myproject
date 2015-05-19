%����Jpegѹ������
function [B] = att_jpeg(imgin, imgout,strength,params)
%{
����1��JPEGѹ��
JPEGѹ����Quality��0��100��
'Quality'   A number between 0 and 100; higher numbers mean higher quality (less image degradation due to compression), but the resulting file size is larger.
'Bitdepth'  A scalar value indicating desired bitdepth; for grayscale images this can be 8, 12, or 16; for color images this can be 8 or 12. 
%}
if(isempty(imgin) | isempty(imgout) | isempty(strength))
    error('��������Ƿ�');
end

%��ȡԭͼ�ļ�������Ϊ����������ļ�����������Ҫ��������
[tpath tfile ext] = fileparts(imgout);
%�湥����ɵ�ͼ������(ȫ·��)
imgout = fullfile(tpath,[tfile,'.jpg']);
%Jpegѹ��
im = imread(imgin);
imwrite(im,imgout,'Bitdepth',8,'Quality',strength);
B = 1;
end
                


