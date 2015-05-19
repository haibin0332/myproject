function  [node3, mark]=splitonedimleafnode(node1, node2)
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%此部分代码被mergeleaf和mergeleafandnode调用
%%%%%%%%%%%%%%%%%%%%%%%%%%%
leaf_num=size(node1,2);
sameitem=0; 
max=100000;
for k=1:1:leaf_num   
      if  strcmp(node1(k).item, node2.item)==1
          node1(k).sum_num=node1(k).sum_num+node2.sum_num;
          node1(k).sum_rating(1)=node1(k).sum_rating(1)+node2.sum_rating(1);
          node1(k).sum_rating(2)=node1(k).sum_rating(2)+node2.sum_rating(2);
          node1(k).sum_rating(3)=node1(k).sum_rating(3)+node2.sum_rating(3);
          node1(k).sum_rating(4)=node1(k).sum_rating(4)+node2.sum_rating(4);
          node1(k).sum_rating(5)=node1(k).sum_rating(5)+node2.sum_rating(5);
          sameitem=1;  
          node3=node1;
          mark=0;
      end     
end

if sameitem==0 %%插入
    %分裂了 记住都是b+树  叶子结点全在下面
        mark=1;
        node1(leaf_num+1).item=node2.item;
        node1(leaf_num+1).price=node2.price;
        node1(leaf_num+1).sum_num=node2.sum_num;
        node1(leaf_num+1).sum_rating(1)=node2.sum_rating(1);
        node1(leaf_num+1).sum_rating(2)=node2.sum_rating(2);
        node1(leaf_num+1).sum_rating(3)=node2.sum_rating(3);
        node1(leaf_num+1).sum_rating(4)=node2.sum_rating(4);
        node1(leaf_num+1).sum_rating(5)=node2.sum_rating(5);
                         for p=1:1:leaf_num                                          %%2个for循环1-dim排序
                             for q=(p+1):1:(leaf_num+1)
                                    if node1(p).price>node1(q).price  %%前面大于后面的交换
                                       anotherleaf=node1(p);
                                       node1(p)=node1(q);
                                       node1(q)=anotherleaf;            
                                    end                                      
                             end
                         end
    
    node3(1).level=0;
    node3(1).maxprice=node1(ceil((leaf_num+1)/2)+1).price;
    node3(1).sum_num=0;
    node3(1).sum_rating(1)=0;
    node3(1).sum_rating(2)=0;
    node3(1).sum_rating(3)=0;
    node3(1).sum_rating(4)=0;
    node3(1).sum_rating(5)=0;
    
    node3(2).level=0;
    node3(2).maxprice=max;
    node3(2).sum_num=0;
    node3(2).sum_rating(1)=0;
    node3(2).sum_rating(2)=0;
    node3(2).sum_rating(3)=0;
    node3(2).sum_rating(4)=0;
    node3(2).sum_rating(5)=0;
    
             for j=1:1:ceil((leaf_num+1)/2)     
                  node3(1).node(j)=node1(j);
                  node3(1).sum_num=node3(1).sum_num+node1(j).sum_num;
                  node3(1).sum_rating(1)=node3(1).sum_rating(1)+node1(j).sum_rating(1);
                  node3(1).sum_rating(2)=node3(1).sum_rating(2)+node1(j).sum_rating(2);
                  node3(1).sum_rating(3)=node3(1).sum_rating(3)+node1(j).sum_rating(3);
                  node3(1).sum_rating(4)=node3(1).sum_rating(4)+node1(j).sum_rating(4);
                  node3(1).sum_rating(5)=node3(1).sum_rating(5)+node1(j).sum_rating(5);
             end
                   
             for j=(ceil((leaf_num+1)/2)+1):1:(leaf_num+1)     
                  node3(2).node(j-ceil((leaf_num+1)/2))=node1(j);   
                  node3(2).sum_num=node3(2).sum_num+node1(j).sum_num;
                  node3(2).sum_rating(1)=node3(2).sum_rating(1)+node1(j).sum_rating(1);
                  node3(2).sum_rating(2)=node3(2).sum_rating(2)+node1(j).sum_rating(2);
                  node3(2).sum_rating(3)=node3(2).sum_rating(3)+node1(j).sum_rating(3);
                  node3(2).sum_rating(4)=node3(2).sum_rating(4)+node1(j).sum_rating(4);
                  node3(2).sum_rating(5)=node3(2).sum_rating(5)+node1(j).sum_rating(5);
             end
end
      
end