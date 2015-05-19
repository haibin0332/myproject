function [internode_2]=splitnode1(tempinternode_2, seed0, seed1, indexinternode_1)
     
    internode_2(1).n_level=2;
    internode_2(1).internode_1=tempinternode_2(seed0);
    internode_2(1).sum=tempinternode_2(seed0).sum;
    internode_2(1).rating(1)=tempinternode_2(seed0).rating(1);
    internode_2(1).rating(2)=tempinternode_2(seed0).rating(2);
    internode_2(1).rating(3)=tempinternode_2(seed0).rating(3);
    internode_2(1).rating(4)=tempinternode_2(seed0).rating(4);
    internode_2(1).rating(5)=tempinternode_2(seed0).rating(5);
    internode_2(1).pricerange.max_price=tempinternode_2(seed0).pricerange.max_price;
    internode_2(1).pricerange.min_price=tempinternode_2(seed0).pricerange.min_price;
    internode_2(1).timerange.max_time=tempinternode_2(seed0).timerange.max_time;
    internode_2(1).timerange.min_time=tempinternode_2(seed0).timerange.min_time;
    indexinternode_1(seed0)=1;
    
    internode_2(2).n_level=2;
    internode_2(2).internode_1=tempinternode_2(seed1);
    internode_2(2).sum=tempinternode_2(seed1).sum;
    internode_2(2).rating(1)=tempinternode_2(seed1).rating(1);
    internode_2(2).rating(2)=tempinternode_2(seed1).rating(2);
    internode_2(2).rating(3)=tempinternode_2(seed1).rating(3);
    internode_2(2).rating(4)=tempinternode_2(seed1).rating(4);
    internode_2(2).rating(5)=tempinternode_2(seed1).rating(5);
    internode_2(2).pricerange.max_price=tempinternode_2(seed1).pricerange.max_price;
    internode_2(2).pricerange.min_price=tempinternode_2(seed1).pricerange.min_price;
    internode_2(2).timerange.max_time=tempinternode_2(seed1).timerange.max_time;
    internode_2(2).timerange.min_time=tempinternode_2(seed1).timerange.min_time;
    indexinternode_1(seed1)=1;  
      
         for  k=1:1:size(tempinternode_2,2)
       node1_num=size(internode_2(1).internode_1, 2);
       node2_num=size(internode_2(2).internode_1, 2);
       if indexinternode_1(k)==0
           if tempinternode_2(k).pricerange.max_price>tempinternode_2(seed0).pricerange.max_price
               u11=tempinternode_2(k).pricerange.max_price;
           else
               u11=tempinternode_2(seed0).pricerange.max_price;
           end
           if tempinternode_2(k).pricerange.min_price<tempinternode_2(seed0).pricerange.min_price
               u12=tempinternode_2(k).pricerange.min_price;
           else
               u12=tempinternode_2(seed0).pricerange.min_price;
           end
           if tempinternode_2(k).timerange.max_time>tempinternode_2(seed0).timerange.max_time
               u21=tempinternode_2(k).timerange.max_time;
           else
               u21=tempinternode_2(seed0).timerange.max_time;
           end
           if tempinternode_2(k).timerange.min_time<tempinternode_2(seed0).timerange.min_time
               u22=tempinternode_2(k).timerange.min_time;
           else
               u22=tempinternode_2(seed0).timerange.min_time;
           end
           growth0=(u11-u12)*(u21-u22)-(tempinternode_2(seed0).pricerange.max_price-tempinternode_2(seed0).pricerange.min_price)*(tempinternode_2(seed0).timerange.max_time-tempinternode_2(seed0).timerange.min_time);
           if tempinternode_2(k).pricerange.max_price>tempinternode_2(seed1).pricerange.max_price
               u11=tempinternode_2(k).pricerange.max_price;
           else
               u11=tempinternode_2(seed1).pricerange.max_price;
           end
           if tempinternode_2(k).pricerange.min_price<tempinternode_2(seed1).pricerange.min_price
               u12=tempinternode_2(k).pricerange.min_price;
           else
               u12=tempinternode_2(seed1).pricerange.min_price;
           end
           if tempinternode_2(k).timerange.max_time>tempinternode_2(seed1).timerange.max_time
               u21=tempinternode_2(k).timerange.max_time;
           else
               u21=tempinternode_2(seed1).timerange.max_time;
           end
           if tempinternode_2(k).timerange.min_time<tempinternode_2(seed1).timerange.min_time
               u22=tempinternode_2(k).timerange.min_time;
           else
               u22=tempinternode_2(seed1).timerange.min_time;
           end                   
           growth1=(u11-u12)*(u21-u22)-(tempinternode_2(seed1).pricerange.max_price-tempinternode_2(seed1).pricerange.min_price)*(tempinternode_2(seed1).timerange.max_time-tempinternode_2(seed1).timerange.min_time);
           
       if   growth1>=growth0
           if  node1_num<=floor(size(tempinternode_2,2)/2)
               
    internode_2(1).internode_1(node1_num+1)=tempinternode_2(k);
    internode_2(1).sum=internode_2(1).sum+tempinternode_2(k).sum;
    internode_2(1).rating(1)=internode_2(1).rating(1)+tempinternode_2(k).rating(1);
    internode_2(1).rating(2)=internode_2(1).rating(2)+tempinternode_2(k).rating(2);
    internode_2(1).rating(3)=internode_2(1).rating(3)+tempinternode_2(k).rating(3);
    internode_2(1).rating(4)=internode_2(1).rating(4)+tempinternode_2(k).rating(4);
    internode_2(1).rating(5)=internode_2(1).rating(5)+tempinternode_2(k).rating(5);
    if internode_2(1).pricerange.max_price<tempinternode_2(k).pricerange.max_price
        internode_2(1).pricerange.max_price=tempinternode_2(k).pricerange.max_price;
    end
    if internode_2(1).pricerange.min_price>tempinternode_2(k).pricerange.min_price
         internode_2(1).pricerange.min_price=tempinternode_2(k).pricerange.min_price;
    end
    if internode_2(1).timerange.max_time<tempinternode_2(k).timerange.max_time
        internode_2(1).timerange.max_time=tempinternode_2(k).timerange.max_time;
    end
    if  internode_2(1).timerange.min_time>tempinternode_2(k).timerange.min_time
        internode_2(1).timerange.min_time=tempinternode_2(k).timerange.min_time;
    end
    indexinternode_1(k)=1;          
       else
  %  internode_2(2).n_count=internode_2(2).n_count+1;
    internode_2(2).internode_1(node2_num+1)=tempinternode_2(k);
    internode_2(2).sum=internode_2(2).sum+tempinternode_2(k).sum;
    internode_2(2).rating(1)=internode_2(2).rating(1)+tempinternode_2(k).rating(1);
    internode_2(2).rating(2)=internode_2(2).rating(2)+tempinternode_2(k).rating(2);
    internode_2(2).rating(3)=internode_2(2).rating(3)+tempinternode_2(k).rating(3);
    internode_2(2).rating(4)=internode_2(2).rating(4)+tempinternode_2(k).rating(4);
    internode_2(2).rating(5)=internode_2(2).rating(5)+tempinternode_2(k).rating(5);
    if internode_2(2).pricerange.max_price<tempinternode_2(k).pricerange.max_price
        internode_2(2).pricerange.max_price=tempinternode_2(k).pricerange.max_price;
    end
    if internode_2(2).pricerange.min_price>tempinternode_2(k).pricerange.min_price
         internode_2(2).pricerange.min_price=tempinternode_2(k).pricerange.min_price;
    end
    if internode_2(2).timerange.max_time<tempinternode_2(k).timerange.max_time
        internode_2(2).timerange.max_time=tempinternode_2(k).timerange.max_time;
    end
    if  internode_2(2).timerange.min_time>tempinternode_2(k).timerange.min_time
        internode_2(2).timerange.min_time=tempinternode_2(k).timerange.min_time;
    end
    indexinternode_1(k)=1; 
               
           end
       else
                   if  node2_num<=floor(size(tempinternode_2,2)/2)
               
              %     internode_2(2).n_count=internode_2(2).n_count+1;
    internode_2(2).internode_1(node2_num+1)=tempinternode_2(k);
    internode_2(2).sum=internode_2(2).sum+tempinternode_2(k).sum;
    internode_2(2).rating(1)=internode_2(2).rating(1)+tempinternode_2(k).rating(1);
    internode_2(2).rating(2)=internode_2(2).rating(2)+tempinternode_2(k).rating(2);
    internode_2(2).rating(3)=internode_2(2).rating(3)+tempinternode_2(k).rating(3);
    internode_2(2).rating(4)=internode_2(2).rating(4)+tempinternode_2(k).rating(4);
    internode_2(2).rating(5)=internode_2(2).rating(5)+tempinternode_2(k).rating(5);
    if internode_2(2).pricerange.max_price<tempinternode_2(k).pricerange.max_price
        internode_2(2).pricerange.max_price=tempinternode_2(k).pricerange.max_price;
    end
    if internode_2(2).pricerange.min_price>tempinternode_2(k).pricerange.min_price
         internode_2(2).pricerange.min_price=tempinternode_2(k).pricerange.min_price;
    end
    if internode_2(2).timerange.max_time<tempinternode_2(k).timerange.max_time
        internode_2(2).timerange.max_time=tempinternode_2(k).timerange.max_time;
    end
    if  internode_2(2).timerange.min_time>tempinternode_2(k).timerange.min_time
        internode_2(2).timerange.min_time=tempinternode_2(k).timerange.min_time;
    end
    indexinternode_1(k)=1;          
                   else
    internode_2(1).internode_1(node1_num+1)=tempinternode_2(k);
    internode_2(1).sum=internode_2(1).sum+tempinternode_2(k).sum;
    internode_2(1).rating(1)=internode_2(1).rating(1)+tempinternode_2(k).rating(1);
    internode_2(1).rating(2)=internode_2(1).rating(2)+tempinternode_2(k).rating(2);
    internode_2(1).rating(3)=internode_2(1).rating(3)+tempinternode_2(k).rating(3);
    internode_2(1).rating(4)=internode_2(1).rating(4)+tempinternode_2(k).rating(4);
    internode_2(1).rating(5)=internode_2(1).rating(5)+tempinternode_2(k).rating(5);
    if internode_2(1).pricerange.max_price<tempinternode_2(k).pricerange.max_price
        internode_2(1).pricerange.max_price=tempinternode_2(k).pricerange.max_price;
    end
    if internode_2(1).pricerange.min_price>tempinternode_2(k).pricerange.min_price
         internode_2(1).pricerange.min_price=tempinternode_2(k).pricerange.min_price;
    end
    if internode_2(1).timerange.max_time<tempinternode_2(k).timerange.max_time
        internode_2(1).timerange.max_time=tempinternode_2(k).timerange.max_time;
    end
    if  internode_2(1).timerange.min_time>tempinternode_2(k).timerange.min_time
        internode_2(1).timerange.min_time=tempinternode_2(k).timerange.min_time;
    end
    indexinternode_1(k)=1;    
                             
                   end
                          
       end
       
       end
       
         end


end
