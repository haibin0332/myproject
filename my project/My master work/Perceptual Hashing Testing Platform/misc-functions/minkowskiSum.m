function [minkowskiDistance] = minkowskiSum(DisVect,beta)
% �����ʵ��������������˹���ͣ����Ǿ����Ķ��ģ�
% �Ķ����ǣ� ��͵�ÿ��Ԫ�ض�ȡ���������֮��Ľ����ȡ����
%% test inputs
% x1 = [1, 1]
% x2 = [2, 3]
% DisVect(1) = {x1};
% DisVect(2) = {x2};
% 
% beta = 2;

%% modified minkowski summation
x = zeros(size(DisVect{1}));
for k = 1:length(DisVect)
	v = DisVect{k};
	v = 1./v;
	v = v.^beta;
	v = v + x;
	x = v;
end % end for k
v = x.^(1/beta);
minkowskiDistance = 1./v;

end
