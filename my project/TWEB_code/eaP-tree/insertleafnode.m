function [totalleafnode,leafnode_num,temptime, mark, same, sum_number, sum_rating]=insertleafnode(internode, leaf, j, totalleafnode)
       temptime=leaf.time;
       leafnode_num=internode.leafnode;
       sum_number=0;
       sum_rating(1)=0;
       sum_rating(2)=0;
       sum_rating(3)=0;
       sum_rating(4)=0;
       sum_rating(5)=0;
       same=0;
    
    if    internode.timerange.timebegin<leaf.time
       templeafnode=totalleafnode(j, internode.leafnode).leaf;  %Ҷ�������汾��
       i=size(totalleafnode(j, internode.leafnode).leaf,2);
       templeafnode(i+1)=leaf;
        for k1=1:1:(i+1)
            sum_number=sum_number+templeafnode(k1).sum;
            sum_rating(1)=sum_rating(1)+templeafnode(k1).rating(1);
            sum_rating(2)=sum_rating(2)+templeafnode(k1).rating(2);
            sum_rating(3)=sum_rating(3)+templeafnode(k1).rating(3);
            sum_rating(4)=sum_rating(4)+templeafnode(k1).rating(4);
            sum_rating(5)=sum_rating(5)+templeafnode(k1).rating(5);
        end
       
       totalleafnode(j, internode.leafnode).leaf=templeafnode;
       
%        totalleafnode(j, newversion).version=newversion;
       mark=1;
       same=0;
      
   else  internode.timerange.timebegin==leaf.time %#ok<NOPRT,EQEFF>
       
       templeafnode=totalleafnode(j, internode.leafnode).leaf;  %Ҷ�������汾��
       i=size(totalleafnode(j, internode.leafnode).leaf,2);%%%internode.leafnodeһ����ֵ
      % templeafnode(i+1)=leaf;
        for k1=1:1:i
            
                if  (strcmp(leaf.itemname, totalleafnode(j, internode.leafnode).leaf(k1).itemname)==1)&&(leaf.time==totalleafnode(j, internode.leafnode).leaf(k1).time)%%�������ͬ�Ľڵ����ȥ  ��ͬʱ���Ӧ���ǲ�ͬ�Ľڵ� ����Ҫ����Ū��                         
                          same=1; 
                          pot=k1;
                          
                end            
            sum_number=sum_number+templeafnode(k1).sum;
            sum_rating(1)=sum_rating(1)+templeafnode(k1).rating(1);
            sum_rating(2)=sum_rating(2)+templeafnode(k1).rating(2);
            sum_rating(3)=sum_rating(3)+templeafnode(k1).rating(3);
            sum_rating(4)=sum_rating(4)+templeafnode(k1).rating(4);
            sum_rating(5)=sum_rating(5)+templeafnode(k1).rating(5);
        end
        if  same==1
            totalleafnode(j, internode.leafnode).leaf(pot).sum=totalleafnode(j, internode.leafnode).leaf(pot).sum+1;
            totalleafnode(j, internode.leafnode).leaf(pot).rating(1)=totalleafnode(j, internode.leafnode).leaf(pot).rating(1)+leaf.rating(1);
            totalleafnode(j, internode.leafnode).leaf(pot).rating(2)=totalleafnode(j, internode.leafnode).leaf(pot).rating(2)+leaf.rating(2);
            totalleafnode(j, internode.leafnode).leaf(pot).rating(3)=totalleafnode(j, internode.leafnode).leaf(pot).rating(3)+leaf.rating(3);
            totalleafnode(j, internode.leafnode).leaf(pot).rating(4)=totalleafnode(j, internode.leafnode).leaf(pot).rating(4)+leaf.rating(4);
            totalleafnode(j, internode.leafnode).leaf(pot).rating(5)=totalleafnode(j, internode.leafnode).leaf(pot).rating(5)+leaf.rating(5);
      
        elseif same==0
            templeafnode(i+1)=leaf;
            totalleafnode(j, internode.leafnode).leaf=templeafnode;
        end
            sum_number=sum_number+1;
            sum_rating(1)=sum_rating(1)+leaf.rating(1);
            sum_rating(2)=sum_rating(2)+leaf.rating(2);
            sum_rating(3)=sum_rating(3)+leaf.rating(3);
            sum_rating(4)=sum_rating(4)+leaf.rating(4);
            sum_rating(5)=sum_rating(5)+leaf.rating(5);
       mark=0;
    end
    
end
    
