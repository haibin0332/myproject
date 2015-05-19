%{
	Դ�ԡ���Ϣ���ؼ���ʵ��̡̳��ڰ���
	PQS��CSF�˲������

���� �� 
	filtercoefficients = csf_pqs;
	result = filter2(filtercoefficients, I);
%}
function [filtercoefficients] = csf_pqs()
%% 
% ����Ƶ����Ӧ����
Fmatrix = csfmat;
% ����Ƶ����Ӧ
% figure(1); mesh(Fmatrix), title('Ƶ����Ӧ'),xlabel('ˮƽ����ռ�Ƶ��');ylabel('��ֱ����ռ�Ƶ��');zlabel('CSFƵ����Ӧ');
% ���� fsample2 ��������Ƶ��ϵ��
filtercoefficients  = fsamp2(Fmatrix);
why

%% �Ӻ���������Ƶ����Ӧ����
function Fmatrix = csfmat()
%%
u = -20:1:20;
v = -20:1:20;
n = length(u);
Z = zeros(n);
for r = 1:n
	for c = 1:n
		Z(r,c) = csffun(u(r),v(c)); % �����Ӻ���������Ӧ�ռ�Ƶ���µ�Ƶ��
	end
end
Fmatrix = Z;

%% �Ӻ���������u��v�µ�Ƶ����Ӧ
function Sa = csffun(u,v)
%% csf Ƶ����Ӧ
sigma = 2;
f = sqrt(u.*u + v.*v);
w = 2*pi*f/60;
Sw = 1.5*exp(-sigma^2 * w^2/2) - exp(-2 * sigma^2 * w^2/2);
% ��Ƶ����
theta = atan(v./(u + eps)); % eps = 2^{-52}, �Ǳ���0��һ������
beta = 8;
f0 = 11.13;
w0 = 2 * pi * f0/60;
Ow = (1 + exp(beta * (w - w0)) * (cos(2 * theta))^4) / ( 1 + exp(beta * (w - w0)));
% ���ս��
Sa = Sw * Ow;

