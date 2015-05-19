function [internode_3]=splitnode2(tempinternode_3, seed0, seed1, indexinternode_1)
     
    internode_3(1).n_level=3;
    internode_3(1).internode_2=tempinternode_3(seed0);
    internode_3(1).sum=tempinternode_3(seed0).sum;
    internode_3(1).rating(1)=tempinternode_3(seed0).rating(1);
    internode_3(1).rating(2)=tempinternode_3(seed0).rating(2);
    internode_3(1).rating(3)=tempinternode_3(seed0).rating(3);
    internode_3(1).rating(4)=tempinternode_3(seed0).rating(4);
    internode_3(1).rating(5)=tempinternode_3(seed0).rating(5);
    internode_3(1).pricerange.max_price=tempinternode_3(seed0).pricerange.max_price;
    internode_3(1).pricerange.min_price=tempinternode_3(seed0).pricerange.min_price;
    internode_3(1).timerange.max_time=tempinternode_3(seed0).timerange.max_time;
    internode_3(1).timerange.min_time=tempinternode_3(seed0).timerange.min_time;
    indexinternode_1(seed0)=1;
    
    internode_3(2).n_level=3;
    internode_3(2).internode_2=tempinternode_3(seed1);
    internode_3(2).sum=tempinternode_3(seed1).sum;
    internode_3(2).rating(1)=tempinternode_3(seed1).rating(1);
    internode_3(2).rating(2)=tempinternode_3(seed1).rating(2);
    internode_3(2).rating(3)=tempinternode_3(seed1).rating(3);
    internode_3(2).rating(4)=tempinternode_3(seed1).rating(4);
    internode_3(2).rating(5)=tempinternode_3(seed1).rating(5);
    internode_3(2).pricerange.max_price=tempinternode_3(seed1).pricerange.max_price;
    internode_3(2).pricerange.min_price=tempinternode_3(seed1).pricerange.min_price;
    internode_3(2).timerange.max_time=tempinternode_3(seed1).timerange.max_time;
    internode_3(2).timerange.min_time=tempinternode_3(seed1).timerange.min_time;
    indexinternode_1(seed1)=1;  
      
         for  k=1:1:size(tempinternode_3,2)
       node1_num=size(internode_3(1).internode_2, 2);
       node2_num=size(internode_3(2).internode_2, 2);
       if indexinternode_1(k)==0
           if tempinternode_3(k).pricerange.max_price>tempinternode_3(seed0).pricerange.max_price
               u11=tempinternode_3(k).pricerange.max_price;
           else
               u11=tempinternode_3(seed0).pricerange.max_price;
           end
           if tempinternode_3(k).pricerange.min_price<tempinternode_3(seed0).pricerange.min_price
               u12=tempinternode_3(k).pricerange.min_price;
           else
               u12=tempinternode_3(seed0).pricerange.min_price;
           end
           if tempinternode_3(k).timerange.max_time>tempinternode_3(seed0).timerange.max_time
               u21=tempinternode_3(k).timerange.max_time;
           else
               u21=tempinternode_3(seed0).timerange.max_time;
           end
           if tempinternode_3(k).timerange.min_time<tempinternode_3(seed0).timerange.min_time
               u22=tempinternode_3(k).timerange.min_time;
           else
               u22=tempinternode_3(seed0).timerange.min_time;
           end
           growth0=(u11-u12)*(u21-u22)-(tempinternode_3(seed0).pricerange.max_price-tempinternode_3(seed0).pricerange.min_price)*(tempinternode_3(seed0).timerange.max_time-tempinternode_3(seed0).timerange.min_time);
           if tempinternode_3(k).pricerange.max_price>tempinternode_3(seed1).pricerange.max_price
               u11=tempinternode_3(k).pricerange.max_price;
           else
               u11=tempinternode_3(seed1).pricerange.max_price;
           end
           if tempinternode_3(k).pricerange.min_price<tempinternode_3(seed1).pricerange.min_price
               u12=tempinternode_3(k).pricerange.min_price;
           else
               u12=tempinternode_3(seed1).pricerange.min_price;
           end
           if tempinternode_3(k).timerange.max_time>tempinternode_3(seed1).timerange.max_time
               u21=tempinternode_3(k).timerange.max_time;
           else
               u21=tempinternode_3(seed1).timerange.max_time;
           end
           if tempinternode_3(k).timerange.min_time<tempinternode_3(seed1).timerange.min_time
               u22=tempinternode_3(k).timerange.min_time;
           else
               u22=tempinternode_3(seed1).timerange.min_time;
           end                   
           growth1=(u11-u12)*(u21-u22)-(tempinternode_3(seed1).pricerange.max_price-tempinternode_3(seed1).pricerange.min_price)*(tempinternode_3(seed1).timerange.max_time-tempinternode_3(seed1).timerange.min_time);
           
       if   growth1>=growth0
           if  node1_num<=floor(size(tempinternode_3,2)/2)
               
    internode_3(1).internode_2(node1_num+1)=tempinternode_3(k);
    internode_3(1).sum=internode_3(1).sum+tempinternode_3(k).sum;
    internode_3(1).rating(1)=internode_3(1).rating(1)+tempinternode_3(k).rating(1);
    internode_3(1).rating(2)=internode_3(1).rating(2)+tempinternode_3(k).rating(2);
    internode_3(1).rating(3)=internode_3(1).rating(3)+tempinternode_3(k).rating(3);
    internode_3(1).rating(4)=internode_3(1).rating(4)+tempinternode_3(k).rating(4);
    internode_3(1).rating(5)=internode_3(1).rating(5)+tempinternode_3(k).rating(5);
    if internode_3(1).pricerange.max_price<tempinternode_3(k).pricerange.max_price
        internode_3(1).pricerange.max_price=tempinternode_3(k).pricerange.max_price;
    end
    if internode_3(1).pricerange.min_price>tempinternode_3(k).pricerange.min_price
         internode_3(1).pricerange.min_price=tempinternode_3(k).pricerange.min_price;
    end
    if internode_3(1).timerange.max_time<tempinternode_3(k).timerange.max_time
        internode_3(1).timerange.max_time=tempinternode_3(k).timerange.max_time;
    end
    if  internode_3(1).timerange.min_time>tempinternode_3(k).timerange.min_time
        internode_3(1).timerange.min_time=tempinternode_3(k).timerange.min_time;
    end
    indexinternode_1(k)=1;          
       else
  %  internode_2(2).n_count=internode_2(2).n_count+1;
    internode_3(2).internode_2(node2_num+1)=tempinternode_3(k);
    internode_3(2).sum=internode_3(2).sum+tempinternode_3(k).sum;
    internode_3(2).rating(1)=internode_3(2).rating(1)+tempinternode_3(k).rating(1);
    internode_3(2).rating(2)=internode_3(2).rating(2)+tempinternode_3(k).rating(2);
    internode_3(2).rating(3)=internode_3(2).rating(3)+tempinternode_3(k).rating(3);
    internode_3(2).rating(4)=internode_3(2).rating(4)+tempinternode_3(k).rating(4);
    internode_3(2).rating(5)=internode_3(2).rating(5)+tempinternode_3(k).rating(5);
    if internode_3(2).pricerange.max_price<tempinternode_3(k).pricerange.max_price
        internode_3(2).pricerange.max_price=tempinternode_3(k).pricerange.max_price;
    end
    if internode_3(2).pricerange.min_price>tempinternode_3(k).pricerange.min_price
         internode_3(2).pricerange.min_price=tempinternode_3(k).pricerange.min_price;
    end
    if internode_3(2).timerange.max_time<tempinternode_3(k).timerange.max_time
        internode_3(2).timerange.max_time=tempinternode_3(k).timerange.max_time;
    end
    if  internode_3(2).timerange.min_time>tempinternode_3(k).timerange.min_time
        internode_3(2).timerange.min_time=tempinternode_3(k).timerange.min_time;
    end
    indexinternode_1(k)=1; 
               
           end
       else
                   if  node2_num<=floor(size(tempinternode_3,2)/2)
               
              %     internode_2(2).n_count=internode_2(2).n_count+1;
    internode_3(2).internode_2(node2_num+1)=tempinternode_3(k);
    internode_3(2).sum=internode_3(2).sum+tempinternode_3(k).sum;
    internode_3(2).rating(1)=internode_3(2).rating(1)+tempinternode_3(k).rating(1);
    internode_3(2).rating(2)=internode_3(2).rating(2)+tempinternode_3(k).rating(2);
    internode_3(2).rating(3)=internode_3(2).rating(3)+tempinternode_3(k).rating(3);
    internode_3(2).rating(4)=internode_3(2).rating(4)+tempinternode_3(k).rating(4);
    internode_3(2).rating(5)=internode_3(2).rating(5)+tempinternode_3(k).rating(5);
    if internode_3(2).pricerange.max_price<tempinternode_3(k).pricerange.max_price
        internode_3(2).pricerange.max_price=tempinternode_3(k).pricerange.max_price;
    end
    if internode_3(2).pricerange.min_price>tempinternode_3(k).pricerange.min_price
         internode_3(2).pricerange.min_price=tempinternode_3(k).pricerange.min_price;
    end
    if internode_3(2).timerange.max_time<tempinternode_3(k).timerange.max_time
        internode_3(2).timerange.max_time=tempinternode_3(k).timerange.max_time;
    end
    if  internode_3(2).timerange.min_time>tempinternode_3(k).timerange.min_time
        internode_3(2).timerange.min_time=tempinternode_3(k).timerange.min_time;
    end
    indexinternode_1(k)=1;          
                   else
    internode_3(1).internode_2(node1_num+1)=tempinternode_3(k);
    internode_3(1).sum=internode_3(1).sum+tempinternode_3(k).sum;
    internode_3(1).rating(1)=internode_3(1).rating(1)+tempinternode_3(k).rating(1);
    internode_3(1).rating(2)=internode_3(1).rating(2)+tempinternode_3(k).rating(2);
    internode_3(1).rating(3)=internode_3(1).rating(3)+tempinternode_3(k).rating(3);
    internode_3(1).rating(4)=internode_3(1).rating(4)+tempinternode_3(k).rating(4);
    internode_3(1).rating(5)=internode_3(1).rating(5)+tempinternode_3(k).rating(5);
    if internode_3(1).pricerange.max_price<tempinternode_3(k).pricerange.max_price
        internode_3(1).pricerange.max_price=tempinternode_3(k).pricerange.max_price;
    end
    if internode_3(1).pricerange.min_price>tempinternode_3(k).pricerange.min_price
         internode_3(1).pricerange.min_price=tempinternode_3(k).pricerange.min_price;
    end
    if internode_3(1).timerange.max_time<tempinternode_3(k).timerange.max_time
        internode_3(1).timerange.max_time=tempinternode_3(k).timerange.max_time;
    end
    if  internode_3(1).timerange.min_time>tempinternode_3(k).timerange.min_time
        internode_3(1).timerange.min_time=tempinternode_3(k).timerange.min_time;
    end
    indexinternode_1(k)=1;    
                             
                   end
                          
       end
       
       end
       
         end


end
