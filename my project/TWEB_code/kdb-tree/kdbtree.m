%function [crtree]=kdbtree(CC)

conna=database('mywork','','');

setdbprefs ('DataReturnFormat','structure'); %%//?????
% 
cursorC=exec(conna,'select * from sd1'); %%//????
% 

cursorC=fetch(cursorC);

CC=cursorC.Data;

n_leaf=51;%%%  root*�ĸ���
n_node=32;%% ����node������ͬ���entries
max=100000;

%%%%���￪ʼ��ʼ��
crtree(1).ctree=CC.cid(1);
%%% ÿһ��entryҪ�洢��
 %%% ����indext price time ��һ����ֳ�3����
   % exmvsb(1).pricerange(1).min_price=str2double(cell2mat(CC.itemprice(1)));
    crtree(1).root.level=0; %%Ҷ�ӽڵ�
    %%%��ʼ����һ���ڵ�
    crtree(1).root.leaf(1).item=CC.itemtitle(1); %%maxkey
    crtree(1).root.leaf(1).price=round(str2double(cell2mat(CC.itemprice(1))));
    crtree(1).root.minprice=round(str2double(cell2mat(CC.itemprice(1))));
    crtree(1).root.maxprice=round(str2double(cell2mat(CC.itemprice(1))));
    crtree(1).root.leaf(1).time=timechange(cell2mat(CC.time(1)));%%maxtime;
    crtree(1).root.leaf(1).sum_num=1; %%maxkey
    crtree(1).root.leaf(1).sum_rating(1)=str2double((CC.rating1(1))); %#ok<ST2NM>
    crtree(1).root.leaf(1).sum_rating(2)=str2double((CC.rating2(1)));
    crtree(1).root.leaf(1).sum_rating(3)=str2double((CC.rating3(1)));
    crtree(1).root.leaf(1).sum_rating(4)=str2double((CC.rating4(1)));
    crtree(1).root.leaf(1).sum_rating(5)=str2double((CC.rating5(1)));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%������ʼ��
    cnumber=1; %% ��¼category�ĸ���
    sameitem=0; 
    sametime=0;
    cexistmark=0;%% ���category�в����������Ϊ0����Ϊ1��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
for i=2:1:size(CC.itemtitle, 1)
        
        
 for j=1:1:cnumber   %%ɨ������root
       
    if  strcmp(crtree(j).ctree, CC.cid(i))==1  %%�µĽڵ�������root���½�һ�� 
        cexistmark=1;        
        %%%%
          if  crtree(j).root.level==0 %#ok<ALIGN> %%˵����һ��  �����Ǹ� 
              leaf_num=size(crtree(j).root.leaf,2); %����Ҷ�ӽڵ�ĸ���
                   for k=1:1:leaf_num  %������Ҷ�ӽڵ���ָ����ͬ��Ʒ��   %%%������ʱ���������
                        if  (strcmp(crtree(j).root.leaf(k).item, CC.itemtitle(i))==1)&&(crtree(j).root.leaf(k).time==timechange(cell2mat(CC.time(i))))%%�������ͬ�Ľڵ����ȥ  ��ͬʱ���Ӧ���ǲ�ͬ�Ľڵ� ����Ҫ����Ū��                         
                               crtree(j).root.leaf(k).sum_num=crtree(j).root.leaf(k).sum_num+1;
                               crtree(j).root.leaf(k).sum_rating(1)=crtree(j).root.leaf(k).sum_rating(1)+str2double((CC.rating1(i)));
                               crtree(j).root.leaf(k).sum_rating(2)=crtree(j).root.leaf(k).sum_rating(2)+str2double((CC.rating2(i)));
                               crtree(j).root.leaf(k).sum_rating(3)=crtree(j).root.leaf(k).sum_rating(3)+str2double((CC.rating3(i)));
                               crtree(j).root.leaf(k).sum_rating(4)=crtree(j).root.leaf(k).sum_rating(4)+str2double((CC.rating4(i)));
                               crtree(j).root.leaf(k).sum_rating(5)=crtree(j).root.leaf(k).sum_rating(5)+str2double((CC.rating5(i)));
                          sameitem=1;     
                        end
                   end
              
                   if  ((leaf_num+1)<= n_leaf)&&(sameitem==0)  %#ok<ALIGN>    
                               crtree(j).root.leaf(leaf_num+1).item=CC.itemtitle(i); %%maxkey
                               crtree(j).root.leaf(leaf_num+1).price=round(str2double(cell2mat(CC.itemprice(i))));
                               crtree(j).root.leaf(leaf_num+1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
                               crtree(j).root.leaf(leaf_num+1).sum_num=1;
                               crtree(j).root.leaf(leaf_num+1).sum_rating(1)=str2double((CC.rating1(i)));
                               crtree(j).root.leaf(leaf_num+1).sum_rating(2)=str2double((CC.rating2(i)));
                               crtree(j).root.leaf(leaf_num+1).sum_rating(3)=str2double((CC.rating3(i)));
                               crtree(j).root.leaf(leaf_num+1).sum_rating(4)=str2double((CC.rating4(i)));
                               crtree(j).root.leaf(leaf_num+1).sum_rating(5)=str2double((CC.rating5(i)));
                   elseif ((leaf_num+1)> n_leaf)&&(sameitem==0) %%Ҷ�ӷ���ͬʱ����key�ֽ�
                 temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                 temp2=timechange(cell2mat(CC.time(i))); %time
                 crtree(j).root.node=splitleaf(crtree(j).root.leaf, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));           
                 crtree(j).root.leaf=[];
                 crtree(j).root.level=crtree(j).root.level+1;  
                              
                   end
       
                  sameitem=0;%��ִ
          elseif crtree(j).root.level==1
              node_num=size(crtree(j).root.node,2);
  %% ����Ҫ���ҵ�����λ��       ������������ĵ��������������ʱ��pot�Ҳ���Ŷ       
              for k=1:1:node_num  
                  if (crtree(j).root.node(k).maxtime==timechange(cell2mat(CC.time(i))))  %%��������ʱ�䲻��һ���µ�ʱ�����뵽ԭ���Ľ����
                      sametime=1;
                  end %%%crtree(j).root.node(k).maxtime==timechange(cell2mat(CC.time(i)))  
                  if  (sametime==1)&&(round(str2double(cell2mat(CC.itemprice(i))))<=crtree(j).root.node(k).maxprice)     
                      pot=k; %#ok<NASGU>
                      break;
                  end
                  if  (sametime==1)    
                      pot=k; %#ok<NASGU>
                  end
              end
              
