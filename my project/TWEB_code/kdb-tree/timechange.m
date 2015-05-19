function [time]=timechange(realtime)


%realtime='2011-07-11T03:25:44.000Z'; %%2012-01-13T07:00:44.000Z

temp1=str2double(realtime(6:7));

temp2=str2double(realtime(9:10));


% temp3=str2num(realtime(12:13));


% temp4=str2num(realtime(15:16));



if temp1==1
    
    time=temp2;
    
end
  
if temp1==2
    
    time=31+temp2;
    
end

if temp1==3
    
    time=60+temp2;
    
end

if temp1==4
    
    time=91+temp2;
    
end
    
if temp1==5
    
    time=91+temp2+30;
    
end

if temp1==6
    
    time=91+temp2+30+31;
    
end

if temp1==7
    
    time=91+temp2+30+31+30;
    
end

if temp1==8
    
    time=91+temp2+30+31+30+31;
    
end

if temp1==9
    
    time=91+temp2+30+31+30+31+31;
    
end

if temp1==10
    
    time=91+temp2+30+31+30+31+31+30;
    
end

if temp1==11
    
    time=91+temp2+30+31+30+31+31+30+31;
    
end

if temp1==12
    
    time=91+temp2+30+31+30+31+31+30+31+30;
    
end


end
