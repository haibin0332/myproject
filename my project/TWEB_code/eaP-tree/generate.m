function  [internode1_1]=generate(internode)

    internode1_1.sum_number=0;  
    internode1_1.sum_rating=[0,0,0,0,0]; 
    internode1_1.level=1;
    number=size(internode,2);
     divinternode=internode;

%  for  r=1:1:(number-1) 
%     for s=(r+1):1:number
%         
%         if   divinternode(r).pricerange.min_price >divinternode(s).pricerange.min_price
%             kaointernode=divinternode(r);
%             divinternode(r)=divinternode(s);
%             divinternode(s)=kaointernode;            
%         end
%         
%     end
%  end    
internode1_1.pricerange.min_price=divinternode(1).pricerange.min_price;
internode1_1.pricerange.max_price=divinternode(1).pricerange.max_price;
internode1_1.timerange.timebegin=divinternode(1).timerange.timebegin;
internode1_1.timerange.timeend='*';

for u=1:1:number
    if internode1_1.pricerange.min_price>divinternode(u).pricerange.min_price
         internode1_1.pricerange.min_price=divinternode(u).pricerange.min_price;
    end
    if internode1_1.pricerange.max_price<divinternode(u).pricerange.max_price
         internode1_1.pricerange.max_price=divinternode(u).pricerange.max_price;
    end
    if internode1_1.timerange.timebegin<divinternode(u).timerange.timebegin
         internode1_1.timerange.timebegin=divinternode(u).timerange.timebegin;
    end
    internode1_1.internode(u)=divinternode(u);  
    internode1_1.sum_rating(1)=internode1_1.sum_rating(1)+divinternode(u).sum_rating(1);
    internode1_1.sum_rating(2)=internode1_1.sum_rating(2)+divinternode(u).sum_rating(2);
    internode1_1.sum_rating(3)=internode1_1.sum_rating(3)+divinternode(u).sum_rating(3);
    internode1_1.sum_rating(4)=internode1_1.sum_rating(4)+divinternode(u).sum_rating(4);
    internode1_1.sum_rating(5)=internode1_1.sum_rating(5)+divinternode(u).sum_rating(5);
    internode1_1.sum_number=internode1_1.sum_number+divinternode(u).sum_number;  
end

    
end