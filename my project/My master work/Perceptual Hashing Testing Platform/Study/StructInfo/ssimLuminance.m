%%
%{
���������SSIM�����µ�ͼ�������
��SSIM�У�������ʵ��ĳ�������ڽ�����ĻҶȾ�ֵ��������Ϊ���ȷ������ڼ���SSIM index����ʵ��һ�����Ⱦ�ֵ���С�
���Ƶ�SSIM�ĶԱȶȺͽṹ�������ĳ�����ض��Եġ�
����pooling�������ǽ����ǵ��������ȡ��ֵ��

���ԣ��ú������� һ��������һ����С�ľ���

���ȣ���ʵ����һ����ͨ�˲�
%}
function lumiI = ssimLuminance(I)
%% test inputs
% img = imread('1.bmp');
% figure;imshow(img);
%% function
window = fspecial('gaussian',11,1.5); % window = ones(8);
window = window/sum(sum(window));
img = double(img);
mu = filter2(window,img,'same');
% figure;imshow(uint8(mu));
lumiI = mu;
end % end function