%{
	Դ�ԡ���Ϣ���ؼ���ʵ��̡̳��ڰ���
	����csf_pqs�ļ�Ȩ����� WSNR Weighted Signal to Noise Ratio
use:
	csf_pqs.m
%} 
function wsnrvalue = Qa_WSNR(original, test)
%% test inputs
% original =  '7-NormalizedOriginalImage-.bmp';
% test = '7-jpg-20.jpg';

%% function
% ��ȡͼ�񲢴������ȹ�ϵ 
A = imread(original);
if isgray(A) ~= 1 && isrgb(A) == 1
	I = rgb2gray(A);
elseif isgray(A) ==1
end
A = double(A);
B = imread(test);
if isgray(B) ~= 1 && isrgb(B) == 1
	I = rgb2gray(B);
elseif isgray(B) ==1
end
B = double(B);
% ���Size
[m,n] = size(A);
[m2,n2] = size(B);
if m2~=m || n2~=n
	error('ͼ���С��һ');
end 
if A == B
	error('ͼ����ȫһ������Ҫ�Ҹ�ʲô�������أ�');
end
% ����ʧ���
e = A - B;
% CSF �˲� 
filtercoefficients = csf_pqs;
result = filter2(filtercoefficients, e);
% ���������
result2 = result^2;
wsnrvalue = 10*log10((255^2)/(mean(result2(:))));
disp(['����ͼ���WNSRΪ: ', num2str(wsnrvalue), ' dB']);
% ����ͼ���WNSRΪ: 52.0113+13.6438idB ���� Ϊʲô����������� ����
