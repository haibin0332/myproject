%% µÈÍ¬ÓÚ£º\liyuenan\Li.m
function hash=mbe_li_LVQHash(imagefile,param)
% imagefile='1.bmp';
A=imread(imagefile);
J=imresize(A,256/size(A,1), 'bilinear');
filter = fspecial('gaussian',5,3);
I=imfilter(J,filter);

Key1=987; Key2=256; Key3=954;Key4=871;

feanum=40;

rand('state',Key1);

kw=33;
kh=33;

feature=zeros(1,feanum);

for k=1:feanum
    r(k)=2*k;
    
    R =zeros(kw,kh);
    Im=zeros(kw,kh);
    [v,h]=meshgrid(-4:8/(kw-1):4);
        
    for n=1:10
        f=0.1*(n-1)+0.1*rand(1,1);
        R =R+f^2*exp(-(v.*f).^2-(h.*f).^2).*cos(2*pi*sqrt(v.^2+h.^2).*f);
        Im=Im+f^2*exp(-(v.*f).^2-(h.*f).^2).*sin(2*pi*sqrt(v.^2+h.^2).*f);
    end
    
    %figure,mesh(h,v,Im)
    
    Re = conv2(double(I),R,'valid');
    Img = conv2(double(I),Im,'valid');
    F=Re.^2+Img.^2;
    
    center=size(F)/2;

    count=0;
    feature(k)=0;
    for i=center(1)-r(k)-2:center(1)+r(k)+2
        for j=center(2)-r(k)-2:center(2)+r(k)+2
            radis=sqrt((i-center(1))^2+(j-center(2))^2);
            if radis>=r(k)-2 && radis<=r(k)+2
                feature(k)=feature(k)+F(i,j);
                count=count+1;
            end
        end
    end

     feature(k)=feature(k)/count;
      %feature(k)=feature(k)/count;
end

%Form feature vectors in a random order
rand('state',Key2);
order=randperm(feanum);

minf=min(feature);
maxf=max(feature);
level=8;
step=(maxf-minf)/level;

%Add dither to feature vector
M=[ 2 1 1 1; 0 1 0 0; 0 0 1 0; 0 0 0 1];
rand('state',Key3);
dv=0.5*rand(4,10);
dv=dv.*power(-1,floor(10*rand(4,10)));

for k=0:feanum/4-1
  dither=M*dv(:,k+1);
  vector(k+1,1:4)=(feature(order(k*4+1:k*4+4))-minf)/step+dither';
    %vector(k+1,1:4)=(feature(order(k*4+1:k*4+4))-minf)/step;
end

%Feature vector labeling
index=blanks(1);
for k=1:feanum/4
   binstr=LVQ(vector(k,:),level);
   index=strcat(index,binstr);
end

%Generate hash string
for n=1:length(index)
  bin(n)=str2num(index(n));
end

%Permution hash string
rand('state',Key4);
len=length(bin);
order=randperm(len);
hash=bin(order);

% % Write hash into files 
% fid = fopen('hash\noise.txt', 'wb');
% fwrite(fid, hash, 'integer*1');
% fclose(fid);

