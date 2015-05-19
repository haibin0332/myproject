function [H,C]=hgicf2im(X,k)

% HGICF2IM - Evaluates the quality of a constant fit to an image area
%            (HGICF2IM - how good is the costant fit to the image)
%
% Description
% [H,C]=hgicf2im(X,k)
%
% Algorithm I/O:
%   X: image
%   C: averages over squares size 2k+1
%   H: fit goodness over squares
%   k: half size of square to fit locally    
%
%   See Also WHSCARP, HMSCARP2
%
% Ref: 
% V. Monga and B. L. Evans, "Robust perceptual image hashing
% using feature points," Proc. IEEE Conf. on Image Processing, 
% Oct. 2004.

% Authored 2005 by Vishal Monga
% Copyright (c) 1999-2005 The University of Texas
% All Rights Reserved.

N = -k:k;
[m,n] = size(X);
C = zeros(m-2*k,n-2*k);
H = C;
y = k+1:n-k; x=k+1:m-k;

for jx=N
   for jy=N
      C=C+X(x+jx,y+jy);
   end
end
C=C/(2*k+1)^2;
for jx=N
   for jy=N
      H=H+(X(x+jx,y+jy)-C).^2;
   end
end

