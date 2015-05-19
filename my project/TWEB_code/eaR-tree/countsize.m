load('tree1.mat');
k=size(rootnode, 2);

for  i=1:1:k
    if  ~isempty(rootnode(i).leafnode) %%如果叶子不为空
          j=size(rootnode(i).leafnode, 2);
        
          for  l=1:1:j
              rootnode(i).leafnode(l).itemname=[]; 
          end
    elseif  ~isempty(rootnode(i).internode) %%如果叶子不为空
        
            j=size(rootnode(i).internode, 2);       
          for  l=1:1:j
              j1=size(rootnode(i).internode(l).leafnode, 2);
              for l1=1:1:j1
              rootnode(i).internode(l).leafnode(l1).itemname=[]; 
              end
          end
        
    elseif ~isempty(rootnode(i).internode_1) %%如果叶子不为空
                  j=size(rootnode(i).internode_1, 2);       
          for  l=1:1:j
              j1=size(rootnode(i).internode_1(l).internode, 2);
              for l1=1:1:j1
                  j2=size(rootnode(i).internode_1(l).internode(l1).leafnode, 2);
                  for l2=1:1:j2
              rootnode(i).internode_1(l).internode(l1).leafnode(l2).itemname=[]; 
                  end
              end
          end
        
    elseif  ~isempty(rootnode(i).internode_2) %%如果叶子不为空
                j=size(rootnode(i).internode_2, 2);       
          for  l=1:1:j
              j1=size(rootnode(i).internode_2(l).internode_1, 2);
              for l1=1:1:j1
                  j2=size(rootnode(i).internode_2(l).internode_1(l1).internode, 2);
                  for l2=1:1:j2
                      j3=size(rootnode(i).internode_2(l).internode_1(l1).internode(l2).leafnode, 2);
                      for l3=1:1:j3
              rootnode(i).internode_2(l).internode_1(l1).internode(l2).leafnode(l3).itemname=[]; 
                      end
                  end
              end
          end  
              
    elseif ~isempty(rootnode(i).internode_3) %%如果叶子不为空
        
                  j=size(rootnode(i).internode_3, 2);       
          for  l=1:1:j
              j1=size(rootnode(i).internode_3(l).internode_2, 2);
              for l1=1:1:j1
                  j2=size(rootnode(i).internode_3(l).internode_2(l1).internode_1, 2);
                  for l2=1:1:j2
                      j3=size(rootnode(i).internode_3(l).internode_2(l1).internode_1(l2).internode, 2);
                      for l3=1:1:j3
                       j4=size(rootnode(i).internode_3(l).internode_2(l1).internode_1(l2).internode(l3).leafnode, 2);
                       for l4=1:1:j4
              rootnode(i).internode_3(l).internode_2(l1).internode_1(l2).internode(l3).leafnode(l4).itemname=[]; 
                       end
                      end
                  end
              end
          end
        
    end
 
      
end
