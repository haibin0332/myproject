function  [sum, r1, r2, r3, r4, r5, R]=mergeleafandnode(node) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%此部分代码被merge调用
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_leaf=64;%1-dim子树里的一些参数
n_node=64;
%test=1;
node_num=size(node,2);
%%%node(k1).leaf(k2)
%%%node(k1).onedimR
sameitem=0;
needhelp=0;
kp=1;
if node_num==1  %%leaf直接插入
    %%从判断level开始
leaf_num=size(node.leaf,2);  
%%因为就一个结点所以node和node(1)一样的但实质是node(1)
sum=node.sum_num;
r1=node.sum_rating(1);
r2=node.sum_rating(2);
r3=node.sum_rating(3);
r4=node.sum_rating(4);
r5=node.sum_rating(5);

for j=1:1:leaf_num
if node.onedimR.level==0
             if  (size(node.onedimR.node,2)+1)<=n_leaf
                for k=1:1:size(node.onedimR.node,2)           
                     if  strcmp(node.onedimR.node(k).item, node.leaf(j).item)==1
                         node.onedimR.node(k).sum_num=node.onedimR.node(k).sum_num+node.leaf(j).sum_num;
                         node.onedimR.node(k).sum_rating(1)=node.onedimR.node(k).sum_rating(1)+node.leaf(j).sum_rating(1);
                         node.onedimR.node(k).sum_rating(2)=node.onedimR.node(k).sum_rating(2)+node.leaf(j).sum_rating(2);
                         node.onedimR.node(k).sum_rating(3)=node.onedimR.node(k).sum_rating(3)+node.leaf(j).sum_rating(3);
                         node.onedimR.node(k).sum_rating(4)=node.onedimR.node(k).sum_rating(4)+node.leaf(j).sum_rating(4);
                         node.onedimR.node(k).sum_rating(5)=node.onedimR.node(k).sum_rating(5)+node.leaf(j).sum_rating(5);
                         sameitem=1;  
                     end
                end
             if sameitem==0 %%插入
                         temp_num=size(node.onedimR.node,2);
                         node.onedimR.node(temp_num+1).item=node.leaf(j).item;
                         node.onedimR.node(temp_num+1).price=node.leaf(j).price;
                         node.onedimR.node(temp_num+1).sum_num=node.leaf(j).sum_num;
                         node.onedimR.node(temp_num+1).sum_rating(1)=node.leaf(j).sum_rating(1);
                         node.onedimR.node(temp_num+1).sum_rating(2)=node.leaf(j).sum_rating(2);
                         node.onedimR.node(temp_num+1).sum_rating(3)=node.leaf(j).sum_rating(3);
                         node.onedimR.node(temp_num+1).sum_rating(4)=node.leaf(j).sum_rating(4);
                         node.onedimR.node(temp_num+1).sum_rating(5)=node.leaf(j).sum_rating(5);
                         for p=1:1:temp_num                                          %%2个for循环1-dim排序
                             for q=(p+1):1:(temp_num+1)
                                    if node.onedimR.node(p).price>node.onedimR.node(q).price  %%前面大于后面的交换
                                       anotherleaf=node.onedimR.node(p);
                                       node.onedimR.node(p)=node.onedimR.node(q);
                                       node.onedimR.node(q)=anotherleaf;            
                                    end                                      
                             end
                         end
                                    
             end
         else  %%分裂
%              test='mergeleaf.m 72 行 叶子分裂了';
              [mdnode, mark]=splitonedimleafnode(node.onedimR.node, node.leaf(j));
              if mark==1
              node.onedimR.node1=mdnode;
              node.onedimR.node=[];
              node.onedimR.level=node.onedimR.level+1;
              end
              if mark==0
              node.onedimR.node=mdnode;
              end
             end  
                         
end

