function  [sum, r1, r2, r3, r4, r5, R]=mergeleaf(node) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%此部分代码被merge调用
%%%%%%%%%%%%%%%%%%%%%%%%%
n_leaf=64;%1-dim子树里的一些参数
n_node=64;
node_num=size(node,2);
r=1;
for j=1:1:node_num
    numleaf(j)=size(node(j).leaf,2);
end

for j=1:1:node_num
    for  k=1:1:numleaf(j)
         templeaf(r).item=node(j).leaf(k).item;
         templeaf(r).price=node(j).leaf(k).price;
         templeaf(r).sum_num=node(j).leaf(k).sum_num;
         templeaf(r).sum_rating(1)=node(j).leaf(k).sum_rating(1);
         templeaf(r).sum_rating(2)=node(j).leaf(k).sum_rating(2);
         templeaf(r).sum_rating(3)=node(j).leaf(k).sum_rating(3);
         templeaf(r).sum_rating(4)=node(j).leaf(k).sum_rating(4);
         templeaf(r).sum_rating(5)=node(j).leaf(k).sum_rating(5);
         r=r+1;
    end
end
sameitem=0;
leaf_num=size(templeaf,2);
tempR.level=0;
tempR.maxprice=templeaf(1).price;
tempR.minprice=templeaf(1).price;
tempR.node(1)=templeaf(1);
sum=templeaf(1).sum_num;
r1=templeaf(1).sum_rating(1);
r2=templeaf(1).sum_rating(2);
r3=templeaf(1).sum_rating(3);
r4=templeaf(1).sum_rating(4);
r5=templeaf(1).sum_rating(5);

for j=2:1:leaf_num
    if tempR.level==0
         if  (size(tempR.node,2)+1)<=n_leaf
             for k=1:1:size(tempR.node,2)           
                     if  strcmp(tempR.node(k).item, templeaf(j).item)==1
                         tempR.node(k).sum_num=tempR.node(k).sum_num+templeaf(j).sum_num;
                         tempR.node(k).sum_rating(1)=tempR.node(k).sum_rating(1)+templeaf(j).sum_rating(1);
                         tempR.node(k).sum_rating(2)=tempR.node(k).sum_rating(2)+templeaf(j).sum_rating(2);
                         tempR.node(k).sum_rating(3)=tempR.node(k).sum_rating(3)+templeaf(j).sum_rating(3);
                         tempR.node(k).sum_rating(4)=tempR.node(k).sum_rating(4)+templeaf(j).sum_rating(4);
                         tempR.node(k).sum_rating(5)=tempR.node(k).sum_rating(5)+templeaf(j).sum_rating(5);
                         sameitem=1;  
                     end
             end
             if sameitem==0 %%插入
                         temp_num=size(tempR.node,2);
                         tempR.node(temp_num+1).item=templeaf(j).item;
                         tempR.node(temp_num+1).price=templeaf(j).price;
                         tempR.node(temp_num+1).sum_num=templeaf(j).sum_num;
                         tempR.node(temp_num+1).sum_rating(1)=templeaf(j).sum_rating(1);
                         tempR.node(temp_num+1).sum_rating(2)=templeaf(j).sum_rating(2);
                         tempR.node(temp_num+1).sum_rating(3)=templeaf(j).sum_rating(3);
                         tempR.node(temp_num+1).sum_rating(4)=templeaf(j).sum_rating(4);
                         tempR.node(temp_num+1).sum_rating(5)=templeaf(j).sum_rating(5);
                         for p=1:1:temp_num                                          %%2个for循环1-dim排序
                             for q=(p+1):1:(temp_num+1)
                                    if tempR.node(p).price>tempR.node(q).price  %%前面大于后面的交换
                                       anotherleaf=tempR.node(p);
                                       tempR.node(p)=tempR.node(q);
                                       tempR.node(q)=anotherleaf;            
                                    end                                      
                             end
                         end
                                    
             end
         else  %%分裂
              [mdnode, mark]=splitonedimleafnode(tempR.node, templeaf(j));
              if mark==1
              tempR.node1=mdnode;
              tempR.node=[];
              tempR.level=tempR.level+1;
              end
              if mark==0
               tempR.node=mdnode;
              end