%%%Ȼ���ٲ��� ���sametime=1;
            if sametime==1
                %%%%���ж� ��ͬ��Ʒ
                [olynode, sameitem]=compdiff(crtree(j).root.node, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));
                if  sameitem==1
                    crtree(j).root.node=olynode;
                elseif sameitem==0
                    
          if  (node_num+1)<=n_node
                    temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                    temp2=timechange(cell2mat(CC.time(i))); %time
             crtree(j).root.node=newsplitleaf(crtree(j).root.node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));  %%���������splitleaf��һ����Ϊ���Ի����һά�ķֽ�                    
          elseif (node_num+1)>n_node
                   if (size(crtree(j).root.node(node_num).leaf,2)+1)<=n_leaf
                    temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                    temp2=timechange(cell2mat(CC.time(i))); %time
                    crtree(j).root.node=newsplitleaf(crtree(j).root.node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));  %%���������splitleaf��һ����Ϊ���Ի����һά�ķֽ�          
                   else
                    temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                    temp2=timechange(cell2mat(CC.time(i))); %time     
                    [kknode, pmark]=splitnode(crtree(j).root.node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));        
                    if pmark==1
                    crtree(j).root.node1=kknode;
                    crtree(j).root.node=[];
                    crtree(j).root.level=crtree(j).root.level+1; 
                    elseif pmark==0
                     crtree(j).root.node=kknode;   
                    end
                   end
          end
                                                                                  
                end                
            end 
%%%Ȼ���ٲ��� ���sametime=0;
             if sametime==0  %%���½�һ����� 
                 if  ((node_num+1)<=n_node) %%��һ���µĽ����룬��ס���ʱ��ÿ����㶼Ҫ��¼1-dim  
                    %%������ص���Ҫ����С�ڰ����� ������Ҫ��paper���������
                    if size(crtree(j).root.node(node_num).leaf,2)<ceil(n_leaf/2)
                               temp_leaf_num=size(crtree(j).root.node(node_num).leaf,2);
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).item=CC.itemtitle(i); %%maxkey
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).price=round(str2double(cell2mat(CC.itemprice(i))));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_num=1;
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(1)=str2double((CC.rating1(i)));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(2)=str2double((CC.rating2(i)));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(3)=str2double((CC.rating3(i)));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(4)=str2double((CC.rating4(i)));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(5)=str2double((CC.rating5(i)));
                               crtree(j).root.node(node_num).maxtime=timechange(cell2mat(CC.time(i)));
                    else  %%��������� �½�һ�������� (node_num+1)                
                     %%%����һ��������1-dimȫ����ȥȻ����ַ��ѵ�ʱ��ֽ�1-dimŶ good
                               crtree(j).root.node(node_num+1).level=0;
                               crtree(j).root.node(node_num+1).dimark=1;
                               crtree(j).root.node(node_num+1).mintime=timechange(cell2mat(CC.time(i)));
                               crtree(j).root.node(node_num+1).maxtime=timechange(cell2mat(CC.time(i)));
                               crtree(j).root.node(node_num+1).minprice=0;
                               crtree(j).root.node(node_num+1).maxprice=max;
