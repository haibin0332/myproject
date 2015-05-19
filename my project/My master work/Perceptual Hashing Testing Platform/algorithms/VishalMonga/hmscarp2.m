function [HM,ANG,POS1,POS2]=hmscarp2(X,C,k,kr,fil)

% HMSCARP2 Computes the number of sign changes around a candidate feature point   
%          Returns that with angle and smoothing information
%          
% Description
% [HM,ANG,POS1,POS2]=hmscarp2(X,C,k,kr,fil) 
%
% Algorithm I/O:
%   X: image
%   C: averages over squares size 2k+1
%   k: half size of square to fit locally    
%   kr: size of square for changes may be any
%   fil: 1D filter for smoothing curves
%   HM: number of sign changes around squares
%   ANG: angle between edges (index length)
%   POS1,POS2: source for ANG
%
%   See Also WHSCARP, HGICF2IM
%
% Ref: 
% V. Monga and B. L. Evans, "Robust perceptual image hashing
% using feature points," Proc. IEEE Conf. on Image Processing, 
% Oct. 2004.

% Authored 2005 by Vishal Monga
% Copyright (c) 1999-2005 The University of Texas
% All Rights Reserved.

if nargin<4, kr=k; end

[m,n]=size(X);
ktr=k;           %  edge size of computed results

if kr>k   
   C=C(kr-k+1:m-2*kr+k,kr-k+1:n-2*kr+k);
   ktr=kr;
end

N=-kr+1:kr;
Nb=kr-1:-1:-kr;
HM=zeros(m,n);
ANG=HM;
POS1=HM;
POS2=HM;
ST=zeros(8*kr+1,n-2*ktr);     %  for storing perimeter fns for a row
y=ktr+1:n-ktr; x=ktr+1:m-ktr;

for jx=x
  jc=1;
  Cr=C(jx-ktr,:);
  ST(jc,:)=X(jx-kr,y-kr)-Cr;
% bottom row right
  for jjy=N
    jc=jc+1;
    ST(jc,:)=X(jx-kr,y+jjy)-Cr;
  end
% right column up
   for jjx=N
    jc=jc+1;
    ST(jc,:)=X(jx+jjx,y+kr)-Cr;
  end
% top row left
  for jjy=Nb
    jc=jc+1;
    ST(jc,:)=X(jx+kr,y+jjy)-Cr;
  end
% left column down
   for jjx=Nb
    jc=jc+1;
    ST(jc,:)=X(jx+jjx,y-kr)-Cr;
  end
  [HMr,ANGr,POS]=whscarp(ST,fil);
  HM(jx,y)=HMr;
  ANG(jx,y)=ANGr;
  POS1(jx,y)=POS(1,:);
  POS2(jx,y)=POS(2,:);
end
