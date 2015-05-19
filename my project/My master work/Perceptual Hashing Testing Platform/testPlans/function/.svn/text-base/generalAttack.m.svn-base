%{
参数： 
	testImages:	保存信息的mat文件。如果为空，则创建一个。如果不为空，则追加。
		testImages = struct('imOriginal',{},'imAttacked',struct('attMethod',{},'attStrength',{},'imSaved',{}));
		如果是追加的情况，则indir是没有用的，outdir用来指定testImages的路径
	attMethods:	攻击方法。
		attMethods = struct('attMethod',{},'attFunction',{},'strength',{});

	mba_attack
%}
function generalAttack(indir,outdir)
attMethods = struct('attMethod',{},'attFunction',{},'strength',{},'params',{});
attackPlan = struct('indir',{},'outdir',{},'attMethods',{},'testImages',{});
%
indir =  'E:\MBench\indir\TestImages';   % fullfile(mbenchpath,'indir\TestImages');
outdir = 'F:\imDatabase\TestImages';
%}

getInputs_allAttMethods;		% attMethods 中保留有所有的攻击方式
attMethods = attMethods(1:end);	% 选择几个 

testImages = '';
%load(fullfile(outdir , 'testImages.mat'));%test for append
attackPlan(1).indir = indir;
attackPlan(1).outdir = outdir;
attackPlan(1).attMethods = attMethods;
attackPlan(1).testImages = testImages;

mba_attack(attackPlan)