[crtree(j).root.node(node_num+1).sum_num, crtree(j).root.node(node_num+1).sum_rating(1), crtree(j).root.node(node_num+1).sum_rating(2), crtree(j).root.node(node_num+1).sum_rating(3), crtree(j).root.node(node_num+1).sum_rating(4), crtree(j).root.node(node_num+1).sum_rating(5), crtree(j).root.node(node_num+1).onedimR]=merge(crtree(j).root.node);                             
                               crtree(j).root.node(node_num+1).leaf(1).item=CC.itemtitle(i); %%�½���ʼ��
                               crtree(j).root.node(node_num+1).leaf(1).price=round(str2double(cell2mat(CC.itemprice(i))));
                               crtree(j).root.node(node_num+1).leaf(1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
                               crtree(j).root.node(node_num+1).leaf(1).sum_num=1;
                               crtree(j).root.node(node_num+1).leaf(1).sum_rating(1)=str2double((CC.rating1(i)));
                               crtree(j).root.node(node_num+1).leaf(1).sum_rating(2)=str2double((CC.rating2(i)));
                               crtree(j).root.node(node_num+1).leaf(1).sum_rating(3)=str2double((CC.rating3(i)));
                               crtree(j).root.node(node_num+1).leaf(1).sum_rating(4)=str2double((CC.rating4(i)));
                               crtree(j).root.node(node_num+1).leaf(1).sum_rating(5)=str2double((CC.rating5(i)));                                                                       
                    end
                 else %%((node_num+1)<=n_node)
                    %%%%���������ж�(node_num+1)�µ�leafҶ���Ƿ�����û����������룬��������һ��ķ����
                    if    size(crtree(j).root.node(node_num).leaf,2)<ceil(n_leaf/2)
                               temp_leaf_num=size(crtree(j).root.node(node_num).leaf,2);
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).item=CC.itemtitle(i); %%maxkey
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).price=round(str2double(cell2mat(CC.itemprice(i))));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_num=1;
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(1)=str2double((CC.rating1(i)));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(2)=str2double((CC.rating2(i)));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(3)=str2double((CC.rating3(i)));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(4)=str2double((CC.rating4(i)));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(5)=str2double((CC.rating5(i)));
                               crtree(j).root.node(node_num).maxtime=timechange(cell2mat(CC.time(i))); 
                    else
                    temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                    temp2=timechange(cell2mat(CC.time(i))); %time     
                    [kknode, pmark]=splitnode(crtree(j).root.node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));        
                    if pmark==1
                    crtree(j).root.node1=kknode;
                    crtree(j).root.node=[];
                    crtree(j).root.level=crtree(j).root.level+1; 
                    elseif pmark==0
                     crtree(j).root.node=kknode;   
                    end        
                    end
                       
                 end
             end
              
               sametime=0; %%��ִ
              
         elseif crtree(j).root.level==2
              node1_num=size(crtree(j).root.node1,2);
              node_num=size(crtree(j).root.node1(node1_num).node,2); %%�϶�������������
  %% ����Ҫ���ҵ�����λ��       ������������ĵ��������������ʱ��pot�Ҳ���Ŷ       
              for k=1:1:node_num;  
                  if (crtree(j).root.node1(node1_num).node(k).maxtime==timechange(cell2mat(CC.time(i))))  %%��������ʱ�䲻��һ���µ�ʱ�����뵽ԭ���Ľ����
                      sametime=1;
                  end %%%crtree(j).root.node(k).maxtime==timechange(cell2mat(CC.time(i)))  
                  if  (sametime==1)&&(round(str2double(cell2mat(CC.itemprice(i))))<=crtree(j).root.node1(node1_num).node(k).maxprice)     
                      pot=k; %#ok<NASGU>
                      break;
                  end
                  if  (sametime==1)    
                      pot=k; %#ok<NASGU>
                  end
              end
              
             if sametime==1
                 
                [olynode, sameitem]=compdiff(crtree(j).root.node1(node1_num).node, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));
                if  sameitem==1
                    crtree(j).root.node1(node1_num).node=olynode;
                elseif sameitem==0
                    
                      if  ((node_num+1)<=n_node) %%�������
                         temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                         temp2=timechange(cell2mat(CC.time(i))); %time
                         crtree(j).root.node1(node1_num).node=newsplitleaf(crtree(j).root.node1(node1_num).node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));  %%���������splitleaf��һ����Ϊ���Ի����һά�ķֽ�         
                     else %%��һ���ٷ��� �ټ�һ��
                          if (size(crtree(j).root.node1(node1_num).node(node_num).leaf,2)+1)<=n_leaf
                                                   temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                                                   temp2=timechange(cell2mat(CC.time(i))); %time
                                                   crtree(j).root.node1(node1_num).node=newsplitleaf(crtree(j).root.node1(node1_num).node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));  %%���������splitleaf��һ����Ϊ���Ի����һά�ķֽ�          
                         else
                         if ((node1_num+1)<=n_node) %%�������
                        temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                        temp2=timechange(cell2mat(CC.time(i))); %time     
                         [ktempnode, pmark]=splitnode(crtree(j).root.node1(node1_num).node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i)); 
                        if pmark==1
                        yy1=crtree(j).root.node1(node1_num).sum_num;
                        yy2=crtree(j).root.node1(node1_num).sum_rating(1);
                        yy3=crtree(j).root.node1(node1_num).sum_rating(2);
                        yy4=crtree(j).root.node1(node1_num).sum_rating(3);                   
                        yy5=crtree(j).root.node1(node1_num).sum_rating(4);
                        yy6=crtree(j).root.node1(node1_num).sum_rating(5);                   
                        crtree(j).root.node1(node1_num)=ktempnode(1);
                        crtree(j).root.node1(node1_num).sum_num=yy1;
                        crtree(j).root.node1(node1_num).sum_rating(1)=yy2;
                        crtree(j).root.node1(node1_num).sum_rating(2)=yy3;
                        crtree(j).root.node1(node1_num).sum_rating(3)=yy4;
                        crtree(j).root.node1(node1_num).sum_rating(4)=yy5;
                        crtree(j).root.node1(node1_num).sum_rating(5)=yy6;
                        crtree(j).root.node1(node1_num+1)=ktempnode(2);
                        elseif pmark==0
                            crtree(j).root.node1(node1_num).node=ktempnode;
                            
                        end
                                                                                                                                                
                         else %%%����һ��
                       temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                       temp2=timechange(cell2mat(CC.time(i))); %time     
                       [jjnode, kmark]=splitnode1(crtree(j).root.node1, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));           
                        if kmark==1
                       crtree(j).root.node2=jjnode;
                       crtree(j).root.node1=[];
                       crtree(j).root.level=crtree(j).root.level+1;  
                       elseif kmark==0
                        crtree(j).root.node1=jjnode;    
                       end
                         end
                         end
                     end
                                       
                end             
                   
 %                 sameitem=0; 
             end   
