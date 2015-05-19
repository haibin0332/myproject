% Paper: New Iterative Geometric Methods for Robust Perceptual Image
% Hashing, ACM CCS-8 Workshop on Security and Privacy in Digital Rights 
% Management (Algorithm A.)

% Yue-nan Li, 28th, Nov, 2008

% µÈÓÚ liyuenan\Ite_Geo_A1_Hash.m

function hash=mbe_mihcak_iterative(imagefile,param)
%% test inputs
% imagefile = '1.bmp'
%% function
Im=imread(imagefile);

% resize image to 512*512
if size(Im,1)~=512 || size(Im,2)~=512
    A =imresize(Im,512/size(Im,1), 'bicubic');
else
    A=Im;
end

ctr=0;   % count for iterative number
dis=inf; % distance between M and M5
        
% Step 1: DWT to get the DC subband
[X,cH1,cV1,cD1] = dwt2(double(A),'db1'); % DC band of a image, X
         
% Iteration
while ctr<20 && dis>0.01*size(X,1)*size(X,2)  % terminate conditions
    % Step 2: Thresholding
    Th=median(median(X));
    M=zeros(size(X));
    M(X>Th)=1;
    
    %Step 3.1: Order-statistics filtering, i.e., median filtering
    M3 = 255*medfilt2(M,[5 5]);
    
    %Step 3.2: Filtering on M3
    M4 = filter2(fspecial('average',3),M3);
    
    %Step 3.3: Thresholding on M4
    Th=median(median(M4));
    M5=zeros(size(M4));
    M5(M4>Th)=1;
    
    ctr=ctr+1;
    
    %Step 3.4: Measure the hamming weight between M5 and M
    dis=sum(sum(abs(M5-M)));
end
    
% convert the binary image M5 to 1-d hash string
hash = reshape(M5,1,size(M5,1)*size(M5,2));