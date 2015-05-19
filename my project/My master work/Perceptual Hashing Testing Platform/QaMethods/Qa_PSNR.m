function [PSNR] = Qa_PSNR(A,B)
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

MSE=sum(sum(R.^2))/(x*y); % MSE
% PSNR
if MSE>0 
    PSNR=10*log10(255^2/MSE); 
else 
    PSNR=Inf;
end;