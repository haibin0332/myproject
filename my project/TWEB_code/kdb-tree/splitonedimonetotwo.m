function  [node3]=splitonedimonetotwo(node1, node2)
%%%%%%%%%%%%%
%%%%%%%此部分代码被mergeleafandnode调用
%%%%%%%%%%%%
leaf_num=size(node1.node,2); 

    %分裂了 记住都是b+树  叶子结点全在下面
        node1.node(leaf_num+1).item=node2.item;
        node1.node(leaf_num+1).price=node2.price;
        node1.node(leaf_num+1).sum_num=node2.sum_num;
        node1.node(leaf_num+1).sum_rating(1)=node2.sum_rating(1);
        node1.node(leaf_num+1).sum_rating(2)=node2.sum_rating(2);
        node1.node(leaf_num+1).sum_rating(3)=node2.sum_rating(3);
        node1.node(leaf_num+1).sum_rating(4)=node2.sum_rating(4);
        node1.node(leaf_num+1).sum_rating(5)=node2.sum_rating(5);
                         for p=1:1:leaf_num                                          %%2个for循环1-dim排序
                             for q=(p+1):1:(leaf_num+1)
                                    if node1.node(p).price>node1.node(q).price  %%前面大于后面的交换
                                       anotherleaf=node1.node(p);
                                       node1.node(p)=node1.node(q);
                                       node1.node(q)=anotherleaf;            
                                    end                                      
                             end
                         end
    
    node3(1).level=0;
    node3(1).maxprice=node1.node(ceil((leaf_num+1)/2)+1).price;
    node3(1).sum_num=0;
    node3(1).sum_rating(1)=0;
    node3(1).sum_rating(2)=0;
    node3(1).sum_rating(3)=0;
    node3(1).sum_rating(4)=0;
    node3(1).sum_rating(5)=0;
    
    node3(2).level=0;
    node3(2).maxprice=node1.maxprice;
    node3(2).sum_num=0;
    node3(2).sum_rating(1)=0;
    node3(2).sum_rating(2)=0;
    node3(2).sum_rating(3)=0;
    node3(2).sum_rating(4)=0;
    node3(2).sum_rating(5)=0;
    
             for j=1:1:ceil((leaf_num+1)/2)     
                  node3(1).node(j)=node1.node(j);
                  node3(1).sum_num=node3(1).sum_num+node1.node(j).sum_num;
                  node3(1).sum_rating(1)=node3(1).sum_rating(1)+node1.node(j).sum_rating(1);
                  node3(1).sum_rating(2)=node3(1).sum_rating(2)+node1.node(j).sum_rating(2);
                  node3(1).sum_rating(3)=node3(1).sum_rating(3)+node1.node(j).sum_rating(3);
                  node3(1).sum_rating(4)=node3(1).sum_rating(4)+node1.node(j).sum_rating(4);
                  node3(1).sum_rating(5)=node3(1).sum_rating(5)+node1.node(j).sum_rating(5);
             end
                   
             for j=(ceil((leaf_num+1)/2)+1):1:(leaf_num+1)     
                  node3(2).node(j-ceil((leaf_num+1)/2))=node1.node(j);   
                  node3(2).sum_num=node3(2).sum_num+node1.node(j).sum_num;
                  node3(2).sum_rating(1)=node3(2).sum_rating(1)+node1.node(j).sum_rating(1);
                  node3(2).sum_rating(2)=node3(2).sum_rating(2)+node1.node(j).sum_rating(2);
                  node3(2).sum_rating(3)=node3(2).sum_rating(3)+node1.node(j).sum_rating(3);
                  node3(2).sum_rating(4)=node3(2).sum_rating(4)+node1.node(j).sum_rating(4);
                  node3(2).sum_rating(5)=node3(2).sum_rating(5)+node1.node(j).sum_rating(5);
             end
end
