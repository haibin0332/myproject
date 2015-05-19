function [hashvector] = struct_sysx(imagefile,param)
%{
���ѡ�飬ԭͼ��ֵ��ʵ��������У���ؾ���
    Ŀ�ģ��۲������ص���������
    ƥ�䷽����SSIM��ƥ�䷽ʽ match_SSIM_lumi()
%}
%% test inputs
% imagefile = '1.bmp';
%% param
I = imread(imagefile);
numrects = 8;  
key = 101;
numdiffTimes = 4;
rand('state',key);
%% ����ֿ飬ԭͼ��ֵ
blocksInfo = randomBlockInfo(I,numrects,key,1/4,1/16,'',@avgblock);
%% �������
hashvector = multiTimesDiff(blocksInfo,numdiffTimes);

end % end function
%{
match_SSIM_struct��
test 1:
    256 1/16 1/32
test 2:
    256 1/4 1/16
test 3:
    8 1/4 1/16
���������Խ�ʾ�Ĺ����� struct_syeh ���ơ�����
��Խ�پ���Խ�ͣ����Ǽ�ʹ�� 8 * 4 = 32 bits���ȣ�������Ȼ�ܺ�
��Խ��EERȷ������ֵԽ��
match_SSIM_lumi��
ͬ���������ԣ����ܺܺã��Բ���Struct�ġ�
match_SSIM_sumlumi��
����Ĳ��Խ���ܳ�����

���⣺SSIM�У�����ļ��㷽ʽ������ʲô���������⣿


%}