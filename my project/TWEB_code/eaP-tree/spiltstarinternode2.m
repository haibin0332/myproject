function [internode2_1, internode2_2]=spiltstarinternode2(internode1)


    internode2_1.sum_number=0;  
    internode2_1.sum_rating=[0,0,0,0,0]; 
    internode2_1.level=3;

    internode2_2.sum_number=0; 
    internode2_2.sum_rating=[0,0,0,0,0];
    internode2_2.level=3;
    
 
    i=size(internode1.internode2, 2);
    
for v=1:1:i
     tempinternode(v)=internode1.internode2(v);    
end
    
      

    
 for  r=1:1:(size(tempinternode,2)-1) 
    for s=(r+1):1:size(tempinternode,2)  
        if   tempinternode(r).pricerange.min_price>tempinternode(s).pricerange.min_price
            kaointernode=tempinternode(r);
            tempinternode(r)=tempinternode(s);
            tempinternode(s)=kaointernode;            
        end
        
    end
end
    

for p=1:1:ceil(i/2)
    internode2_1.internode2(p)=tempinternode(p);  
    internode2_1.sum_rating=internode2_1.sum_rating+tempinternode(p).sum_rating;
    internode2_1.sum_number=internode2_1.sum_number+tempinternode(p).sum_number;    
end

internode2_1.pricerange.min_price=internode2_1.internode2(1).pricerange.min_price;
internode2_1.pricerange.max_price=internode2_1.internode2(1).pricerange.max_price;

for u=1:1:size(internode2_1.internode2,2)
    if internode2_1.pricerange.min_price>internode2_1.internode2(u).pricerange.min_price
         internode2_1.pricerange.min_price=internode2_1.internode2(u).pricerange.min_price;
    end
    if internode2_1.pricerange.max_price<internode2_1.internode2(u).pricerange.max_price
         internode2_1.pricerange.max_price=internode2_1.internode2(u).pricerange.max_price;
    end
    
end


% internode2_1.price=internode1(1).price;
internode2_1.timerange.timebegin=internode1.timerange.timebegin;
internode2_1.timerange.timeend='*';


for p=(ceil(i/2)+1):1:i
    internode2_2.internode2(p-ceil(i/2))=tempinternode(p);  
    internode2_2.sum_rating=internode2_2.sum_rating+tempinternode(p).sum_rating;
    internode2_2.sum_number=internode2_2.sum_number+tempinternode(p).sum_number;    
end

internode2_2.pricerange.min_price=internode2_2.internode2(1).pricerange.min_price;
internode2_2.pricerange.max_price=internode2_2.internode2(1).pricerange.max_price;

for u=1:1:size(internode2_2.internode2,2)
    if internode2_2.pricerange.min_price>internode2_2.internode2(u).pricerange.min_price
         internode2_2.pricerange.min_price=internode2_2.internode2(u).pricerange.min_price;
    end
    if internode2_2.pricerange.max_price<internode2_2.internode2(u).pricerange.max_price
         internode2_2.pricerange.max_price=internode2_2.internode2(u).pricerange.max_price;
    end
    
end

% internode2_2.price=internode1((ceil(i/2)+1)).price;
internode2_2.timerange.timebegin=internode1.timerange.timebegin;
internode2_2.timerange.timeend='*';


end