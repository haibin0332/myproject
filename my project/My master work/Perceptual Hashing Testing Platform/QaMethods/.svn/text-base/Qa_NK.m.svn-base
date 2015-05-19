 function [NK] = Qa_NK(A,B)
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
NK=sum(sum(A.*B))/Pk; % NK
