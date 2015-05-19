function [HM,ANG,POSI]=whscarp(ST,fil)

% WHSCARP - Computes what sign changes around points (one row of pixels)
%               
% Description
% [HM,ANG,POSI]=whscarp(ST,fil)
%
% Algorithm I/O:
%   ST: columns contain perimeter functions, last row=first
%   fil: 1D filter to smooth the columns
%   HM: number of sign changes in each column
%   ANG: for two changes, distance (sharp angle) between them
%   POSI: actual positions of sign changes
%
%   See Also HMSCARP2, HGICF2IM
%
% Ref: 
% V. Monga and B. L. Evans, "Robust perceptual image hashing
% using feature points," Proc. IEEE Conf. on Image Processing, 
% Oct. 2004.

% Authored 2005 by Vishal Monga
% Copyright (c) 1999-2005 The University of Texas
% All Rights Reserved.

if nargin<2, fil=1; end

if length(fil) > 1
%    do the filtering here
end

[le,n]=size(ST);
le=le-1;             % no. of steps around "circle"
STsi = ST>=0 ;
STch = (STsi(1:le,:) ~= STsi(2:le+1,:));
HM = sum(STch);
ANG=zeros(1,n);
POSI=zeros(2,n);
for j=1:n
   if HM(j)==2
      tt=find(STch(:,j));
      ttt=tt(2)-tt(1);
      ANG(j)=min(ttt,le-ttt);
      POSI(:,j)=tt;
   end
end
