%{
针对提取的hash执行 interclass 测试
interclass测试是为了评估图像的区分性，所以，主要是计算两幅不同的图之间的距离。
根据原图个数，如果只在原图之间进行测试的话，一幅图与其他图之间的比较总共有 n(n-1)次。
而如果把受攻击之后的图也作为interclass测试的样本，理论上是可以的，但事实上有两个缺点：
	1、攻击强度不大的图之间的比较，与原图的直接比较没有区别
	2、攻击强度太大的图有可能会产生太多的临近hash值，破坏数据的随机性

interClass测试的结果有两个用处：
	1、直接用于观察结果的分布，对于归一化的汉明距（BER）的情况，这个分布应该以0.5为中心分布，可以画出
相应的直方图，这个直方图可以用于观察区分性。
	2、用于ROC曲线的绘制

对于interclass测试数据用于ROC的情况，需要考虑的问题有： 
	1、ROC曲线针对某种攻击的某种强度进行绘制，interclass数据来源于interclass测试数据中的某一列，
即有多少幅图像参与测试，就有多少个样本数据。但是interclass测试数据却和攻击方法和强度无关，只与
提取方式（算法）相关。
	2、interclass的样本个数为n，interclass的样本为n(n-1)。样本个数不均衡，往往
interclass数据会太少。虽然如此， 在interclass的测试中，依然不需要选择图像，因为图像多总会没错的。
	3、interclass只与提取方法相关，所以，interclass的数据可以在各个ROC曲线的绘制中复用。

为了避免参数太复杂，不在此处画interclass结果的散点图或者直方图，但是在 getInputs_mbt_interclasstest  中给出示例

输入： 
	interClassTestPlan
		interClassTestPlan = struct('workdir',{},'extractedImages',{},'extractedImagesName',{},'customedOutName',{},...
								'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{});
			workdir
				保存 extractedImages 的路径，这个路径可以视作针对某一个算法进行测试的工作路径，今后产生的结果都保存在这里
			extractedImages
				mat 文件名， 比如：“extractBy-mbe_yanan”
			customedOutName
				不同测试目的可能会产生多个不同的 interClassTest 结构，这个名称用于标识这种不同。
				如果没有特殊要求，这个参数可以为空。因为 过程会自动产生一个 名称。
			algfun
				算法的函数，比如： mbe_yanan 
			matchfun
				函数指针： @match_yanan 如果是最普通的汉明距，那么输入为空，相应的DistRange为【0，1】
			params
				匹配函数可能需要使用的参数
			normalizedDistRange
				表示matchfun的返回是否经过了normalize。如果为空，表示没有经过Normalize,如果不为空，应该指出大小范围，如： [0,1]
输出：
	savemat: 产生的输出，应该是保存相关信息的mat文件
%}

function [savemat] = mbt_interclasstest(interClassTestPlan)
%% test input
%  getInputs_mbt_interclasstest

%% get inputs
workdir = interClassTestPlan(1).workdir;
extractedImages = interClassTestPlan(1).extractedImages;
customedOutName = interClassTestPlan(1).customedOutName;
matchfun = interClassTestPlan(1).matchfun;
params = interClassTestPlan(1).params;
% includeAttacks = interClassTestPlan(1).includeAttacks;
% includeImages = interClassTestPlan(1).includeImages;
if ~isstruct(extractedImages)
    hashmatfile = fullfile(workdir,extractedImages);
    load(hashmatfile);
end

%% 
interClassTest = struct('interClassTestPlan',{},'interDistances',{});
% interDistance 是一个大的列向量，长度为n(n-1)
% interDistances = zeros(length(extractedImages)*(length(extractedImages) -
% 1)/2,1);
nCounter = 0;
for r = 1:length(extractedImages)
	for c = r+1:length(extractedImages)
		rhashOriginal = extractedImages(r).hashOriginal;
		chashOriginal = extractedImages(c).hashOriginal;
		nCounter = nCounter + 1
		interDistances(nCounter) = findDistance(rhashOriginal,chashOriginal,matchfun,params);
	end % end for c
end % end for r
%% 
interClassTest = setfield(interClassTest,{1},'interClassTestPlan',interClassTestPlan);
interClassTest = setfield(interClassTest,{1},'interDistances',interDistances);
%% save outfile
if isempty(customedOutName)
	savemat = fullfile(workdir,['interTest-',interClassTestPlan(1).extractedImages]);
else
	savemat = fullfile(workdir,['interTest-',interClassTestPlan(1).extractedImages,'_',customedOutName]);
end
if exist(savemat,'file') ~= 0
	movefile(savemat, [savemat, '.bak']);
end 
save(savemat,'interClassTest');
end % end for function
%% find the distance between two hash values
function [NormalizedDistance] = findDistance(hashReference,hashTest,matchfun,params)
	if isempty(matchfun) % 对于绝大部分情况，汉民距就是这样的
		NormalizedDistance = sum(abs(hashReference - hashTest))/length(hashTest);
	else
		NormalizedDistance = matchfun(hashReference,hashTest,params);
	end
end