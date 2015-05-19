%%
% Paper: Robust and Secure Image Hashing via Non-Negative Matrix Factorizations, 
% Information Forensics and Security, IEEE Transactions on, Vol.2 No.3 2007
% Author: Monga, V. Mhcak, M. K
% Coded by: Li Yuenan, 2009-1-10
% Note: Binary quantization is added using the random quantization scheme,
%       the paper focuses on feature vector extraction.
function hash=mbe_VishalMonga_NMF(imagefile,param)
%% test input
imagefile = '001n.bmp';
%% 
I=imread(imagefile);
I=double(imresize(I,256/size(I,1), 'bilinear'));

Key1=20;
rand('state',Key1);

p=25;
k=100;
r1=2;
r2=2;
M=64;

r_row=floor((256-k)*rand(1,p)+1);
r_col=floor((256-k)*rand(1,p)+1);

for i=1:p
   A=I(r_row(i):r_row(i)+k-1,r_col(i):r_col(i)+k-1);
   [W,H]=nnmf(A,r1);
   H=H';
   ContM=[W H];
   
   if i==1
       J=ContM;
   else
       J=[J ContM];
   end
   
end
% 文章中描述的随机置乱过程应该发生在这里。但是加在这里会不会影响鲁棒性？
[W,H]=nnmf(J,r2);
V=[W H']';

V=reshape(V,1,size(V,1)*size(V,2));

VectDim=size(V,1)*size(V,2)/50;
rand('state',Key1);
for i=0:49
r=rand(VectDim,1);
hv(i+1)=V(i*VectDim+1:(i+1)*VectDim)*r; % 这只是一个随机加权，与文章的描述是不一致的
end

hash=RandQuant(hv,50,16,123, 123);