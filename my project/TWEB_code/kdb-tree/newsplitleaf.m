function  [node2]=newsplitleaf(node, num1, num2, rating1, rating2, rating3, rating4, rating5, item) %num2时间， num1 钱
%%%%%%%%%%%%%%%%%%%
%%%%%%%此部分被kdbtree调用
%%%%%%%%%%%%%%%%%%%%%%%%%%
% test='newsplitleaf.m 没编呢';
n_leaf=51;

k=1;
sameitem=0;
node_num=size(node,2); 
record=node(node_num).maxtime;
for  j=1:1:node_num
    if  node(j).maxtime==record
        w(k)=j;
        k=k+1;
    end
end

for p=1:1:size(w,2)
vector(p)=node(w(p)); 
end

if size(w,2)==1
      
        for u=1:1:size(node(node_num).leaf, 2)
            if strcmp(node(node_num).leaf(u).item, item)==1
                  node(node_num).leaf(u).sum_num=node(node_num).leaf(u).sum_num+1;
                  node(node_num).leaf(u).sum_rating(1)=node(node_num).leaf(u).sum_rating(1)+str2double(rating1);
                  node(node_num).leaf(u).sum_rating(2)=node(node_num).leaf(u).sum_rating(2)+str2double(rating2);
                  node(node_num).leaf(u).sum_rating(3)=node(node_num).leaf(u).sum_rating(3)+str2double(rating3);
                  node(node_num).leaf(u).sum_rating(4)=node(node_num).leaf(u).sum_rating(4)+str2double(rating4);
                  node(node_num).leaf(u).sum_rating(5)=node(node_num).leaf(u).sum_rating(5)+str2double(rating5);
                  sameitem=1;                  
            end
            %%%直接返回
        end
        if sameitem==1            
            node2=node;
        end
        if  ((size(node(node_num).leaf, 2)+1)<= n_leaf)&&(sameitem==0)  %#ok<ALIGN>   
             u=size(node(node_num).leaf, 2);
          node(node_num).leaf(u+1).item=item; %%maxkey
          node(node_num).leaf(u+1).price=num1;
          node(node_num).leaf(u+1).time=num2;%%maxtime;        
          node(node_num).leaf(u+1).sum_num=1;
          node(node_num).leaf(u+1).sum_rating(1)=str2double(rating1);
          node(node_num).leaf(u+1).sum_rating(2)=str2double(rating2);
          node(node_num).leaf(u+1).sum_rating(3)=str2double(rating3);
          node(node_num).leaf(u+1).sum_rating(4)=str2double(rating4);
          node(node_num).leaf(u+1).sum_rating(5)=str2double(rating5);                      %#ok<NASGU>
          %%%直接返回
              node2=node;
     
        elseif ((size(node(node_num).leaf, 2)+1)> n_leaf)&&(sameitem==0) %%叶子分裂同时伴随key分解 
           %%%分裂%%%%
           temptwonode=smallsplitnode(vector(1), num1, num2, rating1, rating2, rating3, rating4, rating5, item);
               node(node_num)=temptwonode(1);
               node(node_num+1)=temptwonode(2);
               node2=node;                             
    end
                  
