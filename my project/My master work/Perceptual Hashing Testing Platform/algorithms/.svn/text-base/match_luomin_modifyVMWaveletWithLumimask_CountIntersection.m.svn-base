%% 计算两幅图像的哈希值之间的距离，输入参数是这两幅图像的哈希值，输出参数是它们之间的距离
%{
这个匹配的方法是计算两个哈希值之间交叉的个数，因为hash值包含三部分，一部分为亮度均值，另外两部分为加上和减去掩蔽的亮度均值，
如果把加上和减去掩蔽之后的均值视作相应图像可以接受的改变的容限，那么，这个方法就是计算他们互相落在对方容限范围内的个数
%}
function distance = match_luomin_modifyVMWaveletWithLumimask_CountIntersection(hashReference,hashTest,params)
interOT = hashReference(:,1) <= hashTest(:,2) & hashReference(:,1) >= hashTest(:,3);
interTO = hashTest(:,1) <= hashReference(:,2) & hashTest(:,1) >= hashReference(:,3);
% method 1 只要有一个落入另一个范围即认为是相近的 总长为size
% countIntersection = sum(xor(interTO,interOT));
% distance = 1 - countIntersection/size(hashTest,1);
% method 2 分成两个等级：一个落入另一个范围内，权为1；两个彼此落入对方范围之内，权为2 总长为size×2
countIntersection = sum(plus(interTO,interOT));
distance = 1 - countIntersection/(2*size(hashTest,1));
