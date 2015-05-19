 function [LMSE] = Qa_LMSE(A,B)
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

OP=4*del2(A);
LMSE=sum(sum((OP-4*del2(B)).^2))/sum(sum(OP.^2));
