function [rootnode, totalleafnode]=buildaPtree(CC)
% conna=database('haibin0332','','');
% 
% setdbprefs ('DataReturnFormat','structure'); %%//?????
% % 
% cursorC=exec(conna,'select itemtitle, time, itemprice, rating1, rating2, rating3, rating4, rating5, cid from seller3'); %%//????
% % 
% 
% cursorC=fetch(cursorC);
% 
% CC=cursorC.Data;
%%�ϵ�494

n_maxcount=51;%%% Ҷ�ӽڵ����װ�ĸ���  21
n_maxcount1=42;%%��Ҷ�ӽڵ������װ�ĸ��� 19

    rootnode(1).ctree=CC.cid(1);
    %% node����ֻ��һ���ڵ�
%     rootnode(1).n_count=1;
    rootnode(1).sum_number=1;
    rootnode(1).sum_rating(1)=str2double((CC.rating1(1)));
    rootnode(1).sum_rating(2)=str2double((CC.rating2(1)));
    rootnode(1).sum_rating(3)=str2double((CC.rating3(1)));
    rootnode(1).sum_rating(4)=str2double((CC.rating4(1)));
    rootnode(1).sum_rating(5)=str2double((CC.rating5(1)));
    %% Ҷ�Ӷ��ڵ�0��
    rootnode(1).n_level=1;
    rootnode(1).minprice=round(str2double(cell2mat(CC.itemprice(1))));
    rootnode(1).maxprice=round(str2double(cell2mat(CC.itemprice(1))));
    %%
    leafnode.leaf.itemname=CC.itemtitle(1);
    leafnode.leaf.price=round(str2double(cell2mat(CC.itemprice(1))));
    leafnode.leaf.time=timechange(cell2mat(CC.time(1)));
    leafnode.leaf.sum=1;
    leafnode.leaf.rating(1)=str2double((CC.rating1(1)));
    leafnode.leaf.rating(2)=str2double((CC.rating2(1)));
    leafnode.leaf.rating(3)=str2double((CC.rating3(1)));
    leafnode.leaf.rating(4)=str2double((CC.rating4(1)));
    leafnode.leaf.rating(5)=str2double((CC.rating5(1)));
        
    leafnode.number=1;
    totalleafnode(1, leafnode.number)=leafnode;

%     internode.within_number=0;
%     internode.within_rating=0;
    internode.sum_number=1;
    internode.sum_rating(1)=str2double((CC.rating1(1)));
    internode.sum_rating(2)=str2double((CC.rating2(1)));
    internode.sum_rating(3)=str2double((CC.rating3(1)));
    internode.sum_rating(4)=str2double((CC.rating4(1)));
    internode.sum_rating(5)=str2double((CC.rating5(1)));
    internode.level=0;
    internode.pricerange.min_price=leafnode.leaf.price;   %%internode�ڵ��key
    internode.pricerange.max_price=leafnode.leaf.price;
    internode.timerange.timebegin=leafnode.leaf.time;
    internode.timerange.timeend='*';
    internode.leafnode=leafnode.number;  %%%��Ҷ�����ڰ汾���
    
    rootnode(1).internode=internode;
    
   rootnumber=1; %% ��¼���ĸ���
   rootexistmark=0;%% ������в����������Ϊ0����Ϊ1��
   countstar=0;
   
   for i=2:1:size(CC.itemtitle, 1)
             
       leaf.itemname=CC.itemtitle(i);
       leaf.price=round(str2double(cell2mat(CC.itemprice(i))));
       leaf.time=timechange(cell2mat(CC.time(i)));
       leaf.sum=1;
       leaf.rating(1)=str2double((CC.rating1(i)));
       leaf.rating(2)=str2double((CC.rating2(i)));
       leaf.rating(3)=str2double((CC.rating3(i)));
       leaf.rating(4)=str2double((CC.rating4(i)));
       leaf.rating(5)=str2double((CC.rating5(i)));
       
       for j=1:1:rootnumber
            if  strcmp(rootnode(j).ctree, CC.cid(i))==1  %%�µĽڵ�������rootnode���½�һ�� 
                rootexistmark=1;               
                if  rootnode(j).n_level==1  %% ˵��ָ��Ҷ�ӽڵ�    
             for p=1:1:size(rootnode(j).internode,2)
                   if strcmp(rootnode(j).internode(p).timerange.timeend,'*')
                       w(1)=p; 
                       v=rootnode(j).internode(p).pricerange.min_price;
                       break;
                   end                
             end
             for p=1:1:size(rootnode(j).internode,2)
                   if strcmp(rootnode(j).internode(p).timerange.timeend,'*')&& rootnode(j).internode(p).pricerange.min_price>v
                       w(1)=p; 
                       v=rootnode(j).internode(p).pricerange.min_price;
                   end                
             end                 
                 var1=size(rootnode(j).internode, 2);
                    if  size(totalleafnode(j, rootnode(j).internode(w(1)).leafnode).leaf,2)<n_maxcount %%recent leafnode�İ���leaf�ĸ���                          
   [totalleafnode, leafnode_num, temptime, mark, same, sum_number, sum_rating]=insertleafnode(rootnode(j).internode(w(1)), leaf, j, totalleafnode);%%��Ҫ�ж���Ʒ�Ƿ�һ��
                          if   same==0     %%��ͬ
                            if mark==1 %%%˵��ʱ���в�ͬ
                              if var1<n_maxcount1
                                      rootnode(j).internode(w(1)).timerange.timeend=temptime;                                     
                                      internode.sum_number=sum_number;
                                      internode.sum_rating(1)=sum_rating(1);
                                      internode.sum_rating(2)=sum_rating(2);
                                      internode.sum_rating(3)=sum_rating(3);
                                      internode.sum_rating(4)=sum_rating(4);
                                      internode.sum_rating(5)=sum_rating(5);
                                      internode.level=0;
                                      internode.pricerange.min_price=rootnode(j).internode(w(1)).pricerange.min_price;   %%internode�ڵ��key
                                      internode.pricerange.max_price=rootnode(j).internode(w(1)).pricerange.max_price;
                                      internode.timerange.timebegin=temptime;
                                      internode.timerange.timeend='*';
                                      internode.leafnode=leafnode_num;
                                      rootnode(j).internode(var1+1)=internode;   
                              else                                      
                                      rootnode(j).internode(w(1)).timerange.timeend=temptime;
                                      internode.sum_number=sum_number;
                                      internode.sum_rating(1)=sum_rating(1);
                                      internode.sum_rating(2)=sum_rating(2);
                                      internode.sum_rating(3)=sum_rating(3);
                                      internode.sum_rating(4)=sum_rating(4);
                                      internode.sum_rating(5)=sum_rating(5);
                                      internode.level=0;
                                      internode.pricerange.min_price=rootnode(j).internode(w(1)).pricerange.min_price;   %%internode�ڵ��key
                                      internode.pricerange.max_price=rootnode(j).internode(w(1)).pricerange.max_price;
                                      internode.timerange.timebegin=temptime;
                                      internode.timerange.timeend='*';
                                      internode.leafnode=leafnode_num;
                                      [internode1_1, internode1_2]=spiltinternode(rootnode(j).internode, internode);%%internode1_2װ���Ǵ�*�ŵ� ����Ҫ*��˳��   
                                      rootnode(j).internode=internode1_1;   
                                  rootnode(j).n_level=rootnode(j).n_level+1;
                                  rootnode(j).internode=[];
                                  node1_num=size(internode1_2, 2);
                                  rootnode(j).internode1(1).sum_number=[];
                                  rootnode(j).internode1(1).sum_rating=[];
                                  rootnode(j).internode1(1).level=1;
                                  rootnode(j).internode1(1).pricerange.min_price=internode1_2(1).pricerange.min_price; 
                                  rootnode(j).internode1(1).pricerange.max_price=internode1_2(1).pricerange.max_price; 
                                  for o=1:1:node1_num
                                      if     rootnode(j).internode1(1).pricerange.min_price>internode1_2(o).pricerange.min_price  
                                          rootnode(j).internode1(1).pricerange.min_price=internode1_2(o).pricerange.min_price;
                                      elseif rootnode(j).internode1(1).pricerange.max_price<internode1_2(o).pricerange.max_price 
                                          rootnode(j).internode1(1).pricerange.max_price=internode1_2(o).pricerange.max_price;
                                      end
                                  end
                                  rootnode(j).internode1(1).timerange.timebegin=internode1_2(1).timerange.timebegin;
                                  rootnode(j).internode1(1).timerange.timeend=leaf.time;
                                  rootnode(j).internode1(1).internode=internode1_2;                                       
                                  rootnode(j).internode1(2).sum_number=0;
                                  rootnode(j).internode1(2).sum_rating=[0,0,0,0,0];
                                  rootnode(j).internode1(2).level=1;
                                  rootnode(j).internode1(2).pricerange.min_price=internode1_1(1).pricerange.min_price;
                                  rootnode(j).internode1(2).pricerange.max_price=internode1_1(1).pricerange.max_price; 
                                   countstar=size(internode1_1, 2);
                                  for o=1:1:countstar
                                      if  rootnode(j).internode1(2).pricerange.min_price>internode1_1(o).pricerange.min_price  
                                          rootnode(j).internode1(2).pricerange.min_price=internode1_1(o).pricerange.min_price;
                                      elseif rootnode(j).internode1(2).pricerange.max_price<internode1_1(o).pricerange.max_price 
                                          rootnode(j).internode1(2).pricerange.max_price=internode1_1(o).pricerange.max_price;
                                      end
                                       rootnode(j).internode1(2).sum_number=rootnode(j).internode1(2).sum_number+internode1_1(o).sum_number;
                                       rootnode(j).internode1(2).sum_rating(1)=rootnode(j).internode1(2).sum_rating(1)+internode1_1(o).sum_rating(1);
                                       rootnode(j).internode1(2).sum_rating(2)=rootnode(j).internode1(2).sum_rating(2)+internode1_1(o).sum_rating(2);
                                       rootnode(j).internode1(2).sum_rating(3)=rootnode(j).internode1(2).sum_rating(3)+internode1_1(o).sum_rating(3);
                                       rootnode(j).internode1(2).sum_rating(4)=rootnode(j).internode1(2).sum_rating(4)+internode1_1(o).sum_rating(4);
                                       rootnode(j).internode1(2).sum_rating(5)=rootnode(j).internode1(2).sum_rating(5)+internode1_1(o).sum_rating(5);    
                                  end
                                  rootnode(j).internode1(2).timerange.timebegin=internode1_1(countstar).timerange.timebegin;
                                  rootnode(j).internode1(2).timerange.timeend='*';
                                  rootnode(j).internode1(2).internode=internode1_1;                                          
