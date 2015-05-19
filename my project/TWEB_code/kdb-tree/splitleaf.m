function  [node]=splitleaf(leaf, num1, num2, rating1, rating2, rating3, rating4, rating5, item) %num2时间， num1 钱
%%%%%%%%%%%%%%%%%%%%
%%%%%此部分代码被kdbtree调用
%%%%%%%%%%%%%%%%%%%
   leaf_num=size(leaf,2); %计算叶子节点的个数  %% 确定插入位置
            
leaf(leaf_num+1).item=item;
leaf(leaf_num+1).price=num1;
leaf(leaf_num+1).time=num2;
leaf(leaf_num+1).sum_num=1;
leaf(leaf_num+1).sum_rating(1)=str2double(rating1);
leaf(leaf_num+1).sum_rating(2)=str2double(rating2);
leaf(leaf_num+1).sum_rating(3)=str2double(rating3);
leaf(leaf_num+1).sum_rating(4)=str2double(rating4);
leaf(leaf_num+1).sum_rating(5)=str2double(rating5); %#ok<NASGU>

             for p=1:1:leaf_num  %%%排序
                 for k=(p+1):1:(leaf_num+1)
                     if     leaf(p).price>leaf(k).price  %%前面大于后面的交换
                            templeaf=leaf(p);
                            leaf(p)=leaf(k);
                            leaf(k)=templeaf;            
                     end
                 end
             end 
             %%还要存下 每个node里的最大time
             divprice=round((leaf(ceil((leaf_num-1)/2)+1).price+leaf(ceil((leaf_num+1)/2)+1).price)/2);     
             
                  node(1).level=0;
                  node(1).dimark=0; %%这个变量表明node有没有1-dim
                  node(1).mintime=leaf(1).time;
                  node(1).maxtime=num2;
                  node(1).minprice=0;
                  node(1).maxprice=divprice;
                  node(1).sum_num=0;
                  node(1).sum_rating(1)=0;
                  node(1).sum_rating(2)=0;
                  node(1).sum_rating(3)=0;
                  node(1).sum_rating(4)=0;
                  node(1).sum_rating(5)=0;
                  node(1).onedimR=struct();
             for j=1:1:ceil((leaf_num+1)/2)     
                  node(1).leaf(j)=leaf(j);      
%                   if  leaf(j).price> node(1).maxprice
%                        node(1).maxprice=leaf(j).price;
%                   end     
%                   if  leaf(j).price< node(1).minprice
%                        node(1).minprice=leaf(j).price;
%                   end  
                  if  leaf(j).time < node(1).mintime
                      node(1).mintime=leaf(j).time;
                  end
%                      node(1).sum_num=node(1).sum_num+leaf(j).sum_num;
%                      node(1).sum_rating(1)=node(1).sum_rating(1)+leaf(j).sum_rating(1);
%                      node(1).sum_rating(2)=node(1).sum_rating(2)+leaf(j).sum_rating(2);
%                      node(1).sum_rating(3)=node(1).sum_rating(3)+leaf(j).sum_rating(3);
%                      node(1).sum_rating(4)=node(1).sum_rating(4)+leaf(j).sum_rating(4);
%                      node(1).sum_rating(5)=node(1).sum_rating(5)+leaf(j).sum_rating(5);
             end
                  
             %%还要存下 每个node里的最大time
                 node(2).level=0;
                 node(2).dimark=0;
                 node(2).mintime=leaf(1).time;
                 node(2).maxtime=num2;
                 node(2).minprice=divprice;
                 node(2).maxprice=100000;  %%max
                 node(2).sum_num=0;
                 node(2).sum_rating(1)=0;
                 node(2).sum_rating(2)=0;
                 node(2).sum_rating(3)=0;
                 node(2).sum_rating(4)=0;
                 node(2).sum_rating(5)=0;
                 node(2).onedimR=struct();
             for j=(ceil((leaf_num+1)/2)+1):1:(leaf_num+1)
                 node(2).leaf(j-ceil((leaf_num+1)/2))=leaf(j);    
%                   if  leaf(j).price> node(2).maxprice
%                        node(2).maxprice=leaf(j).price;
%                   end     
%                   if  leaf(j).price< node(2).minprice
%                        node(2).minprice=leaf(j).price;
%                   end    
                  if leaf(j).time < node(2).mintime
                      node(2).mintime=leaf(j).time;
                  end 
%                      node(2).sum_num=node(2).sum_num+leaf(j).sum_num;
%                      node(2).sum_rating(1)=node(2).sum_rating(1)+leaf(j).sum_rating(1);
%                      node(2).sum_rating(2)=node(2).sum_rating(2)+leaf(j).sum_rating(2);
%                      node(2).sum_rating(3)=node(2).sum_rating(3)+leaf(j).sum_rating(3);
%                      node(2).sum_rating(4)=node(2).sum_rating(4)+leaf(j).sum_rating(4);
%                      node(2).sum_rating(5)=node(2).sum_rating(5)+leaf(j).sum_rating(5);
                                    
             end
             if  node(2).mintime>=node(1).mintime
                 node(2).mintime=node(1).mintime;
             else
                 node(1).mintime=node(2).mintime;
             end
            
end