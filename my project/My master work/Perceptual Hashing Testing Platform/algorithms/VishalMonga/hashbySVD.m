
function [hashVec] = hashbySVD(imgin, key, numRects, rectsize);

% HASHBYSVD Image Hashing by singular value decomposition
%  Description
%  [hashVec] = hashbySVD(imgin, key, numRects, size) extracts
%  hash vector hashVec from input image "imgin". The basic approach  
%  is to divide the image into random rectangles selected using 
%  the secret key "key" and obtain a singular value decomposition (SVD)
%  of each rectangle. "numRects" is the number of input rectangles and 
%  "rectsize" is the size of each rectangle. A random subset of the most 
%  significant singular vectors and singular values forms the hash. Details 
%  can be found in the reference below.
%
%	See also WAVELETHASH, FEATUREPOINTHASH
%
%	Ref: 
%   1.) S. S. Kozat, K. Mihcak, and R. Venkatesan, "Robust 
%   perceptual image hashing via matrix invariances", Proc. IEEE
%   Conf. on Image Processing, pp. 3443-3446, Oct. 2004.
%
% Authored 2005 by Vishal Monga
% Copyright (c) 1999-2005 The University of Texas
% All Rights Reserved.

siz = size(imgin,1);

rand('state',key);
xcoors = ceil(rand(numRects,1)*(siz-rectsize+1)); 
ycoors = ceil(rand(numRects,1)*(siz-rectsize+1)); 

umat = zeros(rectsize,2*numRects);
uumat1 = zeros(rectsize,numRects);
vvmat1 = zeros(rectsize,numRects);

for i=1:1:numRects,
   subim = imgin(xcoors(i):(xcoors(i)+rectsize-1),ycoors(i):(ycoors(i)+rectsize-1));
   tt = subim+randn(size(subim));    
   [u1,s1,v1] = svds(tt,1);
   uumat1(:,i) = sign(sum(u1))*u1;
   vvmat1(:,i) = sign(sum(v1))*v1;
end;
umat = [uumat1 vvmat1];


[u,s,v] = svds(umat,1);
u = sign(sum(u))*u;
v = sign(sum(v))*v;
hashVec = [u;v];

return;
