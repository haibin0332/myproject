function  [sum, r1, r2, r3, r4, r5, R]=merge(node) 
%%%%%%%%%%%%%
%%%%%%此部分代码被kdbtree调用
%%%%%%%%%%%%%
%max=100000;
%%%先找前面的形成1-dim    
pot=0; %%如果最后还是0说明没有
temptime=0;
i=1;
node_num=size(node,2);
  for j=1:1:(node_num-1)   %%pot初始化 
      if (node(j).dimark==1) %%找mintime最大且maxtime不等于max
          pot=j;  
          temptime=node(j).mintime;
      end
  end  
  
  if  pot==0
    %%说明之前没有可以merge的 直接R的初始化
    for k=1:1:node_num
      if  node(k).dimark==0
       tempnode(k).leaf=node(k).leaf;
      end
    end
    [sum, r1, r2, r3, r4, r5, R]=mergeleaf(tempnode);
  elseif pot>0
      for j=1:1:node_num   %%定位都把那些1-dim记录下来  
      if node(j).mintime==temptime
       tempnode(i).leaf=node(j).leaf;
       tempnode(i).onedimR=node(j).onedimR;
       tempnode(i).sum_num=node(j).sum_num;
       tempnode(i).sum_rating(1)=node(j).sum_rating(1);
       tempnode(i).sum_rating(2)=node(j).sum_rating(2);
       tempnode(i).sum_rating(3)=node(j).sum_rating(3);
       tempnode(i).sum_rating(4)=node(j).sum_rating(4);
       tempnode(i).sum_rating(5)=node(j).sum_rating(5);
       i=i+1;
      end
      end  
      [sum, r1, r2, r3, r4, r5, R]=mergeleafandnode(tempnode);
      
  end
%   if   temptime>0  %%%%%定位
%       for j=1:1:node_num   %%定位都把那些1-dim记录下来  
%       if node(j).mintime==temptime
%        tempnode(i).leaf=node(j).leaf;
%        tempnode(i).onedimR=node(j).onedimR;
%        tempnode(i).sum_num=node(j).sum_num;
%        tempnode(i).sum_rating(1)=node(j).sum_rating(1);
%        tempnode(i).sum_rating(2)=node(j).sum_rating(2);
%        tempnode(i).sum_rating(3)=node(j).sum_rating(3);
%        tempnode(i).sum_rating(4)=node(j).sum_rating(4);
%        tempnode(i).sum_rating(5)=node(j).sum_rating(5);
%        i=i+1;
%       end
%       end  
%       %%%merge pot+node.leaf
%     [sum, r1, r2, r3, r4, r5, R]=mergeleafandnode(tempnode);
%   end
%   
end