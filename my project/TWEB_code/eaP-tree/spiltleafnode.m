function [internode_1, internode_2, totalleafnode]=spiltleafnode(internode, leaf, j ,totalleafnode)

%     internode_1.within_number=0;
%     internode_1.within_rating=0;
    internode_1.sum_number=0;
    internode_1.sum_rating=0;
    internode_1.level=0;
%     internode_2.within_number=0;
%     internode_2.within_rating=0;
    internode_2.sum_number=0;
    internode_2.sum_rating=0;
    internode_2.level=0;
%     internode.leafnode=leafnode;
%     internode.price=leafnode.price;   %%internode节点的key
%     internode.timerange.timebegin=leafnode.time;
%     internode.timerange.timeend='*';
    

templeafnode=totalleafnode(j, internode.leafnode).leaf;
i=size(templeafnode, 2);
templeafnode(i+1)=leaf;

for  p=1:1:i   
    for k=(p+1):1:(i+1)
        
        if   templeafnode(p).price >templeafnode(k).price
            kaoleafnode=templeafnode(p);
            templeafnode(p)=templeafnode(k);
            templeafnode(k)=kaoleafnode;            
        end
        
    end
end



rtempnode=totalleafnode(j,:);
   newnodenumber=1;  %%%叶子所属版本加1 因为又有个一个新的版本   
     for  p=1:1:size(rtempnode,2)
           if isempty(rtempnode(p).leaf)
               break;
           else
               newnodenumber=newnodenumber+1;               
           end   
     end

internode_1.pricerange.min_price=templeafnode(1).price;
internode_1.pricerange.max_price=templeafnode(1).price; 
     
for p=1:1:ceil(size(templeafnode,2)/2)
    totalleafnode(j, newnodenumber).leaf(p)=templeafnode(p);  
    internode_1.sum_rating=internode_1.sum_rating+templeafnode(p).rating;
    internode_1.sum_number=internode_1.sum_number+1;  
    if  internode_1.pricerange.min_price>templeafnode(p).price
        internode_1.pricerange.min_price=templeafnode(p).price;
    end
    if  internode_1.pricerange.max_price<templeafnode(p).price
        internode_1.pricerange.max_price=templeafnode(p).price;
    end
    
end
totalleafnode(j, newnodenumber).number=newnodenumber;

internode_1.timerange.timebegin=leaf.time;
internode_1.timerange.timeend='*';
internode_1.leafnode=newnodenumber;

newnodenumber=newnodenumber+1;

internode_2.pricerange.min_price=templeafnode((ceil(size(templeafnode,2)/2)+1)).price;
internode_2.pricerange.max_price=templeafnode((ceil(size(templeafnode,2)/2)+1)).price; 

for p=(ceil(size(templeafnode,2)/2)+1):1:(i+1)
    totalleafnode(j, newnodenumber).leaf(p-(ceil(size(templeafnode,2)/2)))=templeafnode(p); 
    internode_2.sum_rating=internode_2.sum_rating+templeafnode(p).rating;
    internode_2.sum_number=internode_2.sum_number+1;  
    
    if  internode_2.pricerange.min_price>templeafnode(p).price
        internode_2.pricerange.min_price=templeafnode(p).price;
    end
    if  internode_2.pricerange.max_price<templeafnode(p).price
        internode_2.pricerange.max_price=templeafnode(p).price;
    end
    
end

totalleafnode(j, newnodenumber).number=newnodenumber;

% internode_2.price=templeafnode(((ceil(size(templeafnode,2)/2))+1)).price;
internode_2.timerange.timebegin=leaf.time;
internode_2.timerange.timeend='*';
internode_2.leafnode=newnodenumber;

end