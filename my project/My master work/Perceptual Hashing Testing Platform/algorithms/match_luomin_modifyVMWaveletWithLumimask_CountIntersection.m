%% ��������ͼ��Ĺ�ϣֵ֮��ľ��룬���������������ͼ��Ĺ�ϣֵ���������������֮��ľ���
%{
���ƥ��ķ����Ǽ���������ϣֵ֮�佻��ĸ�������Ϊhashֵ���������֣�һ����Ϊ���Ⱦ�ֵ������������Ϊ���Ϻͼ�ȥ�ڱε����Ⱦ�ֵ��
����Ѽ��Ϻͼ�ȥ�ڱ�֮��ľ�ֵ������Ӧͼ����Խ��ܵĸı�����ޣ���ô������������Ǽ������ǻ������ڶԷ����޷�Χ�ڵĸ���
%}
function distance = match_luomin_modifyVMWaveletWithLumimask_CountIntersection(hashReference,hashTest,params)
interOT = hashReference(:,1) <= hashTest(:,2) & hashReference(:,1) >= hashTest(:,3);
interTO = hashTest(:,1) <= hashReference(:,2) & hashTest(:,1) >= hashReference(:,3);
% method 1 ֻҪ��һ��������һ����Χ����Ϊ������� �ܳ�Ϊsize
% countIntersection = sum(xor(interTO,interOT));
% distance = 1 - countIntersection/size(hashTest,1);
% method 2 �ֳ������ȼ���һ��������һ����Χ�ڣ�ȨΪ1�������˴�����Է���Χ֮�ڣ�ȨΪ2 �ܳ�Ϊsize��2
countIntersection = sum(plus(interTO,interOT));
distance = 1 - countIntersection/(2*size(hashTest,1));