%%%Ȼ���ٲ��� ���sametime=0;
             if sametime==0  %%���½�һ����� 
                 if  ((node_num+1)<=n_node) %%��һ���µĽ����룬��ס���ʱ��ÿ����㶼Ҫ��¼1-dim  
                    %%������ص���Ҫ����С�ڰ����� ������Ҫ��paper���������
                    if size(crtree(j).root.node1(node1_num).node(node_num).leaf,2)<ceil(n_leaf/2)
                               temp_leaf_num=size(crtree(j).root.node1(node1_num).node(node_num).leaf,2);
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).item=CC.itemtitle(i); %%maxkey
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).price=round(str2double(cell2mat(CC.itemprice(i))));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_num=1;
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(1)=str2double((CC.rating1(i)));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(2)=str2double((CC.rating2(i)));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(3)=str2double((CC.rating3(i)));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(4)=str2double((CC.rating4(i)));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(5)=str2double((CC.rating5(i)));
                               crtree(j).root.node1(node1_num).node(node_num).maxtime=timechange(cell2mat(CC.time(i)));
                    else  %%��������� �½�һ�������� (node_num+1)                
                     %%%����һ��������1-dimȫ����ȥȻ����ַ��ѵ�ʱ��ֽ�1-dimŶ good
                               crtree(j).root.node1(node1_num).node(node_num+1).level=0;
                               crtree(j).root.node1(node1_num).node(node_num+1).dimark=1;
                               crtree(j).root.node1(node1_num).node(node_num+1).mintime=timechange(cell2mat(CC.time(i)));
                               crtree(j).root.node1(node1_num).node(node_num+1).maxtime=max;
                               crtree(j).root.node1(node1_num).node(node_num+1).minprice=0;
                               crtree(j).root.node1(node1_num).node(node_num+1).maxprice=max;