if node.onedimR.level==1
            for p=1:1:size(node.onedimR.node1,2)  %% 63      %%93
                       if  node.leaf(j).price<node.onedimR.node1(p).maxprice
                            w(1)=p; %#ok<NASGU>
                            break;
                       end
                       if  node.leaf(j).price==node.onedimR.node1(p).maxprice
                            w(1)=p+1; %#ok<NASGU>
                            break;
                       end
            end   
            %%% 搜索所有node.onedimR.node1(w(1))
            for k=1:1:size(node.onedimR.node1(w(1)).node,2)
                    if  strcmp(node.onedimR.node1(w(1)).node(k).item, node.leaf(j).item)==1
                         node.onedimR.node1(w(1)).node(k).sum_num=node.onedimR.node1(w(1)).node(k).sum_num+node.leaf(j).sum_num;
                         node.onedimR.node1(w(1)).node(k).sum_rating(1)=node.onedimR.node1(w(1)).node(k).sum_rating(1)+node.leaf(j).sum_rating(1);
                         node.onedimR.node1(w(1)).node(k).sum_rating(2)=node.onedimR.node1(w(1)).node(k).sum_rating(2)+node.leaf(j).sum_rating(2);
                         node.onedimR.node1(w(1)).node(k).sum_rating(3)=node.onedimR.node1(w(1)).node(k).sum_rating(3)+node.leaf(j).sum_rating(3);
                         node.onedimR.node1(w(1)).node(k).sum_rating(4)=node.onedimR.node1(w(1)).node(k).sum_rating(4)+node.leaf(j).sum_rating(4);
                         node.onedimR.node1(w(1)).node(k).sum_rating(5)=node.onedimR.node1(w(1)).node(k).sum_rating(5)+node.leaf(j).sum_rating(5);
                         node.onedimR.node1(w(1)).sum_num=node.onedimR.node1(w(1)).sum_num+node.leaf(j).sum_num;
                         node.onedimR.node1(w(1)).sum_rating(1)=node.onedimR.node1(w(1)).sum_rating(1)+node.leaf(j).sum_rating(1);
                         node.onedimR.node1(w(1)).sum_rating(2)=node.onedimR.node1(w(1)).sum_rating(2)+node.leaf(j).sum_rating(2);
                         node.onedimR.node1(w(1)).sum_rating(3)=node.onedimR.node1(w(1)).sum_rating(3)+node.leaf(j).sum_rating(3);
                         node.onedimR.node1(w(1)).sum_rating(4)=node.onedimR.node1(w(1)).sum_rating(4)+node.leaf(j).sum_rating(4);
                         node.onedimR.node1(w(1)).sum_rating(5)=node.onedimR.node1(w(1)).sum_rating(5)+node.leaf(j).sum_rating(5); 
                         sameitem=1;  
                    end
            end
            if sameitem==0      %%没有
                if   (size(node.onedimR.node1(w(1)).node,2)+1)<=n_leaf           %%如果没满
                         temp_num=size(node.onedimR.node1(w(1)).node,2);
                         node.onedimR.node1(w(1)).node(temp_num+1).item=node.leaf(j).item;
                         node.onedimR.node1(w(1)).node(temp_num+1).price=node.leaf(j).price;
                         node.onedimR.node1(w(1)).node(temp_num+1).sum_num=node.leaf(j).sum_num;
                         node.onedimR.node1(w(1)).node(temp_num+1).sum_rating(1)=node.leaf(j).sum_rating(1);
                         node.onedimR.node1(w(1)).node(temp_num+1).sum_rating(2)=node.leaf(j).sum_rating(2);
                         node.onedimR.node1(w(1)).node(temp_num+1).sum_rating(3)=node.leaf(j).sum_rating(3);
                         node.onedimR.node1(w(1)).node(temp_num+1).sum_rating(4)=node.leaf(j).sum_rating(4);
                         node.onedimR.node1(w(1)).node(temp_num+1).sum_rating(5)=node.leaf(j).sum_rating(5);
                         for p=1:1:temp_num                                          %%2个for循环1-dim排序
                             for q=(p+1):1:(temp_num+1)
                                    if node.onedimR.node1(w(1)).node(p).price>node.onedimR.node1(w(1)).node(q).price  %%前面大于后面的交换
                                       anotherleaf=node.onedimR.node1(w(1)).node(p);
                                       node.onedimR.node1(w(1)).node(p)=node.onedimR.node1(w(1)).node(q);
                                       node.onedimR.node1(w(1)).node(q)=anotherleaf;            
                                    end                                      
                             end
                         end     
                         %%% 向上更新
                         node.onedimR.node1(w(1)).sum_num=node.onedimR.node1(w(1)).sum_num+node.leaf(j).sum_num;
                         node.onedimR.node1(w(1)).sum_rating(1)=node.onedimR.node1(w(1)).sum_rating(1)+node.leaf(j).sum_rating(1);
                         node.onedimR.node1(w(1)).sum_rating(2)=node.onedimR.node1(w(1)).sum_rating(2)+node.leaf(j).sum_rating(2);
                         node.onedimR.node1(w(1)).sum_rating(3)=node.onedimR.node1(w(1)).sum_rating(3)+node.leaf(j).sum_rating(3);
                         node.onedimR.node1(w(1)).sum_rating(4)=node.onedimR.node1(w(1)).sum_rating(4)+node.leaf(j).sum_rating(4);
                         node.onedimR.node1(w(1)).sum_rating(5)=node.onedimR.node1(w(1)).sum_rating(5)+node.leaf(j).sum_rating(5);  
                elseif  (size(node.onedimR.node1,2)+1)<=n_node %%新建结点
                         tempnode1=splitonedimonetotwo(node.onedimR.node1(w(1)), node.leaf(j)); %%分裂成2个
                         u=size(node.onedimR.node1,2);
                         %%%这里是把2个直接插入
                         if  w(1)==1
                             %剩下的都插入tempnode1里面
                             for  kk=2:1:u
                                tempnode1(kk+1)=node.onedimR.node1(kk);
                             end 
                             node.onedimR.node1=tempnode1;
                         end
                         if (w(1)>1)&&(w(1)==u)
                             for kk=1:1:(w(1)-1)
                                 rtempnode1(kk)=node.onedimR.node1(kk);
                             end
                                 rtempnode1(w(1))=tempnode1(1);
                                 rtempnode1(w(1)+1)=tempnode1(2);
                             node.onedimR.node1=rtempnode1;    
                         end
                         if (w(1)>1)&&(w(1)<u)
                             for kk=1:1:(w(1)-1)
                                 rtempnode1(kk)=node.onedimR.node1(kk);
                             end
                                 rtempnode1(w(1))=tempnode1(1);
                                 rtempnode1(w(1)+1)=tempnode1(2);
                             for kk=(w(1)+1):1:u
                                 rtempnode1(kk+1)=node.onedimR.node1(kk);
                             end   
                             node.onedimR.node1=rtempnode1; 
                         end
                        %%%%%%%%%%%%%%%
                elseif (size(node.onedimR.node1,2)+1)>n_node   %%%
                    %%%分裂形成第三层level==2
                    test='mergeleafandnode.m line 160';
                    
                end
           end  
      
