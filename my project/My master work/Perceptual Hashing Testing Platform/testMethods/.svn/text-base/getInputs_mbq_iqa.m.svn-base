%% test inputs
iqaPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'QaMethods',{},'includeAttacks',{},'includeImages',{});


iqaPlan(1).imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
iqaPlan(1).testImages = 'testImages';
iqaPlan(1).outdir = 'E:\DoctorThesis\MBench\Plan\outdir\iqa';
iqaPlan(1).customedOutName =

getInputs_allQaMethods
iqaPlan(1).QaMethods = QaMethods([12]); % 选择Qa方法       1:8 10:end

load(fullfile(iqaPlan(1).imdir,iqaPlan(1).testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};

iqaPlan(1).includeAttacks = allAttacks([1:end]);	% 选择攻击类型
iqaPlan(1).includeImages = allImages([1:38]); % 选择图像

clear testImages QaMethods allAttacks allImages

%{
 'Watson_38images' 的时候，3 9 30 三张图片因为掩蔽会出现全零的块，导致求距离的时候除零。最后通过给零值加上一个很小的数解决，但形成几个奇异点。
%}
