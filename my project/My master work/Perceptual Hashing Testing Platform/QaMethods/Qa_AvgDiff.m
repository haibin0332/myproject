 function [AD] = Qa_AvgDiff(A,B)
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
R=A-B;

AD=sum(sum(R))/(x*y); % AD