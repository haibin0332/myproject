function PQS=pqs(A,B,blok)
%Script that runs PQS (Picture Quality Scale) image quality measure?
%PQS = pqs(A,B,blok)
%Version: 2.01, Date: 2007/11/21, author: Nikola Sprljan
%
%Input: 
% A - array containing the original image or its filename
% B - array containing the compressed image or its filename
% blok - [optional, default = size(A,1)] size of the block that 
%        the compression algorithm uses. In a default case, when the function 
%        is called without the 'blok' parameter, the dimension of the input 
%        image is used instead (the whole image is treated as a block).
%
%Output: 
% PQS - Picture Quality Scale; number from range 0-5 specifying the quality of 
%       the compressed image (note that it can fall out of range 0-5!) 
%		这里说到PQS的输出值的范围，0-5，但是会超出。我的实测得到的全是负值。为什么？？ 
% 		pqs('2.bmp','g2.bmp')
% 		ans =
% 		   -1.9004
% 
% 		pqs('1.bmp','g1.bmp')
% 		ans =
% 		   -1.8065
% 
% 		pqs('11.bmp','g11.bmp')
% 		ans =
% 		   -5.3601
% 		pqs(A,A)			完全相同的两幅图，得到的值却是 5.7970
% 		ans =
% 			5.7970

%{
PQS原始README关于输出范围的描述，简单来说，就是大于5时，pqs取值没有意义，但可以肯定的说，大于的图像质量很poor。
或者按照我的猜测：大于5的取值，不具备稳定的意义，不线性了。
3. The regression coefficients used in PQS restricts its applicability
to data within the range of the test set.  That means that if any of
the weighted distortion factor values are outside the range of the MOS
scale [0,5], the PQS evaluation has little meaning.  However, a clear
statement can generally be made about the quality of the image when
weighted distortion factor values exceed their limits, i.e. the image
quality is poor.  Warnings are issued when the weighted contributions
are beyond the range of values obtained during the design of PQS.
%}
%Note:
% This function is based in on CIPIC PQS version 1 software. The DOS program 
% pqs.exe must be located in the subdirectory \Pqs. For more information refer 
% to \Pqs\README; just one important excerpt:
%  "PQS was designed and tested on 256 x 256 images...its use with other than 
%  256 x 256 images at 4 times picture height is shaky." 
% PQS works only for square images! 关于图像大小，这里给出了一个说法。
%
%Uses: 
% .\Pqs\pqs.exe (c) 1996, Robert R. Estes, Jr. and V. Ralph Algazi
%
%Example:牋
% PQS=pqs(A,B,8);
% PQS=pqs('Lena256.png','LenaSPIHT0.1bpp.bmp');?

%% test
% A = '11.bmp';
% B = 'g11.bmp';
% A=imread(A);  
% blok = size(A,1);
%% original code
if isstr(A)
  A=imread(A);   
 end;
 if isstr(B)
  B=imread(B);   
 end; 
 PQS = -1;
 if (size(A,1) ~= size(A,2))
   error('Works only for square images!');   
 end;
 siz=size(A,1);
 if nargin==2
  blok=siz;    
 end;
 if ~((size(A,1) == size(B,1)) & (size(A,2) == size(B,2)))
   error('Images must have the same dimensions!');   
 end;
 where=[fileparts(which(mfilename)) '\Pqs'];
 pic1=[where '\pic1.pqs '];
 fid1=fopen(pic1,'w');
 Ad=double(A);
 fwrite(fid1,Ad,'uint8');
 fclose(fid1);
 pic2=[where '\pic2.pqs '];
 fid2=fopen(pic2,'w');
 Bd=double(B);
 fwrite(fid2,Bd,'uint8');
 fclose(fid2);
 rez=[where '\rez.txt'];
 naredba=[where '\pqs.exe -b ' num2str(blok) ' -s ' num2str(siz) ' ' pic1 pic2 ' > ' rez];
 [c,w]=dos(naredba);
 disp(w);
 fid=fopen(rez);
 st=fscanf(fid,'%s');
 PQS=str2num(st(5:size(st,2)));
 fclose(fid);
 delete(pic1);
 delete(pic2);
 delete(rez);