%              test='mergeleaf.m 72 行 叶子分裂了';
         end
        
    elseif tempR.level==1
            for p=1:1:size(tempR.node1,2)  %% 63      %%93
                       if  templeaf(j).price<tempR.node1(p).maxprice
                            w(1)=p; %#ok<NASGU>
                            break;
                       end
                       if  templeaf(j).price==tempR.node1(p).maxprice
                            w(1)=p+1; %#ok<NASGU>
                            break;
                       end
            end
            
            %%% 搜索所有tempR.node1(w(1))
            for k=1:1:size(tempR.node1(w(1)).node,2)
                    if  strcmp(tempR.node1(w(1)).node(k).item, templeaf(j).item)==1
                         tempR.node1(w(1)).node(k).sum_num=tempR.node1(w(1)).node(k).sum_num+templeaf(j).sum_num;
                         tempR.node1(w(1)).node(k).sum_rating(1)=tempR.node1(w(1)).node(k).sum_rating(1)+templeaf(j).sum_rating(1);
                         tempR.node1(w(1)).node(k).sum_rating(2)=tempR.node1(w(1)).node(k).sum_rating(2)+templeaf(j).sum_rating(2);
                         tempR.node1(w(1)).node(k).sum_rating(3)=tempR.node1(w(1)).node(k).sum_rating(3)+templeaf(j).sum_rating(3);
                         tempR.node1(w(1)).node(k).sum_rating(4)=tempR.node1(w(1)).node(k).sum_rating(4)+templeaf(j).sum_rating(4);
                         tempR.node1(w(1)).node(k).sum_rating(5)=tempR.node1(w(1)).node(k).sum_rating(5)+templeaf(j).sum_rating(5);
                         tempR.node1(w(1)).sum_num=tempR.node1(w(1)).sum_num+templeaf(j).sum_num;
                         tempR.node1(w(1)).sum_rating(1)=tempR.node1(w(1)).sum_rating(1)+templeaf(j).sum_rating(1);
                         tempR.node1(w(1)).sum_rating(2)=tempR.node1(w(1)).sum_rating(2)+templeaf(j).sum_rating(2);
                         tempR.node1(w(1)).sum_rating(3)=tempR.node1(w(1)).sum_rating(3)+templeaf(j).sum_rating(3);
                         tempR.node1(w(1)).sum_rating(4)=tempR.node1(w(1)).sum_rating(4)+templeaf(j).sum_rating(4);
                         tempR.node1(w(1)).sum_rating(5)=tempR.node1(w(1)).sum_rating(5)+templeaf(j).sum_rating(5); 
                         sameitem=1;  
                    end
            end
            if sameitem==0      
                if   (size(tempR.node1(w(1)).node,2)+1)<=n_leaf           %%如果没满
                         temp_num=size(tempR.node1(w(1)).node,2);
                         tempR.node1(w(1)).node(temp_num+1).item=templeaf(j).item;
                         tempR.node1(w(1)).node(temp_num+1).price=templeaf(j).price;
                         tempR.node1(w(1)).node(temp_num+1).sum_num=templeaf(j).sum_num;
                         tempR.node1(w(1)).node(temp_num+1).sum_rating(1)=templeaf(j).sum_rating(1);
                         tempR.node1(w(1)).node(temp_num+1).sum_rating(2)=templeaf(j).sum_rating(2);
                         tempR.node1(w(1)).node(temp_num+1).sum_rating(3)=templeaf(j).sum_rating(3);
                         tempR.node1(w(1)).node(temp_num+1).sum_rating(4)=templeaf(j).sum_rating(4);
                         tempR.node1(w(1)).node(temp_num+1).sum_rating(5)=templeaf(j).sum_rating(5);
                         for p=1:1:temp_num                                          %%2个for循环1-dim排序
                             for q=(p+1):1:(temp_num+1)
                                    if tempR.node1(w(1)).node(p).price>tempR.node1(w(1)).node(q).price  %%前面大于后面的交换
                                       anotherleaf=tempR.node1(w(1)).node(p);
                                       tempR.node1(w(1)).node(p)=tempR.node1(w(1)).node(q);
                                       tempR.node1(w(1)).node(q)=anotherleaf;            
                                    end                                      
                             end
                         end     
                         %%% 向上更新
                         tempR.node1(w(1)).sum_num=tempR.node1(w(1)).sum_num+templeaf(j).sum_num;
                         tempR.node1(w(1)).sum_rating(1)=tempR.node1(w(1)).sum_rating(1)+templeaf(j).sum_rating(1);
                         tempR.node1(w(1)).sum_rating(2)=tempR.node1(w(1)).sum_rating(2)+templeaf(j).sum_rating(2);
                         tempR.node1(w(1)).sum_rating(3)=tempR.node1(w(1)).sum_rating(3)+templeaf(j).sum_rating(3);
                         tempR.node1(w(1)).sum_rating(4)=tempR.node1(w(1)).sum_rating(4)+templeaf(j).sum_rating(4);
                         tempR.node1(w(1)).sum_rating(5)=tempR.node1(w(1)).sum_rating(5)+templeaf(j).sum_rating(5);  
                elseif  (size(tempR.node1,2)+1)<=n_node %%新建结点
                  test='mergeleaf line 121';   %#ok<NASGU>
                    
                end
            end        
    elseif tempR.level==2
         test='mergeleaf line 126';   %#ok<NASGU>
    end
    %%%
    sameitem=0; %%回执
    if tempR.maxprice<templeaf(j).price
        tempR.maxprice=templeaf(j).price;
    end
    if tempR.minprice>templeaf(j).price
        tempR.minprice=templeaf(j).price;
    end 
sum=sum+templeaf(j).sum_num;
r1=r1+templeaf(j).sum_rating(1);
r2=r2+templeaf(j).sum_rating(2);
r3=r3+templeaf(j).sum_rating(3);
r4=r4+templeaf(j).sum_rating(4);
r5=r5+templeaf(j).sum_rating(5);
    
end

R=tempR;

end