%                                         test='line 128';
                              end
                             elseif mark==0                             
                                  rootnode(j).internode(w(1)).sum_number=sum_number;
                                  rootnode(j).internode(w(1)).sum_rating=sum_rating;                                               
                           end %%%%%mark=1    
                              
                          elseif same==1   %%��ͬ                    
                             rootnode(j).internode(w(1)).sum_number=sum_number;
                             rootnode(j).internode(w(1)).sum_rating=sum_rating;
                          end
   
                    else
                        [internode_1, internode_2, totalleafnode]=spiltleafnode(rootnode(j).internode(w(1)), leaf, j, totalleafnode); %%����,����
                        var1=size(rootnode(j).internode, 2);
                        if   var1+2<=n_maxcount1
                            rootnode(j).internode(w(1)).timerange.timeend=internode_1.timerange.timebegin;
                            rootnode(j).internode(var1+1)=internode_1;                           
                            rootnode(j).internode(var1+2)=internode_2;                             
                        else

                                      rootnode(j).internode(w(1)).timerange.timeend=internode_1.timerange.timebegin;
                                      spilttempnode(1)=internode_1;
                                      spilttempnode(2)=internode_2;
                                      [internode1_1, internode1_2]=spiltinternode(rootnode(j).internode, spilttempnode);
                                    %  rootnode(j).internode=internode1_1;      ����������һ��  
                                     % end  
                                  rootnode(j).n_level=rootnode(j).n_level+1;
                                  rootnode(j).internode=[];
                                  node1_num=size(internode1_2, 2);
                                  rootnode(j).internode1(1).sum_number=[];
                                  rootnode(j).internode1(1).sum_rating=[];
                                  rootnode(j).internode1(1).level=1;
                                  rootnode(j).internode1(1).pricerange.min_price=internode1_2(1).pricerange.min_price; 
                                  rootnode(j).internode1(1).pricerange.max_price=internode1_2(1).pricerange.max_price; 
                                  for o=1:1:node1_num
                                      if     rootnode(j).internode1(1).pricerange.min_price>internode1_2(o).pricerange.min_price  
                                          rootnode(j).internode1(1).pricerange.min_price=internode1_2(o).pricerange.min_price;
                                      elseif rootnode(j).internode1(1).pricerange.max_price<internode1_2(o).pricerange.max_price 
                                          rootnode(j).internode1(1).pricerange.max_price=internode1_2(o).pricerange.max_price;
                                      end
                                  end
                                  rootnode(j).internode1(1).timerange.timebegin=internode1_2(1).timerange.timebegin;
                                  rootnode(j).internode1(1).timerange.timeend=leaf.time;
                                  rootnode(j).internode1(1).internode=internode1_2; 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                              
                                  countstar=size(internode1_1, 2);
                           if  countstar>=ceil(n_maxcount1*5/6)%%%�����޸�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                              
                               [starinternode1, starinternode2]=spiltstarinternode(internode1_1, countstar);
                               %rootnode(j).internode1(2).mark='star';
                                  rootnode(j).internode1(2)=starinternode1; 
                                  rootnode(j).internode1(3)=starinternode2; 
                           else
                                  rootnode(j).internode1(2).sum_number=0;
                                  rootnode(j).internode1(2).sum_rating=[0,0,0,0,0];
                                  rootnode(j).internode1(2).level=1;
                                  rootnode(j).internode1(2).pricerange.min_price=internode1_1(1).pricerange.min_price;
                                  rootnode(j).internode1(2).pricerange.max_price=internode1_1(1).pricerange.max_price; 
                                  for o=1:1:countstar
                                      if  rootnode(j).internode1(2).pricerange.min_price>internode1_1(o).pricerange.min_price  
                                          rootnode(j).internode1(2).pricerange.min_price=internode1_1(o).pricerange.min_price;
                                      elseif rootnode(j).internode1(2).pricerange.max_price<internode1_1(o).pricerange.max_price 
                                          rootnode(j).internode1(2).pricerange.max_price=internode1_1(o).pricerange.max_price;
                                      end
                                       rootnode(j).internode1(2).sum_number=rootnode(j).internode1(2).sum_number+internode1_1(o).sum_number;
                                       rootnode(j).internode1(2).sum_rating(1)=rootnode(j).internode1(2).sum_rating(1)+internode1_1(o).sum_rating(1);
                                       rootnode(j).internode1(2).sum_rating(2)=rootnode(j).internode1(2).sum_rating(2)+internode1_1(o).sum_rating(2);
                                       rootnode(j).internode1(2).sum_rating(3)=rootnode(j).internode1(2).sum_rating(3)+internode1_1(o).sum_rating(3);
                                       rootnode(j).internode1(2).sum_rating(4)=rootnode(j).internode1(2).sum_rating(4)+internode1_1(o).sum_rating(4);
                                       rootnode(j).internode1(2).sum_rating(5)=rootnode(j).internode1(2).sum_rating(5)+internode1_1(o).sum_rating(5);    
                                  end
                                  rootnode(j).internode1(2).timerange.timebegin=internode1_1(countstar).timerange.timebegin;
                                  rootnode(j).internode1(2).timerange.timeend='*';
                                  rootnode(j).internode1(2).internode=internode1_1; 
                           end       
                        end
                    end %%size(rootnode(j).internode(rootnode(j).n_count).leafnode,2)<n_maxcount   
                  %  countstar=0; 
                elseif rootnode(j).n_level==2
                 %%���ñ� ÿ��ֱ�Ӳ������
             %% �����ҵ�����λ�� ������
              v=0;
             for p=1:1:size(rootnode(j).internode1,2)
                  if strcmp(rootnode(j).internode1(p).timerange.timeend,'*')
                      for ppt=1:1:size(rootnode(j).internode1(p).internode, 2)
                          if strcmp(rootnode(j).internode1(p).internode(ppt).timerange.timeend,'*')&& rootnode(j).internode1(p).internode(ppt).pricerange.min_price>v
                       w(1)=p; 
                       w(2)=ppt;
                       v=rootnode(j).internode1(p).internode(ppt).pricerange.min_price;                     
                          end
                      end
                  end
             end  
             
                  
                    var1=size(rootnode(j).internode1(w(1)).internode, 2);                   
    if   size(totalleafnode(j, rootnode(j).internode1(w(1)).internode(w(2)).leafnode).leaf,2)<n_maxcount
     %%%������Ҷ�ӽڵ���� ���ǲ������ѵ�
        [totalleafnode, leafnode_num, temptime, mark, same, sum_number, sum_rating]=insertleafnode(rootnode(j).internode1(w(1)).internode(w(2)), leaf, j, totalleafnode);%%��Ҫ�ж���Ʒ�Ƿ�һ��
       if  same==0
        if mark==1 %%%˵��ʱ���в�ͬ
                               if  var1<n_maxcount1
                                      rootnode(j).internode1(w(1)).internode(w(2)).timerange.timeend=temptime;  
                                      internode.sum_number=sum_number;
                                      internode.sum_rating(1)=sum_rating(1);
                                      internode.sum_rating(2)=sum_rating(2);
                                      internode.sum_rating(3)=sum_rating(3);
                                      internode.sum_rating(4)=sum_rating(4);
                                      internode.sum_rating(5)=sum_rating(5);
                                      internode.level=0;
                                      internode.pricerange.min_price=rootnode(j).internode1(w(1)).internode(w(2)).pricerange.min_price;   %%internode�ڵ��key
                                      internode.pricerange.max_price=rootnode(j).internode1(w(1)).internode(w(2)).pricerange.max_price;

                                      internode.timerange.timebegin=temptime;
                                      internode.timerange.timeend='*';
                                      internode.leafnode=leafnode_num;                                                                        
                                      rootnode(j).internode1(w(1)).internode(var1+1)=internode; 
                                      rootnode(j).internode1(w(1)).sum_number=rootnode(j).internode1(w(1)).sum_number+1;
                                      rootnode(j).internode1(w(1)).sum_rating(1)=rootnode(j).internode1(w(1)).sum_rating(1)+leaf.rating(1);
                                      rootnode(j).internode1(w(1)).sum_rating(2)=rootnode(j).internode1(w(1)).sum_rating(2)+leaf.rating(2);
                                      rootnode(j).internode1(w(1)).sum_rating(3)=rootnode(j).internode1(w(1)).sum_rating(3)+leaf.rating(3);
                                      rootnode(j).internode1(w(1)).sum_rating(4)=rootnode(j).internode1(w(1)).sum_rating(4)+leaf.rating(4);
                                      rootnode(j).internode1(w(1)).sum_rating(5)=rootnode(j).internode1(w(1)).sum_rating(5)+leaf.rating(5);                                      
                                  if   rootnode(j).internode1(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode1(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode1(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode1(w(1)).pricerange.max_price=leaf.price;
                                  end
                               else       
%                                   test=1;
                                      rootnode(j).internode1(w(1)).internode(w(2)).timerange.timeend=temptime;  
                                      internode.sum_number=sum_number;
                                      internode.sum_rating(1)=sum_rating(1);
                                      internode.sum_rating(2)=sum_rating(2);
                                      internode.sum_rating(3)=sum_rating(3);
                                      internode.sum_rating(4)=sum_rating(4);
                                      internode.sum_rating(5)=sum_rating(5);
                                      internode.level=0;
                                      internode.pricerange.min_price=rootnode(j).internode1(w(1)).internode(w(2)).pricerange.min_price;   %%internode�ڵ��key
                                      internode.pricerange.max_price=rootnode(j).internode1(w(1)).internode(w(2)).pricerange.max_price;
                                      internode.timerange.timebegin=temptime;
                                      internode.timerange.timeend='*';
                                      internode.leafnode=leafnode_num;     
                                      var2=size(rootnode(j).internode1, 2);
                                      [internode1_1, internode1_2]=spiltinternode(rootnode(j).internode1(w(1)).internode, internode);
                                      countstar=size(internode1_1, 2);
                           if  countstar<ceil(n_maxcount1*5/6)%%%�����޸�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                   if  var2<n_maxcount1  %%ֱ�ӷ��Ѳ���
                                                ptemp=generate(internode1_1);  %%��������һ�����
                                                oldtemp=generateold(internode1_2, leaf, rootnode(j).internode1(w(1)).timerange.timebegin);            
                                                rootnode(j).internode1(w(1))=ptemp;
                                                rootnode(j).internode1(var2+1)=oldtemp;
                                      rootnode(j).internode1(w(1)).sum_number=rootnode(j).internode1(w(1)).sum_number+1;
                                      rootnode(j).internode1(w(1)).sum_rating(1)=rootnode(j).internode1(w(1)).sum_rating(1)+leaf.rating(1);
                                      rootnode(j).internode1(w(1)).sum_rating(2)=rootnode(j).internode1(w(1)).sum_rating(2)+leaf.rating(2);
                                      rootnode(j).internode1(w(1)).sum_rating(3)=rootnode(j).internode1(w(1)).sum_rating(3)+leaf.rating(3);
                                      rootnode(j).internode1(w(1)).sum_rating(4)=rootnode(j).internode1(w(1)).sum_rating(4)+leaf.rating(4);
                                      rootnode(j).internode1(w(1)).sum_rating(5)=rootnode(j).internode1(w(1)).sum_rating(5)+leaf.rating(5);
                                  if   rootnode(j).internode1(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode1(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode1(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode1(w(1)).pricerange.max_price=leaf.price;
                                  end
                                          
                                      else %% %%���Ϸ���
                                                ptemp=generate(internode1_1);  %%��������һ�����
                                                oldtemp=generateold(internode1_2, leaf, rootnode(j).internode1(w(1)).timerange.timebegin); 
                                                rootnode(j).internode1(w(1))=oldtemp;
                                                [internode2_1, internode2_2]=spiltinternode1_1(rootnode(j).internode1, ptemp);
                                                rootnode(j).n_level=rootnode(j).n_level+1;
                                                rootnode(j).internode1=[];  
                                                rootnode(j).internode2(1)=internode2_1;
                                                rootnode(j).internode2(2)=internode2_2;
                                    end  
                               
                           else
                               if (var2+1)<n_maxcount1  %%ֱ�ӷ��Ѳ���
                                                [starinternode1, starinternode2]=spiltstarinternode(internode1_1, countstar);
                                                var2=size(rootnode(j).internode1, 2);
                                                oldtemp=generateold(internode1_2, leaf, rootnode(j).internode1(w(1)).timerange.timebegin);            
                                                rootnode(j).internode1(w(1))=oldtemp;
                                                rootnode(j).internode1(var2+1)=starinternode1;
                                                rootnode(j).internode1(var2+2)=starinternode2;
                                  if   rootnode(j).internode1(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode1(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode1(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode1(w(1)).pricerange.max_price=leaf.price;
                                  end                                   
                                   
                               else
                                                [starinternode1, starinternode2]=spiltstarinternode(internode1_1, countstar);
                                                ptemp(1)=starinternode1;  %%��������һ�����
                                                ptemp(2)=starinternode2;
                                                oldtemp=generateold(internode1_2, leaf, rootnode(j).internode1(w(1)).timerange.timebegin); 
                                                rootnode(j).internode1(w(1))=oldtemp;
                                                [internode2_1, internode2_2]=spiltinternode1_1(rootnode(j).internode1, ptemp);
                                                rootnode(j).n_level=rootnode(j).n_level+1;
                                                rootnode(j).internode1=[];  
                                                rootnode(j).internode2(1)=internode2_1;
                                                rootnode(j).internode2(2)=internode2_2;                                  
                               end
                           end                    
                          
                               end  
        elseif  mark==0                 
                 rootnode(j).internode1(w(1)).internode(w(2)).sum_number=sum_number;
                 rootnode(j).internode1(w(1)).internode(w(2)).sum_rating(1)=sum_rating(1);
                 rootnode(j).internode1(w(1)).internode(w(2)).sum_rating(2)=sum_rating(2);
                 rootnode(j).internode1(w(1)).internode(w(2)).sum_rating(3)=sum_rating(3);
                 rootnode(j).internode1(w(1)).internode(w(2)).sum_rating(4)=sum_rating(4);
                 rootnode(j).internode1(w(1)).internode(w(2)).sum_rating(5)=sum_rating(5); 
                 rootnode(j).internode1(w(1)).sum_number=rootnode(j).internode1(w(1)).sum_number+1;
                 rootnode(j).internode1(w(1)).sum_rating(1)=rootnode(j).internode1(w(1)).sum_rating(1)+leaf.rating(1);
                 rootnode(j).internode1(w(1)).sum_rating(2)=rootnode(j).internode1(w(1)).sum_rating(2)+leaf.rating(2);  
                 rootnode(j).internode1(w(1)).sum_rating(3)=rootnode(j).internode1(w(1)).sum_rating(3)+leaf.rating(3);  
                 rootnode(j).internode1(w(1)).sum_rating(4)=rootnode(j).internode1(w(1)).sum_rating(4)+leaf.rating(4);  
                 rootnode(j).internode1(w(1)).sum_rating(5)=rootnode(j).internode1(w(1)).sum_rating(5)+leaf.rating(5);  
        end  
       elseif same==1
                 rootnode(j).internode1(w(1)).internode(w(2)).sum_number=sum_number;
                 rootnode(j).internode1(w(1)).internode(w(2)).sum_rating(1)=sum_rating(1);
                 rootnode(j).internode1(w(1)).internode(w(2)).sum_rating(2)=sum_rating(2);
                 rootnode(j).internode1(w(1)).internode(w(2)).sum_rating(3)=sum_rating(3);
                 rootnode(j).internode1(w(1)).internode(w(2)).sum_rating(4)=sum_rating(4);
                 rootnode(j).internode1(w(1)).internode(w(2)).sum_rating(5)=sum_rating(5);
                 rootnode(j).internode1(w(1)).sum_number=rootnode(j).internode1(w(1)).sum_number+1;
                 rootnode(j).internode1(w(1)).sum_rating(1)=rootnode(j).internode1(w(1)).sum_rating(1)+leaf.rating(1);
                 rootnode(j).internode1(w(1)).sum_rating(2)=rootnode(j).internode1(w(1)).sum_rating(2)+leaf.rating(2);  
                 rootnode(j).internode1(w(1)).sum_rating(3)=rootnode(j).internode1(w(1)).sum_rating(3)+leaf.rating(3);  
                 rootnode(j).internode1(w(1)).sum_rating(4)=rootnode(j).internode1(w(1)).sum_rating(4)+leaf.rating(4);  
                 rootnode(j).internode1(w(1)).sum_rating(5)=rootnode(j).internode1(w(1)).sum_rating(5)+leaf.rating(5);              
       end        
    else%% size(totalleafnode(j, rootnode(j).internode1(rootnode(j).n_count).internode(size(rootnode(j).internode1(rootnode(j).n_count).internode, 2)).leafnode).leaf,2)<n_maxcount
    [internode_1, internode_2, totalleafnode]=spiltleafnode(rootnode(j).internode1(w(1)).internode(w(2)), leaf, j, totalleafnode); 
                 var1=size(rootnode(j).internode1(w(1)).internode, 2);
                         if   var1+2<=n_maxcount1 %%���±�
                            rootnode(j).internode1(w(1)).internode(w(2)).timerange.timeend=internode_1.timerange.timebegin;                            
                            rootnode(j).internode1(w(1)).internode(var1+1)=internode_1;                           
                            rootnode(j).internode1(w(1)).internode(var1+2)=internode_2; 
                                  if   rootnode(j).internode1(w(1)).pricerange.min_price>internode_1.pricerange.min_price
                                      rootnode(j).internode1(w(1)).pricerange.min_price=internode_1.pricerange.min_price;
                                  end
                                  if   rootnode(j).internode1(w(1)).pricerange.max_price<internode_2.pricerange.max_price
                                      rootnode(j).internode1(w(1)).pricerange.max_price=internode_2.pricerange.max_price;
                                  end                                                  
                            rootnode(j).internode1(w(1)).sum_number=rootnode(j).internode1(w(1)).sum_number+1;
                            rootnode(j).internode1(w(1)).sum_rating(1)=rootnode(j).internode1(w(1)).sum_rating(1)+leaf.rating(1);
                            rootnode(j).internode1(w(1)).sum_rating(2)=rootnode(j).internode1(w(1)).sum_rating(2)+leaf.rating(2);  
                            rootnode(j).internode1(w(1)).sum_rating(3)=rootnode(j).internode1(w(1)).sum_rating(3)+leaf.rating(3);  
                            rootnode(j).internode1(w(1)).sum_rating(4)=rootnode(j).internode1(w(1)).sum_rating(4)+leaf.rating(4);  
                            rootnode(j).internode1(w(1)).sum_rating(5)=rootnode(j).internode1(w(1)).sum_rating(5)+leaf.rating(5);  
                         else  %%size(rootnode(j).internode1(rootnode(j).n_count).internode,2)+2<n_maxcount1                                   
                                      rootnode(j).internode1(w(1)).internode(w(2)).timerange.timeend=internode_1.timerange.timebegin;                                 
                                      spilttempnode(1)=internode_1;
                                      spilttempnode(2)=internode_2;
                                      [internode1_1, internode1_2]=spiltinternode(rootnode(j).internode1(w(1)).internode, spilttempnode);
                                  countstar=size(internode1_1, 2);
                           if  countstar>=ceil(n_maxcount1*5/6)%%%�����޸�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                              
                               [starinternode1, starinternode2]=spiltstarinternode(internode1_1, countstar);
                               if  size(rootnode(j).internode1,2)+2<=n_maxcount1
                                   var2=size(rootnode(j).internode1,2);
                                  rootnode(j).internode1(w(1)).sum_number=[];
                                  rootnode(j).internode1(w(1)).sum_rating=[];
                                  rootnode(j).internode1(w(1)).level=1;
                                  node1_num=size(internode1_2, 2);
                                  rootnode(j).internode1(w(1)).pricerange.min_price=internode1_2(1).pricerange.min_price; 
                                  rootnode(j).internode1(w(1)).pricerange.max_price=internode1_2(1).pricerange.max_price; 
                                  for o=1:1:node1_num %%
                                      if  rootnode(j).internode1(w(1)).pricerange.min_price>internode1_2(o).pricerange.min_price  
                                          rootnode(j).internode1(w(1)).pricerange.min_price=internode1_2(o).pricerange.min_price;
                                      elseif rootnode(j).internode1(w(1)).pricerange.max_price<internode1_2(o).pricerange.max_price 
                                          rootnode(j).internode1(w(1)).pricerange.max_price=internode1_2(o).pricerange.max_price;
                                      end
                                  end
                                  rootnode(j).internode1(w(1)).timerange.timebegin=rootnode(j).internode1(w(1)).timerange.timebegin;
                                  rootnode(j).internode1(w(1)).timerange.timeend=leaf.time;
                                  rootnode(j).internode1(w(1)).internode=internode1_2;
                                  rootnode(j).internode1(var2+1)=starinternode1;
                                  rootnode(j).internode1(var2+2)=starinternode2;  
                               else %%�ϲ���ѵ�����
                                   ptemp(1)=starinternode1;
                                   ptemp(2)=starinternode2;
                                   oldtemp=generateold(internode1_2, leaf, rootnode(j).internode1(w(1)).timerange.timebegin);
                                   rootnode(j).internode1(w(1))=oldtemp;
                                   [internode2_1, internode2_2]=spiltinternode1_1(rootnode(j).internode1, ptemp);
                                  rootnode(j).n_level=rootnode(j).n_level+1;
                                  rootnode(j).internode1=[];  
                                     countstar=size(internode2_2.internode1, 2);
                                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                                    %%%internode2_2�ֽ�star                                                   
                                 [starinternode1_1, starinternode2_1]=spiltstarinternode1(internode2_2);
                                                  rootnode(j).internode2(1)=internode2_1;  
                                                  rootnode(j).internode2(2)=starinternode1_1; 
                                                  rootnode(j).internode2(3)=starinternode2_1;
                                                else %countstar<ceil(n_maxcount1*5/6)
                                  rootnode(j).internode2(1)=internode2_1;
                                  rootnode(j).internode2(2)=internode2_2;                     
                                                end   
                               end
                           else%%countstar<ceil(n_maxcount1*5/6)
                               if  size(rootnode(j).internode1,2)+1<=n_maxcount1
                                  var2=size(rootnode(j).internode1,2);
                                  rootnode(j).internode1(w(1)).sum_number=[];
                                  rootnode(j).internode1(w(1)).sum_rating=[];
                                  rootnode(j).internode1(w(1)).level=1;
                                  node1_num=size(internode1_2, 2);
                                  rootnode(j).internode1(w(1)).pricerange.min_price=internode1_2(1).pricerange.min_price; 
                                  rootnode(j).internode1(w(1)).pricerange.max_price=internode1_2(1).pricerange.max_price; 
                                  for o=1:1:node1_num
                                      if  rootnode(j).internode1(w(1)).pricerange.min_price>internode1_2(o).pricerange.min_price  
                                          rootnode(j).internode1(w(1)).pricerange.min_price=internode1_2(o).pricerange.min_price;
                                      elseif rootnode(j).internode1(w(1)).pricerange.max_price<internode1_2(o).pricerange.max_price 
                                          rootnode(j).internode1(w(1)).pricerange.max_price=internode1_2(o).pricerange.max_price;
                                      end
                                  end
                                  rootnode(j).internode1(w(1)).timerange.timebegin=rootnode(j).internode1(w(1)).timerange.timebegin;
                                  rootnode(j).internode1(w(1)).timerange.timeend=leaf.time;
                                  rootnode(j).internode1(w(1)).internode=internode1_2;        
                                  rootnode(j).internode1(var2+1).sum_number=0;
                                  rootnode(j).internode1(var2+1).sum_rating=[0,0,0,0,0];
                                  rootnode(j).internode1(var2+1).level=1;
                                  rootnode(j).internode1(var2+1).pricerange.min_price=internode1_1(1).pricerange.min_price;
                                  rootnode(j).internode1(var2+1).pricerange.max_price=internode1_1(1).pricerange.max_price; 
                                  for o=1:1:countstar
                                      if  rootnode(j).internode1(var2+1).pricerange.min_price>internode1_1(o).pricerange.min_price  
                                          rootnode(j).internode1(var2+1).pricerange.min_price=internode1_1(o).pricerange.min_price;
                                      elseif rootnode(j).internode1(var2+1).pricerange.max_price<internode1_1(o).pricerange.max_price 
                                          rootnode(j).internode1(var2+1).pricerange.max_price=internode1_1(o).pricerange.max_price;
                                      end
                                       rootnode(j).internode1(var2+1).sum_number=rootnode(j).internode1(var2+1).sum_number+internode1_1(o).sum_number;
                                       rootnode(j).internode1(var2+1).sum_rating(1)=rootnode(j).internode1(var2+1).sum_rating(1)+internode1_1(o).sum_rating(1);
                                       rootnode(j).internode1(var2+1).sum_rating(2)=rootnode(j).internode1(var2+1).sum_rating(2)+internode1_1(o).sum_rating(2);
                                       rootnode(j).internode1(var2+1).sum_rating(3)=rootnode(j).internode1(var2+1).sum_rating(3)+internode1_1(o).sum_rating(3);
                                       rootnode(j).internode1(var2+1).sum_rating(4)=rootnode(j).internode1(var2+1).sum_rating(4)+internode1_1(o).sum_rating(4);
                                       rootnode(j).internode1(var2+1).sum_rating(5)=rootnode(j).internode1(var2+1).sum_rating(5)+internode1_1(o).sum_rating(5);    
                                  end
                                  rootnode(j).internode1(var2+1).timerange.timebegin=internode1_1(countstar).timerange.timebegin;
                                  rootnode(j).internode1(var2+1).timerange.timeend='*';
                                  rootnode(j).internode1(var2+1).internode=internode1_1;                                     
                               else %%�ϲ���ѵ�����
                                                ptemp=generate(internode1_1);  %%��������һ�����
                                                oldtemp=generateold(internode1_2, leaf, rootnode(j).internode1(w(1)).timerange.timebegin);
                                                rootnode(j).internode1(w(1))=oldtemp;
                                         [internode2_1, internode2_2]=spiltinternode1_1(rootnode(j).internode1, ptemp);
                                  rootnode(j).n_level=rootnode(j).n_level+1;
                                  rootnode(j).internode1=[];    
                                     countstar=size(internode2_2.internode1, 2);
                                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                                    %%%internode2_2�ֽ�star                                                   
                                 [starinternode1_1, starinternode2_1]=spiltstarinternode1(internode2_2);
                                                  rootnode(j).internode2(1)=internode2_1;  
                                                  rootnode(j).internode2(2)=starinternode1_1; 
                                                  rootnode(j).internode2(3)=starinternode2_1;
                                                else %countstar<ceil(n_maxcount1*5/6)
                                  rootnode(j).internode2(1)=internode2_1;
                                  rootnode(j).internode2(2)=internode2_2;                     
                                                end                   
                               end  
                           end 
                                                                           
                         end%size(rootnode(j).internode1(rootnode(j).n_count).internode,2)+2<n_maxcount1
                           
    end                
                elseif rootnode(j).n_level==3          
              v=0;
             for p=1:1:size(rootnode(j).internode2,2)
                  if strcmp(rootnode(j).internode2(p).timerange.timeend,'*')
                      for ppt=1:1:size(rootnode(j).internode2(p).internode1, 2)
                          if strcmp(rootnode(j).internode2(p).internode1(ppt).timerange.timeend,'*')
                          for pppt=1:1:size(rootnode(j).internode2(p).internode1(ppt).internode, 2)
                          if strcmp(rootnode(j).internode2(p).internode1(ppt).internode(pppt).timerange.timeend,'*')&& rootnode(j).internode2(p).internode1(ppt).internode(pppt).pricerange.min_price>v
                       w(1)=p; 
                       w(2)=ppt;
                       w(3)=pppt;
                       v=rootnode(j).internode2(p).internode1(ppt).internode(pppt).pricerange.min_price;                     
                          end
                          end
                          end
                      end
                  end
             end         
             var1=size(rootnode(j).internode2(w(1)).internode1(w(2)).internode, 2);  
               if   size(totalleafnode(j, rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).leafnode).leaf,2)<n_maxcount
               [totalleafnode, leafnode_num, temptime, mark, same, sum_number, sum_rating]=insertleafnode(rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)), leaf, j, totalleafnode);               
        if  same==0           
                        if mark==1 %%%˵��ʱ���в�ͬ
                              
                           if  var1<n_maxcount1
                                   %rootnode(j).n_count<n_maxcount1
                                   rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).timerange.timeend=temptime;  
                                      internode.sum_number=sum_number;
                                      internode.sum_rating(1)=sum_rating(1);
                                      internode.sum_rating(2)=sum_rating(2);
                                      internode.sum_rating(3)=sum_rating(3);
                                      internode.sum_rating(4)=sum_rating(4);
                                      internode.sum_rating(5)=sum_rating(5);
                                      internode.level=0;
                                      internode.pricerange.min_price=rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).pricerange.min_price;   %%internode�ڵ��key
                                      internode.pricerange.max_price=rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).pricerange.min_price;                                     
                                  if   rootnode(j).internode2(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode2(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode2(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode2(w(1)).pricerange.max_price=leaf.price;
                                  end                                      
                                  if   rootnode(j).internode2(w(1)).internode1(w(2)).pricerange.min_price>leaf.price
                                      rootnode(j).internode2(w(1)).internode1(w(2)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode2(w(1)).internode1(w(2)).pricerange.max_price<leaf.price
                                      rootnode(j).internode2(w(1)).internode1(w(2)).pricerange.max_price=leaf.price;
                                  end
                                      internode.timerange.timebegin=temptime;
                                      internode.timerange.timeend='*';
                                      internode.leafnode=leafnode_num;                                                                        
                                      rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)+1)=internode; 
                                      rootnode(j).internode2(w(1)).internode1(w(2)).sum_number=rootnode(j).internode2(w(1)).internode1(w(2)).sum_number+1;
                                      rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(1)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(1)+leaf.rating(1);
                                      rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(2)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(2)+leaf.rating(2);
                                      rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(3)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(3)+leaf.rating(3);
                                      rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(4)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(4)+leaf.rating(4);
                                      rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(5)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(5)+leaf.rating(5);
                                      rootnode(j).internode2(w(1)).sum_number=rootnode(j).internode2(w(1)).sum_number+1;
                                      rootnode(j).internode2(w(1)).sum_rating(1)=rootnode(j).internode2(w(1)).sum_rating(1)+leaf.rating(1);
                                      rootnode(j).internode2(w(1)).sum_rating(2)=rootnode(j).internode2(w(1)).sum_rating(2)+leaf.rating(2);
                                      rootnode(j).internode2(w(1)).sum_rating(3)=rootnode(j).internode2(w(1)).sum_rating(3)+leaf.rating(3);
                                      rootnode(j).internode2(w(1)).sum_rating(4)=rootnode(j).internode2(w(1)).sum_rating(4)+leaf.rating(4);
                                      rootnode(j).internode2(w(1)).sum_rating(5)=rootnode(j).internode2(w(1)).sum_rating(5)+leaf.rating(5);
                               else  %size(rootnode(j).internode2(w(1)).internode1(w(2)).internode,2)<n_maxcount1                                              
                                      rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).timerange.timeend=temptime;  
                                      internode.sum_number=sum_number;
                                      internode.sum_rating(1)=sum_rating(1);
                                      internode.sum_rating(2)=sum_rating(2);
                                      internode.sum_rating(3)=sum_rating(3);
                                      internode.sum_rating(4)=sum_rating(4);
                                      internode.sum_rating(5)=sum_rating(5);
                                      internode.level=0;
                                      internode.pricerange.min_price=rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).pricerange.min_price;   %%internode�ڵ��key
                                      internode.pricerange.max_price=rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).pricerange.max_price;
                                      internode.timerange.timebegin=temptime;
                                      internode.timerange.timeend='*';
                                      internode.leafnode=leafnode_num; 
                                      [internode1_1, internode1_2]=spiltinternode(rootnode(j).internode2(w(1)).internode1(w(2)).internode, internode);
                                      countstar=size(internode1_1, 2);
                                    if  countstar>=ceil(n_maxcount1*5/6)%%%�����޸�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
                                    [starinternode1, starinternode2]=spiltstarinternode(internode1_1, countstar);
                                    if  size(rootnode(j).internode2(w(1)).internode1,2)+2<=n_maxcount1
                                        var2=size(rootnode(j).internode2(w(1)).internode1,2);
                                        oldtemp=generateold(internode1_2, leaf, rootnode(j).internode2(w(1)).internode1(w(2)).timerange.timebegin); 
                                       rootnode(j).internode2(w(1)).internode1(w(2))=oldtemp;
                                       rootnode(j).internode2(w(1)).internode1(var2+1)=starinternode1;
                                       rootnode(j).internode2(w(1)).internode1(var2+2)=starinternode2;  
                                    rootnode(j).internode2(w(1)).sum_number=rootnode(j).internode2(w(1)).sum_number+1;
                                    rootnode(j).internode2(w(1)).sum_rating=rootnode(j).internode2(w(1)).sum_rating+leaf.rating;
                                  if   rootnode(j).internode2(w(1)).pricerange.min_price>internode_1.pricerange.min_price
                                      rootnode(j).internode2(w(1)).pricerange.min_price=internode_1.pricerange.min_price;
                                  end
                                  if   rootnode(j).internode2(w(1)).pricerange.max_price<internode_2.pricerange.max_price
                                      rootnode(j).internode2(w(1)).pricerange.max_price=internode_2.pricerange.max_price;
                                  end         
                                    else %% internode2(w(1))
                                                  var3=size(rootnode(j).internode2,2);
                                                  ptemp(1)=starinternode1;
                                                  ptemp(2)=starinternode2;
                                                 oldtemp=generateold(internode1_2, leaf, rootnode(j).internode2(w(1)).internode1(w(2)).timerange.timebegin);
                                                 rootnode(j).internode2(w(1)).internode1(w(2))=oldtemp;
                                                 [internode2_1, internode2_2]=spiltinternode1(rootnode(j).internode2(w(1)).internode1, ptemp, rootnode(j).internode2(w(1)).timerange.timebegin); %%%����Ҫ�ж�countstar;
                                                 countstar=size(internode2_2.internode1, 2);
                                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                                    %%%internode2_2�ֽ�star   
                                                 [starinternode1_1, starinternode2_1]=spiltstarinternode1(internode2_2);
                                                 if size(rootnode(j).internode2,2)+2<=n_maxcount1
                                                     var3=size(rootnode(j).internode2,2);
                                                  rootnode(j).internode2(w(1))=internode2_1;  
                                                  rootnode(j).internode2(var3+1)=starinternode1_1; 
                                                  rootnode(j).internode2(var3+2)=starinternode2_1;        
                                                 else %%����һ�� 
                                                  ptemp1(1)=starinternode1_1; 
                                                  ptemp1(2)=starinternode2_1; 
                                                  rootnode(j).internode2(w(1))=internode2_1;
                                                  [internode3_1, internode3_2]=spiltinternode2_1(rootnode(j).internode2, ptemp1);  
                                                rootnode(j).n_level=rootnode(j).n_level+1;
                                                rootnode(j).internode2=[]; 
                                               countstar=size(internode3_2.internode2, 2);
                                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                                    %%%internode2_2�ֽ�star                                                   
                                                [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                                                  rootnode(j).internode3(1)=internode3_1;  
                                                  rootnode(j).internode3(2)=starinternode1_2; 
                                                  rootnode(j).internode3(3)=starinternode2_2;
                                                else %countstar<ceil(n_maxcount1*5/6)
                                                   rootnode(j).internode3(1)=internode3_1;
                                                   rootnode(j).internode3(2)=internode3_2;                     
                                                end                                                    
                                                 end 
                                                else %countstar<ceil(n_maxcount1*5/6)
                                                 if size(rootnode(j).internode2,2)+1<=n_maxcount1
                                                     var3=size(rootnode(j).internode2,2);
                                                  rootnode(j).internode2(w(1))=internode2_1;  
                                                  rootnode(j).internode2(var3+1)=internode2_2;              
                                                 else %%����һ��
                                                  ptemp1=internode2_2;                                                 
                                                  rootnode(j).internode2(w(1))=internode2_1;
                                                  [internode3_1, internode3_2]=spiltinternode2_1(rootnode(j).internode2, ptemp1);
                                                rootnode(j).n_level=rootnode(j).n_level+1;
                                                rootnode(j).internode2=[]; 
                                               countstar=size(internode3_2.internode2, 2);
                                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                                    %%%internode2_2�ֽ�star                                                   
                                                [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                                                  rootnode(j).internode3(1)=internode3_1;  
                                                  rootnode(j).internode3(2)=starinternode1_2; 
                                                  rootnode(j).internode3(3)=starinternode2_2;
                                                else %countstar<ceil(n_maxcount1*5/6)
                                                   rootnode(j).internode3(1)=internode3_1;
                                                   rootnode(j).internode3(2)=internode3_2;                     
                                                end      
                                                 end                                                     
                                                end                                    
                                    end
                else %%countstar
                                           if  size(rootnode(j).internode2(w(1)).internode1,2)+1<=n_maxcount1
                                               var2=size(rootnode(j).internode2(w(1)).internode1,2);
                                                ptemp=generate(internode1_1);  %%��������һ�����
                                                oldtemp=generateold(internode1_2, leaf, rootnode(j).internode2(w(1)).internode1(w(2)).timerange.timebegin);            
                                                rootnode(j).internode2(w(1)).internode1(w(2))=oldtemp;
                                                rootnode(j).internode2(w(1)).internode1(var2+1)=ptemp;
                                        rootnode(j).internode2(w(1)).sum_number=rootnode(j).internode2(w(1)).sum_number+1;
                                        rootnode(j).internode2(w(1)).sum_rating=rootnode(j).internode2(w(1)).sum_rating+leaf.rating;
                                     if   rootnode(j).internode2(w(1)).pricerange.min_price>internode_1.pricerange.min_price
                                      rootnode(j).internode2(w(1)).pricerange.min_price=internode_1.pricerange.min_price;
                                     end
                                     if   rootnode(j).internode2(w(1)).pricerange.max_price<internode_2.pricerange.max_price
                                      rootnode(j).internode2(w(1)).pricerange.max_price=internode_2.pricerange.max_price;
                                     end                                              
                                           else
                                                var3=size(rootnode(j).internode2,2);
                                                ptemp=generate(internode1_1);  %%��������һ�����
                                                oldtemp=generateold(internode1_2, leaf, rootnode(j).internode2(w(1)).internode1(w(2)).timerange.timebegin);
                                                rootnode(j).internode2(w(1)).internode1(w(2))=oldtemp;
                                                [internode2_1, internode2_2]=spiltinternode1(rootnode(j).internode2(w(1)).internode1, ptemp, rootnode(j).internode2(w(1)).timerange.timebegin);
                                                 countstar=size(internode2_2.internode1, 2);
                                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                                    %%%internode2_2�ֽ�star   
                                                [starinternode1_1, starinternode2_1]=spiltstarinternode1(internode2_2);
                                                 if size(rootnode(j).internode2,2)+2<=n_maxcount1
                                                     var3=size(rootnode(j).internode2,2);
                                                  rootnode(j).internode2(w(1))=internode2_1;  
                                                  rootnode(j).internode2(var3+1)=starinternode1_1; 
                                                  rootnode(j).internode2(var3+2)=starinternode2_1;         
                                                 else %%����һ�� 
                                                  ptemp1(1)=starinternode1_1; 
                                                  ptemp1(2)=starinternode2_1; 
                                                  rootnode(j).internode2(w(1))=internode2_1;
                                                  [internode3_1, internode3_2]=spiltinternode2_1(rootnode(j).internode2, ptemp1);
                                                rootnode(j).n_level=rootnode(j).n_level+1;
                                                rootnode(j).internode2=[]; 
                                               countstar=size(internode3_2.internode2, 2);
                                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                                    %%%internode2_2�ֽ�star                                                   
                                                [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                                                  rootnode(j).internode3(1)=internode3_1;  
                                                  rootnode(j).internode3(2)=starinternode1_2; 
                                                  rootnode(j).internode3(3)=starinternode2_2;
                                                else %countstar<ceil(n_maxcount1*5/6)
                                                   rootnode(j).internode3(1)=internode3_1;
                                                   rootnode(j).internode3(2)=internode3_2;                     
                                                end     
                                                 end 
                                                else %countstar<ceil(n_maxcount1*5/6)
                                                 if size(rootnode(j).internode2,2)+1<=n_maxcount1
                                                     var3=size(rootnode(j).internode2,2);
                                                  rootnode(j).internode2(w(1))=internode2_1;  
                                                  rootnode(j).internode2(var3+1)=internode2_2;              
                                                 else %%����һ��
                                                  ptemp1=internode2_2;                                                 
                                                  rootnode(j).internode2(w(1))=internode2_1;
                                                  [internode3_1, internode3_2]=spiltinternode2_1(rootnode(j).internode2, ptemp1); 
                                                rootnode(j).n_level=rootnode(j).n_level+1;
                                                rootnode(j).internode2=[]; 
                                               countstar=size(internode3_2.internode2, 2);
                                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                                    %%%internode2_2�ֽ�star                                                   
                                                [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                                                  rootnode(j).internode3(1)=internode3_1;  
                                                  rootnode(j).internode3(2)=starinternode1_2; 
                                                  rootnode(j).internode3(3)=starinternode2_2;
                                                else %countstar<ceil(n_maxcount1*5/6)
                                                   rootnode(j).internode3(1)=internode3_1;
                                                   rootnode(j).internode3(2)=internode3_2;                     
                                                end        
                                                 end                                                     
                                                end    
                                           end

                                    end                                   
                                                  
                           end %%size(rootnode(j).internode2(w(1)).internode1,2)<n_maxcount1
                              
        elseif  mark==0          
                 rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).sum_number=sum_number;
                 rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).sum_rating(1)=sum_rating(1);
                 rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).sum_rating(2)=sum_rating(2);
                 rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).sum_rating(3)=sum_rating(3);
                 rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).sum_rating(4)=sum_rating(4);
                 rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).sum_rating(5)=sum_rating(5);
                 rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).leafnode=leafnode_num; 
                 rootnode(j).internode2(w(1)).internode1(w(2)).sum_number=rootnode(j).internode2(w(1)).internode1(w(2)).sum_number+1;
                 rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(1)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(1)+leaf.rating(1); 
                 rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(2)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(2)+leaf.rating(2);
                 rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(3)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(3)+leaf.rating(3);
                 rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(4)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(4)+leaf.rating(4);
                 rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(5)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(5)+leaf.rating(5);
                 rootnode(j).internode2(w(1)).sum_number=rootnode(j).internode2(w(1)).sum_number+1;
                 rootnode(j).internode2(w(1)).sum_rating(1)=rootnode(j).internode2(w(1)).sum_rating(1)+leaf.rating(1); 
                 rootnode(j).internode2(w(1)).sum_rating(2)=rootnode(j).internode2(w(1)).sum_rating(2)+leaf.rating(2); 
                 rootnode(j).internode2(w(1)).sum_rating(3)=rootnode(j).internode2(w(1)).sum_rating(3)+leaf.rating(3); 
                 rootnode(j).internode2(w(1)).sum_rating(4)=rootnode(j).internode2(w(1)).sum_rating(4)+leaf.rating(4); 
                 rootnode(j).internode2(w(1)).sum_rating(5)=rootnode(j).internode2(w(1)).sum_rating(5)+leaf.rating(5);                              
                        end            
        elseif same==1
                 rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).sum_number=sum_number;
                 rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).sum_rating(1)=sum_rating(1);
                 rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).sum_rating(2)=sum_rating(2);
                 rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).sum_rating(3)=sum_rating(3);
                 rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).sum_rating(4)=sum_rating(4);
                 rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).sum_rating(5)=sum_rating(5);
                 rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).leafnode=leafnode_num; 
                 rootnode(j).internode2(w(1)).internode1(w(2)).sum_number=rootnode(j).internode2(w(1)).internode1(w(2)).sum_number+1;
                 rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(1)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(1)+leaf.rating(1); 
                 rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(2)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(2)+leaf.rating(2);
                 rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(3)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(3)+leaf.rating(3);
                 rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(4)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(4)+leaf.rating(4);
                 rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(5)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(5)+leaf.rating(5);
                 rootnode(j).internode2(w(1)).sum_number=rootnode(j).internode2(w(1)).sum_number+1;
                 rootnode(j).internode2(w(1)).sum_rating(1)=rootnode(j).internode2(w(1)).sum_rating(1)+leaf.rating(1); 
                 rootnode(j).internode2(w(1)).sum_rating(2)=rootnode(j).internode2(w(1)).sum_rating(2)+leaf.rating(2); 
                 rootnode(j).internode2(w(1)).sum_rating(3)=rootnode(j).internode2(w(1)).sum_rating(3)+leaf.rating(3); 
                 rootnode(j).internode2(w(1)).sum_rating(4)=rootnode(j).internode2(w(1)).sum_rating(4)+leaf.rating(4); 
                 rootnode(j).internode2(w(1)).sum_rating(5)=rootnode(j).internode2(w(1)).sum_rating(5)+leaf.rating(5);             
        end                             
              else%% size(totalleafnode(j, rootnode(j).internode1(rootnode(j).n_count).internode(size(rootnode(j).internode1(rootnode(j).n_count).internode, 2)).leafnode).leaf,2)<n_maxcount
    [internode_1, internode_2, totalleafnode]=spiltleafnode(rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)), leaf, j, totalleafnode); 
                         var1=size(rootnode(j).internode2(w(1)).internode1(w(2)).internode, 2);    
                         if   var1+2<=n_maxcount1 %%���±�
                            rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).timerange.timeend=internode_1.timerange.timebegin;
                            rootnode(j).internode2(w(1)).internode1(w(2)).internode(var1+1)=internode_1;                           
                            rootnode(j).internode2(w(1)).internode1(w(2)).internode(var1+2)=internode_2; 
                            rootnode(j).internode2(w(1)).internode1(w(2)).sum_number=rootnode(j).internode2(w(1)).internode1(w(2)).sum_number+1;
                            rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(1)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(1)+leaf.rating(1);
                            rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(2)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(2)+leaf.rating(2); 
                            rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(3)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(3)+leaf.rating(3); 
                            rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(4)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(4)+leaf.rating(4); 
                            rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(5)=rootnode(j).internode2(w(1)).internode1(w(2)).sum_rating(5)+leaf.rating(5); 
                            rootnode(j).internode2(w(1)).sum_number=rootnode(j).internode2(w(1)).sum_number+1;
                            rootnode(j).internode2(w(1)).sum_rating(1)=rootnode(j).internode2(w(1)).sum_rating(1)+leaf.rating(1);
                            rootnode(j).internode2(w(1)).sum_rating(2)=rootnode(j).internode2(w(1)).sum_rating(2)+leaf.rating(2);
                            rootnode(j).internode2(w(1)).sum_rating(3)=rootnode(j).internode2(w(1)).sum_rating(3)+leaf.rating(3);
                            rootnode(j).internode2(w(1)).sum_rating(4)=rootnode(j).internode2(w(1)).sum_rating(4)+leaf.rating(4);
                            rootnode(j).internode2(w(1)).sum_rating(5)=rootnode(j).internode2(w(1)).sum_rating(5)+leaf.rating(5);
                                  if  rootnode(j).internode2(w(1)).internode1(w(2)).pricerange.min_price>internode_1.pricerange.min_price
                                      rootnode(j).internode2(w(1)).internode1(w(2)).pricerange.min_price=internode_1.pricerange.min_price;
                                  end
                                  if   rootnode(j).internode2(w(1)).internode1(w(2)).pricerange.max_price<internode_2.pricerange.max_price
                                      rootnode(j).internode2(w(1)).internode1(w(2)).pricerange.max_price=internode_2.pricerange.max_price;
                                  end
                            
                                  if   rootnode(j).internode2(w(1)).pricerange.min_price>internode_1.pricerange.min_price
                                      rootnode(j).internode2(w(1)).pricerange.min_price=internode_1.pricerange.min_price;
                                  end
                                  if   rootnode(j).internode2(w(1)).pricerange.max_price<internode_2.pricerange.max_price
                                      rootnode(j).internode2(w(1)).pricerange.max_price=internode_2.pricerange.max_price;
                                  end
                         else  %% size(rootnode(j).internode2(w(1)).internode1(w(2)).internode,2)+2<n_maxcount1 %%���±�
                            rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).timerange.timeend=internode_1.timerange.timebegin;                                    
                                      spilttempnode(1)=internode_1;
                                      spilttempnode(2)=internode_2;
                                      [internode1_1, internode1_2]=spiltinternode(rootnode(j).internode2(w(1)).internode1(w(2)).internode, spilttempnode);
                                      countstar=size(internode1_1, 2);
                                    if  countstar>=ceil(n_maxcount1*5/6)%%%�����޸�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
                                    [starinternode1, starinternode2]=spiltstarinternode(internode1_1, countstar);
                                    if  size(rootnode(j).internode2(w(1)).internode1,2)+2<=n_maxcount1
                                        var2=size(rootnode(j).internode2(w(1)).internode1,2);
                                        oldtemp=generateold(internode1_2, leaf, rootnode(j).internode2(w(1)).internode1(w(2)).timerange.timebegin); 
                                       rootnode(j).internode2(w(1)).internode1(w(2))=oldtemp;
                                       rootnode(j).internode2(w(1)).internode1(var2+1)=starinternode1;
                                       rootnode(j).internode2(w(1)).internode1(var2+2)=starinternode2;  
                                    rootnode(j).internode2(w(1)).sum_number=rootnode(j).internode2(w(1)).sum_number+1;
                                    rootnode(j).internode2(w(1)).sum_rating=rootnode(j).internode2(w(1)).sum_rating+leaf.rating;
                                  if   rootnode(j).internode2(w(1)).pricerange.min_price>internode_1.pricerange.min_price
                                      rootnode(j).internode2(w(1)).pricerange.min_price=internode_1.pricerange.min_price;
                                  end
                                  if   rootnode(j).internode2(w(1)).pricerange.max_price<internode_2.pricerange.max_price
                                      rootnode(j).internode2(w(1)).pricerange.max_price=internode_2.pricerange.max_price;
                                  end         
                                    else %% internode2(w(1))
                                                  var3=size(rootnode(j).internode2,2);
                                                  ptemp(1)=starinternode1;
                                                  ptemp(2)=starinternode2;
                                                 oldtemp=generateold(internode1_2, leaf, rootnode(j).internode2(w(1)).internode1(w(2)).timerange.timebegin);
                                                 rootnode(j).internode2(w(1)).internode1(w(2))=oldtemp;
                                                 [internode2_1, internode2_2]=spiltinternode1(rootnode(j).internode2(w(1)).internode1, ptemp, rootnode(j).internode2(w(1)).timerange.timebegin); %%%����Ҫ�ж�countstar;
                                                 countstar=size(internode2_2.internode1, 2);
                                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                                    %%%internode2_2�ֽ�star   
                                                 [starinternode1_1, starinternode2_1]=spiltstarinternode1(internode2_2);
                                                 if size(rootnode(j).internode2,2)+2<=n_maxcount1
                                                     var3=size(rootnode(j).internode2,2);
                                                  rootnode(j).internode2(w(1))=internode2_1;  
                                                  rootnode(j).internode2(var3+1)=starinternode1_1; 
                                                  rootnode(j).internode2(var3+2)=starinternode2_1;        
                                                 else %%����һ�� 
                                                  ptemp1(1)=starinternode1_1; 
                                                  ptemp1(2)=starinternode2_1; 
                                                  rootnode(j).internode2(w(1))=internode2_1;
                                                  [internode3_1, internode3_2]=spiltinternode2_1(rootnode(j).internode2, ptemp1);  
                                                rootnode(j).n_level=rootnode(j).n_level+1;
                                                rootnode(j).internode2=[]; 
                                               countstar=size(internode3_2.internode2, 2);
                                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                                    %%%internode2_2�ֽ�star                                                   
                                                [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                                                  rootnode(j).internode3(1)=internode3_1;  
                                                  rootnode(j).internode3(2)=starinternode1_2; 
                                                  rootnode(j).internode3(3)=starinternode2_2;
                                                else %countstar<ceil(n_maxcount1*5/6)
                                                   rootnode(j).internode3(1)=internode3_1;
                                                   rootnode(j).internode3(2)=internode3_2;                     
                                                end                                                    
                                                 end 
                                                else %countstar<ceil(n_maxcount1*5/6)
                                                 if size(rootnode(j).internode2,2)+1<=n_maxcount1
                                                     var3=size(rootnode(j).internode2,2);
                                                  rootnode(j).internode2(w(1))=internode2_1;  
                                                  rootnode(j).internode2(var3+1)=internode2_2;              
                                                 else %%����һ��
                                                  ptemp1=internode2_2;                                                 
                                                  rootnode(j).internode2(w(1))=internode2_1;
                                                  [internode3_1, internode3_2]=spiltinternode2_1(rootnode(j).internode2, ptemp1);
                                                rootnode(j).n_level=rootnode(j).n_level+1;
                                                rootnode(j).internode2=[]; 
                                               countstar=size(internode3_2.internode2, 2);
                                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                                    %%%internode2_2�ֽ�star                                                   
                                                [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                                                  rootnode(j).internode3(1)=internode3_1;  
                                                  rootnode(j).internode3(2)=starinternode1_2; 
                                                  rootnode(j).internode3(3)=starinternode2_2;
                                                else %countstar<ceil(n_maxcount1*5/6)
                                                   rootnode(j).internode3(1)=internode3_1;
                                                   rootnode(j).internode3(2)=internode3_2;                     
                                                end      
                                                 end                                                     
                                                end                                    
                                    end
                else %%countstar
                                           if  size(rootnode(j).internode2(w(1)).internode1,2)+1<=n_maxcount1
                                               var2=size(rootnode(j).internode2(w(1)).internode1,2);
                                                ptemp=generate(internode1_1);  %%��������һ�����
                                                oldtemp=generateold(internode1_2, leaf, rootnode(j).internode2(w(1)).internode1(w(2)).timerange.timebegin);            
                                                rootnode(j).internode2(w(1)).internode1(w(2))=oldtemp;
                                                rootnode(j).internode2(w(1)).internode1(var2+1)=ptemp;
                                        rootnode(j).internode2(w(1)).sum_number=rootnode(j).internode2(w(1)).sum_number+1;
                                        rootnode(j).internode2(w(1)).sum_rating=rootnode(j).internode2(w(1)).sum_rating+leaf.rating;
                                     if   rootnode(j).internode2(w(1)).pricerange.min_price>internode_1.pricerange.min_price
                                      rootnode(j).internode2(w(1)).pricerange.min_price=internode_1.pricerange.min_price;
                                     end
                                     if   rootnode(j).internode2(w(1)).pricerange.max_price<internode_2.pricerange.max_price
                                      rootnode(j).internode2(w(1)).pricerange.max_price=internode_2.pricerange.max_price;
                                     end                                              
                                           else
                                                var3=size(rootnode(j).internode2,2);
                                                ptemp=generate(internode1_1);  %%��������һ�����
                                                oldtemp=generateold(internode1_2, leaf, rootnode(j).internode2(w(1)).internode1(w(2)).timerange.timebegin);
                                                rootnode(j).internode2(w(1)).internode1(w(2))=oldtemp;
                                                [internode2_1, internode2_2]=spiltinternode1(rootnode(j).internode2(w(1)).internode1, ptemp, rootnode(j).internode2(w(1)).timerange.timebegin);
                                                 countstar=size(internode2_2.internode1, 2);
                                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                                    %%%internode2_2�ֽ�star   
                                                [starinternode1_1, starinternode2_1]=spiltstarinternode1(internode2_2);
                                                 if size(rootnode(j).internode2,2)+2<=n_maxcount1
                                                     var3=size(rootnode(j).internode2,2);
                                                  rootnode(j).internode2(w(1))=internode2_1;  
                                                  rootnode(j).internode2(var3+1)=starinternode1_1; 
                                                  rootnode(j).internode2(var3+2)=starinternode2_1;         
                                                 else %%����һ�� 
                                                  ptemp1(1)=starinternode1_1; 
                                                  ptemp1(2)=starinternode2_1; 
                                                  rootnode(j).internode2(w(1))=internode2_1;
                                                  [internode3_1, internode3_2]=spiltinternode2_1(rootnode(j).internode2, ptemp1);
                                                rootnode(j).n_level=rootnode(j).n_level+1;
                                                rootnode(j).internode2=[]; 
                                               countstar=size(internode3_2.internode2, 2);
                                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                                    %%%internode2_2�ֽ�star                                                   
                                                [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                                                  rootnode(j).internode3(1)=internode3_1;  
                                                  rootnode(j).internode3(2)=starinternode1_2; 
                                                  rootnode(j).internode3(3)=starinternode2_2;
                                                else %countstar<ceil(n_maxcount1*5/6)
                                                   rootnode(j).internode3(1)=internode3_1;
                                                   rootnode(j).internode3(2)=internode3_2;                     
                                                end     
                                                 end 
                                                else %countstar<ceil(n_maxcount1*5/6)
                                                 if size(rootnode(j).internode2,2)+1<=n_maxcount1
                                                     var3=size(rootnode(j).internode2,2);
                                                  rootnode(j).internode2(w(1))=internode2_1;  
                                                  rootnode(j).internode2(var3+1)=internode2_2;              
                                                 else %%����һ��
                                                  ptemp1=internode2_2;                                                 
                                                  rootnode(j).internode2(w(1))=internode2_1;
                                                  [internode3_1, internode3_2]=spiltinternode2_1(rootnode(j).internode2, ptemp1); 
                                                rootnode(j).n_level=rootnode(j).n_level+1;
                                                rootnode(j).internode2=[]; 
                                               countstar=size(internode3_2.internode2, 2);
                                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                                    %%%internode2_2�ֽ�star                                                   
                                                [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                                                  rootnode(j).internode3(1)=internode3_1;  
                                                  rootnode(j).internode3(2)=starinternode1_2; 
                                                  rootnode(j).internode3(3)=starinternode2_2;
                                                else %countstar<ceil(n_maxcount1*5/6)
                                                   rootnode(j).internode3(1)=internode3_1;
                                                   rootnode(j).internode3(2)=internode3_2;                     
                                                end        
                                                 end                                                     
                                                end    
                                           end

                                    end
                         end%size(rootnode(j).internode2(w(1)).internode1(w(2)).internode,2)+2<n_maxcount1
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5                 
              end %%size(totalleafnode(j, rootnode(j).internode2(w(1)).internode1(w(2)).internode(w(3)).leafnode).leaf,2)<n_maxcount
                elseif rootnode(j).n_level==4
              v=0;
             for p=1:1:size(rootnode(j).internode3,2)
                  if strcmp(rootnode(j).internode3(p).timerange.timeend,'*')
                      for ppt=1:1:size(rootnode(j).internode3(p).internode2, 2)
                          if strcmp(rootnode(j).internode3(p).internode2(ppt).timerange.timeend,'*')
                          for pppt=1:1:size(rootnode(j).internode3(p).internode2(ppt).internode1, 2)
                              if strcmp(rootnode(j).internode3(p).internode2(ppt).internode1(pppt).timerange.timeend,'*')
                                  for ppppt=1:1:size(rootnode(j).internode3(p).internode2(ppt).internode1(pppt).internode, 2)
                       if strcmp(rootnode(j).internode3(p).internode2(ppt).internode1(pppt).internode(ppppt).timerange.timeend,'*')&& rootnode(j).internode3(p).internode2(ppt).internode1(pppt).internode(ppppt).pricerange.min_price>v
                       w(1)=p; 
                       w(2)=ppt;
                       w(3)=pppt;
                       w(4)=ppppt;
                       v=rootnode(j).internode3(p).internode2(ppt).internode1(pppt).internode(ppppt).pricerange.min_price;                     
                       end
                                      
                                  end
                              end
                          end
                          end
                      end
                  end
             end 
         var1=size(rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode, 2);      
             if   size(totalleafnode(j, rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).leafnode).leaf,2)<n_maxcount
        [totalleafnode, leafnode_num, temptime, mark, same, sum_number, sum_rating]=insertleafnode(rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)), leaf, j, totalleafnode);               
         if  same==0           
                        if mark==1 %%%˵��ʱ���в�ͬ    
                           if  var1<n_maxcount1
                                   %rootnode(j).n_count<n_maxcount1
                                   rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).timerange.timeend=temptime;  
                                      internode.sum_number=sum_number;
                                      internode.sum_rating(1)=sum_rating(1);
                                      internode.sum_rating(2)=sum_rating(2);
                                      internode.sum_rating(3)=sum_rating(3);
                                      internode.sum_rating(4)=sum_rating(4);
                                      internode.sum_rating(5)=sum_rating(5);
                                      internode.level=0;
                                      internode.pricerange.min_price=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).pricerange.min_price;   %%internode�ڵ��key
                                      internode.pricerange.max_price=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).pricerange.min_price;                                     
                                  if   rootnode(j).internode3(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode3(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode3(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode3(w(1)).pricerange.max_price=leaf.price;
                                  end                                      
                                  if   rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.min_price>leaf.price
                                      rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.max_price<leaf.price
                                      rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.max_price=leaf.price;
                                  end
                                  if   rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).pricerange.min_price>leaf.price
                                      rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).pricerange.max_price<leaf.price
                                      rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).pricerange.max_price=leaf.price;
                                  end
                                      internode.timerange.timebegin=temptime;
                                      internode.timerange.timeend='*';
                                      internode.leafnode=leafnode_num;                                                                        
                                      rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)+1)=internode; 
                                      rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_number=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_number+1;
                                      rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(1)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(1)+leaf.rating(1);
                                      rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(2)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(2)+leaf.rating(2);
                                      rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(3)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(3)+leaf.rating(3);
                                      rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(4)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(4)+leaf.rating(4);
                                      rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(5)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(5)+leaf.rating(5);
                                      rootnode(j).internode3(w(1)).internode2(w(2)).sum_number=rootnode(j).internode3(w(1)).internode2(w(2)).sum_number+1;
                                      rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(1)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(1)+leaf.rating(1);
                                      rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(2)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(2)+leaf.rating(2);
                                      rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(3)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(3)+leaf.rating(3);
                                      rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(4)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(4)+leaf.rating(4);
                                      rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(5)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(5)+leaf.rating(5);
                                      rootnode(j).internode3(w(1)).sum_number=rootnode(j).internode3(w(1)).sum_number+1;
                                      rootnode(j).internode3(w(1)).sum_rating(1)=rootnode(j).internode3(w(1)).sum_rating(1)+leaf.rating(1);
                                      rootnode(j).internode3(w(1)).sum_rating(2)=rootnode(j).internode3(w(1)).sum_rating(2)+leaf.rating(2);
                                      rootnode(j).internode3(w(1)).sum_rating(3)=rootnode(j).internode3(w(1)).sum_rating(3)+leaf.rating(3);
                                      rootnode(j).internode3(w(1)).sum_rating(4)=rootnode(j).internode3(w(1)).sum_rating(4)+leaf.rating(4);
                                      rootnode(j).internode3(w(1)).sum_rating(5)=rootnode(j).internode3(w(1)).sum_rating(5)+leaf.rating(5);
                               else  %size(rootnode(j).internode2(w(1)).internode1(w(2)).internode,2)<n_maxcount1                                              
