function  [sum, r1, r2, r3, r4, r5, R]=mergebackup(node) 
%%%%%%%%%%%%%
%%%%%%此部分代码被kdbtree调用
%%%%%%%%%%%%%
%max=100000;
%%%先找前面的形成1-dim    

% temptime=0;
i=1;
node_num=size(node,2);
temptime=node(node_num).mintime;

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