end

if node.onedimR.level==2
    
     test='mergeleafandnode.m line 169';
  
end

    sameitem=0; %%回执
    if node.onedimR.maxprice<node.leaf(j).price
        node.onedimR.maxprice=node.leaf(j).price;
    end
    if node.onedimR.minprice>node.leaf(j).price
        node.onedimR.minprice=node.leaf(j).price;
    end 
sum=sum+node.leaf(j).sum_num;
r1=r1+node.leaf(j).sum_rating(1);
r2=r2+node.leaf(j).sum_rating(2);
r3=r3+node.leaf(j).sum_rating(3);
r4=r4+node.leaf(j).sum_rating(4);
r5=r5+node.leaf(j).sum_rating(5);

end %%fori=1:1:leaf_num

R=node(1).onedimR;  %%都向第一个里面插入

end %%node_num==1 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if node_num>1  %%多个1dimtree 和 leaf
%      test='mergeleafandnode.m line 199';
sum=node(1).sum_num;
r1=node(1).sum_rating(1);
r2=node(1).sum_rating(2);
r3=node(1).sum_rating(3);
r4=node(1).sum_rating(4);
r5=node(1).sum_rating(5);
R=node(1).onedimR; 

for j=1:1:size(node(1).leaf, 2) %%先把第一个node的里的leaf结点都插入
        if R.level==0
             if  (size(R.node,2)+1)<=n_leaf
                for k=1:1:size(R.node,2)           
                     if  strcmp(R.node(k).item, node(1).leaf(j).item)==1
                         R.node(k).sum_num=R.node(k).sum_num+node(1).leaf(j).sum_num;
                         R.node(k).sum_rating(1)=R.node(k).sum_rating(1)+node(1).leaf(j).sum_rating(1);
                         R.node(k).sum_rating(2)=R.node(k).sum_rating(2)+node(1).leaf(j).sum_rating(2);
                         R.node(k).sum_rating(3)=R.node(k).sum_rating(3)+node(1).leaf(j).sum_rating(3);
                         R.node(k).sum_rating(4)=R.node(k).sum_rating(4)+node(1).leaf(j).sum_rating(4);
                         R.node(k).sum_rating(5)=R.node(k).sum_rating(5)+node(1).leaf(j).sum_rating(5);
                         sameitem=1;  
                     end
                end
              if sameitem==0 %%插入
                         temp_num=size(R.node,2);
                         R.node(temp_num+1).item=node(1).leaf(j).item;
                         R.node(temp_num+1).price=node(1).leaf(j).price;
                         R.node(temp_num+1).sum_num=node(1).leaf(j).sum_num;
                         R.node(temp_num+1).sum_rating(1)=node(1).leaf(j).sum_rating(1);
                         R.node(temp_num+1).sum_rating(2)=node(1).leaf(j).sum_rating(2);
                         R.node(temp_num+1).sum_rating(3)=node(1).leaf(j).sum_rating(3);
                         R.node(temp_num+1).sum_rating(4)=node(1).leaf(j).sum_rating(4);
                         R.node(temp_num+1).sum_rating(5)=node(1).leaf(j).sum_rating(5);
                         for p=1:1:temp_num                                          %%2个for循环1-dim排序
                             for q=(p+1):1:(temp_num+1)
                                    if R.node(p).price>R.node(q).price  %%前面大于后面的交换
                                       anotherleaf=R.node(p);
                                       R.node(p)=R.node(q);
                                       R.node(q)=anotherleaf;            
                                    end                                      
                             end
                         end
                                    
             end
            else  %%分裂
