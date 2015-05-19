%{
	没有归一化距离
		因为不知道如何解释距离的计算方式， 所以不知道如何归一化 
	param
		暂时没有用到
%}
function [Distance] = match_VishalMonga(hashVec1, hashVec2, param)
v = (hashVec1 - hashVec2)/(2*sqrt(norm(hashVec1)*norm(hashVec2)));
Distance = norm(v);

%{
关于上面的距离公式：
可以理解为依然是求欧式距离，不过用他的分母进行了归一化而已：） 

问题是为什么要选择用这个来归一化？？？
%}

%{ 
关于范数
The norm of a matrix is a scalar that gives some measure of the magnitude of the elements of the matrix.
norm(x) is the Euclidean length of a vector x. 
norm(x) is equal to norm(x,2)

sqrt(0+1+4+9)   % Euclidean length
ans =
    3.7417

norm(x)
ans =
    3.7417
下面的例子更加清楚的说明了欧式距离的概念
x = [0 1]
x =
     0     1
y = [1 0]
y =
     1     0
norm(x)
ans =
     1
norm(y)
ans =
     1
norm(x-y)
ans =
    1.4142

%}