%                                         test=1;
                                      rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).timerange.timeend=temptime;  
                                      internode.sum_number=sum_number;
                                      internode.sum_rating(1)=sum_rating(1);
                                      internode.sum_rating(2)=sum_rating(2);
                                      internode.sum_rating(3)=sum_rating(3);
                                      internode.sum_rating(4)=sum_rating(4);
                                      internode.sum_rating(5)=sum_rating(5);
                                      internode.level=0;
                                      internode.pricerange.min_price=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).pricerange.min_price;   %%internode�ڵ��key
                                      internode.pricerange.max_price=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).pricerange.max_price;
                                      internode.timerange.timebegin=temptime;
                                      internode.timerange.timeend='*';
                                      internode.leafnode=leafnode_num; 
                                      var2=size(rootnode(j).internode3(w(1)).internode2(w(2)).internode1, 2);
                                      [internode1_1, internode1_2]=spiltinternode(rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode, internode);
                                       countstar=size(internode1_1, 2);
           if countstar<ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                            if  var2<n_maxcount1  %%ֱ�ӷ��Ѳ���
                                                ptemp=generate(internode1_1);  %%��������һ�����
                                                oldtemp=generateold(internode1_2, leaf, rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).timerange.timebegin);            
                                                rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3))=ptemp;
                                                rootnode(j).internode3(w(1)).internode2(w(2)).internode1(var2+1)=oldtemp;
                                      rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_number=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_number+1;
                                  if   rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).pricerange.min_price>leaf.price
                                      rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).pricerange.max_price<leaf.price
                                      rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).pricerange.max_price=leaf.price;
                                  end
                                      rootnode(j).internode3(w(1)).internode2(w(2)).sum_number=rootnode(j).internode3(w(1)).internode2(w(2)).sum_number+1;
                                  if   rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.min_price>leaf.price
                                      rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.max_price<leaf.price
                                      rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.max_price=leaf.price;
                                  end
                                      rootnode(j).internode3(w(1)).sum_number=rootnode(j).internode3(w(1)).sum_number+1;

                                  if   rootnode(j).internode3(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode3(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode3(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode3(w(1)).pricerange.max_price=leaf.price;
                                  end
                                          
                            else %% %%���Ϸ���
                  var3=size(rootnode(j).internode3(w(1)).internode2, 2);
                  ptemp=generate(internode1_1);  %%��������һ�����
                  oldtemp=generateold(internode1_2, leaf, rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).timerange.timebegin);
                  rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3))=oldtemp;
                  [internode2_1, internode2_2]=spiltinternode1(rootnode(j).internode3(w(1)).internode2(w(2)).internode1, ptemp, rootnode(j).internode3(w(1)).internode2(w(2)).timerange.timebegin);
                  countstar=size(internode2_2.internode1, 2);
          if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
             [starinternode1_1, starinternode2_1]=spiltstarinternode1(internode2_2);
                     if size(rootnode(j).internode3(w(1)).internode2,2)+2<=n_maxcount1
                         var3=size(rootnode(j).internode3(w(1)).internode2,2);
                          rootnode(j).internode3(w(1)).internode2(w(2))=internode2_1;  
                          rootnode(j).internode3(w(1)).internode2(var3+1)=starinternode1_1; 
                          rootnode(j).internode3(w(1)).internode2(var3+2)=starinternode2_1; 
               rootnode(j).internode3(w(1)).sum_number=rootnode(j).internode3(w(1)).sum_number+1;
               rootnode(j).internode3(w(1)).sum_rating(1)=rootnode(j).internode3(w(1)).sum_rating(1)+leaf.rating(1);
               rootnode(j).internode3(w(1)).sum_rating(2)=rootnode(j).internode3(w(1)).sum_rating(2)+leaf.rating(2);
               rootnode(j).internode3(w(1)).sum_rating(3)=rootnode(j).internode3(w(1)).sum_rating(3)+leaf.rating(3);
               rootnode(j).internode3(w(1)).sum_rating(4)=rootnode(j).internode3(w(1)).sum_rating(4)+leaf.rating(4);
               rootnode(j).internode3(w(1)).sum_rating(5)=rootnode(j).internode3(w(1)).sum_rating(5)+leaf.rating(5);
             if   rootnode(j).internode3(w(1)).pricerange.min_price>internode_1.pricerange.min_price
                 rootnode(j).internode3(w(1)).pricerange.min_price=internode_1.pricerange.min_price;
             end
             if   rootnode(j).internode3(w(1)).pricerange.max_price<internode_2.pricerange.max_price
                  rootnode(j).internode3(w(1)).pricerange.max_price=internode_2.pricerange.max_price;
             end                            
                     else %%����һ�� 
                         var4=size(rootnode(j).internode3,2);
                          ptemp1(1)=starinternode1_1; 
                          ptemp1(2)=starinternode2_1; 
                          rootnode(j).internode3(w(1)).internode2(w(1))=internode2_1;
                         [internode3_1, internode3_2]=spiltinternode2(rootnode(j).internode3(w(1)).internode2, ptemp1, rootnode(j).internode3(w(1)).timerange.timebegin);  
                         countstar=size(internode3_2.internode2, 2);
                          if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                              [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                              if size(rootnode(j).internode3,2)+2<=n_maxcount1
                                       rootnode(j).internode3(w(1))=internode3_1;  
                                       rootnode(j).internode3(var4+1)=starinternode1_2; 
                                       rootnode(j).internode3(var4+2)=starinternode2_2;
                              else %%%���ѵ����%%%%%%%%%%%%%%%%%
                             rootnode(j).internode3(w(1))=internode3_1; 
                             ptemp2(1)=starinternode1_2; 
                             ptemp2(2)=starinternode2_2;
                            [internode4_1, internode4_2]=spiltinternode3_1(rootnode(j).internode3, ptemp2); 
                            rootnode(j).n_level=rootnode(j).n_level+1;
                            rootnode(j).internode3=[];  
                               countstar=size(internode4_2.internode3, 2);
                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             rootnode(j).internode4(1)=internode4_1;
                            [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                            rootnode(j).internode4(2)=starinternode3_1;
                            rootnode(j).internode4(2)=starinternode3_2;
                                else
                            rootnode(j).internode4(1)=internode4_1;
                            rootnode(j).internode4(2)=internode4_2; 
                                end                                    
                              end
                          else %countstar<
                          if size(rootnode(j).internode3,2)+1<=n_maxcount1
                                rootnode(j).internode3(w(1))=internode3_1;  
                                rootnode(j).internode3(var4+1)=internode3_2;  
                          else  %%���ѵ����%%%%%%%%%%%%%%%%%%%
                            rootnode(j).internode3(w(1))=internode3_1; 
                             ptemp2=internode3_2; 
                            [internode4_1, internode4_2]=spiltinternode3_1(rootnode(j).internode3, ptemp2); 
                            rootnode(j).n_level=rootnode(j).n_level+1;
                            rootnode(j).internode3=[];  
                               countstar=size(internode4_2.internode3, 2);
                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             rootnode(j).internode4(1)=internode4_1;
                            [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                            rootnode(j).internode4(2)=starinternode3_1;
                            rootnode(j).internode4(2)=starinternode3_2;
                                else
                            rootnode(j).internode4(1)=internode4_1;
                            rootnode(j).internode4(2)=internode4_2; 
                                end 
                          end
                          end
                     end             
          else
               if size(rootnode(j).internode3(w(1)).internode2,2)+1<=n_maxcount1
                   var3=size(rootnode(j).internode3(w(1)).internode2,2);
                    rootnode(j).internode3(w(1)).internode2(w(2))=internode2_1;  
                    rootnode(j).internode3(w(1)).internode2(var3+1)=internode2_2; 
               rootnode(j).internode3(w(1)).sum_number=rootnode(j).internode3(w(1)).sum_number+1;
               rootnode(j).internode3(w(1)).sum_rating(1)=rootnode(j).internode3(w(1)).sum_rating(1)+leaf.rating(1);
               rootnode(j).internode3(w(1)).sum_rating(2)=rootnode(j).internode3(w(1)).sum_rating(2)+leaf.rating(2);
               rootnode(j).internode3(w(1)).sum_rating(3)=rootnode(j).internode3(w(1)).sum_rating(3)+leaf.rating(3);
               rootnode(j).internode3(w(1)).sum_rating(4)=rootnode(j).internode3(w(1)).sum_rating(4)+leaf.rating(4);
               rootnode(j).internode3(w(1)).sum_rating(5)=rootnode(j).internode3(w(1)).sum_rating(5)+leaf.rating(5);
             if   rootnode(j).internode3(w(1)).pricerange.min_price>internode_1.pricerange.min_price
                 rootnode(j).internode3(w(1)).pricerange.min_price=internode_1.pricerange.min_price;
             end
             if   rootnode(j).internode3(w(1)).pricerange.max_price<internode_2.pricerange.max_price
                  rootnode(j).internode3(w(1)).pricerange.max_price=internode_2.pricerange.max_price;
             end                   
               else %size(rootnode(j).internode3(w(1)).internode2,2)+1<=n_maxcount1
                   var4=size(rootnode(j).internode3,2);
                    ptemp1=internode2_2;                                                 
                    rootnode(j).internode3(w(1)).internode2(w(2))=internode2_1;
                    [internode3_1, internode3_2]=spiltinternode2(rootnode(j).internode3(w(1)).internode2, ptemp1, rootnode(j).internode3(w(1)).timerange.timebegin);
                          countstar=size(internode3_2.internode2, 2);
                          if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                              [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                              if size(rootnode(j).internode3,2)+2<=n_maxcount1
                                       rootnode(j).internode3(w(1))=internode3_1;  
                                       rootnode(j).internode3(var4+1)=starinternode1_2; 
                                       rootnode(j).internode3(var4+2)=starinternode2_2;
                              else %%%���ѵ����%%%%%%%%%%%%%%%
                             rootnode(j).internode3(w(1))=internode3_1; 
                             ptemp2(1)=starinternode1_2; 
                             ptemp2(2)=starinternode2_2;
                            [internode4_1, internode4_2]=spiltinternode3_1(rootnode(j).internode3, ptemp2); 
                            rootnode(j).n_level=rootnode(j).n_level+1;
                            rootnode(j).internode3=[];  
                               countstar=size(internode4_2.internode3, 2);
                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             rootnode(j).internode4(1)=internode4_1;
                            [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                            rootnode(j).internode4(2)=starinternode3_1;
                            rootnode(j).internode4(2)=starinternode3_2;
                                else
                            rootnode(j).internode4(1)=internode4_1;
                            rootnode(j).internode4(2)=internode4_2; 
                                end               
                              end
                          else %countstar<
                          if size(rootnode(j).internode3,2)+1<=n_maxcount1
                                rootnode(j).internode3(w(1))=internode3_1;  
                                rootnode(j).internode3(var4+1)=internode3_2;  
                          else  %%���ѵ����%%%%%%%%%%%%%%%%%%%
                             rootnode(j).internode3(w(1))=internode3_1; 
                             ptemp2=internode3_2; 
                            [internode4_1, internode4_2]=spiltinternode3_1(rootnode(j).internode3, ptemp2); 
                            rootnode(j).n_level=rootnode(j).n_level+1;
                            rootnode(j).internode3=[];  
                               countstar=size(internode4_2.internode3, 2);
                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             rootnode(j).internode4(1)=internode4_1;
                            [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                            rootnode(j).internode4(2)=starinternode3_1;
                            rootnode(j).internode4(2)=starinternode3_2;
                                else
                            rootnode(j).internode4(1)=internode4_1;
                            rootnode(j).internode4(2)=internode4_2; 
                                end                                 
                          end
                          end                                   
               end
          end                                                                                               
                            end                 
               
           else  %count>=  
                             if  (var2+1)<n_maxcount1  %%ֱ�ӷ��Ѳ���
                                                [starinternode1, starinternode2]=spiltstarinternode(internode1_1, countstar);
                                                var2=size(rootnode(j).internode1, 2);
                                                oldtemp=generateold(internode1_2, leaf, rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).timerange.timebegin);            
                                                rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3))=oldtemp;
                                                rootnode(j).internode3(w(1)).internode2(w(2)).internode1(var2+1)=starinternode1;
                                                rootnode(j).internode3(w(1)).internode2(w(2)).internode1(var2+2)=starinternode2;
                                  if   rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).pricerange.min_price>leaf.price
                                      rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).pricerange.max_price<leaf.price
                                      rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).pricerange.max_price=leaf.price;
                                  end

                                  if   rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.min_price>leaf.price
                                      rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.max_price<leaf.price
                                      rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.max_price=leaf.price;
                                  end
                                  if   rootnode(j).internode3(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode3(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode3(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode3(w(1)).pricerange.max_price=leaf.price;
                                  end
                                          
                            else %% %%���Ϸ���
                 var3=size(rootnode(j).internode3(w(1)).internode2,2);      
                 ptemp(1)=starinternode1;
                 ptemp(2)=starinternode2;
                 oldtemp=generateold(internode1_2, leaf, rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).timerange.timebegin);
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3))=oldtemp;
                [internode2_1, internode2_2]=spiltinternode1(rootnode(j).internode3(w(1)).internode2(w(2)).internode1, ptemp, rootnode(j).internode3(w(1)).internode2(w(2)).timerange.timebegin); %%%����Ҫ�ж�countstar;
                 countstar=size(internode2_2.internode1, 2);
          if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
             [starinternode1_1, starinternode2_1]=spiltstarinternode1(internode2_2);
                     if size(rootnode(j).internode3(w(1)).internode2,2)+2<=n_maxcount1
                         var3=size(rootnode(j).internode3(w(1)).internode2,2);
                          rootnode(j).internode3(w(1)).internode2(w(2))=internode2_1;  
                          rootnode(j).internode3(w(1)).internode2(var3+1)=starinternode1_1; 
                          rootnode(j).internode3(w(1)).internode2(var3+2)=starinternode2_1; 
               rootnode(j).internode3(w(1)).sum_number=rootnode(j).internode3(w(1)).sum_number+1;
               rootnode(j).internode3(w(1)).sum_rating(1)=rootnode(j).internode3(w(1)).sum_rating(1)+leaf.rating(1);
               rootnode(j).internode3(w(1)).sum_rating(2)=rootnode(j).internode3(w(1)).sum_rating(2)+leaf.rating(2);
               rootnode(j).internode3(w(1)).sum_rating(3)=rootnode(j).internode3(w(1)).sum_rating(3)+leaf.rating(3);
               rootnode(j).internode3(w(1)).sum_rating(4)=rootnode(j).internode3(w(1)).sum_rating(4)+leaf.rating(4);
               rootnode(j).internode3(w(1)).sum_rating(5)=rootnode(j).internode3(w(1)).sum_rating(5)+leaf.rating(5);
             if   rootnode(j).internode3(w(1)).pricerange.min_price>internode_1.pricerange.min_price
                 rootnode(j).internode3(w(1)).pricerange.min_price=internode_1.pricerange.min_price;
             end
             if   rootnode(j).internode3(w(1)).pricerange.max_price<internode_2.pricerange.max_price
                  rootnode(j).internode3(w(1)).pricerange.max_price=internode_2.pricerange.max_price;
             end                            
                     else %%����һ�� 
                         var4=size(rootnode(j).internode3,2);
                          ptemp1(1)=starinternode1_1; 
                          ptemp1(2)=starinternode2_1; 
                          rootnode(j).internode3(w(1)).internode2(w(1))=internode2_1;
                         [internode3_1, internode3_2]=spiltinternode2(rootnode(j).internode3(w(1)).internode2, ptemp1, rootnode(j).internode3(w(1)).timerange.timebegin);  
                         countstar=size(internode3_2.internode2, 2);
                          if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                              [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                              if size(rootnode(j).internode3,2)+2<=n_maxcount1
                                       rootnode(j).internode3(w(1))=internode3_1;  
                                       rootnode(j).internode3(var4+1)=starinternode1_2; 
                                       rootnode(j).internode3(var4+2)=starinternode2_2;
                              else %%%���ѵ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                             rootnode(j).internode3(w(1))=internode3_1; 
                             ptemp2(1)=starinternode1_2; 
                             ptemp2(2)=starinternode2_2;
                            [internode4_1, internode4_2]=spiltinternode3_1(rootnode(j).internode3, ptemp2); 
                            rootnode(j).n_level=rootnode(j).n_level+1;
                            rootnode(j).internode3=[];  
                               countstar=size(internode4_2.internode3, 2);
                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             rootnode(j).internode4(1)=internode4_1;
                            [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                            rootnode(j).internode4(2)=starinternode3_1;
                            rootnode(j).internode4(2)=starinternode3_2;
                                else
                            rootnode(j).internode4(1)=internode4_1;
                            rootnode(j).internode4(2)=internode4_2; 
                                end                                              
                              end
                          else %countstar<
                          if size(rootnode(j).internode3,2)+1<=n_maxcount1
                                rootnode(j).internode3(w(1))=internode3_1;  
                                rootnode(j).internode3(var4+1)=internode3_2;  
                          else  %%���ѵ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                           rootnode(j).internode3(w(1))=internode3_1; 
                             ptemp2=internode3_2; 
                            [internode4_1, internode4_2]=spiltinternode3_1(rootnode(j).internode3, ptemp2); 
                            rootnode(j).n_level=rootnode(j).n_level+1;
                            rootnode(j).internode3=[];  
                               countstar=size(internode4_2.internode3, 2);
                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             rootnode(j).internode4(1)=internode4_1;
                            [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                            rootnode(j).internode4(2)=starinternode3_1;
                            rootnode(j).internode4(2)=starinternode3_2;
                                else
                            rootnode(j).internode4(1)=internode4_1;
                            rootnode(j).internode4(2)=internode4_2; 
                                end
                          end
                          end
                     end             
          else
               if size(rootnode(j).internode3(w(1)).internode2,2)+1<=n_maxcount1
                   var3=size(rootnode(j).internode3(w(1)).internode2,2);
                    rootnode(j).internode3(w(1)).internode2(w(2))=internode2_1;  
                    rootnode(j).internode3(w(1)).internode2(var3+1)=internode2_2; 
               rootnode(j).internode3(w(1)).sum_number=rootnode(j).internode3(w(1)).sum_number+1;
               rootnode(j).internode3(w(1)).sum_rating(1)=rootnode(j).internode3(w(1)).sum_rating(1)+leaf.rating(1);
               rootnode(j).internode3(w(1)).sum_rating(2)=rootnode(j).internode3(w(1)).sum_rating(2)+leaf.rating(2);
               rootnode(j).internode3(w(1)).sum_rating(3)=rootnode(j).internode3(w(1)).sum_rating(3)+leaf.rating(3);
               rootnode(j).internode3(w(1)).sum_rating(4)=rootnode(j).internode3(w(1)).sum_rating(4)+leaf.rating(4);
               rootnode(j).internode3(w(1)).sum_rating(5)=rootnode(j).internode3(w(1)).sum_rating(5)+leaf.rating(5);
             if   rootnode(j).internode3(w(1)).pricerange.min_price>internode_1.pricerange.min_price
                 rootnode(j).internode3(w(1)).pricerange.min_price=internode_1.pricerange.min_price;
             end
             if   rootnode(j).internode3(w(1)).pricerange.max_price<internode_2.pricerange.max_price
                  rootnode(j).internode3(w(1)).pricerange.max_price=internode_2.pricerange.max_price;
             end                   
               else %size(rootnode(j).internode3(w(1)).internode2,2)+1<=n_maxcount1
                   var4=size(rootnode(j).internode3,2);
                    ptemp1=internode2_2;                                                 
                    rootnode(j).internode3(w(1)).internode2(w(2))=internode2_1;
                    [internode3_1, internode3_2]=spiltinternode2(rootnode(j).internode3(w(1)).internode2, ptemp1, rootnode(j).internode3(w(1)).timerange.timebegin);
                          countstar=size(internode3_2.internode2, 2);
                          if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                              [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                              if size(rootnode(j).internode3,2)+2<=n_maxcount1
                                       rootnode(j).internode3(w(1))=internode3_1;  
                                       rootnode(j).internode3(var4+1)=starinternode1_2; 
                                       rootnode(j).internode3(var4+2)=starinternode2_2;
                              else %%%���ѵ����%%%%%%%%%%%%%%%%%%%
                             rootnode(j).internode3(w(1))=internode3_1; 
                             ptemp2(1)=starinternode1_2; 
                             ptemp2(2)=starinternode2_2;
                            [internode4_1, internode4_2]=spiltinternode3_1(rootnode(j).internode3, ptemp2); 
                            rootnode(j).n_level=rootnode(j).n_level+1;
                            rootnode(j).internode3=[];  
                               countstar=size(internode4_2.internode3, 2);
                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             rootnode(j).internode4(1)=internode4_1;
                            [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                            rootnode(j).internode4(2)=starinternode3_1;
                            rootnode(j).internode4(2)=starinternode3_2;
                                else
                            rootnode(j).internode4(1)=internode4_1;
                            rootnode(j).internode4(2)=internode4_2; 
                                end     
                              end
                          else %countstar<
                          if size(rootnode(j).internode3,2)+1<=n_maxcount1
                                rootnode(j).internode3(w(1))=internode3_1;  
                                rootnode(j).internode3(var4+1)=internode3_2;  
                          else  %%���ѵ����%%%%%%%%%%%%%%%%%%%%
                                                       rootnode(j).internode3(w(1))=internode3_1; 
                             ptemp2=internode3_2; 
                            [internode4_1, internode4_2]=spiltinternode3_1(rootnode(j).internode3, ptemp2); 
                            rootnode(j).n_level=rootnode(j).n_level+1;
                            rootnode(j).internode3=[];  
                               countstar=size(internode4_2.internode3, 2);
                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             rootnode(j).internode4(1)=internode4_1;
                            [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                            rootnode(j).internode4(2)=starinternode3_1;
                            rootnode(j).internode4(2)=starinternode3_2;
                                else
                            rootnode(j).internode4(1)=internode4_1;
                            rootnode(j).internode4(2)=internode4_2; 
                                end    
                          end
                          end                   
                   
               end
          end  
                                                              
                             end                
               
           end
                                                 
                           end %%size(rootnode(j).internode2(w(1)).internode1,2)<n_maxcount1
                              
        elseif  mark==0          
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).sum_number=sum_number;
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).sum_rating(1)=sum_rating(1);
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).sum_rating(2)=sum_rating(2);
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).sum_rating(3)=sum_rating(3);
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).sum_rating(4)=sum_rating(4);
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).sum_rating(5)=sum_rating(5);
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).leafnode=leafnode_num; 
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_number=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_number+1;
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(1)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(1)+leaf.rating(1); 
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(2)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(2)+leaf.rating(2);
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(3)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(3)+leaf.rating(3);
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(4)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(4)+leaf.rating(4);
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(5)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(5)+leaf.rating(5);
                 rootnode(j).internode3(w(1)).internode2(w(2)).sum_number=rootnode(j).internode3(w(1)).internode2(w(2)).sum_number+1;
                 rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(1)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(1)+leaf.rating(1); 
                 rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(2)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(2)+leaf.rating(2);
                 rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(3)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(3)+leaf.rating(3);
                 rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(4)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(4)+leaf.rating(4);
                 rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(5)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(5)+leaf.rating(5);  
                 rootnode(j).internode3(w(1)).sum_number=rootnode(j).internode3(w(1)).sum_number+1;
                 rootnode(j).internode3(w(1)).sum_rating(1)=rootnode(j).internode3(w(1)).sum_rating(1)+leaf.rating(1); 
                 rootnode(j).internode3(w(1)).sum_rating(2)=rootnode(j).internode3(w(1)).sum_rating(2)+leaf.rating(2);
                 rootnode(j).internode3(w(1)).sum_rating(3)=rootnode(j).internode3(w(1)).sum_rating(3)+leaf.rating(3);
                 rootnode(j).internode3(w(1)).sum_rating(4)=rootnode(j).internode3(w(1)).sum_rating(4)+leaf.rating(4);
                 rootnode(j).internode3(w(1)).sum_rating(5)=rootnode(j).internode3(w(1)).sum_rating(5)+leaf.rating(5);   
                        end            
        elseif same==1
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).sum_number=sum_number;
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).sum_rating(1)=sum_rating(1);
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).sum_rating(2)=sum_rating(2);
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).sum_rating(3)=sum_rating(3);
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).sum_rating(4)=sum_rating(4);
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).sum_rating(5)=sum_rating(5);
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).leafnode=leafnode_num; 
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_number=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_number+1;
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(1)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(1)+leaf.rating(1); 
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(2)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(2)+leaf.rating(2);
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(3)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(3)+leaf.rating(3);
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(4)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(4)+leaf.rating(4);
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(5)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(5)+leaf.rating(5);
                 rootnode(j).internode3(w(1)).internode2(w(2)).sum_number=rootnode(j).internode3(w(1)).internode2(w(2)).sum_number+1;
                 rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(1)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(1)+leaf.rating(1); 
                 rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(2)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(2)+leaf.rating(2);
                 rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(3)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(3)+leaf.rating(3);
                 rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(4)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(4)+leaf.rating(4);
                 rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(5)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(5)+leaf.rating(5);  
                 rootnode(j).internode3(w(1)).sum_number=rootnode(j).internode3(w(1)).sum_number+1;
                 rootnode(j).internode3(w(1)).sum_rating(1)=rootnode(j).internode3(w(1)).sum_rating(1)+leaf.rating(1); 
                 rootnode(j).internode3(w(1)).sum_rating(2)=rootnode(j).internode3(w(1)).sum_rating(2)+leaf.rating(2);
                 rootnode(j).internode3(w(1)).sum_rating(3)=rootnode(j).internode3(w(1)).sum_rating(3)+leaf.rating(3);
                 rootnode(j).internode3(w(1)).sum_rating(4)=rootnode(j).internode3(w(1)).sum_rating(4)+leaf.rating(4);
                 rootnode(j).internode3(w(1)).sum_rating(5)=rootnode(j).internode3(w(1)).sum_rating(5)+leaf.rating(5);             
        end                   
             
             else %%%Ҷ�ӷ���
          [internode_1, internode_2, totalleafnode]=spiltleafnode(rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)), leaf, j, totalleafnode);
          var1=size(rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode, 2);
          if   var1+2<=n_maxcount1 %%���±�
                            rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).timerange.timeend=internode_1.timerange.timebegin;
                            rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(var1+1)=internode_1;                           
                            rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(var1+2)=internode_2; 
                            rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_number=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_number+1;
                            rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(1)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(1)+leaf.rating(1);
                            rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(2)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(2)+leaf.rating(2); 
                            rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(3)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(3)+leaf.rating(3); 
                            rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(4)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(4)+leaf.rating(4); 
                            rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(5)=rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).sum_rating(5)+leaf.rating(5); 
                            rootnode(j).internode3(w(1)).internode2(w(2)).sum_number=rootnode(j).internode3(w(1)).internode2(w(2)).sum_number+1;
                            rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(1)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(1)+leaf.rating(1);
                            rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(2)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(2)+leaf.rating(2);
                            rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(3)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(3)+leaf.rating(3);
                            rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(4)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(4)+leaf.rating(4);
                            rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(5)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(5)+leaf.rating(5);
                            rootnode(j).internode3(w(1)).sum_number=rootnode(j).internode3(w(1)).sum_number+1;
                            rootnode(j).internode3(w(1)).sum_rating(1)=rootnode(j).internode3(w(1)).sum_rating(1)+leaf.rating(1);
                            rootnode(j).internode3(w(1)).sum_rating(2)=rootnode(j).internode3(w(1)).sum_rating(2)+leaf.rating(2);
                            rootnode(j).internode3(w(1)).sum_rating(3)=rootnode(j).internode3(w(1)).sum_rating(3)+leaf.rating(3);
                            rootnode(j).internode3(w(1)).sum_rating(4)=rootnode(j).internode3(w(1)).sum_rating(4)+leaf.rating(4);
                            rootnode(j).internode3(w(1)).sum_rating(5)=rootnode(j).internode3(w(1)).sum_rating(5)+leaf.rating(5);
                                  if  rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).pricerange.min_price>internode_1.pricerange.min_price
                                      rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).pricerange.min_price=internode_1.pricerange.min_price;
                                  end
                                  if   rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).pricerange.max_price<internode_2.pricerange.max_price
                                      rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).pricerange.max_price=internode_2.pricerange.max_price;
                                  end
                            
                                  if   rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.min_price>internode_1.pricerange.min_price
                                      rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.min_price=internode_1.pricerange.min_price;
                                  end
                                  if   rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.max_price<internode_2.pricerange.max_price
                                      rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.max_price=internode_2.pricerange.max_price;
                                  end 
                                  if   rootnode(j).internode3(w(1)).pricerange.min_price>internode_1.pricerange.min_price
                                      rootnode(j).internode3(w(1)).pricerange.min_price=internode_1.pricerange.min_price;
                                  end
                                  if   rootnode(j).internode3(w(1)).pricerange.max_price<internode_2.pricerange.max_price
                                      rootnode(j).internode3(w(1)).pricerange.max_price=internode_2.pricerange.max_price;
                                  end   
          else  %%%var1+2> 
    rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode(w(4)).timerange.timeend=internode_1.timerange.timebegin;                                    
    spilttempnode(1)=internode_1;
    spilttempnode(2)=internode_2;
    [internode1_1, internode1_2]=spiltinternode(rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).internode, spilttempnode);
    countstar=size(internode1_1, 2);
 if  countstar>=ceil(n_maxcount1*5/6)%%%�����޸�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  var2=size(rootnode(j).internode3(w(1)).internode2(w(2)).internode1,2);
     [starinternode1, starinternode2]=spiltstarinternode(internode1_1, countstar);   
       if  size(rootnode(j).internode3(w(1)).internode2(w(2)).internode1,2)+2<=n_maxcount1 %%var2+2
                                      var2=size(rootnode(j).internode3(w(1)).internode2(w(2)).internode1,2);
                                        oldtemp=generateold(internode1_2, leaf, rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).timerange.timebegin); 
                                       rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3))=oldtemp;
                                       rootnode(j).internode3(w(1)).internode2(w(2)).internode1(var2+1)=starinternode1;
                                       rootnode(j).internode3(w(1)).internode2(w(2)).internode1(var2+2)=starinternode2;  
               rootnode(j).internode3(w(1)).internode2(w(2)).sum_number=rootnode(j).internode3(w(1)).internode2(w(2)).sum_number+1;
               rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(1)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(1)+leaf.rating(1);
               rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(2)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(2)+leaf.rating(2);
               rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(3)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(3)+leaf.rating(3);
               rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(4)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(4)+leaf.rating(4);
               rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(5)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(5)+leaf.rating(5);
               rootnode(j).internode3(w(1)).sum_number=rootnode(j).internode3(w(1)).sum_number+1;
               rootnode(j).internode3(w(1)).sum_rating(1)=rootnode(j).internode3(w(1)).sum_rating(1)+leaf.rating(1);
               rootnode(j).internode3(w(1)).sum_rating(2)=rootnode(j).internode3(w(1)).sum_rating(2)+leaf.rating(2);
               rootnode(j).internode3(w(1)).sum_rating(3)=rootnode(j).internode3(w(1)).sum_rating(3)+leaf.rating(3);
               rootnode(j).internode3(w(1)).sum_rating(4)=rootnode(j).internode3(w(1)).sum_rating(4)+leaf.rating(4);
               rootnode(j).internode3(w(1)).sum_rating(5)=rootnode(j).internode3(w(1)).sum_rating(5)+leaf.rating(5);
             if   rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.min_price>internode_1.pricerange.min_price
                   rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.min_price=internode_1.pricerange.min_price;
             end
             if   rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.max_price<internode_2.pricerange.max_price
                  rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.max_price=internode_2.pricerange.max_price;
             end   
             if   rootnode(j).internode3(w(1)).pricerange.min_price>internode_1.pricerange.min_price
                 rootnode(j).internode3(w(1)).pricerange.min_price=internode_1.pricerange.min_price;
             end
             if   rootnode(j).internode3(w(1)).pricerange.max_price<internode_2.pricerange.max_price
                  rootnode(j).internode3(w(1)).pricerange.max_price=internode_2.pricerange.max_price;
             end  
       else %%����internode2(w(1))
                 var3=size(rootnode(j).internode3(w(1)).internode2,2);      
                 ptemp(1)=starinternode1;
                 ptemp(2)=starinternode2;
                 oldtemp=generateold(internode1_2, leaf, rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).timerange.timebegin);
                 rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3))=oldtemp;
                [internode2_1, internode2_2]=spiltinternode1(rootnode(j).internode3(w(1)).internode2(w(2)).internode1, ptemp, rootnode(j).internode3(w(1)).internode2(w(2)).timerange.timebegin); %%%����Ҫ�ж�countstar;
                 countstar=size(internode2_2.internode1, 2);
          if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
             [starinternode1_1, starinternode2_1]=spiltstarinternode1(internode2_2);
                     if size(rootnode(j).internode3(w(1)).internode2,2)+2<=n_maxcount1
                         var3=size(rootnode(j).internode3(w(1)).internode2,2);
                          rootnode(j).internode3(w(1)).internode2(w(2))=internode2_1;  
                          rootnode(j).internode3(w(1)).internode2(var3+1)=starinternode1_1; 
                          rootnode(j).internode3(w(1)).internode2(var3+2)=starinternode2_1; 
               rootnode(j).internode3(w(1)).sum_number=rootnode(j).internode3(w(1)).sum_number+1;
               rootnode(j).internode3(w(1)).sum_rating(1)=rootnode(j).internode3(w(1)).sum_rating(1)+leaf.rating(1);
               rootnode(j).internode3(w(1)).sum_rating(2)=rootnode(j).internode3(w(1)).sum_rating(2)+leaf.rating(2);
               rootnode(j).internode3(w(1)).sum_rating(3)=rootnode(j).internode3(w(1)).sum_rating(3)+leaf.rating(3);
               rootnode(j).internode3(w(1)).sum_rating(4)=rootnode(j).internode3(w(1)).sum_rating(4)+leaf.rating(4);
               rootnode(j).internode3(w(1)).sum_rating(5)=rootnode(j).internode3(w(1)).sum_rating(5)+leaf.rating(5);
             if   rootnode(j).internode3(w(1)).pricerange.min_price>internode_1.pricerange.min_price
                 rootnode(j).internode3(w(1)).pricerange.min_price=internode_1.pricerange.min_price;
             end
             if   rootnode(j).internode3(w(1)).pricerange.max_price<internode_2.pricerange.max_price
                  rootnode(j).internode3(w(1)).pricerange.max_price=internode_2.pricerange.max_price;
             end                            
                     else %%����һ�� 
                         var4=size(rootnode(j).internode3,2);
                          ptemp1(1)=starinternode1_1; 
                          ptemp1(2)=starinternode2_1; 
                          rootnode(j).internode3(w(1)).internode2(w(1))=internode2_1;
                         [internode3_1, internode3_2]=spiltinternode2(rootnode(j).internode3(w(1)).internode2, ptemp1, rootnode(j).internode3(w(1)).timerange.timebegin);  
                         countstar=size(internode3_2.internode2, 2);
                          if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                              [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                              if size(rootnode(j).internode3,2)+2<=n_maxcount1
                                       rootnode(j).internode3(w(1))=internode3_1;  
                                       rootnode(j).internode3(var4+1)=starinternode1_2; 
                                       rootnode(j).internode3(var4+2)=starinternode2_2;
                              else %%%���ѵ����%%%%%%%%%%%%%%%%%%%%%%%%
                             rootnode(j).internode3(w(1))=internode3_1; 
                             ptemp2(1)=starinternode1_2; 
                             ptemp2(2)=starinternode2_2;
                            [internode4_1, internode4_2]=spiltinternode3_1(rootnode(j).internode3, ptemp2); 
                            rootnode(j).n_level=rootnode(j).n_level+1;
                            rootnode(j).internode3=[];  
                               countstar=size(internode4_2.internode3, 2);
                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             rootnode(j).internode4(1)=internode4_1;
                            [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                            rootnode(j).internode4(2)=starinternode3_1;
                            rootnode(j).internode4(2)=starinternode3_2;
                                else
                            rootnode(j).internode4(1)=internode4_1;
                            rootnode(j).internode4(2)=internode4_2; 
                                end                      
                                  
                              end
                          else %countstar<
                          if size(rootnode(j).internode3,2)+1<=n_maxcount1
                                rootnode(j).internode3(w(1))=internode3_1;  
                                rootnode(j).internode3(var4+1)=internode3_2;  
                          else  %%���ѵ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                             rootnode(j).internode3(w(1))=internode3_1; 
                             ptemp2=internode3_2; 
                            [internode4_1, internode4_2]=spiltinternode3_1(rootnode(j).internode3, ptemp2); 
                            rootnode(j).n_level=rootnode(j).n_level+1;
                            rootnode(j).internode3=[];  
                               countstar=size(internode4_2.internode3, 2);
                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             rootnode(j).internode4(1)=internode4_1;
                            [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                            rootnode(j).internode4(2)=starinternode3_1;
                            rootnode(j).internode4(2)=starinternode3_2;
                                else
                            rootnode(j).internode4(1)=internode4_1;
                            rootnode(j).internode4(2)=internode4_2; 
                                end
                          end
                          end
                     end             
          else
               if size(rootnode(j).internode3(w(1)).internode2,2)+1<=n_maxcount1
                   var3=size(rootnode(j).internode3(w(1)).internode2,2);
                    rootnode(j).internode3(w(1)).internode2(w(2))=internode2_1;  
                    rootnode(j).internode3(w(1)).internode2(var3+1)=internode2_2; 
               rootnode(j).internode3(w(1)).sum_number=rootnode(j).internode3(w(1)).sum_number+1;
               rootnode(j).internode3(w(1)).sum_rating(1)=rootnode(j).internode3(w(1)).sum_rating(1)+leaf.rating(1);
               rootnode(j).internode3(w(1)).sum_rating(2)=rootnode(j).internode3(w(1)).sum_rating(2)+leaf.rating(2);
               rootnode(j).internode3(w(1)).sum_rating(3)=rootnode(j).internode3(w(1)).sum_rating(3)+leaf.rating(3);
               rootnode(j).internode3(w(1)).sum_rating(4)=rootnode(j).internode3(w(1)).sum_rating(4)+leaf.rating(4);
               rootnode(j).internode3(w(1)).sum_rating(5)=rootnode(j).internode3(w(1)).sum_rating(5)+leaf.rating(5);
             if   rootnode(j).internode3(w(1)).pricerange.min_price>internode_1.pricerange.min_price
                 rootnode(j).internode3(w(1)).pricerange.min_price=internode_1.pricerange.min_price;
             end
             if   rootnode(j).internode3(w(1)).pricerange.max_price<internode_2.pricerange.max_price
                  rootnode(j).internode3(w(1)).pricerange.max_price=internode_2.pricerange.max_price;
             end                   
               else %size(rootnode(j).internode3(w(1)).internode2,2)+1<=n_maxcount1
                   var4=size(rootnode(j).internode3,2);
                    ptemp1=internode2_2;                                                 
                    rootnode(j).internode3(w(1)).internode2(w(2))=internode2_1;
                    [internode3_1, internode3_2]=spiltinternode2(rootnode(j).internode3(w(1)).internode2, ptemp1, rootnode(j).internode3(w(1)).timerange.timebegin);
                          countstar=size(internode3_2.internode2, 2);
                          if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                              [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                              if size(rootnode(j).internode3,2)+2<=n_maxcount1
                                       rootnode(j).internode3(w(1))=internode3_1;  
                                       rootnode(j).internode3(var4+1)=starinternode1_2; 
                                       rootnode(j).internode3(var4+2)=starinternode2_2;
                              else %%%���ѵ����
                             rootnode(j).internode3(w(1))=internode3_1; 
                             ptemp2(1)=starinternode1_2; 
                             ptemp2(2)=starinternode2_2;
                            [internode4_1, internode4_2]=spiltinternode3_1(rootnode(j).internode3, ptemp2); 
                            rootnode(j).n_level=rootnode(j).n_level+1;
                            rootnode(j).internode3=[];  
                               countstar=size(internode4_2.internode3, 2);
                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             rootnode(j).internode4(1)=internode4_1;
                            [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                            rootnode(j).internode4(2)=starinternode3_1;
                            rootnode(j).internode4(2)=starinternode3_2;
                                else
                            rootnode(j).internode4(1)=internode4_1;
                            rootnode(j).internode4(2)=internode4_2; 
                                end             
                              end
                          else %countstar<
                          if size(rootnode(j).internode3,2)+1<=n_maxcount1
                                rootnode(j).internode3(w(1))=internode3_1;  
                                rootnode(j).internode3(var4+1)=internode3_2;  
                          else  %%���ѵ����
                                                    rootnode(j).internode3(w(1))=internode3_1; 
                             ptemp2=internode3_2; 
                            [internode4_1, internode4_2]=spiltinternode3_1(rootnode(j).internode3, ptemp2); 
                            rootnode(j).n_level=rootnode(j).n_level+1;
                            rootnode(j).internode3=[];  
                               countstar=size(internode4_2.internode3, 2);
                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             rootnode(j).internode4(1)=internode4_1;
                            [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                            rootnode(j).internode4(2)=starinternode3_1;
                            rootnode(j).internode4(2)=starinternode3_2;
                                else
                            rootnode(j).internode4(1)=internode4_1;
                            rootnode(j).internode4(2)=internode4_2; 
                                end       
                              
                          end
                          end                   
                   
               end
          end                            
       end
     
 else   %%countstar              
     if  size(rootnode(j).internode3(w(1)).internode2(w(2)).internode1,2)+1<=n_maxcount1
               var2=size(rootnode(j).internode3(w(1)).internode2(w(2)).internode1,2);
               ptemp=generate(internode1_1);  %%��������һ�����
               oldtemp=generateold(internode1_2, leaf, rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).timerange.timebegin);            
               rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3))=oldtemp;
               rootnode(j).internode3(w(1)).internode2(w(2)).internode1(var2+1)=ptemp;
               rootnode(j).internode3(w(1)).internode2(w(2)).sum_number=rootnode(j).internode3(w(1)).internode2(w(2)).sum_number+1;
               rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(1)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(1)+leaf.rating(1);
               rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(2)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(2)+leaf.rating(2);
               rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(3)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(3)+leaf.rating(3);
               rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(4)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(4)+leaf.rating(4);
               rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(5)=rootnode(j).internode3(w(1)).internode2(w(2)).sum_rating(5)+leaf.rating(5);
               rootnode(j).internode3(w(1)).sum_number=rootnode(j).internode3(w(1)).sum_number+1;
               rootnode(j).internode3(w(1)).sum_rating(1)=rootnode(j).internode3(w(1)).sum_rating(1)+leaf.rating(1);
               rootnode(j).internode3(w(1)).sum_rating(2)=rootnode(j).internode3(w(1)).sum_rating(2)+leaf.rating(2);
               rootnode(j).internode3(w(1)).sum_rating(3)=rootnode(j).internode3(w(1)).sum_rating(3)+leaf.rating(3);
               rootnode(j).internode3(w(1)).sum_rating(4)=rootnode(j).internode3(w(1)).sum_rating(4)+leaf.rating(4);
               rootnode(j).internode3(w(1)).sum_rating(5)=rootnode(j).internode3(w(1)).sum_rating(5)+leaf.rating(5);
             if   rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.min_price>internode_1.pricerange.min_price
                   rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.min_price=internode_1.pricerange.min_price;
             end
             if   rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.max_price<internode_2.pricerange.max_price
                  rootnode(j).internode3(w(1)).internode2(w(2)).pricerange.max_price=internode_2.pricerange.max_price;
             end   
             if   rootnode(j).internode3(w(1)).pricerange.min_price>internode_1.pricerange.min_price
                 rootnode(j).internode3(w(1)).pricerange.min_price=internode_1.pricerange.min_price;
             end
             if   rootnode(j).internode3(w(1)).pricerange.max_price<internode_2.pricerange.max_price
                  rootnode(j).internode3(w(1)).pricerange.max_price=internode_2.pricerange.max_price;
             end          
     else%%+1
                  var3=size(rootnode(j).internode3(w(1)).internode2, 2);
                  ptemp=generate(internode1_1);  %%��������һ�����
                  oldtemp=generateold(internode1_2, leaf, rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3)).timerange.timebegin);
                  rootnode(j).internode3(w(1)).internode2(w(2)).internode1(w(3))=oldtemp;
                  [internode2_1, internode2_2]=spiltinternode1(rootnode(j).internode3(w(1)).internode2(w(2)).internode1, ptemp, rootnode(j).internode3(w(1)).internode2(w(2)).timerange.timebegin);
                  countstar=size(internode2_2.internode1, 2);
          if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
             [starinternode1_1, starinternode2_1]=spiltstarinternode1(internode2_2);
                     if size(rootnode(j).internode3(w(1)).internode2,2)+2<=n_maxcount1
                         var3=size(rootnode(j).internode3(w(1)).internode2,2);
                          rootnode(j).internode3(w(1)).internode2(w(2))=internode2_1;  
                          rootnode(j).internode3(w(1)).internode2(var3+1)=starinternode1_1; 
                          rootnode(j).internode3(w(1)).internode2(var3+2)=starinternode2_1; 
               rootnode(j).internode3(w(1)).sum_number=rootnode(j).internode3(w(1)).sum_number+1;
               rootnode(j).internode3(w(1)).sum_rating(1)=rootnode(j).internode3(w(1)).sum_rating(1)+leaf.rating(1);
               rootnode(j).internode3(w(1)).sum_rating(2)=rootnode(j).internode3(w(1)).sum_rating(2)+leaf.rating(2);
               rootnode(j).internode3(w(1)).sum_rating(3)=rootnode(j).internode3(w(1)).sum_rating(3)+leaf.rating(3);
               rootnode(j).internode3(w(1)).sum_rating(4)=rootnode(j).internode3(w(1)).sum_rating(4)+leaf.rating(4);
               rootnode(j).internode3(w(1)).sum_rating(5)=rootnode(j).internode3(w(1)).sum_rating(5)+leaf.rating(5);
             if   rootnode(j).internode3(w(1)).pricerange.min_price>internode_1.pricerange.min_price
                 rootnode(j).internode3(w(1)).pricerange.min_price=internode_1.pricerange.min_price;
             end
             if   rootnode(j).internode3(w(1)).pricerange.max_price<internode_2.pricerange.max_price
                  rootnode(j).internode3(w(1)).pricerange.max_price=internode_2.pricerange.max_price;
             end                            
                     else %%����һ�� 
                         var4=size(rootnode(j).internode3,2);
                          ptemp1(1)=starinternode1_1; 
                          ptemp1(2)=starinternode2_1; 
                          rootnode(j).internode3(w(1)).internode2(w(1))=internode2_1;
                         [internode3_1, internode3_2]=spiltinternode2(rootnode(j).internode3(w(1)).internode2, ptemp1, rootnode(j).internode3(w(1)).timerange.timebegin);  
                         countstar=size(internode3_2.internode2, 2);
                          if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                              [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                              if size(rootnode(j).internode3,2)+2<=n_maxcount1
                                       rootnode(j).internode3(w(1))=internode3_1;  
                                       rootnode(j).internode3(var4+1)=starinternode1_2; 
                                       rootnode(j).internode3(var4+2)=starinternode2_2;
                              else %%%���ѵ����
                             rootnode(j).internode3(w(1))=internode3_1; 
                             ptemp2(1)=starinternode1_2; 
                             ptemp2(2)=starinternode2_2;
                            [internode4_1, internode4_2]=spiltinternode3_1(rootnode(j).internode3, ptemp2); 
                            rootnode(j).n_level=rootnode(j).n_level+1;
                            rootnode(j).internode3=[];  
                               countstar=size(internode4_2.internode3, 2);
                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             rootnode(j).internode4(1)=internode4_1;
                            [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                            rootnode(j).internode4(2)=starinternode3_1;
                            rootnode(j).internode4(2)=starinternode3_2;
                                else
                            rootnode(j).internode4(1)=internode4_1;
                            rootnode(j).internode4(2)=internode4_2; 
                                end       
                              end
                          else %countstar<
                          if size(rootnode(j).internode3,2)+1<=n_maxcount1
                                rootnode(j).internode3(w(1))=internode3_1;  
                                rootnode(j).internode3(var4+1)=internode3_2;  
                          else  %%���ѵ����
                                                           rootnode(j).internode3(w(1))=internode3_1; 
                             ptemp2=internode3_2; 
                            [internode4_1, internode4_2]=spiltinternode3_1(rootnode(j).internode3, ptemp2); 
                            rootnode(j).n_level=rootnode(j).n_level+1;
                            rootnode(j).internode3=[];  
                               countstar=size(internode4_2.internode3, 2);
                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             rootnode(j).internode4(1)=internode4_1;
                            [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                            rootnode(j).internode4(2)=starinternode3_1;
                            rootnode(j).internode4(2)=starinternode3_2;
                                else
                            rootnode(j).internode4(1)=internode4_1;
                            rootnode(j).internode4(2)=internode4_2; 
                                end
                              
                          end
                          end
                     end             
          else
               if size(rootnode(j).internode3(w(1)).internode2,2)+1<=n_maxcount1
                   var3=size(rootnode(j).internode3(w(1)).internode2,2);
                    rootnode(j).internode3(w(1)).internode2(w(2))=internode2_1;  
                    rootnode(j).internode3(w(1)).internode2(var3+1)=internode2_2; 
               rootnode(j).internode3(w(1)).sum_number=rootnode(j).internode3(w(1)).sum_number+1;
               rootnode(j).internode3(w(1)).sum_rating(1)=rootnode(j).internode3(w(1)).sum_rating(1)+leaf.rating(1);
               rootnode(j).internode3(w(1)).sum_rating(2)=rootnode(j).internode3(w(1)).sum_rating(2)+leaf.rating(2);
               rootnode(j).internode3(w(1)).sum_rating(3)=rootnode(j).internode3(w(1)).sum_rating(3)+leaf.rating(3);
               rootnode(j).internode3(w(1)).sum_rating(4)=rootnode(j).internode3(w(1)).sum_rating(4)+leaf.rating(4);
               rootnode(j).internode3(w(1)).sum_rating(5)=rootnode(j).internode3(w(1)).sum_rating(5)+leaf.rating(5);
             if   rootnode(j).internode3(w(1)).pricerange.min_price>internode_1.pricerange.min_price
                 rootnode(j).internode3(w(1)).pricerange.min_price=internode_1.pricerange.min_price;
             end
             if   rootnode(j).internode3(w(1)).pricerange.max_price<internode_2.pricerange.max_price
                  rootnode(j).internode3(w(1)).pricerange.max_price=internode_2.pricerange.max_price;
             end                   
               else %size(rootnode(j).internode3(w(1)).internode2,2)+1<=n_maxcount1
                   var4=size(rootnode(j).internode3,2);
                    ptemp1=internode2_2;                                                 
                    rootnode(j).internode3(w(1)).internode2(w(2))=internode2_1;
                    [internode3_1, internode3_2]=spiltinternode2(rootnode(j).internode3(w(1)).internode2, ptemp1, rootnode(j).internode3(w(1)).timerange.timebegin);
                          countstar=size(internode3_2.internode2, 2);
                          if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                              [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                              if size(rootnode(j).internode3,2)+2<=n_maxcount1
                                       rootnode(j).internode3(w(1))=internode3_1;  
                                       rootnode(j).internode3(var4+1)=starinternode1_2; 
                                       rootnode(j).internode3(var4+2)=starinternode2_2;
                              else %%%���ѵ����
                             rootnode(j).internode3(w(1))=internode3_1; 
                             ptemp2(1)=starinternode1_2; 
                             ptemp2(2)=starinternode2_2;
                            [internode4_1, internode4_2]=spiltinternode3_1(rootnode(j).internode3, ptemp2); 
                            rootnode(j).n_level=rootnode(j).n_level+1;
                            rootnode(j).internode3=[];  
                               countstar=size(internode4_2.internode3, 2);
                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             rootnode(j).internode4(1)=internode4_1;
                            [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                            rootnode(j).internode4(2)=starinternode3_1;
                            rootnode(j).internode4(2)=starinternode3_2;
                                else
                            rootnode(j).internode4(1)=internode4_1;
                            rootnode(j).internode4(2)=internode4_2; 
                                end                              
                              end
                          else %countstar<
                          if size(rootnode(j).internode3,2)+1<=n_maxcount1
                                rootnode(j).internode3(w(1))=internode3_1;  
                                rootnode(j).internode3(var4+1)=internode3_2;  
                          else  %%���ѵ����
                                                           rootnode(j).internode3(w(1))=internode3_1; 
                             ptemp2=internode3_2; 
                            [internode4_1, internode4_2]=spiltinternode3_1(rootnode(j).internode3, ptemp2); 
                            rootnode(j).n_level=rootnode(j).n_level+1;
                            rootnode(j).internode3=[];  
                               countstar=size(internode4_2.internode3, 2);
                                if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             rootnode(j).internode4(1)=internode4_1;
                            [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                            rootnode(j).internode4(2)=starinternode3_1;
                            rootnode(j).internode4(2)=starinternode3_2;
                                else
                            rootnode(j).internode4(1)=internode4_1;
                            rootnode(j).internode4(2)=internode4_2; 
                                end
                          end
                          end                   
                   
               end
          end         
     end     
 end             
          end    
             end
                elseif rootnode(j).n_level==5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              v=0;
             for p=1:1:size(rootnode(j).internode4,2)
                  if strcmp(rootnode(j).internode4(p).timerange.timeend,'*')
                      for ppt=1:1:size(rootnode(j).internode4(p).internode3, 2)
                          if strcmp(rootnode(j).internode4(p).internode3(ppt).timerange.timeend,'*')
                          for pppt=1:1:size(rootnode(j).internode4(p).internode3(ppt).internode2, 2)
                              if strcmp(rootnode(j).internode4(p).internode3(ppt).internode2(pppt).timerange.timeend,'*')
                                  for ppppt=1:1:size(rootnode(j).internode4(p).internode3(ppt).internode2(pppt).internode1, 2)
                                     if strcmp(rootnode(j).internode4(p).internode3(ppt).internode2(pppt).internode1(ppppt).timerange.timeend,'*')
                                         for pppppt=1:1:size(rootnode(j).internode4(p).internode3(ppt).internode2(pppt).internode1(ppppt).internode, 2)
                       if strcmp(rootnode(j).internode4(p).internode3(ppt).internode2(pppt).internode1(ppppt).internode(pppppt).timerange.timeend,'*')&& rootnode(j).internode4(p).internode3(ppt).internode2(pppt).internode1(ppppt).internode(pppppt).pricerange.min_price>v
                       w(1)=p; 
                       w(2)=ppt;
                       w(3)=pppt;
                       w(4)=ppppt;
                       w(5)=pppppt;
                       v=rootnode(j).internode4(p).internode3(ppt).internode2(pppt).internode1(ppppt).internode(pppppt).pricerange.min_price;                     
                       end                                             
                                         end
                                     end                                     
                                  end
                              end
                          end
                          end
                      end
                  end
             end 
                                                           
 var1=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode, 2);      
             if   size(totalleafnode(j, rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).leafnode).leaf,2)<n_maxcount
        [totalleafnode, leafnode_num, temptime, mark, same, sum_number, sum_rating]=insertleafnode(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)), leaf, j, totalleafnode);               
       if  same==0  
            if mark==1 %%%˵��ʱ���в�ͬ
                if  var1<n_maxcount1
                                      rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).timerange.timeend=temptime;  
                                      internode.sum_number=sum_number;
                                      internode.sum_rating(1)=sum_rating(1);
                                      internode.sum_rating(2)=sum_rating(2);
                                      internode.sum_rating(3)=sum_rating(3);
                                      internode.sum_rating(4)=sum_rating(4);
                                      internode.sum_rating(5)=sum_rating(5);
                                      internode.level=0;
                                      internode.pricerange.min_price=rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).pricerange.min_price;   %%internode�ڵ��key
                                      internode.pricerange.max_price=rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).pricerange.min_price;                                     
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end                                      
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.max_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).pricerange.max_price=leaf.price;
                                  end
                                      internode.timerange.timebegin=temptime;
                                      internode.timerange.timeend='*';
                                      internode.leafnode=leafnode_num;                                                                        
                                      rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)+1)=internode;                      
                else %%%���Ѹ�����Ķ�һ����
                                      rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).timerange.timeend=temptime;  
                                      internode.sum_number=sum_number;
                                      internode.sum_rating(1)=sum_rating(1);
                                      internode.sum_rating(2)=sum_rating(2);
                                      internode.sum_rating(3)=sum_rating(3);
                                      internode.sum_rating(4)=sum_rating(4);
                                      internode.sum_rating(5)=sum_rating(5);
                                      internode.level=0;
                                      internode.pricerange.min_price=rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).pricerange.min_price;   %%internode�ڵ��key
                                      internode.pricerange.max_price=rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).pricerange.max_price;
                                      internode.timerange.timebegin=temptime;
                                      internode.timerange.timeend='*';
                                      internode.leafnode=leafnode_num; 
                                      [internode1_1, internode1_2]=spiltinternode(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode, internode); 
                                      countstar=size(internode1_1, 2);
                                      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����Ĳ��ֿ�������
   if  countstar>=ceil(n_maxcount1*5/6)%%%�����޸�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
      var2=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1,2);
     [starinternode1, starinternode2]=spiltstarinternode(internode1_1, countstar); 
     if  size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1,2)+2<=n_maxcount1 %%var2+2
                               var2=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1,2);
                                        oldtemp=generateold(internode1_2, leaf, rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).timerange.timebegin); 
                                       rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4))=oldtemp;
                                       rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(var2+1)=starinternode1;
                                       rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(var2+2)=starinternode2;  

                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end                                      
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.max_price=leaf.price;
                                  end   
     else %%
                 var3=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2,2);      
                 ptemp(1)=starinternode1;
                 ptemp(2)=starinternode2;
                 oldtemp=generateold(internode1_2, leaf, rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).timerange.timebegin);
                 rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4))=oldtemp;
                [internode2_1, internode2_2]=spiltinternode1(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1, ptemp, rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).timerange.timebegin); %%%����Ҫ�ж�countstar;
                 countstar=size(internode2_2.internode1, 2);
                   if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                       [starinternode1_1, starinternode2_1]=spiltstarinternode1(internode2_2);
                        if size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2,2)+2<=n_maxcount1
                           var3=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2,2);
                          rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3))=internode2_1;  
                          rootnode(j).internode4(w(1)).internode3(w(2)).internode2(var3+1)=starinternode1_1; 
                          rootnode(j).internode4(w(1)).internode3(w(2)).internode2(var3+2)=starinternode2_1; 

                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end                                      
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price=leaf.price;
                                  end 
                              
                        else
                           var4=size(rootnode(j).internode4(w(1)).internode3,2);
                          ptemp1(1)=starinternode1_1; 
                          ptemp1(2)=starinternode2_1; 
                          rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3))=internode2_1;
                         [internode3_1, internode3_2]=spiltinternode2(rootnode(j).internode4(w(1)).internode3(w(2)).internode2, ptemp1, rootnode(j).internode4(w(1)).internode3(w(2)).timerange.timebegin);  
                         countstar=size(internode3_2.internode2, 2);
                         if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                                    if size(rootnode(j).internode4(w(1)).internode3,2)+2<=n_maxcount1
                                       rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1;  
                                       rootnode(j).internode4(w(1)).internode3(var4+1)=starinternode1_2; 
                                       rootnode(j).internode4(w(1)).internode3(var4+2)=starinternode2_2;
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end        
                                    else
                             rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1; 
                             ptemp2(1)=starinternode1_2; 
                             ptemp2(2)=starinternode2_2;
                            [internode4_1, internode4_2]=spiltinternode3(rootnode(j).internode4(w(1)).internode3, ptemp2, rootnode(j).internode4(w(1)).timerange.timebegin); 
                                        countstar=size(internode4_2.internode3, 2);
                                        if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                            if size(rootnode(j).internode4,2)+2<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                         [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                                          rootnode(j).internode4(var5+1)=starinternode3_1;
                                          rootnode(j).internode4(var5+2)=starinternode3_2; 
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end
                                        else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ��Ĳ�
                                            if size(rootnode(j).internode4,2)+1<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                          rootnode(j).internode4(var5+1)=internode4_2;
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end                                                
                                        end                                                   
                                    end                           
                         else  %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ�����
                             if size(rootnode(j).internode4(w(1)).internode3,2)+1<=n_maxcount1
                                rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1;  
                                rootnode(j).internode4(w(1)).internode3(var4+1)=internode3_2;
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end  
                             else
                             rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1; 
                             ptemp2=internode3_2; 
                            [internode4_1, internode4_2]=spiltinternode3(rootnode(j).internode4(w(1)).internode3, ptemp2, rootnode(j).internode4(w(1)).timerange.timebegin); 
                                   countstar=size(internode4_2.internode3, 2);
                                        if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                            if size(rootnode(j).internode4,2)+2<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                         [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                                          rootnode(j).internode4(var5+1)=starinternode3_1;
                                          rootnode(j).internode4(var5+2)=starinternode3_2; 
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end
                                        else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ��Ĳ�
                                            if size(rootnode(j).internode4,2)+1<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                          rootnode(j).internode4(var5+1)=internode4_2;
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end                                                
                                        end 
                             end
                         end
                        end
                   else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵڶ���
                       if size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2,2)+1<=n_maxcount1
                        var3=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2,2);
                     rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3))=internode2_1;  
                     rootnode(j).internode4(w(1)).internode3(w(2)).internode2(var3+1)=internode2_2; 

                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end                                      
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price=leaf.price;
                                  end                                              
                       else
                     var4=size(rootnode(j).internode4(w(1)).internode3,2);
                     ptemp1=internode2_2;                                                 
                     rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3))=internode2_1;
                     [internode3_1, internode3_2]=spiltinternode2(rootnode(j).internode4(w(1)).internode3(w(2)).internode2, ptemp1, rootnode(j).internode4(w(1)).internode3(w(2)).timerange.timebegin);
                     countstar=size(internode3_2.internode2, 2); 
                          if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                                    if size(rootnode(j).internode4(w(1)).internode3,2)+2<=n_maxcount1
                                       rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1;  
                                       rootnode(j).internode4(w(1)).internode3(var4+1)=starinternode1_2; 
                                       rootnode(j).internode4(w(1)).internode3(var4+2)=starinternode2_2;
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end        
                                    else
                             rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1; 
                             ptemp2(1)=starinternode1_2; 
                             ptemp2(2)=starinternode2_2;
                            [internode4_1, internode4_2]=spiltinternode3(rootnode(j).internode4(w(1)).internode3, ptemp2, rootnode(j).internode4(w(1)).timerange.timebegin); 
                                        countstar=size(internode4_2.internode3, 2);
                                        if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                            if size(rootnode(j).internode4,2)+2<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                         [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                                          rootnode(j).internode4(var5+1)=starinternode3_1;
                                          rootnode(j).internode4(var5+2)=starinternode3_2; 
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end
                                        else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ��Ĳ�
                                            if size(rootnode(j).internode4,2)+1<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                          rootnode(j).internode4(var5+1)=internode4_2;
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end                                                
                                        end                                                   
                                    end                           
                         else  %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ�����
                             if size(rootnode(j).internode4(w(1)).internode3,2)+1<=n_maxcount1
                                rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1;  
                                rootnode(j).internode4(w(1)).internode3(var4+1)=internode3_2;
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end  
                             else
                             rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1; 
                             ptemp2=internode3_2; 
                            [internode4_1, internode4_2]=spiltinternode3(rootnode(j).internode4(w(1)).internode3, ptemp2, rootnode(j).internode4(w(1)).timerange.timebegin); 
                                   countstar=size(internode4_2.internode3, 2);
                                        if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                            if size(rootnode(j).internode4,2)+2<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                         [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                                          rootnode(j).internode4(var5+1)=starinternode3_1;
                                          rootnode(j).internode4(var5+2)=starinternode3_2; 
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end
                                        else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ��Ĳ�
                                            if size(rootnode(j).internode4,2)+1<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                          rootnode(j).internode4(var5+1)=internode4_2;
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end                                                
                                        end 
                             end
                         end                                                       
                       end
                   end
     end
   else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ�һ��
       if  size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1,2)+1<=n_maxcount1
               var2=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1,2);
               ptemp=generate(internode1_1);  %%��������һ�����
               oldtemp=generateold(internode1_2, leaf, rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).timerange.timebegin);            
               rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4))=oldtemp;
               rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(var2+1)=ptemp;
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end                                      
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.max_price=leaf.price;
                                  end  
       else
                  var3=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2, 2);
                  ptemp=generate(internode1_1);  %%��������һ�����
                  oldtemp=generateold(internode1_2, leaf, rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).timerange.timebegin);
                  rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4))=oldtemp;
                  [internode2_1, internode2_2]=spiltinternode1(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1, ptemp, rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).timerange.timebegin);
                  countstar=size(internode2_2.internode1, 2);
                   if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                       [starinternode1_1, starinternode2_1]=spiltstarinternode1(internode2_2);
                        if size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2,2)+2<=n_maxcount1
                           var3=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2,2);
                          rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3))=internode2_1;  
                          rootnode(j).internode4(w(1)).internode3(w(2)).internode2(var3+1)=starinternode1_1; 
                          rootnode(j).internode4(w(1)).internode3(w(2)).internode2(var3+2)=starinternode2_1; 

                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end                                      
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price=leaf.price;
                                  end 
                              
                        else
                           var4=size(rootnode(j).internode4(w(1)).internode3,2);
                          ptemp1(1)=starinternode1_1; 
                          ptemp1(2)=starinternode2_1; 
                          rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3))=internode2_1;
                         [internode3_1, internode3_2]=spiltinternode2(rootnode(j).internode4(w(1)).internode3(w(2)).internode2, ptemp1, rootnode(j).internode4(w(1)).internode3(w(2)).timerange.timebegin);  
                         countstar=size(internode3_2.internode2, 2);
                         if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                                    if size(rootnode(j).internode4(w(1)).internode3,2)+2<=n_maxcount1
                                       rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1;  
                                       rootnode(j).internode4(w(1)).internode3(var4+1)=starinternode1_2; 
                                       rootnode(j).internode4(w(1)).internode3(var4+2)=starinternode2_2;
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end        
                                    else
                             rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1; 
                             ptemp2(1)=starinternode1_2; 
                             ptemp2(2)=starinternode2_2;
                            [internode4_1, internode4_2]=spiltinternode3(rootnode(j).internode4(w(1)).internode3, ptemp2, rootnode(j).internode4(w(1)).timerange.timebegin); 
                                        countstar=size(internode4_2.internode3, 2);
                                        if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                            if size(rootnode(j).internode4,2)+2<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                         [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                                          rootnode(j).internode4(var5+1)=starinternode3_1;
                                          rootnode(j).internode4(var5+2)=starinternode3_2; 
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end
                                        else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ��Ĳ�
                                            if size(rootnode(j).internode4,2)+1<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                          rootnode(j).internode4(var5+1)=internode4_2;
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end                                                
                                        end                                                   
                                    end                           
                         else  %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ�����
                             if size(rootnode(j).internode4(w(1)).internode3,2)+1<=n_maxcount1
                                rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1;  
                                rootnode(j).internode4(w(1)).internode3(var4+1)=internode3_2;
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end  
                             else
                             rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1; 
                             ptemp2=internode3_2; 
                            [internode4_1, internode4_2]=spiltinternode3(rootnode(j).internode4(w(1)).internode3, ptemp2, rootnode(j).internode4(w(1)).timerange.timebegin); 
                                   countstar=size(internode4_2.internode3, 2);
                                        if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                            if size(rootnode(j).internode4,2)+2<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                         [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                                          rootnode(j).internode4(var5+1)=starinternode3_1;
                                          rootnode(j).internode4(var5+2)=starinternode3_2; 
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end
                                        else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ��Ĳ�
                                            if size(rootnode(j).internode4,2)+1<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                          rootnode(j).internode4(var5+1)=internode4_2;
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end                                                
                                        end 
                             end
                         end
                        end
                   else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵڶ���
                       if size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2,2)+1<=n_maxcount1
                        var3=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2,2);
                     rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3))=internode2_1;  
                     rootnode(j).internode4(w(1)).internode3(w(2)).internode2(var3+1)=internode2_2; 

                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end                                      
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price=leaf.price;
                                  end                                              
                       else
                     var4=size(rootnode(j).internode4(w(1)).internode3,2);
                     ptemp1=internode2_2;                                                 
                     rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3))=internode2_1;
                     [internode3_1, internode3_2]=spiltinternode2(rootnode(j).internode4(w(1)).internode3(w(2)).internode2, ptemp1, rootnode(j).internode4(w(1)).internode3(w(2)).timerange.timebegin);
                     countstar=size(internode3_2.internode2, 2); 
                          if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                                    if size(rootnode(j).internode4(w(1)).internode3,2)+2<=n_maxcount1
                                       rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1;  
                                       rootnode(j).internode4(w(1)).internode3(var4+1)=starinternode1_2; 
                                       rootnode(j).internode4(w(1)).internode3(var4+2)=starinternode2_2;
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end        
                                    else
                             rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1; 
                             ptemp2(1)=starinternode1_2; 
                             ptemp2(2)=starinternode2_2;
                            [internode4_1, internode4_2]=spiltinternode3(rootnode(j).internode4(w(1)).internode3, ptemp2, rootnode(j).internode4(w(1)).timerange.timebegin); 
                                        countstar=size(internode4_2.internode3, 2);
                                        if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                            if size(rootnode(j).internode4,2)+2<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                         [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                                          rootnode(j).internode4(var5+1)=starinternode3_1;
                                          rootnode(j).internode4(var5+2)=starinternode3_2; 
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end
                                        else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ��Ĳ�
                                            if size(rootnode(j).internode4,2)+1<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                          rootnode(j).internode4(var5+1)=internode4_2;
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end                                                
                                        end                                                   
                                    end                           
                         else  %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ�����
                             if size(rootnode(j).internode4(w(1)).internode3,2)+1<=n_maxcount1
                                rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1;  
                                rootnode(j).internode4(w(1)).internode3(var4+1)=internode3_2;
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end  
                             else
                             rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1; 
                             ptemp2=internode3_2; 
                            [internode4_1, internode4_2]=spiltinternode3(rootnode(j).internode4(w(1)).internode3, ptemp2, rootnode(j).internode4(w(1)).timerange.timebegin); 
                                   countstar=size(internode4_2.internode3, 2);
                                        if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                            if size(rootnode(j).internode4,2)+2<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                         [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                                          rootnode(j).internode4(var5+1)=starinternode3_1;
                                          rootnode(j).internode4(var5+2)=starinternode3_2; 
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end
                                        else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ��Ĳ�
                                            if size(rootnode(j).internode4,2)+1<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                          rootnode(j).internode4(var5+1)=internode4_2;
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end                                                
                                        end 
                             end
                         end                                                       
                       end
                   end                  
       
       end    
   end                                                                                          
                end
            elseif mark==0             
                 rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).sum_number=sum_number;
                 rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).sum_rating(1)=sum_rating(1);
                 rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).sum_rating(2)=sum_rating(2);
                 rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).sum_rating(3)=sum_rating(3);
                 rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).sum_rating(4)=sum_rating(4);
                 rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).sum_rating(5)=sum_rating(5);
                 rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).leafnode=leafnode_num;          
            end
            
       elseif same==1
                 rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).sum_number=sum_number;
                 rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).sum_rating(1)=sum_rating(1);
                 rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).sum_rating(2)=sum_rating(2);
                 rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).sum_rating(3)=sum_rating(3);
                 rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).sum_rating(4)=sum_rating(4);
                 rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).sum_rating(5)=sum_rating(5);
                 rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).leafnode=leafnode_num;            
           
       end
             else
              [internode_1, internode_2, totalleafnode]=spiltleafnode(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)), leaf, j, totalleafnode); %%Ҷ�ӷ���
              var1=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode, 2);
              if   var1+2<=n_maxcount1 %%���±�
                            rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).timerange.timeend=internode_1.timerange.timebegin;
                            rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(var1+1)=internode_1;                           
                            rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(var1+2)=internode_2; 
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end                                      
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.max_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).pricerange.max_price=leaf.price;
                                  end                          
              else %%var1+2
     rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode(w(5)).timerange.timeend=internode_1.timerange.timebegin;                                    
    spilttempnode(1)=internode_1;
    spilttempnode(2)=internode_2;
    [internode1_1, internode1_2]=spiltinternode(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).internode, spilttempnode);
     countstar=size(internode1_1, 2);   
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ��������ȫ��������2152
   if  countstar>=ceil(n_maxcount1*5/6)%%%�����޸�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
      var2=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1,2);
     [starinternode1, starinternode2]=spiltstarinternode(internode1_1, countstar); 
     if  size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1,2)+2<=n_maxcount1 %%var2+2
                               var2=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1,2);
                                        oldtemp=generateold(internode1_2, leaf, rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).timerange.timebegin); 
                                       rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4))=oldtemp;
                                       rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(var2+1)=starinternode1;
                                       rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(var2+2)=starinternode2;  

                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end                                      
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.max_price=leaf.price;
                                  end   
     else %%
                 var3=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2,2);      
                 ptemp(1)=starinternode1;
                 ptemp(2)=starinternode2;
                 oldtemp=generateold(internode1_2, leaf, rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).timerange.timebegin);
                 rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4))=oldtemp;
                [internode2_1, internode2_2]=spiltinternode1(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1, ptemp, rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).timerange.timebegin); %%%����Ҫ�ж�countstar;
                 countstar=size(internode2_2.internode1, 2);
                   if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                       [starinternode1_1, starinternode2_1]=spiltstarinternode1(internode2_2);
                        if size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2,2)+2<=n_maxcount1
                           var3=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2,2);
                          rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3))=internode2_1;  
                          rootnode(j).internode4(w(1)).internode3(w(2)).internode2(var3+1)=starinternode1_1; 
                          rootnode(j).internode4(w(1)).internode3(w(2)).internode2(var3+2)=starinternode2_1; 

                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end                                      
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price=leaf.price;
                                  end 
                              
                        else
                           var4=size(rootnode(j).internode4(w(1)).internode3,2);
                          ptemp1(1)=starinternode1_1; 
                          ptemp1(2)=starinternode2_1; 
                          rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3))=internode2_1;
                         [internode3_1, internode3_2]=spiltinternode2(rootnode(j).internode4(w(1)).internode3(w(2)).internode2, ptemp1, rootnode(j).internode4(w(1)).internode3(w(2)).timerange.timebegin);  
                         countstar=size(internode3_2.internode2, 2);
                         if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                                    if size(rootnode(j).internode4(w(1)).internode3,2)+2<=n_maxcount1
                                       rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1;  
                                       rootnode(j).internode4(w(1)).internode3(var4+1)=starinternode1_2; 
                                       rootnode(j).internode4(w(1)).internode3(var4+2)=starinternode2_2;
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end        
                                    else
                             rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1; 
                             ptemp2(1)=starinternode1_2; 
                             ptemp2(2)=starinternode2_2;
                            [internode4_1, internode4_2]=spiltinternode3(rootnode(j).internode4(w(1)).internode3, ptemp2, rootnode(j).internode4(w(1)).timerange.timebegin); 
                                        countstar=size(internode4_2.internode3, 2);
                                        if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                            if size(rootnode(j).internode4,2)+2<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                         [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                                          rootnode(j).internode4(var5+1)=starinternode3_1;
                                          rootnode(j).internode4(var5+2)=starinternode3_2; 
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end
                                        else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ��Ĳ�
                                            if size(rootnode(j).internode4,2)+1<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                          rootnode(j).internode4(var5+1)=internode4_2;
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end                                                
                                        end                                                   
                                    end                           
                         else  %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ�����
                             if size(rootnode(j).internode4(w(1)).internode3,2)+1<=n_maxcount1
                                rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1;  
                                rootnode(j).internode4(w(1)).internode3(var4+1)=internode3_2;
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end  
                             else
                             rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1; 
                             ptemp2=internode3_2; 
                            [internode4_1, internode4_2]=spiltinternode3(rootnode(j).internode4(w(1)).internode3, ptemp2, rootnode(j).internode4(w(1)).timerange.timebegin); 
                                   countstar=size(internode4_2.internode3, 2);
                                        if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                            if size(rootnode(j).internode4,2)+2<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                         [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                                          rootnode(j).internode4(var5+1)=starinternode3_1;
                                          rootnode(j).internode4(var5+2)=starinternode3_2; 
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end
                                        else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ��Ĳ�
                                            if size(rootnode(j).internode4,2)+1<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                          rootnode(j).internode4(var5+1)=internode4_2;
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end                                                
                                        end 
                             end
                         end
                        end
                   else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵڶ���
                       if size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2,2)+1<=n_maxcount1
                        var3=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2,2);
                     rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3))=internode2_1;  
                     rootnode(j).internode4(w(1)).internode3(w(2)).internode2(var3+1)=internode2_2; 

                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end                                      
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price=leaf.price;
                                  end                                              
                       else
                     var4=size(rootnode(j).internode4(w(1)).internode3,2);
                     ptemp1=internode2_2;                                                 
                     rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3))=internode2_1;
                     [internode3_1, internode3_2]=spiltinternode2(rootnode(j).internode4(w(1)).internode3(w(2)).internode2, ptemp1, rootnode(j).internode4(w(1)).internode3(w(2)).timerange.timebegin);
                     countstar=size(internode3_2.internode2, 2); 
                          if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                                    if size(rootnode(j).internode4(w(1)).internode3,2)+2<=n_maxcount1
                                       rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1;  
                                       rootnode(j).internode4(w(1)).internode3(var4+1)=starinternode1_2; 
                                       rootnode(j).internode4(w(1)).internode3(var4+2)=starinternode2_2;
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end        
                                    else
                             rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1; 
                             ptemp2(1)=starinternode1_2; 
                             ptemp2(2)=starinternode2_2;
                            [internode4_1, internode4_2]=spiltinternode3(rootnode(j).internode4(w(1)).internode3, ptemp2, rootnode(j).internode4(w(1)).timerange.timebegin); 
                                        countstar=size(internode4_2.internode3, 2);
                                        if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                            if size(rootnode(j).internode4,2)+2<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                         [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                                          rootnode(j).internode4(var5+1)=starinternode3_1;
                                          rootnode(j).internode4(var5+2)=starinternode3_2; 
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end
                                        else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ��Ĳ�
                                            if size(rootnode(j).internode4,2)+1<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                          rootnode(j).internode4(var5+1)=internode4_2;
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end                                                
                                        end                                                   
                                    end                           
                         else  %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ�����
                             if size(rootnode(j).internode4(w(1)).internode3,2)+1<=n_maxcount1
                                rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1;  
                                rootnode(j).internode4(w(1)).internode3(var4+1)=internode3_2;
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end  
                             else
                             rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1; 
                             ptemp2=internode3_2; 
                            [internode4_1, internode4_2]=spiltinternode3(rootnode(j).internode4(w(1)).internode3, ptemp2, rootnode(j).internode4(w(1)).timerange.timebegin); 
                                   countstar=size(internode4_2.internode3, 2);
                                        if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                            if size(rootnode(j).internode4,2)+2<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                         [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                                          rootnode(j).internode4(var5+1)=starinternode3_1;
                                          rootnode(j).internode4(var5+2)=starinternode3_2; 
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end
                                        else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ��Ĳ�
                                            if size(rootnode(j).internode4,2)+1<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                          rootnode(j).internode4(var5+1)=internode4_2;
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end                                                
                                        end 
                             end
                         end                                                       
                       end
                   end
     end
   else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ�һ��
       if  size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1,2)+1<=n_maxcount1
               var2=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1,2);
               ptemp=generate(internode1_1);  %%��������һ�����
               oldtemp=generateold(internode1_2, leaf, rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).timerange.timebegin);            
               rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4))=oldtemp;
               rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(var2+1)=ptemp;
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end                                      
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).pricerange.max_price=leaf.price;
                                  end  
       else
                  var3=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2, 2);
                  ptemp=generate(internode1_1);  %%��������һ�����
                  oldtemp=generateold(internode1_2, leaf, rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4)).timerange.timebegin);
                  rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1(w(4))=oldtemp;
                  [internode2_1, internode2_2]=spiltinternode1(rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).internode1, ptemp, rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3)).timerange.timebegin);
                  countstar=size(internode2_2.internode1, 2);
                   if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                       [starinternode1_1, starinternode2_1]=spiltstarinternode1(internode2_2);
                        if size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2,2)+2<=n_maxcount1
                           var3=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2,2);
                          rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3))=internode2_1;  
                          rootnode(j).internode4(w(1)).internode3(w(2)).internode2(var3+1)=starinternode1_1; 
                          rootnode(j).internode4(w(1)).internode3(w(2)).internode2(var3+2)=starinternode2_1; 

                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end                                      
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price=leaf.price;
                                  end 
                              
                        else
                           var4=size(rootnode(j).internode4(w(1)).internode3,2);
                          ptemp1(1)=starinternode1_1; 
                          ptemp1(2)=starinternode2_1; 
                          rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3))=internode2_1;
                         [internode3_1, internode3_2]=spiltinternode2(rootnode(j).internode4(w(1)).internode3(w(2)).internode2, ptemp1, rootnode(j).internode4(w(1)).internode3(w(2)).timerange.timebegin);  
                         countstar=size(internode3_2.internode2, 2);
                         if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                                    if size(rootnode(j).internode4(w(1)).internode3,2)+2<=n_maxcount1
                                       rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1;  
                                       rootnode(j).internode4(w(1)).internode3(var4+1)=starinternode1_2; 
                                       rootnode(j).internode4(w(1)).internode3(var4+2)=starinternode2_2;
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end        
                                    else
                             rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1; 
                             ptemp2(1)=starinternode1_2; 
                             ptemp2(2)=starinternode2_2;
                            [internode4_1, internode4_2]=spiltinternode3(rootnode(j).internode4(w(1)).internode3, ptemp2, rootnode(j).internode4(w(1)).timerange.timebegin); 
                                        countstar=size(internode4_2.internode3, 2);
                                        if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                            if size(rootnode(j).internode4,2)+2<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                         [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                                          rootnode(j).internode4(var5+1)=starinternode3_1;
                                          rootnode(j).internode4(var5+2)=starinternode3_2; 
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end
                                        else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ��Ĳ�
                                            if size(rootnode(j).internode4,2)+1<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                          rootnode(j).internode4(var5+1)=internode4_2;
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end                                                
                                        end                                                   
                                    end                           
                         else  %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ�����
                             if size(rootnode(j).internode4(w(1)).internode3,2)+1<=n_maxcount1
                                rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1;  
                                rootnode(j).internode4(w(1)).internode3(var4+1)=internode3_2;
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end  
                             else
                             rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1; 
                             ptemp2=internode3_2; 
                            [internode4_1, internode4_2]=spiltinternode3(rootnode(j).internode4(w(1)).internode3, ptemp2, rootnode(j).internode4(w(1)).timerange.timebegin); 
                                   countstar=size(internode4_2.internode3, 2);
                                        if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                            if size(rootnode(j).internode4,2)+2<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                         [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                                          rootnode(j).internode4(var5+1)=starinternode3_1;
                                          rootnode(j).internode4(var5+2)=starinternode3_2; 
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end
                                        else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ��Ĳ�
                                            if size(rootnode(j).internode4,2)+1<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                          rootnode(j).internode4(var5+1)=internode4_2;
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end                                                
                                        end 
                             end
                         end
                        end
                   else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵڶ���
                       if size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2,2)+1<=n_maxcount1
                        var3=size(rootnode(j).internode4(w(1)).internode3(w(2)).internode2,2);
                     rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3))=internode2_1;  
                     rootnode(j).internode4(w(1)).internode3(w(2)).internode2(var3+1)=internode2_2; 

                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end                                      
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).internode3(w(2)).pricerange.max_price=leaf.price;
                                  end                                              
                       else
                     var4=size(rootnode(j).internode4(w(1)).internode3,2);
                     ptemp1=internode2_2;                                                 
                     rootnode(j).internode4(w(1)).internode3(w(2)).internode2(w(3))=internode2_1;
                     [internode3_1, internode3_2]=spiltinternode2(rootnode(j).internode4(w(1)).internode3(w(2)).internode2, ptemp1, rootnode(j).internode4(w(1)).internode3(w(2)).timerange.timebegin);
                     countstar=size(internode3_2.internode2, 2); 
                          if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                             [starinternode1_2, starinternode2_2]=spiltstarinternode2(internode3_2);
                                    if size(rootnode(j).internode4(w(1)).internode3,2)+2<=n_maxcount1
                                       rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1;  
                                       rootnode(j).internode4(w(1)).internode3(var4+1)=starinternode1_2; 
                                       rootnode(j).internode4(w(1)).internode3(var4+2)=starinternode2_2;
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end        
                                    else
                             rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1; 
                             ptemp2(1)=starinternode1_2; 
                             ptemp2(2)=starinternode2_2;
                            [internode4_1, internode4_2]=spiltinternode3(rootnode(j).internode4(w(1)).internode3, ptemp2, rootnode(j).internode4(w(1)).timerange.timebegin); 
                                        countstar=size(internode4_2.internode3, 2);
                                        if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                            if size(rootnode(j).internode4,2)+2<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                         [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                                          rootnode(j).internode4(var5+1)=starinternode3_1;
                                          rootnode(j).internode4(var5+2)=starinternode3_2; 
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end
                                        else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ��Ĳ�
                                            if size(rootnode(j).internode4,2)+1<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                          rootnode(j).internode4(var5+1)=internode4_2;
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end                                                
                                        end                                                   
                                    end                           
                         else  %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ�����
                             if size(rootnode(j).internode4(w(1)).internode3,2)+1<=n_maxcount1
                                rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1;  
                                rootnode(j).internode4(w(1)).internode3(var4+1)=internode3_2;
                                  if   rootnode(j).internode4(w(1)).pricerange.min_price>leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.min_price=leaf.price;
                                  end
                                  if   rootnode(j).internode4(w(1)).pricerange.max_price<leaf.price
                                      rootnode(j).internode4(w(1)).pricerange.max_price=leaf.price;
                                  end  
                             else
                             rootnode(j).internode4(w(1)).internode3(w(2))=internode3_1; 
                             ptemp2=internode3_2; 
                            [internode4_1, internode4_2]=spiltinternode3(rootnode(j).internode4(w(1)).internode3, ptemp2, rootnode(j).internode4(w(1)).timerange.timebegin); 
                                   countstar=size(internode4_2.internode3, 2);
                                        if countstar>=ceil(n_maxcount1*5/6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ɸ�
                                            if size(rootnode(j).internode4,2)+2<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                         [starinternode3_1, starinternode3_2]=spiltstarinternode3(internode4_2); 
                                          rootnode(j).internode4(var5+1)=starinternode3_1;
                                          rootnode(j).internode4(var5+2)=starinternode3_2; 
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end
                                        else %countstar>=ceil(n_maxcount1*5/6)%�ʼ�ĵ��Ĳ�
                                            if size(rootnode(j).internode4,2)+1<=n_maxcount1
                                               var5=size(rootnode(j).internode4,2);  
                                          rootnode(j).internode4(w(1))=internode4_1;
                                          rootnode(j).internode4(var5+1)=internode4_2;
                                            else
                                                test='������';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                            end                                                
                                        end 
                             end
                         end                                                       
                       end
                   end                  
       
       end    
   end
              end
             end
                end %%% rootnode(j).n_level==1     
                                
        rootnode(j).sum_number=rootnode(j).sum_number+1;
        rootnode(j).sum_rating(1)=rootnode(j).sum_rating(1)+str2double((CC.rating1(1)));
        rootnode(j).sum_rating(2)=rootnode(j).sum_rating(2)+str2double((CC.rating1(2)));
        rootnode(j).sum_rating(3)=rootnode(j).sum_rating(3)+str2double((CC.rating1(3)));
        rootnode(j).sum_rating(4)=rootnode(j).sum_rating(4)+str2double((CC.rating1(4)));
        rootnode(j).sum_rating(5)=rootnode(j).sum_rating(5)+str2double((CC.rating1(5)));
              if rootnode(j).minprice>round(str2double(cell2mat(CC.itemprice(i))))
                  rootnode(j).minprice=round(str2double(cell2mat(CC.itemprice(i))));
              end
              if rootnode(j).maxprice<round(str2double(cell2mat(CC.itemprice(i))))
                  
                  rootnode(j).maxprice=round(str2double(cell2mat(CC.itemprice(i))));
              end
                  break;
            end
                     
       end
       
   if rootexistmark==0
    rootnumber=rootnumber+1;
    rootnode(rootnumber).ctree=CC.cid(i);
    
    %% node����ֻ��һ���ڵ�
%     rootnode(rootnumber).n_count=1;
    rootnode(rootnumber).sum_number=1;
    rootnode(rootnumber).sum_rating(1)=str2double((CC.rating1(1)));
    rootnode(rootnumber).sum_rating(2)=str2double((CC.rating2(1)));
    rootnode(rootnumber).sum_rating(3)=str2double((CC.rating3(1)));
    rootnode(rootnumber).sum_rating(4)=str2double((CC.rating4(1)));
    rootnode(rootnumber).sum_rating(5)=str2double((CC.rating5(1)));
    %% Ҷ�Ӷ��ڵ�0��
    rootnode(rootnumber).n_level=1;
    %%
    
    
     
    leafnode.leaf=leaf;
    leafnode.number=1;
    totalleafnode(rootnumber, leafnode.number)=leafnode;
    rootnode(rootnumber).minprice=round(str2double(cell2mat(CC.itemprice(i))));
    rootnode(rootnumber).maxprice=round(str2double(cell2mat(CC.itemprice(i))));
    
%     internode.within_number=0;
%     internode.within_rating=0;
    internode.sum_number=1;
    internode.sum_rating(1)=str2double((CC.rating1(i)));
    internode.sum_rating(2)=str2double((CC.rating2(i)));
    internode.sum_rating(3)=str2double((CC.rating3(i)));
    internode.sum_rating(4)=str2double((CC.rating4(i)));
    internode.sum_rating(5)=str2double((CC.rating5(i)));
    internode.level=0;
    internode.pricerange.min_price=leafnode.leaf.price;   %%internode�ڵ��key
    internode.pricerange.max_price=leafnode.leaf.price;
    internode.timerange.timebegin=leafnode.leaf.time;
    internode.timerange.timeend='*';
    internode.leafnode=leafnode.number;%%%Ҷ�����ڰ汾��totalleafnode�����ҵ�
    rootnode(rootnumber).internode=internode;   
   end
        
       rootexistmark=0;
       
   end
   
end

