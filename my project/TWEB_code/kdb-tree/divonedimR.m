function  [R]=divonedimR(mid, onedimR) 
%%%%%%%%%%%%%%%%
%smallsplitnode.m调用 newsplitleaf.m
%%%%%%%%%%%%%%%%%%
n_leaf=64;%1-dim子树里的一些参数
n_node=64;
k1=1;
k2=1;
k3=1;
sameitem=0;
          R(1).sum_num=0;
          R(1).sum_rating(1)=0;
          R(1).sum_rating(2)=0;
          R(1).sum_rating(3)=0;
          R(1).sum_rating(4)=0;
          R(1).sum_rating(5)=0;
          R(2).sum_num=0;
          R(2).sum_rating(1)=0;
          R(2).sum_rating(2)=0;
          R(2).sum_rating(3)=0;
          R(2).sum_rating(4)=0;
          R(2).sum_rating(5)=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%此部分被smallsplitnode调用
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(onedimR, 'level')

 if  onedimR.level==0
    R(1).onedimR.level=0;
    R(1).onedimR.maxprice=onedimR.minprice;
    R(1).onedimR.minprice=onedimR.minprice;
    R(2).onedimR.level=0;
    R(2).onedimR.maxprice=onedimR.maxprice;
    R(2).onedimR.minprice=onedimR.maxprice;
    if isfield(onedimR, 'node')
     for j=1:1:size(onedimR.node,2)
      if onedimR.node(j).price<=mid
          R(1).sum_num=R(1).sum_num+onedimR.node(j).sum_num;
          R(1).sum_rating(1)=R(1).sum_rating(1)+onedimR.node(j).sum_rating(1);
          R(1).sum_rating(2)=R(1).sum_rating(2)+onedimR.node(j).sum_rating(2);
          R(1).sum_rating(3)=R(1).sum_rating(3)+onedimR.node(j).sum_rating(3);
          R(1).sum_rating(4)=R(1).sum_rating(4)+onedimR.node(j).sum_rating(4);
          R(1).sum_rating(5)=R(1).sum_rating(5)+onedimR.node(j).sum_rating(5);
          R(1).onedimR.node(k1)=onedimR.node(j);
          if  onedimR.node(j).price>R(1).onedimR.maxprice
              R(1).onedimR.maxprice=onedimR.node(j).price;
          end
          k1=k1+1;   
      end   
       if onedimR.node(j).price>mid
          R(2).sum_num=R(2).sum_num+onedimR.node(j).sum_num;
          R(2).sum_rating(1)=R(2).sum_rating(1)+onedimR.node(j).sum_rating(1);
          R(2).sum_rating(2)=R(2).sum_rating(2)+onedimR.node(j).sum_rating(2);
          R(2).sum_rating(3)=R(2).sum_rating(3)+onedimR.node(j).sum_rating(3);
          R(2).sum_rating(4)=R(2).sum_rating(4)+onedimR.node(j).sum_rating(4);
          R(2).sum_rating(5)=R(2).sum_rating(5)+onedimR.node(j).sum_rating(5);
          R(2).onedimR.node(k2)=onedimR.node(j);
          k2=k2+1; 
          if onedimR.node(j).price<R(2).onedimR.minprice
              R(2).onedimR.minprice=onedimR.node(j).price;
          end
      end           
     end
    else  %%%如果没有
      R(2).sum_num=0;
      R(2).sum_rating(1)=0;
      R(2).sum_rating(2)=0;
      R(2).sum_rating(3)=0;
      R(2).sum_rating(4)=0;
      R(2).sum_rating(5)=0;
      R(2).onedimR=struct(); 
      
      R(1).sum_num=0;
      R(1).sum_rating(1)=0;
      R(1).sum_rating(2)=0;
      R(1).sum_rating(3)=0;
      R(1).sum_rating(4)=0;
      R(1).sum_rating(5)=0;
      R(1).onedimR=struct(); 
        
    end
     
