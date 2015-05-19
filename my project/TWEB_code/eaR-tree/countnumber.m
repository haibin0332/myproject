load('bymonthsy.mat');
scc_1=size(rootnode, 2);
k=0;
for scc_2=1:1:scc_1
     if rootnode(scc_2).n_level==1
         k=1;
     end
end