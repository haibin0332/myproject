%% getInputs_mbt_interclasstest
function [savemat] = mbt_interclasstest(interClassTestPlan)

interClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{});


interClassTestPlan(1).workdir = 'E:\PH1\mbe_yangbian';
interClassTestPlan(1).extractedImages = 'extractBy-mbe_bian.mat';
interClassTestPlan(1).customedOutName = '';
interClassTestPlan(1).algfun = 'extractBy-mbe_bian';
interClassTestPlan(1).matchfun = @match_yanan;
% interClassTestPlan(1).params = [2 64 0.71 1/4];	%method,n,r2,r1;
interClassTestPlan(1).normalizedDistRange = [0,1];

% %%
% 
 savemat = mbt_interclasstest(interClassTestPlan)

% %% �����ʾ����ʾ���ʹ�� mbt_interclasstest �Ľ������ֱ��ͼ
% workdir = 'E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\SVD';
% savemat = fullfile(workdir,'interTest-extractBy-mbe_VishalMonga_SVD.mat');
% load(savemat);
% % interClassTest = struct('interClassTestPlan',{},'interDistances',{});
% interDistances = interClassTest.interDistances;
% interClassTestPlan = interClassTest.interClassTestPlan;
% % ֱ��ͼ
% figure;
% nbins = 100;	% ָ��ֱ��ͼ����
% % һ�ַ�ʽ
% [n,xout] = hist(interDistances,nbins)	% ������Եõ��ֲ��ľ�����ֵ
% hist(interDistances,nbins)			% �����ͼ
% if ~isempty(interClassTestPlan.normalizedDistRange)	% �����һ���ˣ����������
% 	range = interClassTestPlan.normalizedDistRange;
% 	v = axis;
% 	v([1 2]) = range;
% 	axis(v);
% end
% grid on;
% 
% outPath = fullfile('E:\DoctorThesis\MBench\Plan\outdir\VishalMonga\SVD','Plot-histeq-inter-mbe_VishalMonga_SVD');
% if isdir(outPath) ~= 1
% 	mkdir(outPath);
% end
% imfile = fullfile(outPath,'histeq-inter-mbe_VishalMonga_SVD');
% % ���imfile���е㣬matlab�Ὣ����Ĳ��ֿ�����׺���ɴˣ��ļ����ͺ�׺��ʧЧ
% imfile = strrep(imfile, '.','_');
% saveas(gcf,imfile,'jpg');	
% 
% clear