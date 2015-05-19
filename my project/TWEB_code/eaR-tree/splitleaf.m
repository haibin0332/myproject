function [tempinternode1, tempinternode2]=splitleaf(leaftemp, seed0, seed1, indexleaftemp, max_price, min_price, max_time, min_time, n_maxcount)
    leaf_num=size(leaftemp, 2);
   tempinternode1.n_level=0;
 %  tempinternode1.n_count=1; %%注意哦  seed1是新的一个节点
  % tempinternode1.leafnode=struct('itemname',{},'rating',{},'price',{}, 'time',{}); 
   tempinternode1.leafnode=leaftemp(seed0);
   tempinternode1.sum=leaftemp(seed0).sum;
   tempinternode1.rating(1)=leaftemp(seed0).rating(1);
   tempinternode1.rating(2)=leaftemp(seed0).rating(2);
   tempinternode1.rating(3)=leaftemp(seed0).rating(3);
   tempinternode1.rating(4)=leaftemp(seed0).rating(4);
   tempinternode1.rating(5)=leaftemp(seed0).rating(5);
   tempinternode1.pricerange.max_price=leaftemp(seed0).price;
   tempinternode1.pricerange.min_price=leaftemp(seed0).price;
   tempinternode1.timerange.max_time=leaftemp(seed0).time;
   tempinternode1.timerange.min_time=leaftemp(seed0).time;
   indexleaftemp(seed0)=1;
   
     tempinternode2.n_level=0;
    tempinternode2.leafnode=leaftemp(seed1);
   tempinternode2.sum=leaftemp(seed1).sum;
   tempinternode2.rating(1)=leaftemp(seed1).rating(1);
   tempinternode2.rating(2)=leaftemp(seed1).rating(2);
   tempinternode2.rating(3)=leaftemp(seed1).rating(3);
   tempinternode2.rating(4)=leaftemp(seed1).rating(4);
   tempinternode2.rating(5)=leaftemp(seed1).rating(5);
   baomaxprice=max_price;
   baominprice=min_price;
    if  baominprice>leaftemp(leaf_num).price%% 如果输入的值更小
        baominprice=leaftemp(leaf_num).price;      
    end 
    
    if  baomaxprice<leaftemp(leaf_num).price %% 如果输入的值更大
        baomaxprice=leaftemp(leaf_num).price;
    end 
   
   tempinternode2.pricerange.max_price=leaftemp(seed1).price;
   tempinternode2.pricerange.min_price=leaftemp(seed1).price;
   baomaxtime=max_time;
   baomintime=min_time;
    if  baomintime>leaftemp(leaf_num).time%% 如果输入的值更小
        baomintime=leaftemp(leaf_num).time;      
    end 
    
    if  baomaxtime<leaftemp(leaf_num).time %% 如果输入的值更大
        baomaxtime=leaftemp(leaf_num).time;
    end 
   tempinternode2.timerange.max_time=leaftemp(seed1).time;
   tempinternode2.timerange.min_time=leaftemp(seed1).time;
   indexleaftemp(seed1)=1;


  for  k=1:1:leaf_num    
        leaf1_num=size(tempinternode1.leafnode,2); %n_count
        leaf2_num=size(tempinternode2.leafnode,2); %n_count        
       if indexleaftemp(k)==0    
           if  baomaxtime>baomintime
           growth0=sqrt(((leaftemp(k).price- leaftemp(seed0).price)/(baomaxprice-baominprice))^2+(((leaftemp(k).time- leaftemp(seed0).time)/(baomaxtime-baomintime))^2));
           growth1=sqrt(((leaftemp(k).price- leaftemp(seed1).price)/(baomaxprice-baominprice))^2+(((leaftemp(k).time- leaftemp(seed1).time)/(baomaxtime-baomintime))^2));
           else
           growth0=sqrt(((leaftemp(k).price- leaftemp(seed0).price)/(baomaxprice-baominprice))^2);
           growth1=sqrt(((leaftemp(k).price- leaftemp(seed1).price)/(baomaxprice-baominprice))^2);    
           end
           if  growth1>=growth0            
              if  leaf1_num<=floor((n_maxcount+1)/2) 
                  tempinternode1.leafnode(leaf1_num+1)=leaftemp(k);
                  tempinternode1.sum=tempinternode1.sum+leaftemp(k).sum;
                  tempinternode1.rating(1)=tempinternode1.rating(1)+leaftemp(k).rating(1);
                  tempinternode1.rating(2)=tempinternode1.rating(2)+leaftemp(k).rating(2);
                  tempinternode1.rating(3)=tempinternode1.rating(3)+leaftemp(k).rating(3);
                  tempinternode1.rating(4)=tempinternode1.rating(4)+leaftemp(k).rating(4);
                  tempinternode1.rating(5)=tempinternode1.rating(5)+leaftemp(k).rating(5);
                     if  tempinternode1.pricerange.min_price>leaftemp(k).price   
       tempinternode1.pricerange.min_price=leaftemp(k).price;    
                    end
   if   tempinternode1.pricerange.max_price<leaftemp(k).price   
       tempinternode1.pricerange.max_price=leaftemp(k).price;     
   end
   if  tempinternode1.timerange.min_time>leaftemp(k).time   
       tempinternode1.timerange.min_time=leaftemp(k).time;   
   end
   if  tempinternode1.timerange.max_time<leaftemp(k).time     
       tempinternode1.timerange.max_time=leaftemp(k).time;      
   end
    indexleaftemp(k)=1;
              else                
                   tempinternode2.leafnode(leaf2_num+1)=leaftemp(k);
                  tempinternode2.sum=tempinternode1.sum+leaftemp(k).sum;
                  tempinternode2.rating(1)=tempinternode2.rating(1)+leaftemp(k).rating(1);
                  tempinternode2.rating(2)=tempinternode2.rating(2)+leaftemp(k).rating(2);
                  tempinternode2.rating(3)=tempinternode2.rating(3)+leaftemp(k).rating(3);
                  tempinternode2.rating(4)=tempinternode2.rating(4)+leaftemp(k).rating(4);
                  tempinternode2.rating(5)=tempinternode2.rating(5)+leaftemp(k).rating(5);
                                        if  tempinternode2.pricerange.min_price>leaftemp(k).price   
       tempinternode2.pricerange.min_price=leaftemp(k).price;    
                                       end
   if   tempinternode2.pricerange.max_price<leaftemp(k).price   
       tempinternode2.pricerange.max_price=leaftemp(k).price;     
   end
   if  tempinternode2.timerange.min_time>leaftemp(k).time   
       tempinternode2.timerange.min_time=leaftemp(k).time;   
   end
   if  tempinternode2.timerange.max_time<leaftemp(k).time     
       tempinternode2.timerange.max_time=leaftemp(k).time;      
   end
    indexleaftemp(k)=1;
                  
              end
              
       else
        if leaf2_num<=floor((n_maxcount+1)/2)
                  tempinternode2.leafnode(leaf2_num+1)=leaftemp(k);
                  tempinternode2.sum=tempinternode2.sum+leaftemp(k).sum;
                  tempinternode2.rating(1)=tempinternode2.rating(1)+leaftemp(k).rating(1);
                  tempinternode2.rating(2)=tempinternode2.rating(2)+leaftemp(k).rating(2);
                  tempinternode2.rating(3)=tempinternode2.rating(3)+leaftemp(k).rating(3);
                  tempinternode2.rating(4)=tempinternode2.rating(4)+leaftemp(k).rating(4);
                  tempinternode2.rating(5)=tempinternode2.rating(5)+leaftemp(k).rating(5);
                                        if  tempinternode2.pricerange.min_price>leaftemp(k).price   
       tempinternode2.pricerange.min_price=leaftemp(k).price;    
                                       end
   if   tempinternode2.pricerange.max_price<leaftemp(k).price   
       tempinternode2.pricerange.max_price=leaftemp(k).price;     
   end
   if  tempinternode2.timerange.min_time>leaftemp(k).time   
       tempinternode2.timerange.min_time=leaftemp(k).time;   
   end
   if  tempinternode2.timerange.max_time<leaftemp(k).time     
       tempinternode2.timerange.max_time=leaftemp(k).time;      
   end
    indexleaftemp(k)=1;
                  
        else
                  tempinternode1.leafnode(leaf1_num+1)=leaftemp(k);
                  tempinternode1.sum=tempinternode1.sum+leaftemp(k).sum;
                  tempinternode1.rating(1)=tempinternode1.rating(1)+leaftemp(k).rating(1);
                  tempinternode1.rating(2)=tempinternode1.rating(2)+leaftemp(k).rating(2);
                  tempinternode1.rating(3)=tempinternode1.rating(3)+leaftemp(k).rating(3);
                  tempinternode1.rating(4)=tempinternode1.rating(4)+leaftemp(k).rating(4);
                  tempinternode1.rating(5)=tempinternode1.rating(5)+leaftemp(k).rating(5);
                     if  tempinternode1.pricerange.min_price>leaftemp(k).price   
       tempinternode1.pricerange.min_price=leaftemp(k).price;    
                    end
   if   tempinternode1.pricerange.max_price<leaftemp(k).price   
       tempinternode1.pricerange.max_price=leaftemp(k).price;     
   end
   if  tempinternode1.timerange.min_time>leaftemp(k).time   
       tempinternode1.timerange.min_time=leaftemp(k).time;   
   end
   if  tempinternode1.timerange.max_time<leaftemp(k).time     
       tempinternode1.timerange.max_time=leaftemp(k).time;      
   end
    indexleaftemp(k)=1;
            
        end
                                         
           end
       
       end
       
  end 


end
