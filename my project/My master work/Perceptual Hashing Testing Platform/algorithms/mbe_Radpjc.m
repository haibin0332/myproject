% Robust video hashing based on radial projections of key frames, 
% Signal Processing, IEEE Transactions on

function hash=mbe_Radpjc(imagefile)

% read image & pre-processing
A=imread(imagefile);
J=imresize(A,256/size(A,1), 'bilinear');
filter = fspecial('gaussian',5,3);
I=imfilter(J,filter);

P=zeros(180,1);
hd=1; % the horizontal distance between the two 
level=32; %quantization level

for n=1:180
    sita=n*pi/180;
    
    if n==90 % to avoid divide zero in y2
        sita=sita+pi/360;
    end
    
    sum_p=0; % sum of pixels
    sum_sq=0; % sum of squares of pixels
    count=0;
    
    for col=1:256
        x=col-128; % -127<=x<=128, move origin to the image center
        
        % Given x, the upper and lower lines of the bend
        y1=round((x*sin(sita)+hd)/cos(sita));
        y2=round((x*sin(sita)-hd)/cos(sita));
        lower_y=min(y1,y2);
        upper_y=max(y1,y2);
        
        if lower_y<=128 && upper_y>-128
            lower_y=max(-127,lower_y);
            upper_y=min(128,upper_y);
            for y=lower_y:upper_y
                row=128+y;
                sum_p=sum_p+double(I(row,col));
                sum_sq=sum_sq+double(I(row,col)^2);
                count=count+1;
            end
        end
    end
    
    % variance of the pixels within the bend
    P(n)=sum_sq/count-(sum_p/count)^2;
end

P=(P-mean(P))/std(P); %normalization

Coeff=dct(P);
R=Coeff(1:40); % Get low-mid frequency components

% Quantization
quant_int=(max(R)-min(R))/(level-1); 
index=floor((R-min(R))/quant_int); 

%dec->bin using Gray coding
hash_str=blanks(1);
binlen=log2(level);

for i=1:40
    decbin=dec2bin(index(i),binlen);
    str=blanks(binlen);
    for n=binlen:-1:2
        if strcmp(decbin(n),decbin(n-1))
            str(n)='0';
        else
            str(n)='1';
        end
    end
    str(1)=decbin(1);
    hash_str=strcat(hash_str,str);
end


for n=1:length(hash_str)
  hash(n)=str2num(hash_str(n))
end






