%{
参数： 
	testImages:	保存信息的mat文件。如果为空，则创建一个。如果不为空，则追加。
		testImages = struct('imOriginal',{},'imAttacked',struct('attMethod',{},'attStrength',{},'imSaved',{}));
		如果是追加的情况，则indir是没有用的，outdir用来指定testImages的路径
	attMethods:	攻击方法。
		attMethods = struct('attMethod',{},'attFunction',{},'strength',{});

	mba_attack
%}
attMethods = struct('attMethod',{},'attFunction',{},'strength',{},'params',{});
attackPlan = struct('indir',{},'outdir',{},'attMethods',{},'testImages',{});
%% testImages为空的情况

indir = fullfile(mbenchpath,'indir\TestImages');
outdir = 'F:\bmpbase';
getInputs_allAttMethods;		% attMethods 中保留有所有的攻击方式
attMethods = attMethods(4);	% 选择几个 

testImages = '';
%load(fullfile(outdir , 'testImages.mat'));%test for append

attackPlan(1).indir = indir;
attackPlan(1).outdir = outdir;
attackPlan(1).attMethods = attMethods;
attackPlan(1).testImages = testImages;

%% 追加的情况 在追加的情况下，将使用testImages中的经过归一化之后的图像作为原图
% indir = '';
% outdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
% 
% getInputs_allAttMethods;		% attMethods 中保留有所有的攻击方式
% attMethods = attMethods([1 4]);	% 选择几个 
% 
% testImages = fullfile(outdir, 'testImages.mat');
% 
% attackPlan(1).indir = indir;
% attackPlan(1).outdir = outdir;
% attackPlan(1).attMethods = attMethods;
% attackPlan(1).testImages = testImages;
%%追加的情况下输出目录要给定到“misc/时间”这一级

%% 
% clear