function  [sum, r1, r2, r3, r4, r5]=smallsizemerge(node) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%此部分被splitnode调用
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%n_leaf=32;
%n_node=32;

node_num=size(node, 2);
%sameitem=0;
%k=1;
if node_num==1
    sum=node.sum_num;
    r1=node.sum_rating(1);
    r2=node.sum_rating(2);
    r3=node.sum_rating(3);
    r4=node.sum_rating(4);
    r5=node.sum_rating(5);    
end
if node_num>1
    sum=node(1).sum_num;
    r1=node(1).sum_rating(1);
    r2=node(1).sum_rating(2);
    r3=node(1).sum_rating(3);
    r4=node(1).sum_rating(4);
    r5=node(1).sum_rating(5);
    
%     for i=2:1:node_num     
% %     sum=sum+node(i).sum_num;
% %     r1=r1+node(i).sum_rating(1);
% %     r2=r2+node(i).sum_rating(2);
% %     r3=r3+node(i).sum_rating(3);
% %     r4=r4+node(i).sum_rating(4);
% %     r5=r5+node(i).sum_rating(5);
% % if isfield(node(i).onedimR, 'level')
% %             if node(i).onedimR.level==0
% %                if isfield(node(i).onedimR, 'node')
% %                      for j=1:1:size(node(i).onedimR.node,2)          
% %                          totalnode(k)=node(i).onedimR.node(j);
% %                          k=k+1;               
% %                      end
% %               end
% %             end   
% % 
% %              if node(i).onedimR.level==1
% %                     for j=1:1:size(node(i).onedimR.node1,2)
% %                         for p=1:1:size(node(i).onedimR.node1(j).node,2)
% %                          totalnode(k)=node(i).onedimR.node1(j).node(p);
% %                          k=k+1;
% %                         end
% %                     end   
% %              end        
% %     
% %              if node(i).onedimR.level==2
% %                     for j=1:1:size(node(i).onedimR.node2,2)
% %                         for p=1:1:size(node(i).onedimR.node2(j).node1,2)
% %                             for q=1:1:size(node(i).onedimR.node2(j).node1(p).node,2)
% %                                totalnode(k)=node(i).onedimR.node2(j).node1(p).node(q);
% %                                k=k+1;
% %                             end
% %                         end
% %                     end   
% %             end         
% %              
% % end
%        
%     end
  
