function  [node1]=smallsplitnode(node, num1, num2, rating1, rating2, rating3, rating4, rating5, item) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%此部分被splitnode调用
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

leaf_num=size(node.leaf,2); %计算叶子节点的个数  %% 确定插入位置
            
node.leaf(leaf_num+1).item=item;
node.leaf(leaf_num+1).price=num1;
node.leaf(leaf_num+1).time=num2;
node.leaf(leaf_num+1).sum_num=1;
node.leaf(leaf_num+1).sum_rating(1)=str2double(rating1);
node.leaf(leaf_num+1).sum_rating(2)=str2double(rating2);
node.leaf(leaf_num+1).sum_rating(3)=str2double(rating3);
node.leaf(leaf_num+1).sum_rating(4)=str2double(rating4);
node.leaf(leaf_num+1).sum_rating(5)=str2double(rating5); %#ok<NASGU>

             for p=1:1:leaf_num  %%%排序
                 for k=(p+1):1:(leaf_num+1)
                     if     node.leaf(p).price>node.leaf(k).price  %%前面大于后面的交换
                            templeaf=node.leaf(p);
                            node.leaf(p)=node.leaf(k);
                            node.leaf(k)=templeaf;            
                     end
                 end
             end 
             %%还要存下 每个node里的最大time
%divprice=round((node.leaf(1).price+node.leaf(ceil((leaf_num+1)/2)+1).price)/2); 
%%%从这里开始divprice做中间量进行划分onedimR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
divprice=round((node.leaf(ceil(leaf_num/2)).price+node.leaf(ceil(leaf_num/2)+1).price)/2);


R=divonedimR(divprice, node.onedimR);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
node1(1).level=0;
node1(1).dimark=node.dimark;
node1(1).mintime=node.mintime;
node1(1).maxtime=num2;
node1(1).minprice=node.minprice;
node1(1).maxprice=divprice;
node1(1).sum_num=R(1).sum_num;
node1(1).sum_rating(1)=R(1).sum_rating(1);
node1(1).sum_rating(2)=R(1).sum_rating(2);
node1(1).sum_rating(3)=R(1).sum_rating(3);
node1(1).sum_rating(4)=R(1).sum_rating(4);
node1(1).sum_rating(5)=R(1).sum_rating(5);
node1(1).onedimR=R(1).onedimR;

             for j=1:1:ceil((leaf_num+1)/2)     
                  node1(1).leaf(j)=node.leaf(j);      
             end

             
node1(2).level=0;
node1(2).dimark=node.dimark;
node1(2).mintime=node.mintime;
node1(2).maxtime=num2;
node1(2).minprice=divprice;
node1(2).maxprice=node.maxprice;
node1(2).sum_num=R(2).sum_num;
node1(2).sum_rating(1)=R(2).sum_rating(1);
node1(2).sum_rating(2)=R(2).sum_rating(2);
node1(2).sum_rating(3)=R(2).sum_rating(3);
node1(2).sum_rating(4)=R(2).sum_rating(4);
node1(2).sum_rating(5)=R(2).sum_rating(5);
node1(2).onedimR=R(2).onedimR;

             for j=(ceil((leaf_num+1)/2)+1):1:(leaf_num+1)
                 node1(2).leaf(j-ceil((leaf_num+1)/2))=node.leaf(j);                  
             end


  
end