[crtree(j).root.node1(node1_num).node(node_num+1).sum_num, crtree(j).root.node1(node1_num).node(node_num+1).sum_rating(1), crtree(j).root.node1(node1_num).node(node_num+1).sum_rating(2), crtree(j).root.node1(node1_num).node(node_num+1).sum_rating(3), crtree(j).root.node1(node1_num).node(node_num+1).sum_rating(4), crtree(j).root.node1(node1_num).node(node_num+1).sum_rating(5), crtree(j).root.node1(node1_num).node(node_num+1).onedimR]=merge(crtree(j).root.node1(node1_num).node);                             
                               crtree(j).root.node1(node1_num).node(node_num+1).leaf(1).item=CC.itemtitle(i); %%�½���ʼ��
                               crtree(j).root.node1(node1_num).node(node_num+1).leaf(1).price=round(str2double(cell2mat(CC.itemprice(i))));
                               crtree(j).root.node1(node1_num).node(node_num+1).leaf(1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
                               crtree(j).root.node1(node1_num).node(node_num+1).leaf(1).sum_num=1;
                               crtree(j).root.node1(node1_num).node(node_num+1).leaf(1).sum_rating(1)=str2double((CC.rating1(i)));
                               crtree(j).root.node1(node1_num).node(node_num+1).leaf(1).sum_rating(2)=str2double((CC.rating2(i)));
                               crtree(j).root.node1(node1_num).node(node_num+1).leaf(1).sum_rating(3)=str2double((CC.rating3(i)));
                               crtree(j).root.node1(node1_num).node(node_num+1).leaf(1).sum_rating(4)=str2double((CC.rating4(i)));
                               crtree(j).root.node1(node1_num).node(node_num+1).leaf(1).sum_rating(5)=str2double((CC.rating5(i)));                                                                       
                    end
                 else %%((node_num+1)<=n_node)
                    %%%%���������ж�(node_num+1)�µ�leafҶ���Ƿ�����û����������룬��������һ��ķ����
                    if    size(crtree(j).root.node1(node1_num).node(node_num).leaf,2)<ceil(n_leaf/2)
                               temp_leaf_num=size(crtree(j).root.node1(node1_num).node(node_num).leaf,2);
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).item=CC.itemtitle(i); %%maxkey
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).price=round(str2double(cell2mat(CC.itemprice(i))));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_num=1;
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(1)=str2double((CC.rating1(i)));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(2)=str2double((CC.rating2(i)));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(3)=str2double((CC.rating3(i)));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(4)=str2double((CC.rating4(i)));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(5)=str2double((CC.rating5(i)));
                               crtree(j).root.node1(node1_num).node(node_num).maxtime=timechange(cell2mat(CC.time(i))); 
                    else
                        if ((node1_num+1)<=n_node) %%�������       
                       temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                       temp2=timechange(cell2mat(CC.time(i))); %time     
                       [ktempnode, pmark]=splitnode(crtree(j).root.node1(node1_num).node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));                                
                        if pmark==1
                        yy1=crtree(j).root.node1(node1_num).sum_num;
                        yy2=crtree(j).root.node1(node1_num).sum_rating(1);
                        yy3=crtree(j).root.node1(node1_num).sum_rating(2);
                        yy4=crtree(j).root.node1(node1_num).sum_rating(3);                   
                        yy5=crtree(j).root.node1(node1_num).sum_rating(4);
                        yy6=crtree(j).root.node1(node1_num).sum_rating(5);
                        crtree(j).root.node1(node1_num)=ktempnode(1);
                        crtree(j).root.node1(node1_num).sum_num=yy1;
                        crtree(j).root.node1(node1_num).sum_rating(1)=yy2;
                        crtree(j).root.node1(node1_num).sum_rating(2)=yy3;
                        crtree(j).root.node1(node1_num).sum_rating(3)=yy4;
                        crtree(j).root.node1(node1_num).sum_rating(4)=yy5;
                        crtree(j).root.node1(node1_num).sum_rating(5)=yy6;
                        crtree(j).root.node1(node1_num+1)=ktempnode(2);
                        elseif pmark==0
                           crtree(j).root.node1(node1_num).node=ktempnode;
                        end
                       %%%%���ϲ���
                        else
                       temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                       temp2=timechange(cell2mat(CC.time(i))); %time     
                       [jjnode, kmark]=splitnode1(crtree(j).root.node1, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));        
                       if kmark==1
                       crtree(j).root.node2=jjnode;
                       crtree(j).root.node1=[];
                       crtree(j).root.level=crtree(j).root.level+1;  
                       elseif kmark==0
                        crtree(j).root.node1=jjnode;    
                       end
                        end

                    end
                       
                 end
             end
              
               sametime=0; %%��ִ     
