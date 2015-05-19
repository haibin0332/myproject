function  [internode2_1, internode2_2]=spiltinternode1(internodetemp1,internodetemp2)

    internode2_1.sum_number=[];  
    internode2_1.sum_rating=[]; 
    internode2_1.level=2;
 
    internode2_2.sum_number=0; 
    internode2_2.sum_rating=[0,0,0,0,0];
    internode2_2.level=2;
    
    if size(internodetemp2,2)==1
    
    tempinternode=internodetemp1;
    i=size(internodetemp1, 2);
    tempinternode(i+1)=internodetemp2;
  
q=1;

for k=1:1:size(tempinternode,2)
    if strcmp(tempinternode(k).timerange.timeend,'*')
        internode2_2.internode1(q)=tempinternode(k);
        q=q+1;  
        internode2_2.sum_number=internode2_2.sum_number+tempinternode(k).sum_number;
        internode2_2.sum_rating(1)=internode2_2.sum_rating(1)+tempinternode(k).sum_rating(1); 
        internode2_2.sum_rating(2)=internode2_2.sum_rating(2)+tempinternode(k).sum_rating(2); 
        internode2_2.sum_rating(3)=internode2_2.sum_rating(3)+tempinternode(k).sum_rating(3); 
        internode2_2.sum_rating(4)=internode2_2.sum_rating(4)+tempinternode(k).sum_rating(4); 
        internode2_2.sum_rating(5)=internode2_2.sum_rating(5)+tempinternode(k).sum_rating(5);          
    end          
end

internode2_1.internode1=internodetemp1; 
% 
%%%注意2 都排序

internode2_1.pricerange.min_price=internodetemp1(1).pricerange.min_price;
internode2_1.pricerange.max_price=internodetemp1(1).pricerange.max_price;

for u=1:1:size(internodetemp1, 2)
    if internode2_1.pricerange.min_price>internodetemp1(u).pricerange.min_price
         internode2_1.pricerange.min_price=internodetemp1(u).pricerange.min_price;
    end
    if internode2_1.pricerange.max_price<internodetemp1(u).pricerange.max_price
         internode2_1.pricerange.max_price=internodetemp1(u).pricerange.max_price;
    end
    
end

% internode2_1.price=internode2_1.internode1(1).price;
internode2_1.timerange.timebegin=internodetemp1(1).timerange.timebegin;
internode2_1.timerange.timeend=internodetemp2.timerange.timebegin;
% 
% 

internode2_2.pricerange.min_price=internode2_2.internode1(1).pricerange.min_price;
internode2_2.pricerange.max_price=internode2_2.internode1(1).pricerange.max_price;

for u=1:1:size(internode2_2.internode1, 2)
    if internode2_2.pricerange.min_price>internode2_2.internode1(u).pricerange.min_price
         internode2_2.pricerange.min_price=internode2_2.internode1(u).pricerange.min_price;
    end
    if internode2_2.pricerange.max_price<internode2_2.internode1(u).pricerange.max_price
         internode2_2.pricerange.max_price=internode2_2.internode1(u).pricerange.max_price;
    end
    
end

% internode2_2.price=internode2_2.internode1(1).price;
internode2_2.timerange.timebegin=internodetemp2.timerange.timebegin;
internode2_2.timerange.timeend='*';


    elseif size(internodetemp2,2)==2
        
    tempinternode=internodetemp1;
    i=size(internodetemp1, 2);
    tempinternode(i+1)=internodetemp2(1);
    tempinternode(i+2)=internodetemp2(2);
    
p=1;
q=1;

for k=1:1:size(tempinternode,2)
    if strcmp(tempinternode(k).timerange.timeend,'*')
        internode2_2.internode1(q)=tempinternode(k);
        q=q+1;  
        internode2_2.sum_number=internode2_2.sum_number+tempinternode(k).sum_number;
        internode2_2.sum_rating(1)=internode2_2.sum_rating(1)+tempinternode(k).sum_rating(1); 
        internode2_2.sum_rating(2)=internode2_2.sum_rating(2)+tempinternode(k).sum_rating(2); 
        internode2_2.sum_rating(3)=internode2_2.sum_rating(3)+tempinternode(k).sum_rating(3); 
        internode2_2.sum_rating(4)=internode2_2.sum_rating(4)+tempinternode(k).sum_rating(4); 
        internode2_2.sum_rating(5)=internode2_2.sum_rating(5)+tempinternode(k).sum_rating(5);           
    end         
end

internode2_1.internode1=internodetemp1; 

%%%注意2 都排序
internode2_1.pricerange.min_price=internodetemp1(1).pricerange.min_price;
internode2_1.pricerange.max_price=internodetemp1(1).pricerange.max_price;

for u=1:1:size(internodetemp1, 2)
    if internode2_1.pricerange.min_price>internodetemp1(u).pricerange.min_price
         internode2_1.pricerange.min_price=internodetemp1(u).pricerange.min_price;
    end
    if internode2_1.pricerange.max_price<internodetemp1(u).pricerange.max_price
         internode2_1.pricerange.max_price=internodetemp1(u).pricerange.max_price;
    end
    
end
internode2_1.timerange.timebegin=internodetemp1(1).timerange.timebegin;
internode2_1.timerange.timeend=internodetemp2(1).timerange.timebegin;
% 


internode2_2.pricerange.min_price=internode2_2.internode1(1).pricerange.min_price;
internode2_2.pricerange.max_price=internode2_2.internode1(1).pricerange.max_price;

for u=1:1:size(internode2_2.internode1, 2)
    if internode2_2.pricerange.min_price>internode2_2.internode1(u).pricerange.min_price
         internode2_2.pricerange.min_price=internode2_2.internode1(u).pricerange.min_price;
    end
    if internode2_2.pricerange.max_price<internode2_2.internode1(u).pricerange.max_price
         internode2_2.pricerange.max_price=internode2_2.internode1(u).pricerange.max_price;
    end
    
end
internode2_2.timerange.timebegin=internodetemp2(1).timerange.timebegin;
internode2_2.timerange.timeend='*';

 
    end
    
end