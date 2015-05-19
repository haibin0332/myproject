function [internode1_1, internode1_2]=spiltstarinternode(internode, number)


    internode1_1.sum_number=0;  
    internode1_1.sum_rating=[0,0,0,0,0]; 
    internode1_1.level=1;

    internode1_2.sum_number=0; 
    internode1_2.sum_rating=[0,0,0,0,0];
    internode1_2.level=1;
    
    divinternode=internode;
%     i=size(internode, 2);

%     q=1;
% 
% for k=1:1:size(tempinternode,2)
%     if strcmp(tempinternode(k).timerange.timeend,'*')
%         divinternode(q)=tempinternode(k); %#ok<AGROW>
%         q=q+1;  
%          
%     end          
% end

for  r=1:1:(number-1) 
    for s=(r+1):1:number
        
        if   divinternode(r).pricerange.min_price >divinternode(s).pricerange.min_price
            kaointernode=divinternode(r);
            divinternode(r)=divinternode(s);
            divinternode(s)=kaointernode;            
        end
        
    end
end


internode1_1.pricerange.min_price=divinternode(1).pricerange.min_price;
internode1_1.pricerange.max_price=divinternode(1).pricerange.max_price;

internode1_1.timerange.timebegin=internode(number).timerange.timebegin;
internode1_1.timerange.timeend='*';

for u=1:1:ceil(number/2)
    if internode1_1.pricerange.min_price>divinternode(u).pricerange.min_price
         internode1_1.pricerange.min_price=divinternode(u).pricerange.min_price;
    end
    if internode1_1.pricerange.max_price<divinternode(u).pricerange.max_price
         internode1_1.pricerange.max_price=divinternode(u).pricerange.max_price;
    end
    internode1_1.internode(u)=divinternode(u);  
    internode1_1.sum_rating(1)=internode1_1.sum_rating(1)+divinternode(u).sum_rating(1);
    internode1_1.sum_rating(2)=internode1_1.sum_rating(2)+divinternode(u).sum_rating(2);
    internode1_1.sum_rating(3)=internode1_1.sum_rating(3)+divinternode(u).sum_rating(3);
    internode1_1.sum_rating(4)=internode1_1.sum_rating(4)+divinternode(u).sum_rating(4);
    internode1_1.sum_rating(5)=internode1_1.sum_rating(5)+divinternode(u).sum_rating(5);
    internode1_1.sum_number=internode1_1.sum_number+divinternode(u).sum_number;  
end



internode1_2.pricerange.min_price=divinternode(ceil(number/2)+1).pricerange.min_price;
internode1_2.pricerange.max_price=divinternode(ceil(number/2)+1).pricerange.max_price;
internode1_2.timerange.timebegin=internode(number).timerange.timebegin;
internode1_2.timerange.timeend='*';

for u=(ceil(number/2)+1):1:number
    if internode1_2.pricerange.min_price>divinternode(u).pricerange.min_price
         internode1_2.pricerange.min_price=divinternode(u).pricerange.min_price;
    end
    if internode1_2.pricerange.max_price<divinternode(u).pricerange.max_price
         internode1_2.pricerange.max_price=divinternode(u).pricerange.max_price;
    end
    internode1_2.internode(u-ceil(number/2))=divinternode(u);  
    internode1_2.sum_rating(1)=internode1_2.sum_rating(1)+divinternode(u).sum_rating(1);
    internode1_2.sum_rating(2)=internode1_2.sum_rating(2)+divinternode(u).sum_rating(2);
    internode1_2.sum_rating(3)=internode1_2.sum_rating(3)+divinternode(u).sum_rating(3);
    internode1_2.sum_rating(4)=internode1_2.sum_rating(4)+divinternode(u).sum_rating(4);
    internode1_2.sum_rating(5)=internode1_2.sum_rating(5)+divinternode(u).sum_rating(5);
    internode1_2.sum_number=internode1_2.sum_number+divinternode(u).sum_number;  
end



end