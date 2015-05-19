%{
����������ڻ�ͼ
���������ͼ��������в�ͬ��ͼ��ʹ��ѡ����Qa����ִ��һ��intraClass���ԣ����һ�����Ӧ��ֱ��ͼ��
Ŀ����Ϊ�˹۲�Qa�����Բ�ͬͼ��֮�����ֵĽ���ķֲ���ȷ����ȡֵ����Ч�߽硣

���룺
	plotparameters ��ͼ������
		plotparameters = struct('imdir',{},'testImages',{},'QaMethods',{},'showimage',{},'saveimageto',{},'saveformats',{});
			showimage
				�Ƿ�����Ļ����ʾfigͼ��
			saveimageto
				������ͼƬ���浽ʲô�ط�
			saveformats
				ָ�������ͼ���ʽ
�����
	���ͼ�񱣴��·��

%}

function [savemat,outPath,minDistance,centerDistance] = mbp_intraQa(plotparameters)
%% test Inputs
getInputs_mbp_intraQa
%% parse input parameter
imdir = plotparameters.imdir;
testImages = fullfile(imdir,plotparameters.testImages);
QaMethods = plotparameters.QaMethods;
showimage = plotparameters.showimage;
saveimageto  = plotparameters.saveimageto;
saveformats = plotparameters.saveformats;
includeImages = plotparameters.includeImages;
if ~isstruct(testImages)
	load(testImages);
end 
if ~ischar(imdir)
	error('need a dir!');
end
qafun = QaMethods.QaFunction;
params =  QaMethods.params;
%% 
% intraDistance ��һ�����������������Ϊn(n-1)
imCount = length(includeImages);
intraDistances = zeros(imCount*(imCount - 1)/2,1);
nCounter = 0;
for r = 1:imCount
	for c = r+1:imCount
		rimgOriginal = testImages(r).imOriginal;
		rimgOriginal = fullfile(imdir,rimgOriginal);	
		cimgOriginal = testImages(c).imOriginal;
		cimgOriginal = fullfile(imdir,cimgOriginal);
		%% ����һ�������ڲ��õ���ƣ���Watson��intra�У������ͼ���С��ͬ�����
		rimgOriginal = imread(rimgOriginal);
		if size(rimgOriginal) == [256,256]
			rimgOriginal = imresize(rimgOriginal,[512 512]);
		end
		cimgOriginal = imread(cimgOriginal);
		if size(cimgOriginal) == [256,256]
			cimgOriginal = imresize(cimgOriginal,[512 512]);
		end
		%%
		if isempty(params)
			QaValue = feval(qafun,rimgOriginal,cimgOriginal);	
		else
			QaValue = feval(qafun,rimgOriginal,rimgOriginal,params);	
		end
		nCounter = nCounter + 1
		intraDistances(nCounter) = QaValue;
	end % end for c
end % end for r
%% savemat
outPath = saveimageto;
if isdir(outPath) ~= 1
	mkdir(outPath);
end
savemat = fullfile(outPath,['IntraTest-',QaMethods.QaMethod]);

if exist(savemat,'file') ~= 0
	movefile(savemat, [savemat, '.bak']);
end 
save(savemat,'intraDistances');
%% ��ͼ������
f = figure('Visible','off');
% һ�ַ�ʽ
%nbins = 100;	% ָ��ֱ��ͼ����
% [n,xout] = hist(intraDistances,nbins)	% ������Եõ��ֲ��ľ�����ֵ
% hist(intraDistances,nbins)			% �����ͼ
ksdensity(intraDistances,'npoints',100,'support','positive','kernel','box');
[f,xi,u] = ksdensity(intraDistances,'npoints',100,'support','positive','kernel','box');
peak = max(f);
index = find(f == peak); 
center = xi(index);
%% ���������Watson���������ݷֲ��Ͽ����Ҽ�����������������Ƶģ�
%{
1����Ҫ�����Ϣ����Сֵ���ֲ�����
2��������
	min(intraDistances); % = 336.1811

	�ݹ���ȡ�ֲ����ģ�����ȥ�����ݼ��кܴ��С�Ķ��ҳ��ִ�����������ݣ�Ȼ������С��Χ��֪���ܹ������ֲ���ͼ�Σ���ȷ�����ġ�
	���� 38 ��ͼƬ��ʵ�飬 ���Ľ���� 828.7320
%}
%{
% ֱ�Ӷ�ԭʼ���ݻ�ͼ
ksdensity(intraDistances,'npoints',100,'support','positive','kernel','box');
% ���Կ���������ƫ����һ�����Ե���һ������
[f,xi,u] = ksdensity(intraDistances,'npoints',100,'support','positive','kernel','box');
peak = max(f);
index = find(f == peak); % = 1
center = xi(index); % =  263.0820
% ��Ϊ������ƫ��index = 1 �� index = 2 ���ܴ�����ȥ�� ���� 2����������
intra = intraDistances(intraDistances <= xi(2));
% �����۲�
ksdensity(intra,'npoints',100,'support','positive','kernel','box');
[f,xi,u] = ksdensity(intra,'npoints',100,'support','positive','kernel','box');
peak = max(f);
index = find(f == peak); % = 8
center = xi(index); % =  868.6944
% �۲�ͼ�񣬷��ִ���4000���Ѿ�ƽ��
intra2 = intra(intra <= 4000);
[f,xi,u] = ksdensity(intra2,'npoints',100,'support','positive','kernel','box');
ksdensity(intra2,'npoints',100,'support','positive','kernel','box');
peak = max(f);
index = find(f == peak); % = 13
center = xi(index); % =  828.7320
%}
minDistance = min(intraDistances);
centerDistance = center;
%% �����ǹ���figure�ĳ��洦��
grid on;
if strcmp(showimage, 'on') == 1
	set(f,'Visible','on');
end
imfile = fullfile(outPath,'histeq-intra-',QaMethods.QaMethod);
% ���imfile���е㣬matlab�Ὣ����Ĳ��ֿ�����׺���ɴˣ��ļ����ͺ�׺��ʧЧ
imfile = strrep(imfile, '.','_');
if isempty(saveformats) ~= 1
	for k = 1:size(saveformats,1)
		if strcmp(saveformats(k,:),'fig')	
			% ����fig�����������Ҫ��ʾ�ٱ��棬����Ļ����ᵼ�´��ͼƬ�򲻿�����Ϊopenfigֻ���ؾ�������fig invisible����ô�Ͳ���ʾ
			% ��ʵ�ϣ���Ϻ����close all��matlabҲ���������ʾ��Щ��
			set(f,'Visible','on');
		end
		saveas(f,imfile,saveformats(k,:));				
	end
	close all;
end				