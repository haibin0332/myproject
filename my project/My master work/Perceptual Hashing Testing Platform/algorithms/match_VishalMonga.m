%{
	û�й�һ������
		��Ϊ��֪����ν��;���ļ��㷽ʽ�� ���Բ�֪����ι�һ�� 
	param
		��ʱû���õ�
%}
function [Distance] = match_VishalMonga(hashVec1, hashVec2, param)
v = (hashVec1 - hashVec2)/(2*sqrt(norm(hashVec1)*norm(hashVec2)));
Distance = norm(v);

%{
��������ľ��빫ʽ��
�������Ϊ��Ȼ����ŷʽ���룬���������ķ�ĸ�����˹�һ�����ѣ��� 

������ΪʲôҪѡ�����������һ��������
%}

%{ 
���ڷ���
The norm of a matrix is a scalar that gives some measure of the magnitude of the elements of the matrix.
norm(x) is the Euclidean length of a vector x. 
norm(x) is equal to norm(x,2)

sqrt(0+1+4+9)   % Euclidean length
ans =
    3.7417

norm(x)
ans =
    3.7417
��������Ӹ��������˵����ŷʽ����ĸ���
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