%     if exist('totalnode') %%%如果存在
%  for j=1:1:size(totalnode, 2)  %%往里面插入把孩子
%               
%         if R.level==0
%              if  (size(R.node,2)+1)<=n_leaf
%                 for k=1:1:size(R.node,2)           
%                      if  strcmp(R.node(k).item, totalnode(j).item)==1
%                          R.node(k).sum_num=R.node(k).sum_num+totalnode(j).sum_num;
%                          R.node(k).sum_rating(1)=R.node(k).sum_rating(1)+totalnode(j).sum_rating(1);
%                          R.node(k).sum_rating(2)=R.node(k).sum_rating(2)+totalnode(j).sum_rating(2);
%                          R.node(k).sum_rating(3)=R.node(k).sum_rating(3)+totalnode(j).sum_rating(3);
%                          R.node(k).sum_rating(4)=R.node(k).sum_rating(4)+totalnode(j).sum_rating(4);
%                          R.node(k).sum_rating(5)=R.node(k).sum_rating(5)+totalnode(j).sum_rating(5);
%                          sameitem=1;  
%                      end
%                 end
%               if sameitem==0 %%插入
%                          temp_num=size(R.node,2);
%                          R.node(temp_num+1).item=totalnode(j).item;
%                          R.node(temp_num+1).price=totalnode(j).price;
%                          R.node(temp_num+1).sum_num=totalnode(j).sum_num;
%                          R.node(temp_num+1).sum_rating(1)=totalnode(j).sum_rating(1);
%                          R.node(temp_num+1).sum_rating(2)=totalnode(j).sum_rating(2);
%                          R.node(temp_num+1).sum_rating(3)=totalnode(j).sum_rating(3);
%                          R.node(temp_num+1).sum_rating(4)=totalnode(j).sum_rating(4);
%                          R.node(temp_num+1).sum_rating(5)=totalnode(j).sum_rating(5);
%                          for p=1:1:temp_num                                          %%2个for循环1-dim排序
%                              for q=(p+1):1:(temp_num+1)
%                                     if R.node(p).price>R.node(q).price  %%前面大于后面的交换
%                                        anotherleaf=R.node(p);
%                                        R.node(p)=R.node(q);
%                                        R.node(q)=anotherleaf;            
%                                     end                                      
%                              end
%                          end
%                                     
%              end
%             else  %%分裂
% %              test='mergeleaf.m 72 行 叶子分裂了';
%               [mdnode, mark]=splitonedimleafnode(R.node, totalnode(j));
%               if mark==1
%               R.node1=mdnode;
%               R.node=[];
%               R.level=R.level+1;
%               end
%               if mark==0
%               R.node=mdnode;
%               end
%              end  
%          elseif R.level==1
%             for p=1:1:size(R.node1,2)  %% 63      %%93
%                        if  totalnode(j).price<R.node1(p).maxprice
%                             w(1)=p; %#ok<NASGU>
%                             break;
%                        end
%                        if  totalnode(j).price==R.node1(p).maxprice
%                             w(1)=p+1; %#ok<NASGU>
%                             break;
%                        end
%             end   
%             %%% 搜索所有R.node1(w(1))
%             for k=1:1:size(R.node1(w(1)).node,2)
%                     if  strcmp(R.node1(w(1)).node(k).item, totalnode(j).item)==1
%                          R.node1(w(1)).node(k).sum_num=R.node1(w(1)).node(k).sum_num+totalnode(j).sum_num;
%                          R.node1(w(1)).node(k).sum_rating(1)=R.node1(w(1)).node(k).sum_rating(1)+totalnode(j).sum_rating(1);
%                          R.node1(w(1)).node(k).sum_rating(2)=R.node1(w(1)).node(k).sum_rating(2)+totalnode(j).sum_rating(2);
%                          R.node1(w(1)).node(k).sum_rating(3)=R.node1(w(1)).node(k).sum_rating(3)+totalnode(j).sum_rating(3);
%                          R.node1(w(1)).node(k).sum_rating(4)=R.node1(w(1)).node(k).sum_rating(4)+totalnode(j).sum_rating(4);
%                          R.node1(w(1)).node(k).sum_rating(5)=R.node1(w(1)).node(k).sum_rating(5)+totalnode(j).sum_rating(5);
%                          R.node1(w(1)).sum_num=R.node1(w(1)).sum_num+totalnode(j).sum_num;
%                          R.node1(w(1)).sum_rating(1)=R.node1(w(1)).sum_rating(1)+totalnode(j).sum_rating(1);
%                          R.node1(w(1)).sum_rating(2)=R.node1(w(1)).sum_rating(2)+totalnode(j).sum_rating(2);
%                          R.node1(w(1)).sum_rating(3)=R.node1(w(1)).sum_rating(3)+totalnode(j).sum_rating(3);
%                          R.node1(w(1)).sum_rating(4)=R.node1(w(1)).sum_rating(4)+totalnode(j).sum_rating(4);
%                          R.node1(w(1)).sum_rating(5)=R.node1(w(1)).sum_rating(5)+totalnode(j).sum_rating(5); 
%                          sameitem=1;  
%                     end
%             end
%             if sameitem==0      %%没有
%                 if   (size(R.node1(w(1)).node,2)+1)<=n_leaf           %%如果没满
%                          temp_num=size(R.node1(w(1)).node,2);
%                          R.node1(w(1)).node(temp_num+1).item=totalnode(j).item;
%                          R.node1(w(1)).node(temp_num+1).price=totalnode(j).price;
%                          R.node1(w(1)).node(temp_num+1).sum_num=totalnode(j).sum_num;
%                          R.node1(w(1)).node(temp_num+1).sum_rating(1)=totalnode(j).sum_rating(1);
%                          R.node1(w(1)).node(temp_num+1).sum_rating(2)=totalnode(j).sum_rating(2);
%                          R.node1(w(1)).node(temp_num+1).sum_rating(3)=totalnode(j).sum_rating(3);
%                          R.node1(w(1)).node(temp_num+1).sum_rating(4)=totalnode(j).sum_rating(4);
%                          R.node1(w(1)).node(temp_num+1).sum_rating(5)=totalnode(j).sum_rating(5);
%                          for p=1:1:temp_num                                          %%2个for循环1-dim排序
%                              for q=(p+1):1:(temp_num+1)
%                                     if R.node1(w(1)).node(p).price>R.node1(w(1)).node(q).price  %%前面大于后面的交换
%                                        anotherleaf=R.node1(w(1)).node(p);
%                                        R.node1(w(1)).node(p)=R.node1(w(1)).node(q);
%                                        R.node1(w(1)).node(q)=anotherleaf;            
%                                     end                                      
%                              end
%                          end     
%                          %%% 向上更新
%                          R.node1(w(1)).sum_num=R.node1(w(1)).sum_num+totalnode(j).sum_num;
%                          R.node1(w(1)).sum_rating(1)=R.node1(w(1)).sum_rating(1)+totalnode(j).sum_rating(1);
%                          R.node1(w(1)).sum_rating(2)=R.node1(w(1)).sum_rating(2)+totalnode(j).sum_rating(2);
%                          R.node1(w(1)).sum_rating(3)=R.node1(w(1)).sum_rating(3)+totalnode(j).sum_rating(3);
%                          R.node1(w(1)).sum_rating(4)=R.node1(w(1)).sum_rating(4)+totalnode(j).sum_rating(4);
%                          R.node1(w(1)).sum_rating(5)=R.node1(w(1)).sum_rating(5)+totalnode(j).sum_rating(5);  
%                 elseif  (size(R.node1,2)+1)<=n_node %%新建结点
%                          tempnode1=splitonedimonetotwo(R.node1(w(1)), totalnode(j)); %%分裂成2个
%                          u=size(R.node1,2);
%                          %%%这里是把2个直接插入
%                          if  w(1)==1
%                              %剩下的都插入tempnode1里面
%                              for  kk=2:1:u
%                                 tempnode1(kk+1)=R.node1(kk);
%                              end 
%                              R.node1=tempnode1;
%                          end
%                          if (w(1)>1)&&(w(1)==u)
%                              for kk=1:1:(w(1)-1)
%                                  rtempnode1(kk)=R.node1(kk);
%                              end
%                                  rtempnode1(w(1))=tempnode1(1);
%                                  rtempnode1(w(1)+1)=tempnode1(2);
%                              R.node1=rtempnode1;    
%                          end
%                          if (w(1)>1)&&(w(1)<u)
%                              for kk=1:1:(w(1)-1)
%                                  rtempnode1(kk)=R.node1(kk);
%                              end
%                                  rtempnode1(w(1))=tempnode1(1);
%                                  rtempnode1(w(1)+1)=tempnode1(2);
%                              for kk=(w(1)+1):1:u
%                                  rtempnode1(kk+1)=R.node1(kk);
%                              end   
%                              R.node1=rtempnode1; 
%                          end
%                         %%%%%%%%%%%%%%%
%                 elseif (size(R.node1,2)+1)>n_node   %%%
%                     %%%分裂形成第三层level==2
%                     test='smallsizemerge.m line 199';
%                     
%                 end
%            end  
%          elseif R.level==2
%     
%              test='smallsizemerge.m line 208';            
%                          
%        end
%      
% 
%     sameitem=0; %%回执   
%     sum=sum+totalnode(j).sum_num;
%     r1=r1+totalnode(j).sum_rating(1);
%     r2=r2+totalnode(j).sum_rating(2);
%     r3=r3+totalnode(j).sum_rating(3);
%     r4=r4+totalnode(j).sum_rating(4);
%     r5=r5+totalnode(j).sum_rating(5);
%  end             
%     end
       
end%%node_num>1

end