%              test='mergeleaf.m 72 行 叶子分裂了';
              [mdnode, mark]=splitonedimleafnode(R.node, node(1).leaf(j));
              if mark==1
              R.node1=mdnode;
              R.node=[];
              R.level=R.level+1;
              end
              if mark==0
              R.node=mdnode;
              end
             end  
        elseif R.level==1
            for p=1:1:size(R.node1,2)  %% 63      %%93
                       if  node(1).leaf(j).price<R.node1(p).maxprice
                            w(1)=p; %#ok<NASGU>
                            break;
                       end
                       if  node(1).leaf(j).price==R.node1(p).maxprice
                            w(1)=p+1; %#ok<NASGU>
                            break;
                       end
            end   
            %%% 搜索所有R.node1(w(1))
            for k=1:1:size(R.node1(w(1)).node,2)
                    if  strcmp(R.node1(w(1)).node(k).item, node(1).leaf(j).item)==1
                         R.node1(w(1)).node(k).sum_num=R.node1(w(1)).node(k).sum_num+node(1).leaf(j).sum_num;
                         R.node1(w(1)).node(k).sum_rating(1)=R.node1(w(1)).node(k).sum_rating(1)+node(1).leaf(j).sum_rating(1);
                         R.node1(w(1)).node(k).sum_rating(2)=R.node1(w(1)).node(k).sum_rating(2)+node(1).leaf(j).sum_rating(2);
                         R.node1(w(1)).node(k).sum_rating(3)=R.node1(w(1)).node(k).sum_rating(3)+node(1).leaf(j).sum_rating(3);
                         R.node1(w(1)).node(k).sum_rating(4)=R.node1(w(1)).node(k).sum_rating(4)+node(1).leaf(j).sum_rating(4);
                         R.node1(w(1)).node(k).sum_rating(5)=R.node1(w(1)).node(k).sum_rating(5)+node(1).leaf(j).sum_rating(5);
                         R.node1(w(1)).sum_num=R.node1(w(1)).sum_num+node(1).leaf(j).sum_num;
                         R.node1(w(1)).sum_rating(1)=R.node1(w(1)).sum_rating(1)+node(1).leaf(j).sum_rating(1);
                         R.node1(w(1)).sum_rating(2)=R.node1(w(1)).sum_rating(2)+node(1).leaf(j).sum_rating(2);
                         R.node1(w(1)).sum_rating(3)=R.node1(w(1)).sum_rating(3)+node(1).leaf(j).sum_rating(3);
                         R.node1(w(1)).sum_rating(4)=R.node1(w(1)).sum_rating(4)+node(1).leaf(j).sum_rating(4);
                         R.node1(w(1)).sum_rating(5)=R.node1(w(1)).sum_rating(5)+node(1).leaf(j).sum_rating(5); 
                         sameitem=1;  
                    end
            end
            if sameitem==0      %%没有
                if   (size(R.node1(w(1)).node,2)+1)<=n_leaf           %%如果没满
                         temp_num=size(R.node1(w(1)).node,2);
                         R.node1(w(1)).node(temp_num+1).item=node(1).leaf(j).item;
                         R.node1(w(1)).node(temp_num+1).price=node(1).leaf(j).price;
                         R.node1(w(1)).node(temp_num+1).sum_num=node(1).leaf(j).sum_num;
                         R.node1(w(1)).node(temp_num+1).sum_rating(1)=node(1).leaf(j).sum_rating(1);
                         R.node1(w(1)).node(temp_num+1).sum_rating(2)=node(1).leaf(j).sum_rating(2);
                         R.node1(w(1)).node(temp_num+1).sum_rating(3)=node(1).leaf(j).sum_rating(3);
                         R.node1(w(1)).node(temp_num+1).sum_rating(4)=node(1).leaf(j).sum_rating(4);
                         R.node1(w(1)).node(temp_num+1).sum_rating(5)=node(1).leaf(j).sum_rating(5);
                         for p=1:1:temp_num                                          %%2个for循环1-dim排序
                             for q=(p+1):1:(temp_num+1)
                                    if R.node1(w(1)).node(p).price>R.node1(w(1)).node(q).price  %%前面大于后面的交换
                                       anotherleaf=R.node1(w(1)).node(p);
                                       R.node1(w(1)).node(p)=R.node1(w(1)).node(q);
                                       R.node1(w(1)).node(q)=anotherleaf;            
                                    end                                      
                             end
                         end     
                         %%% 向上更新
                         R.node1(w(1)).sum_num=R.node1(w(1)).sum_num+node(1).leaf(j).sum_num;
                         R.node1(w(1)).sum_rating(1)=R.node1(w(1)).sum_rating(1)+node(1).leaf(j).sum_rating(1);
                         R.node1(w(1)).sum_rating(2)=R.node1(w(1)).sum_rating(2)+node(1).leaf(j).sum_rating(2);
                         R.node1(w(1)).sum_rating(3)=R.node1(w(1)).sum_rating(3)+node(1).leaf(j).sum_rating(3);
                         R.node1(w(1)).sum_rating(4)=R.node1(w(1)).sum_rating(4)+node(1).leaf(j).sum_rating(4);
                         R.node1(w(1)).sum_rating(5)=R.node1(w(1)).sum_rating(5)+node(1).leaf(j).sum_rating(5);  
                elseif  (size(R.node1,2)+1)<=n_node %%新建结点
                         tempnode1=splitonedimonetotwo(R.node1(w(1)), node(1).leaf(j)); %%分裂成2个
                         u=size(R.node1,2);
                         %%%这里是把2个直接插入
                         if  w(1)==1
                             %剩下的都插入tempnode1里面
                             for  kk=2:1:u
                                tempnode1(kk+1)=R.node1(kk);
                             end 
                             R.node1=tempnode1;
                         end
                         if (w(1)>1)&&(w(1)==u)
                             for kk=1:1:(w(1)-1)
                                 rtempnode1(kk)=R.node1(kk);
                             end
                                 rtempnode1(w(1))=tempnode1(1);
                                 rtempnode1(w(1)+1)=tempnode1(2);
                             R.node1=rtempnode1;    
                         end
                         if (w(1)>1)&&(w(1)<u)
                             for kk=1:1:(w(1)-1)
                                 rtempnode1(kk)=R.node1(kk);
                             end
                                 rtempnode1(w(1))=tempnode1(1);
                                 rtempnode1(w(1)+1)=tempnode1(2);
                             for kk=(w(1)+1):1:u
                                 rtempnode1(kk+1)=R.node1(kk);
                             end   
                             R.node1=rtempnode1; 
                         end
                        %%%%%%%%%%%%%%%
                elseif (size(R.node1,2)+1)>n_node   %%%
                    %%%分裂形成第三层level==2
                    test='mergeleafandnode.m line 348';
                    
                end
            end  
      
        elseif R.level==2
    
     test='mergeleafandnode.m line 357';
                  
        end
    
    if  R.maxprice<node(1).leaf(j).price
        R.maxprice=node(1).leaf(j).price;
    end
    if  R.minprice>node(1).leaf(j).price
        R.minprice=node(1).leaf(j).price;
    end 
       