end

  if  onedimR.level==1
    R(1).onedimR.level=0;
    R(1).onedimR.maxprice=onedimR.minprice;
    R(1).onedimR.minprice=onedimR.minprice;
    R(2).onedimR.level=0;
    R(2).onedimR.maxprice=onedimR.maxprice;
    R(2).onedimR.minprice=onedimR.maxprice;
    for  j=1:1:size(onedimR.node1,2)
       for k=1:1:size(onedimR.node1(j).node,2)        
         totalnode(k3)=onedimR.node1(j).node(k);
         k3=k3+1;
       end
    end
    for i=1:1:size(totalnode,2)
      if totalnode(i).price<=mid
          R(1).sum_num=R(1).sum_num+totalnode(i).sum_num;
          R(1).sum_rating(1)=R(1).sum_rating(1)+totalnode(i).sum_rating(1);
          R(1).sum_rating(2)=R(1).sum_rating(2)+totalnode(i).sum_rating(2);
          R(1).sum_rating(3)=R(1).sum_rating(3)+totalnode(i).sum_rating(3);
          R(1).sum_rating(4)=R(1).sum_rating(4)+totalnode(i).sum_rating(4);
          R(1).sum_rating(5)=R(1).sum_rating(5)+totalnode(i).sum_rating(5);
          temp1(k1)=totalnode(i);
          if  totalnode(i).price>R(1).onedimR.maxprice
              R(1).onedimR.maxprice=totalnode(i).price;
          end
          k1=k1+1;   
      end   
       if totalnode(i).price>mid
          R(2).sum_num=R(2).sum_num+totalnode(i).sum_num;
          R(2).sum_rating(1)=R(2).sum_rating(1)+totalnode(i).sum_rating(1);
          R(2).sum_rating(2)=R(2).sum_rating(2)+totalnode(i).sum_rating(2);
          R(2).sum_rating(3)=R(2).sum_rating(3)+totalnode(i).sum_rating(3);
          R(2).sum_rating(4)=R(2).sum_rating(4)+totalnode(i).sum_rating(4);
          R(2).sum_rating(5)=R(2).sum_rating(5)+totalnode(i).sum_rating(5);
          temp2(k2)=totalnode(i);
          k2=k2+1; 
          if  totalnode(i).price<R(2).onedimR.minprice
              R(2).onedimR.minprice=totalnode(i).price;
          end
      end      
    end

   if ~exist('temp1')  %%%如果不存在 自己赋值
      R(1).sum_num=0;
      R(1).sum_rating(1)=0;
      R(1).sum_rating(2)=0;
      R(1).sum_rating(3)=0;
      R(1).sum_rating(4)=0;
      R(1).sum_rating(5)=0;
      R(1).onedimR=struct();  
    else
        R(1).onedimR.node(1)=temp1(1);
    for  i=2:1:size(temp1,2)%%%% R(1).onedimR.level 判断并不断增加
        if  R(1).onedimR.level==0
            if (size(R(1).onedimR.node,2)+1)<=n_leaf
              temp_num=size(R(1).onedimR.node,2);
              R(1).onedimR.node(temp_num+1)=temp1(i); 
            else
              [mdnode, mark]=splitonedimleafnode(R(1).onedimR.node, temp1(i));
              if mark==1
              R(1).onedimR.node1=mdnode;
              R(1).onedimR.node=[];
              R(1).onedimR.level=R(1).onedimR.level+1;
              end
              if mark==0
              R(1).onedimR.node=mdnode;
              end 
            end
            
        elseif  R(1).onedimR.level==1
            for p=1:1:size(R(1).onedimR.node1,2)  %% 63      %%93
                       if  temp1(i).price<R(1).onedimR.node1(p).maxprice
                            w(1)=p; %#ok<NASGU>
                            break;
                       end
                       if  temp1(i).price==R(1).onedimR.node1(p).maxprice
                            w(1)=p+1; %#ok<NASGU>
                            break;
                       end
            end   
            for k=1:1:size(R(1).onedimR.node1(w(1)).node,2)
                    if  strcmp(R(1).onedimR.node1(w(1)).node(k).item, temp1(i).item)==1
                         R(1).onedimR.node1(w(1)).node(k).sum_num=R(1).onedimR.node1(w(1)).node(k).sum_num+temp1(i).sum_num;
                         R(1).onedimR.node1(w(1)).node(k).sum_rating(1)=R(1).onedimR.node1(w(1)).node(k).sum_rating(1)+temp1(i).sum_rating(1);
                         R(1).onedimR.node1(w(1)).node(k).sum_rating(2)=R(1).onedimR.node1(w(1)).node(k).sum_rating(2)+temp1(i).sum_rating(2);
                         R(1).onedimR.node1(w(1)).node(k).sum_rating(3)=R(1).onedimR.node1(w(1)).node(k).sum_rating(3)+temp1(i).sum_rating(3);
                         R(1).onedimR.node1(w(1)).node(k).sum_rating(4)=R(1).onedimR.node1(w(1)).node(k).sum_rating(4)+temp1(i).sum_rating(4);
                         R(1).onedimR.node1(w(1)).node(k).sum_rating(5)=R(1).onedimR.node1(w(1)).node(k).sum_rating(5)+temp1(i).sum_rating(5);
                         R(1).onedimR.node1(w(1)).sum_num=R(1).onedimR.node1(w(1)).sum_num+temp1(i).sum_num;
                         R(1).onedimR.node1(w(1)).sum_rating(1)=R(1).onedimR.node1(w(1)).sum_rating(1)+temp1(i).sum_rating(1);
                         R(1).onedimR.node1(w(1)).sum_rating(2)=R(1).onedimR.node1(w(1)).sum_rating(2)+temp1(i).sum_rating(2);
                         R(1).onedimR.node1(w(1)).sum_rating(3)=R(1).onedimR.node1(w(1)).sum_rating(3)+temp1(i).sum_rating(3);
                         R(1).onedimR.node1(w(1)).sum_rating(4)=R(1).onedimR.node1(w(1)).sum_rating(4)+temp1(i).sum_rating(4);
                         R(1).onedimR.node1(w(1)).sum_rating(5)=R(1).onedimR.node1(w(1)).sum_rating(5)+temp1(i).sum_rating(5); 
                         sameitem=1;  
                    end
            end
            if sameitem==0      %%没有
                if   (size(R(1).onedimR.node1(w(1)).node,2)+1)<=n_leaf           %%如果没满
                         temp_num=size(R(1).onedimR.node1(w(1)).node,2);
                         R(1).onedimR.node1(w(1)).node(temp_num+1).item=temp1(i).item;
                         R(1).onedimR.node1(w(1)).node(temp_num+1).price=temp1(i).price;
                         R(1).onedimR.node1(w(1)).node(temp_num+1).sum_num=temp1(i).sum_num;
                         R(1).onedimR.node1(w(1)).node(temp_num+1).sum_rating(1)=temp1(i).sum_rating(1);
                         R(1).onedimR.node1(w(1)).node(temp_num+1).sum_rating(2)=temp1(i).sum_rating(2);
                         R(1).onedimR.node1(w(1)).node(temp_num+1).sum_rating(3)=temp1(i).sum_rating(3);
                         R(1).onedimR.node1(w(1)).node(temp_num+1).sum_rating(4)=temp1(i).sum_rating(4);
                         R(1).onedimR.node1(w(1)).node(temp_num+1).sum_rating(5)=temp1(i).sum_rating(5);
                         for p=1:1:temp_num                                          %%2个for循环1-dim排序
                             for q=(p+1):1:(temp_num+1)
                                    if R(1).onedimR.node1(w(1)).node(p).price>R(1).onedimR.node1(w(1)).node(q).price  %%前面大于后面的交换
                                       anotherleaf=R(1).onedimR.node1(w(1)).node(p);
                                       R(1).onedimR.node1(w(1)).node(p)=R(1).onedimR.node1(w(1)).node(q);
                                       R(1).onedimR.node1(w(1)).node(q)=anotherleaf;            
                                    end                                      
                             end
                         end     
                         %%% 向上更新
                         R(1).onedimR.node1(w(1)).sum_num=R(1).onedimR.node1(w(1)).sum_num+temp1(i).sum_num;
                         R(1).onedimR.node1(w(1)).sum_rating(1)=R(1).onedimR.node1(w(1)).sum_rating(1)+temp1(i).sum_rating(1);
                         R(1).onedimR.node1(w(1)).sum_rating(2)=R(1).onedimR.node1(w(1)).sum_rating(2)+temp1(i).sum_rating(2);
                         R(1).onedimR.node1(w(1)).sum_rating(3)=R(1).onedimR.node1(w(1)).sum_rating(3)+temp1(i).sum_rating(3);
                         R(1).onedimR.node1(w(1)).sum_rating(4)=R(1).onedimR.node1(w(1)).sum_rating(4)+temp1(i).sum_rating(4);
                         R(1).onedimR.node1(w(1)).sum_rating(5)=R(1).onedimR.node1(w(1)).sum_rating(5)+temp1(i).sum_rating(5);  
                elseif  (size(R(1).onedimR.node1,2)+1)<=n_node %%新建结点
                         tempnode1=splitonedimonetotwo(R(1).onedimR.node1(w(1)), temp1(i)); %%分裂成2个
                         u=size(R(1).onedimR.node1,2);
                         %%%这里是把2个直接插入
                         if  w(1)==1
                             %剩下的都插入tempnode1里面
                             for  kk=2:1:u
                                tempnode1(kk+1)=R(1).onedimR.node1(kk);
                             end 
                             R(1).onedimR.node1=tempnode1;
                         end
                         if (w(1)>1)&&(w(1)==u)
                             for kk=1:1:(w(1)-1)
                                 rtempnode1(kk)=R(1).onedimR.node1(kk);
                             end
                                 rtempnode1(w(1))=tempnode1(1);
                                 rtempnode1(w(1)+1)=tempnode1(2);
                             R(1).onedimR.node1=rtempnode1;    
                         end
                         if (w(1)>1)&&(w(1)<u)
                             for kk=1:1:(w(1)-1)
                                 rtempnode1(kk)=R(1).onedimR.node1(kk);
                             end
                                 rtempnode1(w(1))=tempnode1(1);
                                 rtempnode1(w(1)+1)=tempnode1(2);
                             for kk=(w(1)+1):1:u
                                 rtempnode1(kk+1)=R(1).onedimR.node1(kk);
                             end   
                             R(1).onedimR.node1=rtempnode1; 
                         end
                        %%%%%%%%%%%%%%%
                elseif (size(R(1).onedimR.node1,2)+1)>n_node   %%%
                    %%%分裂形成第三层level==2
                    test='divonedimR.m line 209';
                    
                end
            end                       
        elseif R(1).onedimR.level==2
    
            test='divonedimR.m line 217';
  
         end      
        
             sameitem=0; %%回执
   end %size
        
        
        
  end %%exist
    
 if ~exist('temp2')
      R(2).sum_num=0;
      R(2).sum_rating(1)=0;
      R(2).sum_rating(2)=0;
      R(2).sum_rating(3)=0;
      R(2).sum_rating(4)=0;
      R(2).sum_rating(5)=0;
      R(2).onedimR=struct();  
    else
         R(2).onedimR.node(1)=temp2(1);
  for i=2:1:size(temp2,2)%%%% R(1).onedimR.level 判断并不断增加
        if  R(2).onedimR.level==0
            if (size(R(2).onedimR.node,2)+1)<=n_leaf
              temp_num=size(R(2).onedimR.node,2);
              R(2).onedimR.node(temp_num+1)=temp2(i); 
            else
              [mdnode, mark]=splitonedimleafnode(R(2).onedimR.node, temp2(i));
              if mark==1
              R(2).onedimR.node1=mdnode;
              R(2).onedimR.node=[];
              R(2).onedimR.level=R(2).onedimR.level+1;
              end
              if mark==0
              R(2).onedimR.node=mdnode;
              end 
            end
        elseif  R(2).onedimR.level==1
            for p=1:1:size(R(2).onedimR.node1,2)  %% 63      %%93
                       if  temp2(i).price<R(2).onedimR.node1(p).maxprice
                            w(1)=p; %#ok<NASGU>
                            break;
                       end
                       if  temp2(i).price==R(2).onedimR.node1(p).maxprice
                            w(1)=p+1; %#ok<NASGU>
                            break;
                       end
            end   
            for k=1:1:size(R(2).onedimR.node1(w(1)).node,2)
                    if  strcmp(R(2).onedimR.node1(w(1)).node(k).item, temp2(i).item)==1
                         R(2).onedimR.node1(w(1)).node(k).sum_num=R(2).onedimR.node1(w(1)).node(k).sum_num+temp2(i).sum_num;
                         R(2).onedimR.node1(w(1)).node(k).sum_rating(1)=R(2).onedimR.node1(w(1)).node(k).sum_rating(1)+temp2(i).sum_rating(1);
                         R(2).onedimR.node1(w(1)).node(k).sum_rating(2)=R(2).onedimR.node1(w(1)).node(k).sum_rating(2)+temp2(i).sum_rating(2);
                         R(2).onedimR.node1(w(1)).node(k).sum_rating(3)=R(2).onedimR.node1(w(1)).node(k).sum_rating(3)+temp2(i).sum_rating(3);
                         R(2).onedimR.node1(w(1)).node(k).sum_rating(4)=R(2).onedimR.node1(w(1)).node(k).sum_rating(4)+temp2(i).sum_rating(4);
                         R(2).onedimR.node1(w(1)).node(k).sum_rating(5)=R(2).onedimR.node1(w(1)).node(k).sum_rating(5)+temp2(i).sum_rating(5);
                         R(2).onedimR.node1(w(1)).sum_num=R(2).onedimR.node1(w(1)).sum_num+temp2(i).sum_num;
                         R(2).onedimR.node1(w(1)).sum_rating(1)=R(2).onedimR.node1(w(1)).sum_rating(1)+temp2(i).sum_rating(1);
                         R(2).onedimR.node1(w(1)).sum_rating(2)=R(2).onedimR.node1(w(1)).sum_rating(2)+temp2(i).sum_rating(2);
                         R(2).onedimR.node1(w(1)).sum_rating(3)=R(2).onedimR.node1(w(1)).sum_rating(3)+temp2(i).sum_rating(3);
                         R(2).onedimR.node1(w(1)).sum_rating(4)=R(2).onedimR.node1(w(1)).sum_rating(4)+temp2(i).sum_rating(4);
                         R(2).onedimR.node1(w(1)).sum_rating(5)=R(2).onedimR.node1(w(1)).sum_rating(5)+temp2(i).sum_rating(5); 
                         sameitem=1;  
                    end
            end
            if sameitem==0      %%没有
                if   (size(R(2).onedimR.node1(w(1)).node,2)+1)<=n_leaf           %%如果没满
                         temp_num=size(R(2).onedimR.node1(w(1)).node,2);
                         R(2).onedimR.node1(w(1)).node(temp_num+1).item=temp2(i).item;
                         R(2).onedimR.node1(w(1)).node(temp_num+1).price=temp2(i).price;
                         R(2).onedimR.node1(w(1)).node(temp_num+1).sum_num=temp2(i).sum_num;
                         R(2).onedimR.node1(w(1)).node(temp_num+1).sum_rating(1)=temp2(i).sum_rating(1);
                         R(2).onedimR.node1(w(1)).node(temp_num+1).sum_rating(2)=temp2(i).sum_rating(2);
                         R(2).onedimR.node1(w(1)).node(temp_num+1).sum_rating(3)=temp2(i).sum_rating(3);
                         R(2).onedimR.node1(w(1)).node(temp_num+1).sum_rating(4)=temp2(i).sum_rating(4);
                         R(2).onedimR.node1(w(1)).node(temp_num+1).sum_rating(5)=temp2(i).sum_rating(5);
                         for p=1:1:temp_num                                          %%2个for循环1-dim排序
                             for q=(p+1):1:(temp_num+1)
                                    if R(2).onedimR.node1(w(1)).node(p).price>R(2).onedimR.node1(w(1)).node(q).price  %%前面大于后面的交换
                                       anotherleaf=R(2).onedimR.node1(w(1)).node(p);
                                       R(2).onedimR.node1(w(1)).node(p)=R(2).onedimR.node1(w(1)).node(q);
                                       R(2).onedimR.node1(w(1)).node(q)=anotherleaf;            
                                    end                                      
                             end
                         end     
                         %%% 向上更新
                         R(2).onedimR.node1(w(1)).sum_num=R(2).onedimR.node1(w(1)).sum_num+temp2(i).sum_num;
                         R(2).onedimR.node1(w(1)).sum_rating(1)=R(2).onedimR.node1(w(1)).sum_rating(1)+temp2(i).sum_rating(1);
                         R(2).onedimR.node1(w(1)).sum_rating(2)=R(2).onedimR.node1(w(1)).sum_rating(2)+temp2(i).sum_rating(2);
                         R(2).onedimR.node1(w(1)).sum_rating(3)=R(2).onedimR.node1(w(1)).sum_rating(3)+temp2(i).sum_rating(3);
                         R(2).onedimR.node1(w(1)).sum_rating(4)=R(2).onedimR.node1(w(1)).sum_rating(4)+temp2(i).sum_rating(4);
                         R(2).onedimR.node1(w(1)).sum_rating(5)=R(2).onedimR.node1(w(1)).sum_rating(5)+temp2(i).sum_rating(5);  
                elseif  (size(R(2).onedimR.node1,2)+1)<=n_node %%新建结点
                         tempnode1=splitonedimonetotwo(R(2).onedimR.node1(w(1)), temp2(i)); %%分裂成2个
                         u=size(R(2).onedimR.node1,2);
                         %%%这里是把2个直接插入
                         if  w(1)==1
                             %剩下的都插入tempnode1里面
                             for  kk=2:1:u
                                tempnode1(kk+1)=R(2).onedimR.node1(kk);
                             end 
                             R(2).onedimR.node1=tempnode1;
                         end
                         if (w(1)>1)&&(w(1)==u)
                             for kk=1:1:(w(1)-1)
                                 rtempnode1(kk)=R(2).onedimR.node1(kk);
                             end
                                 rtempnode1(w(1))=tempnode1(1);
                                 rtempnode1(w(1)+1)=tempnode1(2);
                             R(2).onedimR.node1=rtempnode1;    
                         end
                         if (w(1)>1)&&(w(1)<u)
                             for kk=1:1:(w(1)-1)
                                 rtempnode1(kk)=R(2).onedimR.node1(kk);
                             end
                                 rtempnode1(w(1))=tempnode1(1);
                                 rtempnode1(w(1)+1)=tempnode1(2);
                             for kk=(w(1)+1):1:u
                                 rtempnode1(kk+1)=R(2).onedimR.node1(kk);
                             end   
                             R(2).onedimR.node1=rtempnode1; 
                         end
                        %%%%%%%%%%%%%%%
                elseif (size(R(2).onedimR.node1,2)+1)>n_node   %%%
                    %%%分裂形成第三层level==2
                    test='divonedimR.m line 329';
                    
                end
           end                       
        elseif R(2).onedimR.level==2
    
                         test='divonedimR.m line 337';
             
        end
        

          sameitem=0; %%回执       
   end %%size
     
 end %% exist
  end
               
if onedimR.level==2
    test='divonedimR.m line ';   
end
     
else
R(1).onedimR=onedimR; 
R(2).onedimR=onedimR; 
end

  
end