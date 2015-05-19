function  [internode4_1, internode4_2]=spiltinternode3(internodetemp1,internodetemp2)

    internode4_1.sum_number=[];  
    internode4_1.sum_rating=[]; 
    internode4_1.level=4;

    internode4_2.sum_number=0; 
    internode4_2.sum_rating=[0,0,0,0,0];
    internode4_2.level=4;
    if size(internodetemp2,2)==1
    tempinternode=internodetemp1;
    i=size(internodetemp1, 2);
    tempinternode(i+1)=internodetemp2;
 
q=1;

for k=1:1:size(tempinternode,2)
    if strcmp(tempinternode(k).timerange.timeend,'*')
        internode4_2.internode3(q)=tempinternode(k);
        q=q+1;  
        internode4_2.sum_number=internode4_2.sum_number+tempinternode(k).sum_number;
        internode4_2.sum_rating(1)=internode4_2.sum_rating(1)+tempinternode(k).sum_rating(1); 
        internode4_2.sum_rating(2)=internode4_2.sum_rating(2)+tempinternode(k).sum_rating(2);
        internode4_2.sum_rating(3)=internode4_2.sum_rating(3)+tempinternode(k).sum_rating(3);
        internode4_2.sum_rating(4)=internode4_2.sum_rating(4)+tempinternode(k).sum_rating(4);
        internode4_2.sum_rating(5)=internode4_2.sum_rating(5)+tempinternode(k).sum_rating(5);
    end          
end

internode4_1.internode3=internodetemp1; 
%%%×¢Òâ2 ¶¼ÅÅÐò
internode4_1.pricerange.min_price=internodetemp1(1).pricerange.min_price;
internode4_1.pricerange.max_price=internodetemp1(1).pricerange.max_price;

for u=1:1:size(internodetemp1, 2)
    if internode4_1.pricerange.min_price>internodetemp1(u).pricerange.min_price
         internode4_1.pricerange.min_price=internodetemp1(u).pricerange.min_price;
    end
    if internode4_1.pricerange.max_price<internodetemp1(u).pricerange.max_price
         internode4_1.pricerange.max_price=internodetemp1(u).pricerange.max_price;
    end
    
end

% internode3_1.price=internodetemp1(1).price;
internode4_1.timerange.timebegin=internodetemp1(1).timerange.timebegin;
internode4_1.timerange.timeend=internodetemp2.timerange.timebegin;
% 
% 

internode4_2.pricerange.min_price=internode4_2.internode3(1).pricerange.min_price;
internode4_2.pricerange.max_price=internode4_2.internode3(1).pricerange.max_price;

for u=1:1:size(internode4_2.internode3, 2)
    if internode4_2.pricerange.min_price>internode4_2.internode3(u).pricerange.min_price
         internode4_2.pricerange.min_price=internode4_2.internode3(u).pricerange.min_price;
    end
    if internode4_2.pricerange.max_price<internode4_2.internode3(u).pricerange.max_price
         internode4_2.pricerange.max_price=internode4_2.internode3(u).pricerange.max_price;
    end
    
end

internode4_2.timerange.timebegin=internodetemp2.timerange.timebegin;
internode4_2.timerange.timeend='*';
    elseif size(internodetemp2,2)==2
        
    tempinternode=internodetemp1;
    i=size(internodetemp1, 2);
    tempinternode(i+1)=internodetemp2(1);
    tempinternode(i+2)=internodetemp2(2);
    
q=1;

for k=1:1:size(tempinternode,2)
    if strcmp(tempinternode(k).timerange.timeend,'*')
        internode4_2.internode3(q)=tempinternode(k);
        q=q+1;  
        internode4_2.sum_number=internode4_2.sum_number+tempinternode(k).sum_number;
        internode4_2.sum_rating(1)=internode4_2.sum_rating(1)+tempinternode(k).sum_rating(1); 
        internode4_2.sum_rating(2)=internode4_2.sum_rating(2)+tempinternode(k).sum_rating(2);
        internode4_2.sum_rating(3)=internode4_2.sum_rating(3)+tempinternode(k).sum_rating(3);
        internode4_2.sum_rating(4)=internode4_2.sum_rating(4)+tempinternode(k).sum_rating(4);
        internode4_2.sum_rating(5)=internode4_2.sum_rating(5)+tempinternode(k).sum_rating(5);     
    end         
end
internode4_1.internode3=internodetemp1; 

internode4_1.pricerange.min_price=internodetemp1(1).pricerange.min_price;
internode4_1.pricerange.max_price=internodetemp1(1).pricerange.max_price;

for u=1:1:size(internodetemp1, 2)
    if internode4_1.pricerange.min_price>internodetemp1(u).pricerange.min_price
         internode4_1.pricerange.min_price=internodetemp1(u).pricerange.min_price;
    end
    if internode4_1.pricerange.max_price<internodetemp1(u).pricerange.max_price
         internode4_1.pricerange.max_price=internodetemp1(u).pricerange.max_price;
    end
    
end
internode4_1.timerange.timebegin=internodetemp1(1).timerange.timebegin;
internode4_1.timerange.timeend=internodetemp2(1).timerange.timebegin;
% 
% 

internode4_2.pricerange.min_price=internode4_2.internode3(1).pricerange.min_price;
internode4_2.pricerange.max_price=internode4_2.internode3(1).pricerange.max_price;

for u=1:1:size(internode4_2.internode3, 2)
    if internode4_2.pricerange.min_price>internode4_2.internode3(u).pricerange.min_price
         internode4_2.pricerange.min_price=internode4_2.internode3(u).pricerange.min_price;
    end
    if internode4_2.pricerange.max_price<internode4_2.internode3(u).pricerange.max_price
         internode4_2.pricerange.max_price=internode4_2.internode3(u).pricerange.max_price;
    end
    
end
internode4_2.timerange.timebegin=internodetemp2(1).timerange.timebegin;
internode4_2.timerange.timeend='*';

 
    end
    
end