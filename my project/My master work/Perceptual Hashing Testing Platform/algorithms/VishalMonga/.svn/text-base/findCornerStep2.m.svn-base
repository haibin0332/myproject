
function [sps] = findCornerStep2(X,fac,npts,HGF,C,HM,ANG, ...
                              k,kr,kn,cl,st,halfSurSize)
             
% FINDCORNERSTEP2 Using inputs from the results of findCornerStep2
%                 employs adaptive thresholding and other user defined  
%                 criterion to generate and return final feature points
%
% Description
% [sps, fig] = findCornerStep2(X,fac,npts,HGF,C,HM,ANG, ...
%                              k,kr,kn,cl,st,halfSurSize) 
%
% Algorithm I/O:
%   X: image
%   fac: enlagement for diplay
%   npts: significant points required
%   HGF: how good is the fit
%   C: averages over squares size 2k+1
%   HM: number of sign changes around squares
%   ANG: angles in discrete sizes - 2kr is \pi/2, 4kr max
%   k: half size of square to fit locally
%   kr: size of square for changes, may be any
%   kn: the minimum allowed distance between SP candidate and straight line
%   cl: determines the interval, where the angle between SP candidate's edges has to be from
%   st: maximum allowed curvature divergence for straight line candidates 
%   sps: boolean matrix as X where points are
%   halfSurSize: half of the size of the surroundings of a maximum where no other maximum should be found
%
%   See Also FINDCORNERSTEP1
%
% Ref: 
% V. Monga and B. L. Evans, "Robust perceptual image hashing
% using feature points," Proc. IEEE Conf. on Image Processing, 
% Oct. 2004.

% Authored 2005 by Vishal Monga
% Copyright (c) 1999-2005 The University of Texas
% All Rights Reserved.

ngl = 255;   %  length of colour map, decrease if problems ...
[m,n] = size(X);

txtp = [' k=' int2str(k) ' kr=' int2str(kr) ' kn=' int2str(kn)]; 
txt = str2mat(['Almost (' int2str(cl) ') right angles kn away from' ...
        ' almost (' int2str(st) ') straight lines']); 

allpts = abs((ANG-2*kr)) <= cl;       % must yet remove neighbours:
sn =- kn:kn;
zz = zeros(m,n);
tt = ANG>=4*kr-st;
maska = ones(2*kn+1,2*kn+1)/(2*kn+1)^2;
zz = conv2(double(tt),maska,'same')>0;
allpts = allpts&(~zz);

%  now prune unless already done
sps = choseImpPointsWithoutZeros(X,allpts.*HGF,npts,halfSurSize);
  
% always display
%txt = str2mat(txt,txtp);
%fig = dispimgs(X,fac,txt,ngl,sps,max(sps(:)));

