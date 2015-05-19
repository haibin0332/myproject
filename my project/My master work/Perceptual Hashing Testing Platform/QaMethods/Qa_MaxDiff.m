 function [MD] = Qa_MaxDiff(A,B)
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

R=A-B;
MD=max(max(abs(R))); % MD