elseif size(w,2)>1
    for  v=1:1:size(w, 2)
        if num1<vector(v).maxprice
        for u=1:1:size(vector(v).leaf, 2)
            if strcmp(vector(v).leaf(u).item, item)==1
                  vector(v).leaf(u).sum_num=vector(v).leaf(u).sum_num+1;
                  vector(v).leaf(u).sum_rating(1)=vector(v).leaf(u).sum_rating(1)+str2double(rating1);
                  vector(v).leaf(u).sum_rating(2)=vector(v).leaf(u).sum_rating(2)+str2double(rating2);
                  vector(v).leaf(u).sum_rating(3)=vector(v).leaf(u).sum_rating(3)+str2double(rating3);
                  vector(v).leaf(u).sum_rating(4)=vector(v).leaf(u).sum_rating(4)+str2double(rating4);
                  vector(v).leaf(u).sum_rating(5)=vector(v).leaf(u).sum_rating(5)+str2double(rating5);
                  sameitem=1;                  
            end
            %%%直接返回
        end
        if sameitem==1            
           if  w(1)==1
             node2=vector;             
           elseif w(1)>1
            for r=1:1:(w(1)-1)                
                node2(r)=node(r);
            end
            for r=1:1:size(vector, 2)
                node2(w(1)-1+r)=vector(r);        
            end              
           end                         
        end
        if  ((size(vector(v).leaf, 2)+1)<= n_leaf)&&(sameitem==0)  %#ok<ALIGN>    
            u=size(vector(v).leaf, 2);
          vector(v).leaf(u+1).item=item; %%maxkey
          vector(v).leaf(u+1).price=num1;
          vector(v).leaf(u+1).time=num2;%%maxtime;        
          vector(v).leaf(u+1).sum_num=1;
          vector(v).leaf(u+1).sum_rating(1)=str2double(rating1);
          vector(v).leaf(u+1).sum_rating(2)=str2double(rating2);
          vector(v).leaf(u+1).sum_rating(3)=str2double(rating3);
          vector(v).leaf(u+1).sum_rating(4)=str2double(rating4);
          vector(v).leaf(u+1).sum_rating(5)=str2double(rating5);                      %#ok<NASGU>
          %%%直接返回
            
           if  w(1)==1
             node2=vector;             
           elseif w(1)>1
            for r=1:1:(w(1)-1)                
                node2(r)=node(r);
            end
            for r=1:1:size(vector, 2)
                node2(w(1)-1+r)=vector(r);        
            end              
           end     
           break;
        elseif ((size(vector(v).leaf, 2)+1)> n_leaf)&&(sameitem==0) %%叶子分裂同时伴随key分解 
           temptwonode=smallsplitnode(vector(v), num1, num2, rating1, rating2, rating3, rating4, rating5, item);
           if  v==1
               vector1(1)=temptwonode(1);
               vector1(2)=temptwonode(2);
               for u=2:1:size(vector, 2)                 
                vector1(u+1)=vector(u);   
               end               
           elseif v==size(vector, 2)
               for u=1:1:(size(vector, 2)-1)               
                vector1(u)=vector(u);   
               end 
               vector1(u+1)=temptwonode(1); 
               vector1(u+2)=temptwonode(2);  %#ok<NASGU>
             
           elseif (v>1)&&(v<size(vector, 2))
               for u=1:1:(v-1)                
                vector1(u)=vector(u);   
               end     
               vector1(v)=temptwonode(1);
               vector1(v+1)=temptwonode(2);
               for u=(v+1):1:size(vector, 2)                
                vector1(u+1)=vector(u);   
               end          
           end
           if  w(1)==1
             node2=vector1;             
           elseif w(1)>1
            for r=1:1:(w(1)-1)                
                node2(r)=node(r);
            end
            for r=1:1:size(vector, 2)
                node2(w(1)-1+r)=vector1(r);        
            end              
           end    
            break;            
                    
        end
           break;     
        end
        
       %%%%%写在这里 num1是大于走到最后 都没有 num1<vector(v).maxprice 说明
       %%%%%num1>vector(v).maxprice
       if v==size(w, 2)
     
         for u=1:1:size(vector(v).leaf, 2)
            if strcmp(vector(v).leaf(u).item, item)==1
                  vector(v).leaf(u).sum_num=vector(v).leaf(u).sum_num+1;
                  vector(v).leaf(u).sum_rating(1)=vector(v).leaf(u).sum_rating(1)+str2double(rating1);
                  vector(v).leaf(u).sum_rating(2)=vector(v).leaf(u).sum_rating(2)+str2double(rating2);
                  vector(v).leaf(u).sum_rating(3)=vector(v).leaf(u).sum_rating(3)+str2double(rating3);
                  vector(v).leaf(u).sum_rating(4)=vector(v).leaf(u).sum_rating(4)+str2double(rating4);
                  vector(v).leaf(u).sum_rating(5)=vector(v).leaf(u).sum_rating(5)+str2double(rating5);
                  sameitem=1;                  
            end
            %%%直接返回
         end
         if sameitem==1                         
            for r=1:1:(w(1)-1)                
                node2(r)=node(r);
            end
            for r=1:1:size(vector, 2)
                node2(w(1)-1+r)=vector(r);        
            end                             
         end       
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
       if  ((size(vector(v).leaf, 2)+1)<= n_leaf)&&(sameitem==0)  %#ok<ALIGN>    
            u=size(vector(v).leaf, 2);
          vector(v).leaf(u+1).item=item; %%maxkey
          vector(v).leaf(u+1).price=num1;
          vector(v).leaf(u+1).time=num2;%%maxtime;        
          vector(v).leaf(u+1).sum_num=1;
          vector(v).leaf(u+1).sum_rating(1)=str2double(rating1);
          vector(v).leaf(u+1).sum_rating(2)=str2double(rating2);
          vector(v).leaf(u+1).sum_rating(3)=str2double(rating3);
          vector(v).leaf(u+1).sum_rating(4)=str2double(rating4);
          vector(v).leaf(u+1).sum_rating(5)=str2double(rating5);      
          vector(v).maxprice=num1;
          %#ok<NASGU>
          %%%直接返回
            
            for r=1:1:(w(1)-1)                
                node2(r)=node(r);
            end
            for r=1:1:size(vector, 2)
                node2(w(1)-1+r)=vector(r);        
            end  
       elseif ((size(vector(v).leaf, 2)+1)> n_leaf)&&(sameitem==0) %%叶子分裂同时伴随key分解 
           
     temptwonode=smallsplitnode(vector(v), num1, num2, rating1, rating2, rating3, rating4, rating5, item);
           if  v==1
               vector1(1)=temptwonode(1);
               vector1(2)=temptwonode(2);
               for u=2:1:size(vector, 2)                 
                vector1(u+1)=vector(u);   
               end               
           elseif v==size(vector, 2)
               for u=1:1:(size(vector, 2)-1)               
                vector1(u)=vector(u);   
               end 
               vector1(u+1)=temptwonode(1); 
               vector1(u+2)=temptwonode(2);  %#ok<NASGU>
             
           elseif (v>1)&&(v<size(vector, 2))
               for u=1:1:(v-1)                
                vector1(u)=vector(u);   
               end     
               vector1(v)=temptwonode(1);
               vector1(v+1)=temptwonode(2);
               for u=(v+1):1:size(vector, 2)                
                vector1(u+1)=vector(u);   
               end          
           end
            for r=1:1:(w(1)-1)                
                node2(r)=node(r);
            end
            for r=1:1:size(vector, 2)
                node2(w(1)-1+r)=vector1(r);        
            end      
       end
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
       end
        sameitem=0; 
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% node_num=size(node,2);
% for  i=1:1:(node_num-1)
%     node2(i)=node(i);
% end
% leaf_num=size(node(node_num).leaf,2); %计算叶子节点的个数  %% 确定插入位置
%             
% node(node_num).leaf(leaf_num+1).item=item;
% node(node_num).leaf(leaf_num+1).price=num1;
% node(node_num).leaf(leaf_num+1).time=num2;
% node(node_num).leaf(leaf_num+1).sum_num=1;
% node(node_num).leaf(leaf_num+1).sum_rating(1)=str2double(rating1);
% node(node_num).leaf(leaf_num+1).sum_rating(2)=str2double(rating2);
% node(node_num).leaf(leaf_num+1).sum_rating(3)=str2double(rating3);
% node(node_num).leaf(leaf_num+1).sum_rating(4)=str2double(rating4);
% node(node_num).leaf(leaf_num+1).sum_rating(5)=str2double(rating5); %#ok<NASGU>
% 
%              for p=1:1:leaf_num  %%%排序
%                  for k=(p+1):1:(leaf_num+1)
%                      if     node(node_num).leaf(p).price>node(node_num).leaf(k).price  %%前面大于后面的交换
%                             templeaf=node(node_num).leaf(p);
%                             node(node_num).leaf(p)=node(node_num).leaf(k);
%                             node(node_num).leaf(k)=templeaf;            
%                      end
%                  end
%              end 
%              %%还要存下 每个node里的最大time
% divprice=round((node(node_num).leaf(ceil(leaf_num/2)).price+node(node_num).leaf(ceil(leaf_num/2)+1).price)/2); 
% %%%从这里开始divprice做中间量进行划分onedimR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% if node(node_num).sum_num>0
% R=divonedimR(divprice, node(node_num).onedimR);
% elseif node(node_num).sum_num==0
% R(1).sum_num=0;
% R(1).sum_rating(1)=0;
% R(1).sum_rating(2)=0;
% R(1).sum_rating(3)=0;
% R(1).sum_rating(4)=0;
% R(1).sum_rating(5)=0;
% R(1).onedimR=struct();
% 
% R(2).sum_num=0;
% R(2).sum_rating(1)=0;
% R(2).sum_rating(2)=0;
% R(2).sum_rating(3)=0;
% R(2).sum_rating(4)=0;
% R(2).sum_rating(5)=0;
% R(2).onedimR=struct();
%     
% end
% 
% node1(1).level=0;
% node1(1).dimark=node(node_num).dimark;
% node1(1).mintime=node(node_num).mintime;
% node1(1).maxtime=num2;
% node1(1).minprice=node(node_num).minprice;
% node1(1).maxprice=divprice;
% node1(1).sum_num=R(1).sum_num;
% node1(1).sum_rating(1)=R(1).sum_rating(1);
% node1(1).sum_rating(2)=R(1).sum_rating(2);
% node1(1).sum_rating(3)=R(1).sum_rating(3);
% node1(1).sum_rating(4)=R(1).sum_rating(4);
% node1(1).sum_rating(5)=R(1).sum_rating(5);
% node1(1).onedimR=R(1).onedimR;
% 
%              for j=1:1:ceil((leaf_num+1)/2)     
%                   node1(1).leaf(j)=node(node_num).leaf(j);      
%              end
% 
%              
% node1(2).level=0;
% node1(2).dimark=node(node_num).dimark;
% node1(2).mintime=node(node_num).mintime;
% node1(2).maxtime=num2;
% node1(2).minprice=divprice;
% node1(2).maxprice=node.maxprice;
% node1(2).sum_num=R(2).sum_num;
% node1(2).sum_rating(1)=R(2).sum_rating(1);
% node1(2).sum_rating(2)=R(2).sum_rating(2);
% node1(2).sum_rating(3)=R(2).sum_rating(3);
% node1(2).sum_rating(4)=R(2).sum_rating(4);
% node1(2).sum_rating(5)=R(2).sum_rating(5);
% node1(2).onedimR=R(2).onedimR;
% 
%              for j=(ceil((leaf_num+1)/2)+1):1:(leaf_num+1)
%                  node1(2).leaf(j-ceil((leaf_num+1)/2))=node(node_num).leaf(j);                  
%              end
% 
% node2(node_num)=node1(1);
% node2(node_num+1)=node1(2);
         