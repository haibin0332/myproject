
function [HGF, Cex, HM, ANG, POS1, POS2] = findCornerStep1(X, f1, k, f2, kr)

% FINDCORNERSTEP1 Projects image onto a selected wavelet (end-stopped) basis   
%                 and computes positions, magnitude etc. of candidate
%                 feature points
%
% Description
% [HGF,C,HM,ANG,POS1,POS2] = findCornerStep1(X,f1,k,f2,kr) 
%
% Algorithm I/O:
%   X: input image
%   f1: filter to apply to X
%   k: half size of square to fit locally
%   f2: 1D filter to apply to per/funs for sign changes count
%   kr: size of square for changes, may be any
%   HGF: how good is the fit
%   C: averages over squares size 2k+1
%   HM: number of sign changes around squares
%   ANG: angle between edges (index length)
%   POS1,POS2: source for ANG
%
%   See Also FINDCORNERSTEP2
%
% Ref: 
% V. Monga and B. L. Evans, "Robust perceptual image hashing
% using feature points," Proc. IEEE Conf. on Image Processing, 
% Oct. 2004.

% Authored 2005 by Vishal Monga
% Copyright (c) 1999-2005 The University of Texas
% All Rights Reserved.

if prod(size(f1)) > 1, 
   X=conv2(X,f1,'same'); 
end

[HGF,C]=hgicf2im(X,k);
maxHGF=max(HGF(:));

[HM,ANG,POS1,POS2]=hmscarp2(X,C,k,kr,f2);

% complete C and HGF (zero border, same size as X)
[m,n]=size(X);
y=k+1:n-k; x=k+1:m-k;
tt=zeros(m,n);  Cex=tt;
Cex(x,y)=C;
tt(x,y)=HGF;  HGF=tt;