sum=sum+node(1).leaf(j).sum_num;
r1=r1+node(1).leaf(j).sum_rating(1);
r2=r2+node(1).leaf(j).sum_rating(2);
r3=r3+node(1).leaf(j).sum_rating(3);
r4=r4+node(1).leaf(j).sum_rating(4);
r5=r5+node(1).leaf(j).sum_rating(5);       
end

for i=2:1:node_num 
         
           for j=1:1:size(node(i).leaf,2)
                         totalnode(kp).item=node(i).leaf(j).item;
                         totalnode(kp).price=node(i).leaf(j).price;
                         totalnode(kp).sum_num=node(i).leaf(j).sum_num;
                         totalnode(kp).sum_rating(1)=node(i).leaf(j).sum_rating(1);
                         totalnode(kp).sum_rating(2)=node(i).leaf(j).sum_rating(2);
                         totalnode(kp).sum_rating(3)=node(i).leaf(j).sum_rating(3);
                         totalnode(kp).sum_rating(4)=node(i).leaf(j).sum_rating(4);
                         totalnode(kp).sum_rating(5)=node(i).leaf(j).sum_rating(5);  
                         
                 sum=sum+node(i).leaf(j).sum_num;
                 r1=r1+node(i).leaf(j).sum_rating(1);
                 r2=r2+node(i).leaf(j).sum_rating(2);
                 r3=r3+node(i).leaf(j).sum_rating(3);
                 r4=r4+node(i).leaf(j).sum_rating(4);
                 r5=r5+node(i).leaf(j).sum_rating(5);          
                         kp=kp+1; 
                                                  
           end
           if  node(i).sum_num>0
            if node(i).onedimR.level==0
                     for j=1:1:size(node(i).onedimR.node,2)
                         totalnode(kp)=node(i).onedimR.node(j);
                         kp=kp+1;
                    end
           end

          if node(i).onedimR.level==1
                    for j=1:1:size(node(i).onedimR.node1,2)
                        for p=1:1:size(node(i).onedimR.node1(j).node,2)
                         totalnode(kp)=node(i).onedimR.node1(j).node(p);
                         kp=kp+1;
                        end
                    end   
          end
          
          if node(i).onedimR.level==2
                    for j=1:1:size(node(i).onedimR.node2,2)
                        for p=1:1:size(node(i).onedimR.node2(j).node1,2)
                            for q=1:1:size(node(i).onedimR.node2(j).node1(p).node,2)
                               totalnode(kp)=node(i).onedimR.node2(j).node1(p).node(q);
                               kp=kp+1;
                            end
                        end
                    end   
          end
                         
           elseif node(i).sum_num==0
               continue;                         
           end       
