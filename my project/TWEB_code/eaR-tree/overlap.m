function  testrange=overlap(pricerange1, timerange1, pricerange2, timerange2)%%1 root  2 query

if pricerange2(2)>=pricerange1(2)&&pricerange1(1)>=pricerange2(1)&&timerange1(1)>=timerange2(1)&&timerange2(2)>=timerange1(2)%%°üº¬
    testrange=0;

else
if  pricerange1(1)>=pricerange2(1)
miny=pricerange1(1);
else
miny=pricerange2(1);
end

if  pricerange1(2)>=pricerange2(2)
maxy=pricerange2(2);
else
maxy=pricerange1(2);
end
if  timerange1(1)>=timerange2(1)
minx=timerange1(1);
else
minx=timerange2(1);
end
if  timerange1(2)>=timerange2(2)
maxx=timerange2(2);
else
maxx=timerange1(2);
end
if (minx>maxx)||(miny>maxy)
    testrange=0;
else
    testrange=1;
end  
end


end