%{
������ 
	testImages:	������Ϣ��mat�ļ������Ϊ�գ��򴴽�һ���������Ϊ�գ���׷�ӡ�
		testImages = struct('imOriginal',{},'imAttacked',struct('attMethod',{},'attStrength',{},'imSaved',{}));
		�����׷�ӵ��������indir��û���õģ�outdir����ָ��testImages��·��
	attMethods:	����������
		attMethods = struct('attMethod',{},'attFunction',{},'strength',{});

	mba_attack
%}
attMethods = struct('attMethod',{},'attFunction',{},'strength',{},'params',{});
attackPlan = struct('indir',{},'outdir',{},'attMethods',{},'testImages',{});
%% testImagesΪ�յ����

indir = fullfile(mbenchpath,'indir\TestImages');
outdir = 'F:\bmpbase';
getInputs_allAttMethods;		% attMethods �б��������еĹ�����ʽ
attMethods = attMethods(4);	% ѡ�񼸸� 

testImages = '';
%load(fullfile(outdir , 'testImages.mat'));%test for append

attackPlan(1).indir = indir;
attackPlan(1).outdir = outdir;
attackPlan(1).attMethods = attMethods;
attackPlan(1).testImages = testImages;

%% ׷�ӵ���� ��׷�ӵ�����£���ʹ��testImages�еľ�����һ��֮���ͼ����Ϊԭͼ
% indir = '';
% outdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
% 
% getInputs_allAttMethods;		% attMethods �б��������еĹ�����ʽ
% attMethods = attMethods([1 4]);	% ѡ�񼸸� 
% 
% testImages = fullfile(outdir, 'testImages.mat');
% 
% attackPlan(1).indir = indir;
% attackPlan(1).outdir = outdir;
% attackPlan(1).attMethods = attMethods;
% attackPlan(1).testImages = testImages;
%%׷�ӵ���������Ŀ¼Ҫ��������misc/ʱ�䡱��һ��

%% 
% clear