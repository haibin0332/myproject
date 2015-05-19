function [minkowskiDistance] = minkowskiSum(DisVect,beta)
% 这个其实不是真正的明科斯基和，而是经过改动的，
% 改动就是： 求和的每个元素都取倒数，求和之后的结果再取倒数
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