sum=sum+node(i).sum_num;
r1=r1+node(i).sum_rating(1);
r2=r2+node(i).sum_rating(2);
r3=r3+node(i).sum_rating(3);
r4=r4+node(i).sum_rating(4);
r5=r5+node(i).sum_rating(5);
needhelp=needhelp+sum;  
end

if needhelp>0
 
for j=1:1:size(totalnode, 2)  %%往里面插入把孩子
    
        if R.level==0
             if  (size(R.node,2)+1)<=n_leaf
                for k=1:1:size(R.node,2)           
                     if  strcmp(R.node(k).item, totalnode(j).item)==1
                         R.node(k).sum_num=R.node(k).sum_num+totalnode(j).sum_num;
                         R.node(k).sum_rating(1)=R.node(k).sum_rating(1)+totalnode(j).sum_rating(1);
                         R.node(k).sum_rating(2)=R.node(k).sum_rating(2)+totalnode(j).sum_rating(2);
                         R.node(k).sum_rating(3)=R.node(k).sum_rating(3)+totalnode(j).sum_rating(3);
                         R.node(k).sum_rating(4)=R.node(k).sum_rating(4)+totalnode(j).sum_rating(4);
                         R.node(k).sum_rating(5)=R.node(k).sum_rating(5)+totalnode(j).sum_rating(5);
                         sameitem=1;  
                     end
                end
              if sameitem==0 %%插入
                         temp_num=size(R.node,2);
                         R.node(temp_num+1).item=totalnode(j).item;
                         R.node(temp_num+1).price=totalnode(j).price;
                         R.node(temp_num+1).sum_num=totalnode(j).sum_num;
                         R.node(temp_num+1).sum_rating(1)=totalnode(j).sum_rating(1);
                         R.node(temp_num+1).sum_rating(2)=totalnode(j).sum_rating(2);
                         R.node(temp_num+1).sum_rating(3)=totalnode(j).sum_rating(3);
                         R.node(temp_num+1).sum_rating(4)=totalnode(j).sum_rating(4);
                         R.node(temp_num+1).sum_rating(5)=totalnode(j).sum_rating(5);
                         for p=1:1:temp_num                                          %%2个for循环1-dim排序
                             for q=(p+1):1:(temp_num+1)
                                    if R.node(p).price>R.node(q).price  %%前面大于后面的交换
                                       anotherleaf=R.node(p);
                                       R.node(p)=R.node(q);
                                       R.node(q)=anotherleaf;            
                                    end                                      
                             end
                         end
                                    
             end
            else  %%分裂
