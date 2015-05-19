function [SC] = Qa_StruContent(A,B)
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

Pk=sum(sum(A.^2));

Bs = sum(sum(B.^2));
if (Bs == 0)
	SC = Inf;
else
	SC=Pk/sum(sum(B.^2)); % SC
end;