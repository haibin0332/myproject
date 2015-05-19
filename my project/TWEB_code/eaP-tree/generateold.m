function  [internode1_1]=generateold(internode, leaf, time)

    internode1_1.sum_number=[];  
    internode1_1.sum_rating=[]; 
    internode1_1.level=1;

                                  node1_num=size(internode, 2);
                                  internode1_1.pricerange.min_price=internode(1).pricerange.min_price; 
                                  internode1_1.pricerange.max_price=internode(1).pricerange.max_price; 
                                  for o=1:1:node1_num
                                      if  internode1_1.pricerange.min_price>internode(o).pricerange.min_price  
                                          internode1_1.pricerange.min_price=internode(o).pricerange.min_price;
                                      elseif internode1_1.pricerange.max_price<internode(o).pricerange.max_price 
                                          internode1_1.pricerange.max_price=internode(o).pricerange.max_price;
                                      end
                                  end
                                  internode1_1.timerange.timebegin=time;
                                  internode1_1.timerange.timeend=leaf.time;
                                  internode1_1.internode=internode;  
   
end