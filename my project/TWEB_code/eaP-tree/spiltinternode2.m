function  [internode3_1, internode3_2]=spiltinternode2(internodetemp1,internodetemp2, time)

    internode3_1.sum_number=[];  
    internode3_1.sum_rating=[]; 
    internode3_1.level=3;

    internode3_2.sum_number=0; 
    internode3_2.sum_rating=[0,0,0,0,0];
    internode3_2.level=3;
    if size(internodetemp2,2)==1
    
    tempinternode=internodetemp1;
    i=size(internodetemp1, 2);
    tempinternode(i+1)=internodetemp2;
 
q=1;

for k=1:1:size(tempinternode,2)
    if strcmp(tempinternode(k).timerange.timeend,'*')
        internode3_2.internode2(q)=tempinternode(k);
        q=q+1;  
        internode3_2.sum_number=internode3_2.sum_number+tempinternode(k).sum_number;
        internode3_2.sum_rating(1)=internode3_2.sum_rating(1)+tempinternode(k).sum_rating(1); 
        internode3_2.sum_rating(2)=internode3_2.sum_rating(2)+tempinternode(k).sum_rating(2);
        internode3_2.sum_rating(3)=internode3_2.sum_rating(3)+tempinternode(k).sum_rating(3);
        internode3_2.sum_rating(4)=internode3_2.sum_rating(4)+tempinternode(k).sum_rating(4);
        internode3_2.sum_rating(5)=internode3_2.sum_rating(5)+tempinternode(k).sum_rating(5);
    end          
end

internode3_1.internode2=internodetemp1; 
%%%×¢Òâ2 ¶¼ÅÅÐò
internode3_1.pricerange.min_price=internodetemp1(1).pricerange.min_price;
internode3_1.pricerange.max_price=internodetemp1(1).pricerange.max_price;

for u=1:1:size(internodetemp1, 2)
    if internode3_1.pricerange.min_price>internodetemp1(u).pricerange.min_price
         internode3_1.pricerange.min_price=internodetemp1(u).pricerange.min_price;
    end
    if internode3_1.pricerange.max_price<internodetemp1(u).pricerange.max_price
         internode3_1.pricerange.max_price=internodetemp1(u).pricerange.max_price;
    end
    
end

% internode3_1.price=internodetemp1(1).price;
internode3_1.timerange.timebegin=time;
internode3_1.timerange.timeend=internodetemp2.timerange.timebegin;
% 
% 

internode3_2.pricerange.min_price=internode3_2.internode2(1).pricerange.min_price;
internode3_2.pricerange.max_price=internode3_2.internode2(1).pricerange.max_price;

for u=1:1:size(internode3_2.internode2, 2)
    if internode3_2.pricerange.min_price>internode3_2.internode2(u).pricerange.min_price
         internode3_2.pricerange.min_price=internode3_2.internode2(u).pricerange.min_price;
    end
    if internode3_2.pricerange.max_price<internode3_2.internode2(u).pricerange.max_price
         internode3_2.pricerange.max_price=internode3_2.internode2(u).pricerange.max_price;
    end
    
end

internode3_2.timerange.timebegin=internodetemp2.timerange.timebegin;
internode3_2.timerange.timeend='*';
    elseif size(internodetemp2,2)==2
        
    tempinternode=internodetemp1;
    i=size(internodetemp1, 2);
    tempinternode(i+1)=internodetemp2(1);
    tempinternode(i+2)=internodetemp2(2);
    
q=1;

for k=1:1:size(tempinternode,2)
    if strcmp(tempinternode(k).timerange.timeend,'*')
        internode3_2.internode2(q)=tempinternode(k);
        q=q+1;  
        internode3_2.sum_number=internode3_2.sum_number+tempinternode(k).sum_number;
        internode3_2.sum_rating(1)=internode3_2.sum_rating(1)+tempinternode(k).sum_rating(1); 
        internode3_2.sum_rating(2)=internode3_2.sum_rating(2)+tempinternode(k).sum_rating(2);
        internode3_2.sum_rating(3)=internode3_2.sum_rating(3)+tempinternode(k).sum_rating(3);
        internode3_2.sum_rating(4)=internode3_2.sum_rating(4)+tempinternode(k).sum_rating(4);
        internode3_2.sum_rating(5)=internode3_2.sum_rating(5)+tempinternode(k).sum_rating(5);     
    end         
end
internode3_1.internode2=internodetemp1; 

internode3_1.pricerange.min_price=internodetemp1(1).pricerange.min_price;
internode3_1.pricerange.max_price=internodetemp1(1).pricerange.max_price;

for u=1:1:size(internodetemp1, 2)
    if internode3_1.pricerange.min_price>internodetemp1(u).pricerange.min_price
         internode3_1.pricerange.min_price=internodetemp1(u).pricerange.min_price;
    end
    if internode3_1.pricerange.max_price<internodetemp1(u).pricerange.max_price
         internode3_1.pricerange.max_price=internodetemp1(u).pricerange.max_price;
    end
    
end
internode3_1.timerange.timebegin=time;
internode3_1.timerange.timeend=internodetemp2(1).timerange.timebegin;
% 
% 

internode3_2.pricerange.min_price=internode3_2.internode2(1).pricerange.min_price;
internode3_2.pricerange.max_price=internode3_2.internode2(1).pricerange.max_price;

for u=1:1:size(internode3_2.internode2, 2)
    if internode3_2.pricerange.min_price>internode3_2.internode2(u).pricerange.min_price
         internode3_2.pricerange.min_price=internode3_2.internode2(u).pricerange.min_price;
    end
    if internode3_2.pricerange.max_price<internode3_2.internode2(u).pricerange.max_price
         internode3_2.pricerange.max_price=internode3_2.internode2(u).pricerange.max_price;
    end
    
end
internode3_2.timerange.timebegin=internodetemp2(1).timerange.timebegin;
internode3_2.timerange.timeend='*';

 
    end
    
end