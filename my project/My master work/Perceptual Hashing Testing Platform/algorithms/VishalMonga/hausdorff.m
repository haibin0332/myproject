
function [haus] = hausdorff(A1,B1);

% HAUSDORFF  Computes the Hausdorff Distance between two sets of feature
%            points A1 and B1
%
% Description
% [haus] = hausdorff(A,B) Computes Hausdorff Distance between two sets of feature points
% A and B defined as: H(A,B) = max_{a in A) min_{b in B) ||a-b||     
% based on the algorithm in reference 2.
%
% Ref:
% 1.) V. Monga, D. Vats and B. L. Evans, ``Image Authentication Under Geometric 
% Attacks Via Structure Matching'', Proc. IEEE Int. Conf. on Multimedia and Expo, 
% pp. 200-203, Netherlands, 2005.
% 2.) W. J. Rucklidge, "Locating objects using the hausdorff distance," IEEE
% Int. Conf. on Computer Vision, 1995.

% Authored January 2005 by Divyanshu Vats, modified by Vishal Monga
% Copyright (c) 1999-2005 The University of Texas
% All Rights Reserved.

sizea = length(A1.x);
sizeb = length(B1.y);
% sizeb % 很多没有取到特征点的情况 
Ax = (A1.x)/std(A1.x);
Ay = (A1.y)/std(A1.y);

Bx = (B1.x)/std(A1.x);
By = (B1.y)/std(A1.y);

% sizeb ==0 情况 没有取到特征点
if sizeb == 0
	haus = max(abs(Ax));
	return;
end
% 第40张图片竟然出现sizea == 0的情况，这意味着在原图上也没有取到特征点
if sizea == 0
	haus = 0;
	return;
end
%% computing h(A,B)
hab = 0;

for i = 1:sizea
    j = 1:sizeb;
    
    dd = ((Ax(i) - Bx(j)).^2 + (Ay(i) - By(j)).^2).^(0.5);
    shortab(i) = min(dd);
end

al = 0.75;
jj = sort(shortab);
hab = sum(shortab)/sizea;

%% computing h(B,A)
hba = 0;
for i = 1:sizeb
    j = 1:sizea;

    dd = ((Ax(j) - Bx(i)).^2 + (Ay(j) - By(i)).^2).^(0.5);
    shortba(i) = min(dd);
end
jj = sort(shortba);

hba = sum(shortba)/sizeb;

haus = max(hab,hba);

