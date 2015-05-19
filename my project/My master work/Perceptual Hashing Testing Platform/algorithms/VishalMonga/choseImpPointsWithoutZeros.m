
function [IMP_POINTS] = choseImpPointsWithoutZeros(IMAGE, FROMTHESEVALUES, n, halfSurSize)

% CHOSEIMPPPOINTSWITHOUTZEROS  Choses a given number of the best significant points         
%
% Description
% Algorithm I/O:
% [IMP_POINTS] = choseImpPointsWithoutZeros(IMAGE, FROMTHESEVALUES, n, halfSurSize)
%   IMP_POINTS: the array of the resulting significant points
%   IMAGE: the image to be processed
%   FROMTHESEVALUES: the array from which the significant points are calculated
%   n: number of significant points
%   halfSurSize: half of the size of the surroundings of a maximum where no other maximum 
%                should be found

% Authored 2004-05 by Vishal Monga
% Copyright (c) 1999-2005 The University of Texas
% All Rights Reserved.

FROMTHESEVALUES = abs(FROMTHESEVALUES);
% --- choose a given number of maximum values: ---

IMP_POINTS = zeros(size(FROMTHESEVALUES)); 
[i, j] = find(FROMTHESEVALUES==max(FROMTHESEVALUES(:)));
k=1;

while (k <= n)&(FROMTHESEVALUES(i(1),j(1))>0)
   dr = max(1,(i(1)-halfSurSize)):min(size(IMAGE,1),(i(1)+halfSurSize));
   dc = max(1,(j(1)-halfSurSize)):min(size(IMAGE,2),(j(1)+halfSurSize));
	patch = IMAGE(dr,dc);
	zeroLoc = patch == 0;
   %	numOfZerosAround = sum(zeroLoc(:));
  	numOfZerosAround = 0;

   Answer = ((i(1)>halfSurSize)&(i(1)<(size(IMAGE,1)-halfSurSize))&(j(1)>halfSurSize)&(j(1)<(size(IMAGE,2)-halfSurSize)));
   if (numOfZerosAround == 0)&(Answer)
      k = k + 1;
      IMP_POINTS(i(1), j(1))  = 1;         
		FROMTHESEVALUES(dr,dc)=0;        
   else
   	FROMTHESEVALUES(i(1), j(1)) = 0;
   end           
   [i, j] = find(FROMTHESEVALUES==max(FROMTHESEVALUES(:)));
end 