%        elseif crtree(j).root.level==3
%               node2_num=size(crtree(j).root.node2,2);
%               node1_num=size(crtree(j).root.node2(node2_num).node1,2);
%               node_num=size(crtree(j).root.node2(node2_num).node1(node1_num).node,2); %%�϶�������������              
%               for k=1:1:node_num;  
%                   if (crtree(j).root.node2(node2_num).node1(node1_num).node(k).maxtime==timechange(cell2mat(CC.time(i))))  %%��������ʱ�䲻��һ���µ�ʱ�����뵽ԭ���Ľ����
%                       sametime=1;
%                   end %%%crtree(j).root.node(k).maxtime==timechange(cell2mat(CC.time(i)))  
%                   if  (sametime==1)&&(round(str2double(cell2mat(CC.itemprice(i))))<=crtree(j).root.node2(node2_num).node1(node1_num).node(k).maxprice)     
%                       pot=k; %#ok<NASGU>
%                       break;
%                   end
%                   if  (sametime==1)    
%                       pot=k; %#ok<NASGU>
%                   end
%               end
%            
%          if sametime==1
%              
%         [olynode, sameitem]=compdiff(crtree(j).root.node2(node2_num).node1(node1_num).node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));
%                 if  sameitem==1
%                     crtree(j).root.node2(node2_num).node1(node1_num).node=olynode;
%                 elseif sameitem==0
%                     
%                      if  ((node_num+1)<=n_node) %%�������
%                          temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
%                          temp2=timechange(cell2mat(CC.time(i))); %time
%                          crtree(j).root.node2(node2_num).node1(node1_num).node=newsplitleaf(crtree(j).root.node2(node2_num).node1(node1_num).node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));  %%���������splitleaf��һ����Ϊ���Ի����һά�ķֽ�         
%                      else %%��һ���ٷ��� �ټ�һ��
%                          
%                                      if (size(crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf,2)+1)<=n_leaf
%                                                    temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
%                                                    temp2=timechange(cell2mat(CC.time(i))); %time
%                                                    crtree(j).root.node2(node2_num).node1(node1_num).node=newsplitleaf(crtree(j).root.node2(node2_num).node1(node1_num).node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));  %%���������splitleaf��һ����Ϊ���Ի����һά�ķֽ�          
%                                      else
%                                          
%                         if ((node1_num+1)<=n_node) %%�������
%                         temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
%                         temp2=timechange(cell2mat(CC.time(i))); %time     
%                         [ktempnode, pmark]=splitnode(crtree(j).root.node2(node2_num).node1(node1_num).node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i)); 
%                         if pmark==1
%                         yyR=crtree(j).root.node2(node2_num).node1(node1_num).onedimR;
%                         yy1=crtree(j).root.node2(node2_num).node1(node1_num).sum_num;
%                         yy2=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(1);
%                         yy3=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(2);
%                         yy4=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(3);                   
%                         yy5=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(4);
%                         yy6=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(5);                   
%                         crtree(j).root.node2(node2_num).node1(node1_num)=ktempnode(1);
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_num=yy1;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(1)=yy2;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(2)=yy3;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(3)=yy4;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(4)=yy5;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(5)=yy6;
%                         crtree(j).root.node2(node2_num).node1(node1_num).onedimR=yyR;
%                         crtree(j).root.node2(node2_num).node1(node1_num+1)=ktempnode(2);
%                         elseif pmark==0
%                             crtree(j).root.node2(node2_num).node1(node1_num).node=ktempnode;
%                         end
%                          else %%%����һ��
%                              if ((node2_num+1)<=n_node)
%                        temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
%                        temp2=timechange(cell2mat(CC.time(i))); %time     
%                        [ktempnode1, kmark]=splitnode1(crtree(j).root.node2(node2_num).node1, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));  
%                         if kmark==1
%                         yyR=crtree(j).root.node2(node2_num).onedimR;
%                         yy1=crtree(j).root.node2(node2_num).sum_num;
%                         yy2=crtree(j).root.node2(node2_num).sum_rating(1);
%                         yy3=crtree(j).root.node2(node2_num).sum_rating(2);
%                         yy4=crtree(j).root.node2(node2_num).sum_rating(3);                   
%                         yy5=crtree(j).root.node2(node2_num).sum_rating(4);
%                         yy6=crtree(j).root.node2(node2_num).sum_rating(5);                   
%                         crtree(j).root.node2(node2_num)=ktempnode1(1);
%                         crtree(j).root.node2(node2_num).sum_num=yy1;
%                         crtree(j).root.node2(node2_num).sum_rating(1)=yy2;
%                         crtree(j).root.node2(node2_num).sum_rating(2)=yy3;
%                         crtree(j).root.node2(node2_num).sum_rating(3)=yy4;
%                         crtree(j).root.node2(node2_num).sum_rating(4)=yy5;
%                         crtree(j).root.node2(node2_num).sum_rating(5)=yy6;
%                         crtree(j).root.node2(node2_num).onedimR=yyR;
%                         crtree(j).root.node2(node2_num+1)=ktempnode1(2);
%                         elseif kmark==0
%                             crtree(j).root.node1=ktempnode1;
%                                                                               
%                         end
%                              else
%                        temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
%                        temp2=timechange(cell2mat(CC.time(i))); %time     
%                        [rrnode, vmark]=splitnode2(crtree(j).root.node1, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));        
%                        if vmark==1
%                        crtree(j).root.node3=rrnode;
%                        crtree(j).root.node2=[];
%                        crtree(j).root.level=crtree(j).root.level+1;  
%                        elseif vmark==0
%                         crtree(j).root.node1=rrnode;    
%                        end
%                                 % test='line';
%                              end
%                          end
%                                                                                                                                                               
%                                      end
%                          
%                      end
%                                                                             
%                 end
%                              
%              %     sameitem=0; 
%          end   
%         
%             if sametime==0  %%���½�һ����� 
%                  if  ((node_num+1)<=n_node) %%��һ���µĽ����룬��ס���ʱ��ÿ����㶼Ҫ��¼1-dim  
%                     %%������ص���Ҫ����С�ڰ����� ������Ҫ��paper���������
%                     if size(crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf,2)<ceil(n_leaf/2)
%                                temp_leaf_num=size(crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf,2);
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).item=CC.itemtitle(i); %%maxkey
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).price=round(str2double(cell2mat(CC.itemprice(i))));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_num=1;
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(1)=str2double((CC.rating1(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(2)=str2double((CC.rating2(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(3)=str2double((CC.rating3(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(4)=str2double((CC.rating4(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(5)=str2double((CC.rating5(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).maxtime=timechange(cell2mat(CC.time(i)));
%                     else  %%��������� �½�һ�������� (node_num+1)                
%                      %%%����һ��������1-dimȫ����ȥȻ����ַ��ѵ�ʱ��ֽ�1-dimŶ good
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).level=0;
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).dimark=1;
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).mintime=timechange(cell2mat(CC.time(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).maxtime=max;
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).minprice=0;
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).maxprice=max;
% [crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).sum_num, crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).sum_rating(1), crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).sum_rating(2), crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).sum_rating(3), crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).sum_rating(4), crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).sum_rating(5), crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).onedimR]=merge(crtree(j).root.node2(node2_num).node1(node1_num).node);                             
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).leaf(1).item=CC.itemtitle(i); %%�½���ʼ��
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).leaf(1).price=round(str2double(cell2mat(CC.itemprice(i))));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).leaf(1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).leaf(1).sum_num=1;
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).leaf(1).sum_rating(1)=str2double((CC.rating1(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).leaf(1).sum_rating(2)=str2double((CC.rating2(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).leaf(1).sum_rating(3)=str2double((CC.rating3(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).leaf(1).sum_rating(4)=str2double((CC.rating4(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).leaf(1).sum_rating(5)=str2double((CC.rating5(i)));                                                                       
%                     end
%                  else %%((node_num+1)<=n_node)
%                     %%%%���������ж�(node_num+1)�µ�leafҶ���Ƿ�����û����������룬��������һ��ķ����
%                     if    size(crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf,2)<ceil(n_leaf/2)
%                                temp_leaf_num=size(crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf,2);
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).item=CC.itemtitle(i); %%maxkey
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).price=round(str2double(cell2mat(CC.itemprice(i))));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_num=1;
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(1)=str2double((CC.rating1(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(2)=str2double((CC.rating2(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(3)=str2double((CC.rating3(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(4)=str2double((CC.rating4(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(5)=str2double((CC.rating5(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).maxtime=timechange(cell2mat(CC.time(i))); 
%                     else
%                         if ((node1_num+1)<=n_node) %%�������       
%                        temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
%                        temp2=timechange(cell2mat(CC.time(i))); %time     
%                        [ktempnode, pmark]=splitnode(crtree(j).root.node2(node2_num).node1(node1_num).node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));                                
%                        if pmark==1 
%                        yyR=crtree(j).root.node2(node2_num).node1(node1_num).onedimR;
%                         yy1=crtree(j).root.node2(node2_num).node1(node1_num).sum_num;
%                         yy2=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(1);
%                         yy3=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(2);
%                         yy4=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(3);                   
%                         yy5=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(4);
%                         yy6=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(5);
%                         crtree(j).root.node2(node2_num).node1(node1_num)=ktempnode(1);
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_num=yy1;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(1)=yy2;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(2)=yy3;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(3)=yy4;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(4)=yy5;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(5)=yy6;
%                         crtree(j).root.node2(node2_num).node1(node1_num).onedimR=yyR;
%                         crtree(j).root.node2(node2_num).node1(node1_num+1)=ktempnode(2);
%                        elseif pmark==0
%                            crtree(j).root.node2(node2_num).node1(node1_num).node=ktempnode;
%                        end
%                        %%%%���ϲ���
%                         else
%                             if ((node2_num+1)<=n_node)                    
%                        temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
%                        temp2=timechange(cell2mat(CC.time(i))); %time     
%                        [ktempnode1, kmark]=splitnode1(crtree(j).root.node2(node2_num).node1, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));  
%                        if kmark==1
%                         yyR=crtree(j).root.node2(node2_num).onedimR;
%                         yy1=crtree(j).root.node2(node2_num).sum_num;
%                         yy2=crtree(j).root.node2(node2_num).sum_rating(1);
%                         yy3=crtree(j).root.node2(node2_num).sum_rating(2);
%                         yy4=crtree(j).root.node2(node2_num).sum_rating(3);                   
%                         yy5=crtree(j).root.node2(node2_num).sum_rating(4);
%                         yy6=crtree(j).root.node2(node2_num).sum_rating(5);                   
%                         crtree(j).root.node2(node2_num)=ktempnode1(1);
%                         crtree(j).root.node2(node2_num).sum_num=yy1;
%                         crtree(j).root.node2(node2_num).sum_rating(1)=yy2;
%                         crtree(j).root.node2(node2_num).sum_rating(2)=yy3;
%                         crtree(j).root.node2(node2_num).sum_rating(3)=yy4;
%                         crtree(j).root.node2(node2_num).sum_rating(4)=yy5;
%                         crtree(j).root.node2(node2_num).sum_rating(5)=yy6;
%                         crtree(j).root.node2(node2_num).onedimR=yyR;
%                         crtree(j).root.node2(node2_num+1)=ktempnode1(2);  
%                        elseif kmark==0 
%                            crtree(j).root.node1=ktempnode1;                   
%                        end
%                             else 
%                        temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
%                        temp2=timechange(cell2mat(CC.time(i))); %time     
%                        [rrnode, vmark]=splitnode2(crtree(j).root.node1, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));        
%                        if vmark==1
%                        crtree(j).root.node3=rrnode;
%                        crtree(j).root.node2=[];
%                        crtree(j).root.level=crtree(j).root.level+1;  
%                        elseif vmark==0
%                         crtree(j).root.node1=rrnode;    
%                        end
% 
%                             end
%                         end
% 
%                     end
%                        
%                  end
%              end
%               
%                sametime=0; %%��ִ  
%        elseif crtree(j).root.level==4
             
       end  %%%%crtree(j).rootstar(n_rootstar).level==0  �����Ҷ�Ӳ�    
       
              if crtree(j).root.minprice>round(str2double(cell2mat(CC.itemprice(i))))
                  crtree(j).root.minprice=round(str2double(cell2mat(CC.itemprice(i))));
              end
              if crtree(j).root.maxprice<round(str2double(cell2mat(CC.itemprice(i))))
                  
                  crtree(j).root.maxprice=round(str2double(cell2mat(CC.itemprice(i))));
              end
       break;
    end  %%strcmp(crtree(j).ctree, CC.cid(i))==1  ��
end  %%%j=1:1:cnumber ��
            
     %    % % %�¸��ڵ����¸�ֵ
 if cexistmark==0
    cnumber=cnumber+1;
    crtree(cnumber).ctree=CC.cid(i);
%%% ÿһ��entryҪ�洢��

    crtree(cnumber).root.level=0; %%Ҷ�ӽڵ�
    %%%��ʼ����һ���ڵ�
    crtree(cnumber).root.minprice=round(str2double(cell2mat(CC.itemprice(i))));
    crtree(cnumber).root.maxprice=round(str2double(cell2mat(CC.itemprice(i))));
    crtree(cnumber).root.leaf(1).item=CC.itemtitle(i); %%maxkey
    crtree(cnumber).root.leaf(1).price=round(str2double(cell2mat(CC.itemprice(i))));
    crtree(cnumber).root.leaf(1).time=timechange(cell2mat(CC.time(i)));%%maxtime;
    crtree(cnumber).root.leaf(1).sum_num=1;
    crtree(cnumber).root.leaf(1).sum_rating(1)=str2double((CC.rating1(i))); %#ok<ST2NM>
    crtree(cnumber).root.leaf(1).sum_rating(2)=str2double((CC.rating2(i)));
    crtree(cnumber).root.leaf(1).sum_rating(3)=str2double((CC.rating3(i)));
    crtree(cnumber).root.leaf(1).sum_rating(4)=str2double((CC.rating4(i)));
    crtree(cnumber).root.leaf(1).sum_rating(5)=str2double((CC.rating5(i)));
    
 end                
   cexistmark=0;     
end
%end   
    
    
    
    
