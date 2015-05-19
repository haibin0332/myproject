function [B] = att_histeq( imgin, imgout,strength,params )
%att_histeq ֱ��ͼ���⻯����
%{
����6: Histogram Equalization
histeq enhances the contrast of images by transforming the values in an intensity image, or the values in the colormap of an indexed
image, so that the histogram of the output image approximately matches a specified histogram.
J = histeq(I);
imshow(I)
figure, imshow(J)
figure; imhist(I,64)
ֱ��ͼ���⻯�����ֿ��Ե��ڵĲ�����һ����Ԥ��ָ����ֱ��ͼģʽ��һ����nֵ��
����nֵ��ʾ��ʾ���⻯֮�󣬻Ҷ�ֵ��ɢ�ĵȼ������Ҷȵȼ���������ȡֵ��Χ2-256����Ϊ2ʱ����ʾ��ֵ����nֵԽ��ֱ��ͼ��ԭͼ���ԽС��

���Ǵӹ����ĽǶ���˵���Ҷȵķֲ��ͻҶ�ȡֵ��ÿһ�������϶������˱仯��
%}  
if(isempty(imgin) | isempty(imgout) | isempty(strength))
    B = -1;
    error('��������Ƿ�');
end

% %��ȡԭͼ�ļ�������Ϊ����������ļ�����������Ҫ��������
% [tpath tfile ext] = fileparts(imgout);
% %�湥����ɵ�ͼ������(ȫ·��)
% imgout = fullfile(tpath,[tfile,'.jpg']);
im = imread(imgin);
im = histeq(im,strength);
imwrite(im,imgout);
B=1;
end