%              test='mergeleaf.m 72 行 叶子分裂了';
              [mdnode, mark]=splitonedimleafnode(R.node, totalnode(j));
              if mark==1
              R.node1=mdnode;
              R.node=[];
              R.level=R.level+1;
              end
              if mark==0
              R.node=mdnode;
              end
             end  
        elseif R.level==1
            
             for p=1:1:size(R.node1,2)  %% 63      %%93
                       if  totalnode(j).price<R.node1(p).maxprice
                            w(1)=p; %#ok<NASGU>
                            break;
                       end
                       if  totalnode(j).price==R.node1(p).maxprice
                            w(1)=p+1; %#ok<NASGU>
                            break;
                       end
            end   
            %%% 搜索所有R.node1(w(1))
            for k=1:1:size(R.node1(w(1)).node,2)
                    if  strcmp(R.node1(w(1)).node(k).item, totalnode(j).item)==1
                         R.node1(w(1)).node(k).sum_num=R.node1(w(1)).node(k).sum_num+totalnode(j).sum_num;
                         R.node1(w(1)).node(k).sum_rating(1)=R.node1(w(1)).node(k).sum_rating(1)+totalnode(j).sum_rating(1);
                         R.node1(w(1)).node(k).sum_rating(2)=R.node1(w(1)).node(k).sum_rating(2)+totalnode(j).sum_rating(2);
                         R.node1(w(1)).node(k).sum_rating(3)=R.node1(w(1)).node(k).sum_rating(3)+totalnode(j).sum_rating(3);
                         R.node1(w(1)).node(k).sum_rating(4)=R.node1(w(1)).node(k).sum_rating(4)+totalnode(j).sum_rating(4);
                         R.node1(w(1)).node(k).sum_rating(5)=R.node1(w(1)).node(k).sum_rating(5)+totalnode(j).sum_rating(5);
                         R.node1(w(1)).sum_num=R.node1(w(1)).sum_num+totalnode(j).sum_num;
                         R.node1(w(1)).sum_rating(1)=R.node1(w(1)).sum_rating(1)+totalnode(j).sum_rating(1);
                         R.node1(w(1)).sum_rating(2)=R.node1(w(1)).sum_rating(2)+totalnode(j).sum_rating(2);
                         R.node1(w(1)).sum_rating(3)=R.node1(w(1)).sum_rating(3)+totalnode(j).sum_rating(3);
                         R.node1(w(1)).sum_rating(4)=R.node1(w(1)).sum_rating(4)+totalnode(j).sum_rating(4);
                         R.node1(w(1)).sum_rating(5)=R.node1(w(1)).sum_rating(5)+totalnode(j).sum_rating(5); 
                         sameitem=1;  
                    end
            end
            if sameitem==0      %%没有
                if   (size(R.node1(w(1)).node,2)+1)<=n_leaf           %%如果没满
                         temp_num=size(R.node1(w(1)).node,2);
                         R.node1(w(1)).node(temp_num+1).item=totalnode(j).item;
                         R.node1(w(1)).node(temp_num+1).price=totalnode(j).price;
                         R.node1(w(1)).node(temp_num+1).sum_num=totalnode(j).sum_num;
                         R.node1(w(1)).node(temp_num+1).sum_rating(1)=totalnode(j).sum_rating(1);
                         R.node1(w(1)).node(temp_num+1).sum_rating(2)=totalnode(j).sum_rating(2);
                         R.node1(w(1)).node(temp_num+1).sum_rating(3)=totalnode(j).sum_rating(3);
                         R.node1(w(1)).node(temp_num+1).sum_rating(4)=totalnode(j).sum_rating(4);
                         R.node1(w(1)).node(temp_num+1).sum_rating(5)=totalnode(j).sum_rating(5);
                         for p=1:1:temp_num                                          %%2个for循环1-dim排序
                             for q=(p+1):1:(temp_num+1)
                                    if R.node1(w(1)).node(p).price>R.node1(w(1)).node(q).price  %%前面大于后面的交换
                                       anotherleaf=R.node1(w(1)).node(p);
                                       R.node1(w(1)).node(p)=R.node1(w(1)).node(q);
                                       R.node1(w(1)).node(q)=anotherleaf;            
                                    end                                      
                             end
                         end     
                         %%% 向上更新
                         R.node1(w(1)).sum_num=R.node1(w(1)).sum_num+totalnode(j).sum_num;
                         R.node1(w(1)).sum_rating(1)=R.node1(w(1)).sum_rating(1)+totalnode(j).sum_rating(1);
                         R.node1(w(1)).sum_rating(2)=R.node1(w(1)).sum_rating(2)+totalnode(j).sum_rating(2);
                         R.node1(w(1)).sum_rating(3)=R.node1(w(1)).sum_rating(3)+totalnode(j).sum_rating(3);
                         R.node1(w(1)).sum_rating(4)=R.node1(w(1)).sum_rating(4)+totalnode(j).sum_rating(4);
                         R.node1(w(1)).sum_rating(5)=R.node1(w(1)).sum_rating(5)+totalnode(j).sum_rating(5);  
                elseif  (size(R.node1,2)+1)<=n_node %%新建结点
                         tempnode1=splitonedimonetotwo(R.node1(w(1)), totalnode(j)); %%分裂成2个
                         u=size(R.node1,2);
                         %%%这里是把2个直接插入
                         if  w(1)==1
                             %剩下的都插入tempnode1里面
                             for  kk=2:1:u
                                tempnode1(kk+1)=R.node1(kk);
                             end 
                             R.node1=tempnode1;
                         end
                         if (w(1)>1)&&(w(1)==u)
                             for kk=1:1:(w(1)-1)
                                 rtempnode1(kk)=R.node1(kk);
                             end
                                 rtempnode1(w(1))=tempnode1(1);
                                 rtempnode1(w(1)+1)=tempnode1(2);
                             R.node1=rtempnode1;    
                         end
                         if (w(1)>1)&&(w(1)<u)
                             for kk=1:1:(w(1)-1)
                                 rtempnode1(kk)=R.node1(kk);
                             end
                                 rtempnode1(w(1))=tempnode1(1);
                                 rtempnode1(w(1)+1)=tempnode1(2);
                             for kk=(w(1)+1):1:u
                                 rtempnode1(kk+1)=R.node1(kk);
                             end   
                             R.node1=rtempnode1; 
                         end
                        %%%%%%%%%%%%%%%
                elseif (size(R.node1,2)+1)>n_node   %%%
                    %%%分裂形成第三层level==2
                    test='smallsizemerge.m line 573';
                    
                end
           end            
             
        elseif R.level==2 
            
             test='smallsizemerge.m line 582';
                         
       end


                             if  R.maxprice<totalnode(j).price
                              R.maxprice=totalnode(j).price;
                             end
                             if  R.minprice>totalnode(j).price
                               R.minprice=totalnode(j).price;
                             end 

    sameitem=0; %%回执     
 end
           
end

   
end
  
end