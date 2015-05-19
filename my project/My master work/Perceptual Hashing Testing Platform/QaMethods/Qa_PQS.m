function [PQS] = Qa_PQS(A,B)
if ischar(A)
    A=imread(A);
end;
if ischar(B)
    B=imread(B);
end;
if ~isa(A,'double')
    A=double(A);
end;
if ~isa(B,'double')
    B=double(B);
end;

x=size(A,2);
y=size(A,1);
if x==y
    % PQS
    PQS=pqs(A,B,x);		% pqs 如果接受两个完全相同的图，将产生错误。
else 
    PQS=0;
end;