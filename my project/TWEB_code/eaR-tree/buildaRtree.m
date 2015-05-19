function [rootnode]=buildaRtree(CC)

% conna=database('haibin0332','','');
% 
% setdbprefs ('DataReturnFormat','structure'); %%//?????
% % 
% cursorC=exec(conna,['select * from testdata order by time ASC']); %#ok<NBRAK> %%//????
% % 
% 
% cursorC=fetch(cursorC);
% 
% CC=cursorC.Data;



%% Ҷ�ӽ�����ж��ٸ�ʵ��������1900��


%% ���ڵ���м�ڵ��������ͣ�2��ֻ���categoryһ����Ŀ
n_maxcount=51;  %%����Ҷ�ӽڵ���װ���ٸ�
n_maxcount1=36;  %%�����Ҷ�ӽڵ���װ���ٸ�
%% node�ڵ�������ٸ�leafnode����internode,mark��ʾnode�ڵ�����Ҷ�ӽڵ㻹���м�ڵ�0ΪҶ��1Ϊ�м�ڵ�,
%%m_count����node�а������ٸ��ڵ�,n_level��node���ڲ㣬
%%n_maxcount ��ʾnode�ڵ��в��ܳ������ٸ�branch
%rootnode=struct('subcategory',{},'category',{}, 'sum_number', {}, 'sum_rating', {}, 'pricerange',{},  'timerange',{}, 'n_count',{}, 'n_level',{}, 'internode',{});

%%
%%internode=struct('sum_number', {}, 'sum_rating', {}, 'pricerange',{},  'timerange',{});
%%leafnode = struct('itemname',{},'rating',{},'price',{}, 'time',{});
%%

% pricerange=struct('min_price',{},'max_price',{});
% timerange=struct('min_time',{},'max_time',{});


%%��һ��node�ڵ��ʼ��
    
    rootnode(1).ctree=CC.cid(1);
    rootnode(1).sum_number=1;
    rootnode(1).sum_rating(1)=str2double((CC.rating1(1)));
    rootnode(1).sum_rating(2)=str2double((CC.rating2(1)));
    rootnode(1).sum_rating(3)=str2double((CC.rating3(1)));
    rootnode(1).sum_rating(4)=str2double((CC.rating4(1)));
    rootnode(1).sum_rating(5)=str2double((CC.rating5(1)));
    rootnode(1).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(1))));
    rootnode(1).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(1))));
    rootnode(1).timerange.min_time=timechange(cell2mat(CC.time(1)));
    rootnode(1).timerange.max_time=timechange(cell2mat(CC.time(1))); 
    
    %% node����ֻ��һ���ڵ�
   % rootnode(1).n_count=1;
    %% Ҷ�Ӷ��ڵ�0��
    rootnode(1).n_level=0;
    %%
    rootnode(1).leafnode(1).itemname=CC.itemtitle(1);
    rootnode(1).leafnode(1).price=round(str2double(cell2mat(CC.itemprice(1))));
    rootnode(1).leafnode(1).time=timechange(cell2mat(CC.time(1)));
    rootnode(1).leafnode(1).sum=1;
    rootnode(1).leafnode(1).rating(1)=str2double((CC.rating1(1)));
    rootnode(1).leafnode(1).rating(2)=str2double((CC.rating2(1)));
    rootnode(1).leafnode(1).rating(3)=str2double((CC.rating3(1)));
    rootnode(1).leafnode(1).rating(4)=str2double((CC.rating4(1)));
    rootnode(1).leafnode(1).rating(5)=str2double((CC.rating5(1)));
    
   rootnumber=1; %% ��¼���ĸ���
   rootexistmark=0;%% ������в����������Ϊ0����Ϊ1��
   
    
%% �ӵڶ����ڵ㿪ʼ����
for i=2:1:size(CC.itemtitle, 1)
     %% �ڵ��ȼ��뵽rootnode
   for j=1:1:rootnumber   %%ɨ������rootnode
       
    if  strcmp(rootnode(j).ctree, CC.cid(i))==1  %%�µĽڵ�������rootnode���½�һ�� 
        rootexistmark=1;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%% ��һ���ϲ���342
if   rootnode(j).n_level==0
                 [pot, same]=sameitem(rootnode(j).leafnode,CC.itemtitle(i), CC.time(i));
                 leaf_num=size(rootnode(j).leafnode, 2);
                 if  same==1
    rootnode(j).leafnode(pot).sum=rootnode(j).leafnode(pot).sum+1;
    rootnode(j).leafnode(pot).rating(1)=rootnode(j).leafnode(pot).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).leafnode(pot).rating(2)=rootnode(j).leafnode(pot).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).leafnode(pot).rating(3)=rootnode(j).leafnode(pot).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).leafnode(pot).rating(4)=rootnode(j).leafnode(pot).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).leafnode(pot).rating(5)=rootnode(j).leafnode(pot).rating(5)+str2double((CC.rating5(i)));

                 elseif same==0
                     
 if  ( (leaf_num+1) <= n_maxcount )  %%����ڵ����û����node��������ָ��Ҷ�ӽڵ�
%     %% Ҷ�ӽڵ����node 

    if  rootnode(j).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ��С
        rootnode(j).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end 
    
    if rootnode(j).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ����
        rootnode(j).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end 
    
    
    rootnode(j).timerange.max_time=timechange(cell2mat(CC.time(i))); 
    

    %%
    rootnode(j).leafnode(leaf_num+1).itemname=CC.itemtitle(i);
    rootnode(j).leafnode(leaf_num+1).price=round(str2double(cell2mat(CC.itemprice(i))));
    rootnode(j).leafnode(leaf_num+1).time=timechange(cell2mat(CC.time(i)));
    rootnode(j).leafnode(leaf_num+1).sum=1;
    rootnode(j).leafnode(leaf_num+1).rating(1)=str2double((CC.rating1(i)));
    rootnode(j).leafnode(leaf_num+1).rating(2)=str2double((CC.rating2(i)));
    rootnode(j).leafnode(leaf_num+1).rating(3)=str2double((CC.rating3(i)));
    rootnode(j).leafnode(leaf_num+1).rating(4)=str2double((CC.rating4(i)));
    rootnode(j).leafnode(leaf_num+1).rating(5)=str2double((CC.rating5(i)));
    
    
elseif  ( (leaf_num+1) > n_maxcount )
    
  %'timerange',{}, 'n_count',{}, 'n_level',{}, 'leafnode',{}, 'internode',{});
%%��������� ���з���
    rootnode(j).n_level=rootnode(j).n_level+1; %%��������1      
    rootnode(j).timerange.max_time=timechange(cell2mat(CC.time(i))); 
       
     for k=1:1:leaf_num       
        temp(1,k)=rootnode(j).leafnode(k).price;
        temp(2,k)=rootnode(j).leafnode(k).time;
        temp(3,k)=0;
     end
    temp(1,(k+1))=round(str2double(cell2mat(CC.itemprice(i))));
    temp(2,(k+1))=timechange(cell2mat(CC.time(i)));
    temp(3,(k+1))=0;
    
 worst=0;
   
 if (rootnode(j).pricerange.max_price-rootnode(j).pricerange.min_price)>0
    for k1=1:1:(leaf_num)             
        for  k2=(k1+1):1:(leaf_num+1)  
            if rootnode(j).timerange.max_time>rootnode(j).timerange.min_time
            waste=sqrt(((temp(1,k1)- temp(1,k2))/(rootnode(j).pricerange.max_price-rootnode(j).pricerange.min_price))^2+(((temp(2,k1)- temp(2,k2))/(rootnode(j).timerange.max_time-rootnode(j).timerange.min_time))^2));             
            else
              waste=sqrt(((temp(1,k1)- temp(1,k2))/(rootnode(j).pricerange.max_price-rootnode(j).pricerange.min_price))^2);   
            end
            if  waste>worst               
                worst=waste;
                seed0=k1;
                seed1=k2;                       
            end
        end     
    end     
 end
 
  if (rootnode(j).pricerange.max_price-rootnode(j).pricerange.min_price)==0               
                seed0=1;
                seed1=leaf_num+1; 
 end
 
    rootnode(j).internode(1).n_level=0; 
    %internode=struct('sum_number', {}, 'sum_rating', {}, 'pricerange',{}, 'timerange',{}, 'n_count',{}, 'n_level',{}, 'leafnode',{}, 'internode',{});
    if seed0==(leaf_num+1) %%%rootnode(j).n_count ---leaf_num
   rootnode(j).internode(1).leafnode(1).itemname=CC.itemtitle(i);
   rootnode(j).internode(1).sum=1;
   rootnode(j).internode(1).leafnode(1).sum=1;
   rootnode(j).internode(1).leafnode(1).rating(1)=str2double((CC.rating1(i)));
   rootnode(j).internode(1).leafnode(1).rating(2)=str2double((CC.rating2(i)));
   rootnode(j).internode(1).leafnode(1).rating(3)=str2double((CC.rating3(i)));
   rootnode(j).internode(1).leafnode(1).rating(4)=str2double((CC.rating4(i)));
   rootnode(j).internode(1).leafnode(1).rating(5)=str2double((CC.rating5(i)));
    else
   rootnode(j).internode(1).leafnode(1).itemname=rootnode(j).leafnode(seed0).itemname;
   rootnode(j).internode(1).sum=rootnode(j).leafnode(seed0).sum;
   rootnode(j).internode(1).leafnode(1).sum=rootnode(j).leafnode(seed0).sum;
   rootnode(j).internode(1).leafnode(1).rating(1)=rootnode(j).leafnode(seed0).rating(1);
   rootnode(j).internode(1).leafnode(1).rating(2)=rootnode(j).leafnode(seed0).rating(2);
   rootnode(j).internode(1).leafnode(1).rating(3)=rootnode(j).leafnode(seed0).rating(3);
   rootnode(j).internode(1).leafnode(1).rating(4)=rootnode(j).leafnode(seed0).rating(4);
   rootnode(j).internode(1).leafnode(1).rating(5)=rootnode(j).leafnode(seed0).rating(5);
    end
   rootnode(j).internode(1).leafnode(1).price=temp(1,seed0);
   rootnode(j).internode(1).leafnode(1).time=temp(2,seed0);  
   rootnode(j).internode(1).rating(1)=rootnode(j).internode(1).leafnode(1).rating(1);
   rootnode(j).internode(1).rating(2)=rootnode(j).internode(1).leafnode(1).rating(2);
   rootnode(j).internode(1).rating(3)=rootnode(j).internode(1).leafnode(1).rating(3);
   rootnode(j).internode(1).rating(4)=rootnode(j).internode(1).leafnode(1).rating(4);
   rootnode(j).internode(1).rating(5)=rootnode(j).internode(1).leafnode(1).rating(5);
   rootnode(j).internode(1).pricerange.max_price=rootnode(j).internode(1).leafnode(1).price;
   rootnode(j).internode(1).pricerange.min_price=rootnode(j).internode(1).leafnode(1).price;
   rootnode(j).internode(1).timerange.max_time=rootnode(j).internode(1).leafnode(1).time;
   rootnode(j).internode(1).timerange.min_time=rootnode(j).internode(1).leafnode(1).time;
   temp(3,seed0)=1;   
    rootnode(j).internode(2).n_level=0;   
    if seed1==(leaf_num+1)
   rootnode(j).internode(2).leafnode(1).itemname=CC.itemtitle(i);
   rootnode(j).internode(2).sum=1;
   rootnode(j).internode(2).leafnode(1).sum=1;
   rootnode(j).internode(2).leafnode(1).rating(1)=str2double((CC.rating1(i)));
   rootnode(j).internode(2).leafnode(1).rating(2)=str2double((CC.rating2(i)));
   rootnode(j).internode(2).leafnode(1).rating(3)=str2double((CC.rating3(i)));
   rootnode(j).internode(2).leafnode(1).rating(4)=str2double((CC.rating4(i)));
   rootnode(j).internode(2).leafnode(1).rating(5)=str2double((CC.rating5(i)));   
    else
   rootnode(j).internode(2).leafnode(1).itemname=rootnode(j).leafnode(seed1).itemname;
   rootnode(j).internode(2).sum=rootnode(j).leafnode(seed1).sum;
   rootnode(j).internode(2).leafnode(1).sum=rootnode(j).leafnode(seed1).sum;
   rootnode(j).internode(2).leafnode(1).rating(1)=rootnode(j).leafnode(seed1).rating(1);
   rootnode(j).internode(2).leafnode(1).rating(2)=rootnode(j).leafnode(seed1).rating(2);
   rootnode(j).internode(2).leafnode(1).rating(3)=rootnode(j).leafnode(seed1).rating(3);
   rootnode(j).internode(2).leafnode(1).rating(4)=rootnode(j).leafnode(seed1).rating(4);
   rootnode(j).internode(2).leafnode(1).rating(5)=rootnode(j).leafnode(seed1).rating(5);
    end
   rootnode(j).internode(2).leafnode(1).price=temp(1,seed1);
   rootnode(j).internode(2).leafnode(1).time=temp(2,seed1);
   rootnode(j).internode(2).rating(1)=rootnode(j).internode(2).leafnode(1).rating(1);
   rootnode(j).internode(2).rating(2)=rootnode(j).internode(2).leafnode(1).rating(2);
   rootnode(j).internode(2).rating(3)=rootnode(j).internode(2).leafnode(1).rating(3);
   rootnode(j).internode(2).rating(4)=rootnode(j).internode(2).leafnode(1).rating(4);
   rootnode(j).internode(2).rating(5)=rootnode(j).internode(2).leafnode(1).rating(5);
   rootnode(j).internode(2).pricerange.max_price=rootnode(j).internode(2).leafnode(1).price;
   rootnode(j).internode(2).pricerange.min_price=rootnode(j).internode(2).leafnode(1).price;
   rootnode(j).internode(2).timerange.max_time=rootnode(j).internode(2).leafnode(1).time;
   rootnode(j).internode(2).timerange.min_time=rootnode(j).internode(2).leafnode(1).time;
   temp(3,seed1)=1;
    
   for  k=1:1:(leaf_num+1)       
       if temp(3,k)==0  
           if rootnode(j).timerange.max_time>rootnode(j).timerange.min_time
           growth0=sqrt(((temp(1,k)- temp(1,seed0))/(rootnode(j).pricerange.max_price-rootnode(j).pricerange.min_price))^2+(((temp(2,k)- temp(2,seed0))/(rootnode(j).timerange.max_time-rootnode(j).timerange.min_time))^2));
           growth1=sqrt(((temp(1,k)- temp(1,seed1))/(rootnode(j).pricerange.max_price-rootnode(j).pricerange.min_price))^2+(((temp(2,k)- temp(2,seed1))/(rootnode(j).timerange.max_time-rootnode(j).timerange.min_time))^2));      
           else
           growth0=sqrt(((temp(1,k)- temp(1,seed0))/(rootnode(j).pricerange.max_price-rootnode(j).pricerange.min_price))^2);
           growth1=sqrt(((temp(1,k)- temp(1,seed1))/(rootnode(j).pricerange.max_price-rootnode(j).pricerange.min_price))^2);                  
           end
           if  growth1>=growth0
               if size(rootnode(j).internode(1).leafnode,2)<=floor((leaf_num+1)/2)
                   temp_leaf1_num=size(rootnode(j).internode(1).leafnode,2);
                           if k==(leaf_num+1)
           rootnode(j).internode(1).leafnode(temp_leaf1_num+1).itemname=CC.itemtitle(i);
           rootnode(j).internode(1).leafnode(temp_leaf1_num+1).sum=1;
           rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(1)=str2double((CC.rating1(i)));
           rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(2)=str2double((CC.rating2(i)));
           rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(3)=str2double((CC.rating3(i)));
           rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(4)=str2double((CC.rating4(i)));
           rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(5)=str2double((CC.rating5(i)));
           rootnode(j).internode(1).sum=rootnode(j).internode(1).sum+1;
           rootnode(j).internode(1).rating(1)=rootnode(j).internode(1).rating(1)+str2double((CC.rating1(i)));
           rootnode(j).internode(1).rating(2)=rootnode(j).internode(1).rating(2)+str2double((CC.rating2(i)));
           rootnode(j).internode(1).rating(3)=rootnode(j).internode(1).rating(3)+str2double((CC.rating3(i)));
           rootnode(j).internode(1).rating(4)=rootnode(j).internode(1).rating(4)+str2double((CC.rating4(i)));
           rootnode(j).internode(1).rating(5)=rootnode(j).internode(1).rating(5)+str2double((CC.rating5(i)));         
                           else
   rootnode(j).internode(1).leafnode(temp_leaf1_num+1).itemname=rootnode(j).leafnode(k).itemname;
   rootnode(j).internode(1).leafnode(temp_leaf1_num+1).sum=rootnode(j).leafnode(k).sum;
   rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(1)=rootnode(j).leafnode(k).rating(1);
   rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(2)=rootnode(j).leafnode(k).rating(2);
   rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(3)=rootnode(j).leafnode(k).rating(3);
   rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(4)=rootnode(j).leafnode(k).rating(4);
   rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(5)=rootnode(j).leafnode(k).rating(5);
   rootnode(j).internode(1).sum=rootnode(j).internode(1).sum+rootnode(j).leafnode(k).sum;
   rootnode(j).internode(1).rating(1)=rootnode(j).internode(1).rating(1)+rootnode(j).leafnode(k).rating(1);
   rootnode(j).internode(1).rating(2)=rootnode(j).internode(1).rating(1)+rootnode(j).leafnode(k).rating(2);
   rootnode(j).internode(1).rating(3)=rootnode(j).internode(1).rating(1)+rootnode(j).leafnode(k).rating(3);
   rootnode(j).internode(1).rating(4)=rootnode(j).internode(1).rating(1)+rootnode(j).leafnode(k).rating(4);
   rootnode(j).internode(1).rating(5)=rootnode(j).internode(1).rating(1)+rootnode(j).leafnode(k).rating(5);
                           end
   rootnode(j).internode(1).leafnode(temp_leaf1_num+1).price=temp(1,k);
   rootnode(j).internode(1).leafnode(temp_leaf1_num+1).time=temp(2,k);
  
   if  rootnode(j).internode(1).pricerange.min_price>temp(1,k)       
       rootnode(j).internode(1).pricerange.min_price=temp(1,k);      
   end
   if   rootnode(j).internode(1).pricerange.max_price<temp(1,k)      
       rootnode(j).internode(1).pricerange.max_price=temp(1,k);      
   end
   if  rootnode(j).internode(1).timerange.min_time>temp(2,k)  
       rootnode(j).internode(1).timerange.min_time=temp(2,k);       
   end
   if  rootnode(j).internode(1).timerange.max_time<temp(2,k)    
       rootnode(j).internode(1).timerange.max_time=temp(2,k);      
   end
   
   temp(3,k)=1; 
                   
               else
                   temp_leaf2_num=size(rootnode(j).internode(2).leafnode,2);
         if k==(leaf_num+1)
           rootnode(j).internode(2).leafnode(temp_leaf2_num+1).itemname=CC.itemtitle(i);
           rootnode(j).internode(2).leafnode(temp_leaf2_num+1).sum=1;
           rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(1)=str2double((CC.rating1(i)));
           rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(2)=str2double((CC.rating2(i)));
           rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(3)=str2double((CC.rating3(i)));
           rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(4)=str2double((CC.rating4(i)));
           rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(5)=str2double((CC.rating5(i)));
           rootnode(j).internode(2).sum=rootnode(j).internode(2).sum+1;
           rootnode(j).internode(2).rating(1)=rootnode(j).internode(2).rating(1)+str2double((CC.rating1(i)));
           rootnode(j).internode(2).rating(2)=rootnode(j).internode(2).rating(2)+str2double((CC.rating2(i)));
           rootnode(j).internode(2).rating(3)=rootnode(j).internode(2).rating(3)+str2double((CC.rating3(i)));
           rootnode(j).internode(2).rating(4)=rootnode(j).internode(2).rating(4)+str2double((CC.rating4(i)));
           rootnode(j).internode(2).rating(5)=rootnode(j).internode(2).rating(5)+str2double((CC.rating5(i)));     
         else
   rootnode(j).internode(2).leafnode(temp_leaf2_num+1).itemname=rootnode(j).leafnode(k).itemname;
   rootnode(j).internode(2).leafnode(temp_leaf2_num+1).sum=rootnode(j).leafnode(k).sum;
   rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(1)=rootnode(j).leafnode(k).rating(1);
   rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(2)=rootnode(j).leafnode(k).rating(2);
   rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(3)=rootnode(j).leafnode(k).rating(3);
   rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(4)=rootnode(j).leafnode(k).rating(4);
   rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(5)=rootnode(j).leafnode(k).rating(5);
   rootnode(j).internode(2).sum=rootnode(j).internode(2).sum+rootnode(j).leafnode(k).sum;
   rootnode(j).internode(2).rating(1)=rootnode(j).internode(2).rating(1)+rootnode(j).leafnode(k).rating(1);
   rootnode(j).internode(2).rating(2)=rootnode(j).internode(2).rating(1)+rootnode(j).leafnode(k).rating(2);
   rootnode(j).internode(2).rating(3)=rootnode(j).internode(2).rating(1)+rootnode(j).leafnode(k).rating(3);
   rootnode(j).internode(2).rating(4)=rootnode(j).internode(2).rating(1)+rootnode(j).leafnode(k).rating(4);
   rootnode(j).internode(2).rating(5)=rootnode(j).internode(2).rating(1)+rootnode(j).leafnode(k).rating(5);
          end
   rootnode(j).internode(2).leafnode(temp_leaf2_num+1).price=temp(1,k);
   rootnode(j).internode(2).leafnode(temp_leaf2_num+1).time=temp(2,k);

   if  rootnode(j).internode(2).pricerange.min_price>temp(1,k) 
       rootnode(j).internode(2).pricerange.min_price=temp(1,k);    
   end
   if   rootnode(j).internode(2).pricerange.max_price<temp(1,k)   
       rootnode(j).internode(2).pricerange.max_price=temp(1,k);     
   end
   if  rootnode(j).internode(2).timerange.min_time>temp(2,k)      
       rootnode(j).internode(2).timerange.min_time=temp(2,k);     
   end
   if  rootnode(j).internode(2).timerange.max_time<temp(2,k)  
       rootnode(j).internode(2).timerange.max_time=temp(2,k);     
   end
   temp(3,k)=1;         
                                    
               end
           else              
             if  size(rootnode(j).internode(2).leafnode,2)<=floor((leaf_num+1)/2)
                  temp_leaf2_num=size(rootnode(j).internode(2).leafnode,2);
                          if k==(leaf_num+1)
           rootnode(j).internode(2).leafnode(temp_leaf2_num+1).itemname=CC.itemtitle(i);
           rootnode(j).internode(2).leafnode(temp_leaf2_num+1).sum=1;
           rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(1)=str2double((CC.rating1(i)));
           rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(2)=str2double((CC.rating2(i)));
           rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(3)=str2double((CC.rating3(i)));
           rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(4)=str2double((CC.rating4(i)));
           rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(5)=str2double((CC.rating5(i)));
           rootnode(j).internode(2).sum=rootnode(j).internode(2).sum+1;
           rootnode(j).internode(2).rating(1)=rootnode(j).internode(2).rating(1)+str2double((CC.rating1(i)));
           rootnode(j).internode(2).rating(2)=rootnode(j).internode(2).rating(2)+str2double((CC.rating2(i)));
           rootnode(j).internode(2).rating(3)=rootnode(j).internode(2).rating(3)+str2double((CC.rating3(i)));
           rootnode(j).internode(2).rating(4)=rootnode(j).internode(2).rating(4)+str2double((CC.rating4(i)));
           rootnode(j).internode(2).rating(5)=rootnode(j).internode(2).rating(5)+str2double((CC.rating5(i))); 
         else
   rootnode(j).internode(2).leafnode(temp_leaf2_num+1).itemname=rootnode(j).leafnode(k).itemname;
   rootnode(j).internode(2).leafnode(temp_leaf2_num+1).sum=rootnode(j).leafnode(k).sum;
   rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(1)=rootnode(j).leafnode(k).rating(1);
   rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(2)=rootnode(j).leafnode(k).rating(2);
   rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(3)=rootnode(j).leafnode(k).rating(3);
   rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(4)=rootnode(j).leafnode(k).rating(4);
   rootnode(j).internode(2).leafnode(temp_leaf2_num+1).rating(5)=rootnode(j).leafnode(k).rating(5);
   rootnode(j).internode(2).sum=rootnode(j).internode(2).sum+rootnode(j).leafnode(k).sum;
   rootnode(j).internode(2).rating(1)=rootnode(j).internode(2).rating(1)+rootnode(j).leafnode(k).rating(1);
   rootnode(j).internode(2).rating(2)=rootnode(j).internode(2).rating(1)+rootnode(j).leafnode(k).rating(2);
   rootnode(j).internode(2).rating(3)=rootnode(j).internode(2).rating(1)+rootnode(j).leafnode(k).rating(3);
   rootnode(j).internode(2).rating(4)=rootnode(j).internode(2).rating(1)+rootnode(j).leafnode(k).rating(4);
   rootnode(j).internode(2).rating(5)=rootnode(j).internode(2).rating(1)+rootnode(j).leafnode(k).rating(5);
                          end
   rootnode(j).internode(2).leafnode(temp_leaf2_num+1).price=temp(1,k);
   rootnode(j).internode(2).leafnode(temp_leaf2_num+1).time=temp(2,k);

   if  rootnode(j).internode(2).pricerange.min_price>temp(1,k)     
       rootnode(j).internode(2).pricerange.min_price=temp(1,k);     
   end
   if   rootnode(j).internode(2).pricerange.max_price<temp(1,k)   
       rootnode(j).internode(2).pricerange.max_price=temp(1,k);   
   end
   if  rootnode(j).internode(2).timerange.min_time>temp(2,k) 
       rootnode(j).internode(2).timerange.min_time=temp(2,k);   
   end
   if  rootnode(j).internode(2).timerange.max_time<temp(2,k) 
       rootnode(j).internode(2).timerange.max_time=temp(2,k);      
   end
   temp(3,k)=1;
                    
             else
                 temp_leaf1_num=size(rootnode(j).internode(1).leafnode,2);
                            if k==(leaf_num+1)
           rootnode(j).internode(1).leafnode(temp_leaf1_num+1).itemname=CC.itemtitle(i);
           rootnode(j).internode(1).leafnode(temp_leaf1_num+1).sum=1;
           rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(1)=str2double((CC.rating1(i)));
           rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(2)=str2double((CC.rating2(i)));
           rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(3)=str2double((CC.rating3(i)));
           rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(4)=str2double((CC.rating4(i)));
           rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(5)=str2double((CC.rating5(i)));
           rootnode(j).internode(1).sum=rootnode(j).internode(1).sum+1;
           rootnode(j).internode(1).rating(1)=rootnode(j).internode(1).rating(1)+str2double((CC.rating1(i)));
           rootnode(j).internode(1).rating(2)=rootnode(j).internode(1).rating(2)+str2double((CC.rating2(i)));
           rootnode(j).internode(1).rating(3)=rootnode(j).internode(1).rating(3)+str2double((CC.rating3(i)));
           rootnode(j).internode(1).rating(4)=rootnode(j).internode(1).rating(4)+str2double((CC.rating4(i)));
           rootnode(j).internode(1).rating(5)=rootnode(j).internode(1).rating(5)+str2double((CC.rating5(i)));    
                           else
   rootnode(j).internode(1).leafnode(temp_leaf1_num+1).itemname=rootnode(j).leafnode(k).itemname;
   rootnode(j).internode(1).leafnode(temp_leaf1_num+1).sum=rootnode(j).leafnode(k).sum;
   rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(1)=rootnode(j).leafnode(k).rating(1);
   rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(2)=rootnode(j).leafnode(k).rating(2);
   rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(3)=rootnode(j).leafnode(k).rating(3);
   rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(4)=rootnode(j).leafnode(k).rating(4);
   rootnode(j).internode(1).leafnode(temp_leaf1_num+1).rating(5)=rootnode(j).leafnode(k).rating(5);
   rootnode(j).internode(1).sum=rootnode(j).internode(1).sum+rootnode(j).leafnode(k).sum;
   rootnode(j).internode(1).rating(1)=rootnode(j).internode(1).rating(1)+rootnode(j).leafnode(k).rating(1);
   rootnode(j).internode(1).rating(2)=rootnode(j).internode(1).rating(1)+rootnode(j).leafnode(k).rating(2);
   rootnode(j).internode(1).rating(3)=rootnode(j).internode(1).rating(1)+rootnode(j).leafnode(k).rating(3);
   rootnode(j).internode(1).rating(4)=rootnode(j).internode(1).rating(1)+rootnode(j).leafnode(k).rating(4);
   rootnode(j).internode(1).rating(5)=rootnode(j).internode(1).rating(1)+rootnode(j).leafnode(k).rating(5);
                           end
   rootnode(j).internode(1).leafnode(temp_leaf1_num+1).price=temp(1,k);
   rootnode(j).internode(1).leafnode(temp_leaf1_num+1).time=temp(2,k);
  
   if  rootnode(j).internode(1).pricerange.min_price>temp(1,k)    
       rootnode(j).internode(1).pricerange.min_price=temp(1,k);     
   end
   if   rootnode(j).internode(1).pricerange.max_price<temp(1,k)    
       rootnode(j).internode(1).pricerange.max_price=temp(1,k);   
   end
   if  rootnode(j).internode(1).timerange.min_time>temp(2,k)    
       rootnode(j).internode(1).timerange.min_time=temp(2,k);    
   end
   if  rootnode(j).internode(1).timerange.max_time<temp(2,k)   
       rootnode(j).internode(1).timerange.max_time=temp(2,k);     
   end
   
   temp(3,k)=1; 
                
             end  
                                                      
           end
       
       end
            
   end
    
 %rootnode(j).n_count=size(rootnode(j).internode,2);   
    %%
    rootnode(j).leafnode=[];
    
end  %% if  ( rootnode(j).n_count <= rootnode(j).n_maxcount )
                                                            
                 end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%��һ����886
elseif rootnode(j).n_level==1  %ָ���Ѿ�����Ҷ�ӽڵ��������һ���ʱ������Ĳ���Ӧ��
    %% �൱��findbranch ����  %%�����������ȥʶ������һ����
   if  rootnode(j).internode(1).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode(1).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end
  
   if  rootnode(j).internode(1).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode(1).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end
   
   if (u1~=u2) && (rootnode(j).internode(1).pricerange.max_price~=rootnode(j).internode(1).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode(1).timerange.min_time)
   v=((abs(u1-rootnode(j).internode(1).pricerange.max_price)+abs(u2-rootnode(j).internode(1).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode(1).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode(1).timerange.min_time));
   end
   
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode(1).timerange.min_time
       
       if (u1~=u2) && (rootnode(j).internode(1).pricerange.max_price~=rootnode(j).internode(1).pricerange.min_price)
            v=(abs(u1-rootnode(j).internode(1).pricerange.max_price)+abs(u2-rootnode(j).internode(1).pricerange.min_price))/(u1-u2);
       else 
            v=0;
       end
       
   end
   
   w(1)=1;  %%root count node
   node_num=size(rootnode(j).internode, 2);
   
    for p=2:1:node_num
   if  rootnode(j).internode(p).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode(p).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end
  
   if  rootnode(j).internode(p).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode(p).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end
   

   if (u1~=u2) && (rootnode(j).internode(p).pricerange.max_price~=rootnode(j).internode(p).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode(p).timerange.min_time)
   v1=((abs(u1-rootnode(j).internode(p).pricerange.max_price)+abs(u2-rootnode(j).internode(p).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode(p).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode(p).timerange.min_time));
   end
   
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode(p).timerange.min_time       
       if (u1~=u2) && (rootnode(j).internode(p).pricerange.max_price~=rootnode(j).internode(p).pricerange.min_price)
            v1=(abs(u1-rootnode(j).internode(p).pricerange.max_price)+abs(u2-rootnode(j).internode(p).pricerange.min_price))/(u1-u2);
       else 
            v1=0;
       end    
   end  
   
   if   v1<v     
       w(1)=p;
       v=v1;
   end
   
    end 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [pot, same]=sameitem(rootnode(j).internode(w(1)).leafnode, CC.itemtitle(i), CC.time(i));
 if  same==1
    rootnode(j).internode(w(1)).leafnode(pot).sum=rootnode(j).internode(w(1)).leafnode(pot).sum+1;
    rootnode(j).internode(w(1)).leafnode(pot).rating(1)=rootnode(j).internode(w(1)).leafnode(pot).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode(w(1)).leafnode(pot).rating(2)=rootnode(j).internode(w(1)).leafnode(pot).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode(w(1)).leafnode(pot).rating(3)=rootnode(j).internode(w(1)).leafnode(pot).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode(w(1)).leafnode(pot).rating(4)=rootnode(j).internode(w(1)).leafnode(pot).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode(w(1)).leafnode(pot).rating(5)=rootnode(j).internode(w(1)).leafnode(pot).rating(5)+str2double((CC.rating5(i)));
    
    rootnode(j).internode(w(1)).sum=rootnode(j).internode(w(1)).sum+1;
    rootnode(j).internode(w(1)).rating(1)=rootnode(j).internode(w(1)).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode(w(1)).rating(2)=rootnode(j).internode(w(1)).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode(w(1)).rating(3)=rootnode(j).internode(w(1)).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode(w(1)).rating(4)=rootnode(j).internode(w(1)).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode(w(1)).rating(5)=rootnode(j).internode(w(1)).rating(5)+str2double((CC.rating5(i)));
 elseif same==0
     
    if rootnode(j).internode(w(1)).n_level==0
        leaf_num=size(rootnode(j).internode(w(1)).leafnode, 2);
    if  ( (leaf_num+1) <= n_maxcount )  %%����ڵ����û����node��������ָ��Ҷ�ӽڵ�
%     %% Ҷ�ӽڵ����node 
           rootnode(j).internode(w(1)).sum=rootnode(j).internode(w(1)).sum+1;
           rootnode(j).internode(w(1)).rating(1)=rootnode(j).internode(w(1)).rating(1)+str2double((CC.rating1(i)));
           rootnode(j).internode(w(1)).rating(2)=rootnode(j).internode(w(1)).rating(2)+str2double((CC.rating2(i)));
           rootnode(j).internode(w(1)).rating(3)=rootnode(j).internode(w(1)).rating(3)+str2double((CC.rating3(i)));
           rootnode(j).internode(w(1)).rating(4)=rootnode(j).internode(w(1)).rating(4)+str2double((CC.rating4(i)));
           rootnode(j).internode(w(1)).rating(5)=rootnode(j).internode(w(1)).rating(5)+str2double((CC.rating5(i)));  
   
    if  rootnode(j).internode(w(1)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i))))%% ��������ֵ��С
        rootnode(j).internode(w(1)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end 
    
    if rootnode(j).internode(w(1)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ����
        rootnode(j).internode(w(1)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end 
      
    rootnode(j).internode(w(1)).timerange.max_time=timechange(cell2mat(CC.time(i))); 
    
    %%
    rootnode(j).internode(w(1)).leafnode(leaf_num+1).itemname=CC.itemtitle(i);
    rootnode(j).internode(w(1)).leafnode(leaf_num+1).price=round(str2double(cell2mat(CC.itemprice(i))));
    rootnode(j).internode(w(1)).leafnode(leaf_num+1).time=timechange(cell2mat(CC.time(i)));
    rootnode(j).internode(w(1)).leafnode(leaf_num+1).sum=1;
    rootnode(j).internode(w(1)).leafnode(leaf_num+1).rating(1)=str2double((CC.rating1(i)));
    rootnode(j).internode(w(1)).leafnode(leaf_num+1).rating(2)=str2double((CC.rating2(i)));
    rootnode(j).internode(w(1)).leafnode(leaf_num+1).rating(3)=str2double((CC.rating3(i)));
    rootnode(j).internode(w(1)).leafnode(leaf_num+1).rating(4)=str2double((CC.rating4(i)));
    rootnode(j).internode(w(1)).leafnode(leaf_num+1).rating(5)=str2double((CC.rating5(i)));
     elseif  ( ( leaf_num+1) > n_maxcount ) %%����ڵ��������node��������ָ��Ҷ�ӽڵ�     
        % o=1;        
        if  (node_num+1)<= n_maxcount1           
            %%%rootnode(j).n_count=node_num+1
            %%%��������ڼ�һ��internode�ڵ�
                if  rootnode(j).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ��С
                    rootnode(j).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
                end 
    
                if rootnode(j).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ����
                   rootnode(j).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
                end 
    
                     rootnode(j).timerange.max_time=timechange(cell2mat(CC.time(i))); 
            
               %% ���￪ʼ����ѵ�
     for k=1:1:leaf_num       
        leaftemp(k)=rootnode(j).internode(w(1)).leafnode(k);
        indexleaftemp(k)=0;
     end
    leaftemp(k+1).itemname=CC.itemtitle(i);
    leaftemp(k+1).sum=1;
    leaftemp(k+1).rating(1)=str2double((CC.rating1(i)));
    leaftemp(k+1).rating(2)=str2double((CC.rating2(i)));
    leaftemp(k+1).rating(3)=str2double((CC.rating3(i)));
    leaftemp(k+1).rating(4)=str2double((CC.rating4(i)));
    leaftemp(k+1).rating(5)=str2double((CC.rating5(i)));
    leaftemp(k+1).price=round(str2double(cell2mat(CC.itemprice(i))));
    leaftemp(k+1).time=timechange(cell2mat(CC.time(i)));
    indexleaftemp(k+1)=0;

 worst=0;
   
 if (rootnode(j).internode(w(1)).pricerange.max_price-rootnode(j).internode(w(1)).pricerange.min_price)>0
    for k1=1:1:leaf_num           
        for  k2=(k1+1):1:(leaf_num+1)
            if rootnode(j).internode(w(1)).timerange.max_time>rootnode(j).internode(w(1)).timerange.min_time
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode(w(1)).pricerange.max_price-rootnode(j).internode(w(1)).pricerange.min_price))^2+(((leaftemp(k1).time- leaftemp(k2).time)/(rootnode(j).internode(w(1)).timerange.max_time-rootnode(j).internode(w(1)).timerange.min_time))^2));     
            else
             waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode(w(1)).pricerange.max_price-rootnode(j).internode(w(1)).pricerange.min_price)))^2;   
            end
            if  waste>worst           
                worst=waste;
                seed0=k1;
                seed1=k2;                     
            end
        end 
        
    end 
    
 end
 
  if (rootnode(j).internode(w(1)).pricerange.max_price-rootnode(j).internode(w(1)).pricerange.min_price)==0     
                seed0=1;
                seed1=leaf_num+1;
  end
                
    [tempinternode1, tempinternode2]=splitleaf(leaftemp, seed0, seed1, indexleaftemp, rootnode(j).internode(w(1)).pricerange.max_price, rootnode(j).internode(w(1)).pricerange.min_price, rootnode(j).internode(w(1)).timerange.max_time, rootnode(j).internode(w(1)).timerange.min_time, n_maxcount);
    rootnode(j).internode(w(1))=tempinternode1;
    rootnode(j).internode(node_num+1)=tempinternode2;
        else  % (rootnode(j).n_count+1)<= n_maxcount

            %%���￪���  ��������һ�� %%�ⲿ�ֶ�Ӧ��533��
     for k=1:1:leaf_num       
        leaftemp(k)=rootnode(j).internode(w(1)).leafnode(k);
        indexleaftemp(k)=0;
     end
    leaftemp(k+1).itemname=CC.itemtitle(i);
    leaftemp(k+1).sum=1;
    leaftemp(k+1).rating(1)=str2double((CC.rating1(i)));
    leaftemp(k+1).rating(2)=str2double((CC.rating2(i)));
    leaftemp(k+1).rating(3)=str2double((CC.rating3(i)));
    leaftemp(k+1).rating(4)=str2double((CC.rating4(i)));
    leaftemp(k+1).rating(5)=str2double((CC.rating5(i)));
    leaftemp(k+1).price=round(str2double(cell2mat(CC.itemprice(i))));
    leaftemp(k+1).time=timechange(cell2mat(CC.time(i)));
    indexleaftemp(k+1)=0;

 worst=0;
    
    %% ���ѳ�ʼ��2���ڵ�    
   
 if (rootnode(j).internode(w(1)).pricerange.max_price-rootnode(j).internode(w(1)).pricerange.min_price)>0
    for k1=1:1:leaf_num           
        for  k2=(k1+1):1:(leaf_num+1)
            if rootnode(j).internode(w(1)).timerange.max_time>rootnode(j).internode(w(1)).timerange.min_time
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode(w(1)).pricerange.max_price-rootnode(j).internode(w(1)).pricerange.min_price))^2+(((leaftemp(k1).time- leaftemp(k2).time)/(rootnode(j).internode(w(1)).timerange.max_time-rootnode(j).internode(w(1)).timerange.min_time))^2));     
            else
             waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode(w(1)).pricerange.max_price-rootnode(j).internode(w(1)).pricerange.min_price)))^2;   
            end
            if  waste>worst           
                worst=waste;
                seed0=k1;
                seed1=k2;                     
            end
        end 
        
    end 
    
 end
 
  if (rootnode(j).internode(w(1)).pricerange.max_price-rootnode(j).internode(w(1)).pricerange.min_price)==0 
                seed0=1;
                seed1=leaf_num+1;
  end
  
    [tempinternode1, tempinternode2]=splitleaf(leaftemp, seed0, seed1, indexleaftemp, rootnode(j).internode(w(1)).pricerange.max_price, rootnode(j).internode(w(1)).pricerange.min_price, rootnode(j).internode(w(1)).timerange.max_time, rootnode(j).internode(w(1)).timerange.min_time, n_maxcount);  
  
    %%%%            
          rootnode(j).n_level=rootnode(j).n_level+1; %%��������1 
   
    if  rootnode(j).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ��С
        rootnode(j).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end 
    
    if rootnode(j).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ����
        rootnode(j).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end 
    
    rootnode(j).timerange.max_time=timechange(cell2mat(CC.time(i)));  
    
    for k=1:1:n_maxcount1
       if k~= w(1)
        tempinternode_1(k)=rootnode(j).internode(k);
        indexinternode_1(k)=0;
       else
        tempinternode_1(k)=tempinternode1;
        indexinternode_1(k)=0;
       end
    end
        tempinternode_1(k+1)=tempinternode2;    
        indexinternode_1(k+1)=0;
        rootnode(j).internode=[];  
   worst=0;
         seed0=1;
         seed1=size(tempinternode_1,2);
      for k1=1:1:(size(tempinternode_1,2)-1)               
        for  k2=(k1+1):1:(size(tempinternode_1,2))
 waste=(rootnode(j).pricerange.max_price-rootnode(j).pricerange.min_price)*(rootnode(j).timerange.max_time-rootnode(j).timerange.min_time)-(tempinternode_1(k1).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k1).timerange.max_time-tempinternode_1(k1).timerange.min_time)-(tempinternode_1(k2).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k2).timerange.max_time-tempinternode_1(k2).timerange.min_time);
            if  waste>worst                
                worst=waste;
                seed0=k1;
                seed1=k2;           
            end
        end 
      end 
           
    [internode_1]=splitnode(tempinternode_1, seed0, seed1, indexinternode_1);  
    
    %%Ҫ�ٽ�һ��internode ����Ϊinternode_1  ������һ��
    rootnode(j).internode_1=internode_1;
                                    
        end  %%(rootnode(j).n_count+1)<= n_maxcount
         
         
    end %%( (rootnode(j).internode(w(1)).n_count+1) <= n_maxcount )
   end %%rootnode(j).internode(w(1)).n_level==0
        
 end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
elseif   rootnode(j).n_level==2
    
   if  rootnode(j).internode_1(1).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode_1(1).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end
  
   if  rootnode(j).internode_1(1).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode_1(1).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end
   
   if (u1~=u2) && (rootnode(j).internode_1(1).pricerange.max_price~=rootnode(j).internode_1(1).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode_1(1).timerange.min_time)
   v=((abs(u1-rootnode(j).internode_1(1).pricerange.max_price)+abs(u2-rootnode(j).internode_1(1).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode_1(1).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode_1(1).timerange.min_time));
   end
   
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode_1(1).timerange.min_time
       
       if (u1~=u2) && (rootnode(j).internode_1(1).pricerange.max_price~=rootnode(j).internode_1(1).pricerange.min_price)
            v=(abs(u1-rootnode(j).internode_1(1).pricerange.max_price)+abs(u2-rootnode(j).internode_1(1).pricerange.min_price))/(u1-u2);
       else 
            v=0;
       end
       
   end
   
   w(1)=1;
    internode1_num=size(rootnode(j).internode_1, 2);
    for p=2:1:internode1_num
   if  rootnode(j).internode_1(p).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode_1(p).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end
  
   if  rootnode(j).internode_1(p).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode_1(p).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end
   

   if (u1~=u2) && (rootnode(j).internode_1(p).pricerange.max_price~=rootnode(j).internode_1(p).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode_1(p).timerange.min_time)
   v1=((abs(u1-rootnode(j).internode_1(p).pricerange.max_price)+abs(u2-rootnode(j).internode_1(p).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode_1(p).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode_1(p).timerange.min_time));
   end
   
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode_1(p).timerange.min_time
       
       if (u1~=u2) && (rootnode(j).internode_1(p).pricerange.max_price~=rootnode(j).internode_1(p).pricerange.min_price)
            v1=(abs(u1-rootnode(j).internode_1(p).pricerange.max_price)+abs(u2-rootnode(j).internode_1(p).pricerange.min_price))/(u1-u2);
       else 
            v1=0;
       end
       
   end  
   
   if   v1<v
       
       w(1)=p;
       v=v1;
   end
   
    end 
    
   if  rootnode(j).internode_1(w(1)).internode(1).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode_1(w(1)).internode(1).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end
  
   if  rootnode(j).internode_1(w(1)).internode(1).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode_1(w(1)).internode(1).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end
   
   if (u1~=u2) && (rootnode(j).internode_1(w(1)).internode(1).pricerange.max_price~=rootnode(j).internode_1(w(1)).internode(1).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode_1(w(1)).internode(1).timerange.min_time)
   v=((abs(u1-rootnode(j).internode_1(w(1)).internode(1).pricerange.max_price)+abs(u2-rootnode(j).internode_1(w(1)).internode(1).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode_1(w(1)).internode(1).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode_1(w(1)).internode(1).timerange.min_time));
   end
   
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode_1(w(1)).internode(1).timerange.min_time
       
       if (u1~=u2) && (rootnode(j).internode_1(w(1)).internode(1).pricerange.max_price~=rootnode(j).internode_1(w(1)).internode(1).pricerange.min_price)
            v=(abs(u1-rootnode(j).internode_1(w(1)).internode(1).pricerange.max_price)+abs(u2-rootnode(j).internode_1(w(1)).internode(1).pricerange.min_price))/(u1-u2);
       else 
            v=0;
       end
       
   end
   
   w(2)=1;
    node_num=size(rootnode(j).internode_1(w(1)).internode, 2);
    for p=2:1:node_num
   if  rootnode(j).internode_1(w(1)).internode(p).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode_1(w(1)).internode(p).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end
  
   if  rootnode(j).internode_1(w(1)).internode(p).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode_1(w(1)).internode(p).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end
   

   if (u1~=u2) && (rootnode(j).internode_1(w(1)).internode(p).pricerange.max_price~=rootnode(j).internode_1(w(1)).internode(p).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode_1(w(1)).internode(p).timerange.min_time)
   v1=((abs(u1-rootnode(j).internode_1(w(1)).internode(p).pricerange.max_price)+abs(u2-rootnode(j).internode_1(w(1)).internode(p).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode_1(w(1)).internode(p).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode_1(w(1)).internode(p).timerange.min_time));
   end
   
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode_1(w(1)).internode(p).timerange.min_time
       
       if (u1~=u2) && (rootnode(j).internode_1(w(1)).internode(p).pricerange.max_price~=rootnode(j).internode_1(w(1)).internode(p).pricerange.min_price)
            v1=(abs(u1-rootnode(j).internode_1(w(1)).internode(p).pricerange.max_price)+abs(u2-rootnode(j).internode_1(w(1)).internode(p).pricerange.min_price))/(u1-u2);
       else 
            v1=0;
       end
       
   end  
   
   if   v1<v
       
       w(2)=p;
       v=v1;
   end
   
    end 
    %%���¶���413��
      [pot, same]=sameitem(rootnode(j).internode_1(w(1)).internode(w(2)).leafnode, CC.itemtitle(i), CC.time(i));
 if  same==1
    rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(pot).sum=rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(pot).sum+1;
    rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(pot).rating(1)=rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(pot).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(pot).rating(2)=rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(pot).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(pot).rating(3)=rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(pot).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(pot).rating(4)=rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(pot).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(pot).rating(5)=rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(pot).rating(5)+str2double((CC.rating5(i)));
    
    rootnode(j).internode_1(w(1)).internode(w(2)).sum=rootnode(j).internode_1(w(1)).internode(w(2)).sum+1;
    rootnode(j).internode_1(w(1)).internode(w(2)).rating(1)=rootnode(j).internode_1(w(1)).internode(w(2)).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode_1(w(1)).internode(w(2)).rating(2)=rootnode(j).internode_1(w(1)).internode(w(2)).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode_1(w(1)).internode(w(2)).rating(3)=rootnode(j).internode_1(w(1)).internode(w(2)).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode_1(w(1)).internode(w(2)).rating(4)=rootnode(j).internode_1(w(1)).internode(w(2)).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode_1(w(1)).internode(w(2)).rating(5)=rootnode(j).internode_1(w(1)).internode(w(2)).rating(5)+str2double((CC.rating5(i)));
    
    rootnode(j).internode_1(w(1)).sum=rootnode(j).internode_1(w(1)).sum+1;
    rootnode(j).internode_1(w(1)).rating(1)=rootnode(j).internode_1(w(1)).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode_1(w(1)).rating(2)=rootnode(j).internode_1(w(1)).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode_1(w(1)).rating(3)=rootnode(j).internode_1(w(1)).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode_1(w(1)).rating(4)=rootnode(j).internode_1(w(1)).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode_1(w(1)).rating(5)=rootnode(j).internode_1(w(1)).rating(5)+str2double((CC.rating5(i)));
    
 elseif same==0
     leaf_num=size(rootnode(j).internode_1(w(1)).internode(w(2)).leafnode, 2);
     if ((leaf_num+1) <= n_maxcount)
%     %% Ҷ�ӽڵ����node 
           rootnode(j).internode_1(w(1)).internode(w(2)).sum=rootnode(j).internode_1(w(1)).internode(w(2)).sum+1;
           rootnode(j).internode_1(w(1)).internode(w(2)).rating(1)=rootnode(j).internode_1(w(1)).internode(w(2)).rating(1)+str2double((CC.rating1(i)));
           rootnode(j).internode_1(w(1)).internode(w(2)).rating(2)=rootnode(j).internode_1(w(1)).internode(w(2)).rating(2)+str2double((CC.rating2(i)));
           rootnode(j).internode_1(w(1)).internode(w(2)).rating(3)=rootnode(j).internode_1(w(1)).internode(w(2)).rating(3)+str2double((CC.rating3(i)));
           rootnode(j).internode_1(w(1)).internode(w(2)).rating(4)=rootnode(j).internode_1(w(1)).internode(w(2)).rating(4)+str2double((CC.rating4(i)));
           rootnode(j).internode_1(w(1)).internode(w(2)).rating(5)=rootnode(j).internode_1(w(1)).internode(w(2)).rating(5)+str2double((CC.rating5(i))); 
           rootnode(j).internode_1(w(1)).sum=rootnode(j).internode_1(w(1)).sum+1;
           rootnode(j).internode_1(w(1)).rating(1)=rootnode(j).internode_1(w(1)).rating(1)+str2double((CC.rating1(i)));
           rootnode(j).internode_1(w(1)).rating(2)=rootnode(j).internode_1(w(1)).rating(2)+str2double((CC.rating2(i)));
           rootnode(j).internode_1(w(1)).rating(3)=rootnode(j).internode_1(w(1)).rating(3)+str2double((CC.rating3(i)));
           rootnode(j).internode_1(w(1)).rating(4)=rootnode(j).internode_1(w(1)).rating(4)+str2double((CC.rating4(i)));
           rootnode(j).internode_1(w(1)).rating(5)=rootnode(j).internode_1(w(1)).rating(5)+str2double((CC.rating5(i))); 
   
    if  rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ��С
        rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end 
    
    if rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ����
        rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end 
    if  rootnode(j).internode_1(w(1)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ��С
        rootnode(j).internode_1(w(1)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end 
    
    if rootnode(j).internode_1(w(1)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ����
        rootnode(j).internode_1(w(1)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end 
      
    rootnode(j).internode_1(w(1)).internode(w(2)).timerange.max_time=timechange(cell2mat(CC.time(i))); 
    %%
    rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(leaf_num+1).itemname=CC.itemtitle(i);
    rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(leaf_num+1).price=round(str2double(cell2mat(CC.itemprice(i))));
    rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(leaf_num+1).time=timechange(cell2mat(CC.time(i)));
    rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(leaf_num+1).sum=1;
    rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(leaf_num+1).rating(1)=str2double((CC.rating1(i)));
    rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(leaf_num+1).rating(2)=str2double((CC.rating2(i)));
    rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(leaf_num+1).rating(3)=str2double((CC.rating3(i)));
    rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(leaf_num+1).rating(4)=str2double((CC.rating4(i)));
    rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(leaf_num+1).rating(5)=str2double((CC.rating5(i)));
    
    rootnode(j).internode_1(w(1)).timerange.max_time=timechange(cell2mat(CC.time(i))); 

    elseif  ( (leaf_num+1) > n_maxcount )
        
    for k=1:1:leaf_num      
        leaftemp(k)=rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(k);
        indexleaftemp(k)=0;
     end
    leaftemp(k+1).itemname=CC.itemtitle(i);
    leaftemp(k+1).sum=1;
    leaftemp(k+1).rating(1)=str2double((CC.rating1(i)));
    leaftemp(k+1).rating(2)=str2double((CC.rating2(i)));
    leaftemp(k+1).rating(3)=str2double((CC.rating3(i)));
    leaftemp(k+1).rating(4)=str2double((CC.rating4(i)));
    leaftemp(k+1).rating(5)=str2double((CC.rating5(i)));
    leaftemp(k+1).price=round(str2double(cell2mat(CC.itemprice(i))));
    leaftemp(k+1).time=timechange(cell2mat(CC.time(i)));
    indexleaftemp(k+1)=0;  

    worst=0;
   if (rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.max_price-rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.min_price)>0
    for k1=1:1:leaf_num       
        for  k2=(k1+1):1:(leaf_num+1)                    
            if rootnode(j).internode_1(w(1)).internode(w(2)).timerange.max_time>rootnode(j).internode_1(w(1)).internode(w(2)).timerange.min_time
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.max_price-rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.min_price))^2+(((leaftemp(k1).time- leaftemp(k2).time)/(rootnode(j).internode_1(w(1)).internode(w(2)).timerange.max_time-rootnode(j).internode_1(w(1)).internode(w(2)).timerange.min_time))^2));           
            else 
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.max_price-rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.min_price))^2);    
            end
            if  waste>worst            
                worst=waste;
                seed0=k1;
                seed1=k2;
                          
            end
        end 
        
     end 
  end
 
  if (rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.max_price-rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.min_price)==0                              
                seed0=1;
                seed1=leaf_num+1;   
  end
    
[tempinternode1, tempinternode2]=splitleaf(leaftemp, seed0, seed1, indexleaftemp, rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.max_price, rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.min_price, rootnode(j).internode_1(w(1)).internode(w(2)).timerange.max_time, rootnode(j).internode_1(w(1)).internode(w(2)).timerange.min_time, n_maxcount);
    %%%%%����д ���ϸ�һ���ڵ����жϳ�û����

    if (node_num+1<=n_maxcount1)
        
         rootnode(j).internode_1(w(1)).sum=rootnode(j).internode_1(w(1)).sum+1;
         rootnode(j).internode_1(w(1)).rating(1)=rootnode(j).internode_1(w(1)).rating(1)+str2double((CC.rating1(i)));
         rootnode(j).internode_1(w(1)).rating(2)=rootnode(j).internode_1(w(1)).rating(2)+str2double((CC.rating2(i)));
         rootnode(j).internode_1(w(1)).rating(3)=rootnode(j).internode_1(w(1)).rating(3)+str2double((CC.rating3(i)));
         rootnode(j).internode_1(w(1)).rating(4)=rootnode(j).internode_1(w(1)).rating(4)+str2double((CC.rating4(i)));
         rootnode(j).internode_1(w(1)).rating(5)=rootnode(j).internode_1(w(1)).rating(5)+str2double((CC.rating5(i)));
             if  rootnode(j).internode_1(w(1)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ��С
        rootnode(j).internode_1(w(1)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
             end 
    
          if rootnode(j).internode_1(w(1)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ����
        rootnode(j).internode_1(w(1)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
          end 
    
          rootnode(j).internode_1(w(1)).timerange.max_time=timechange(cell2mat(CC.time(i))); 
         
             if  rootnode(j).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ��С
        rootnode(j).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
             end 
    
          if rootnode(j).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ����
            rootnode(j).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
          end 
    
          rootnode(j).internode_1(w(1)).timerange.max_time=timechange(cell2mat(CC.time(i))); 
          
           rootnode(j).internode_1(w(1)).internode(w(2))=tempinternode1;
           rootnode(j).internode_1(w(1)).internode(node_num+1)=tempinternode2;
    else 
        
      for k=1:1:leaf_num       
        leaftemp(k)=rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(k);
        indexleaftemp(k)=0;
     end
    leaftemp(k+1).itemname=CC.itemtitle(i);
    leaftemp(k+1).sum=1;
    leaftemp(k+1).rating(1)=str2double((CC.rating1(i)));
    leaftemp(k+1).rating(2)=str2double((CC.rating2(i)));
    leaftemp(k+1).rating(3)=str2double((CC.rating3(i)));
    leaftemp(k+1).rating(4)=str2double((CC.rating4(i)));
    leaftemp(k+1).rating(5)=str2double((CC.rating5(i)));
    leaftemp(k+1).price=round(str2double(cell2mat(CC.itemprice(i))));
    leaftemp(k+1).time=timechange(cell2mat(CC.time(i)));
    indexleaftemp(k+1)=0;

%      rootnode(j).internode(w(1)).leafnode= struct('itemname',{},'rating',{},'price',{}, 'time',{});    
 worst=0;
      
   if (rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.max_price-rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.min_price)>0
    for k1=1:1:leaf_num       
        for  k2=(k1+1):1:(leaf_num+1)                    
            if rootnode(j).internode_1(w(1)).internode(w(2)).timerange.max_time>rootnode(j).internode_1(w(1)).internode(w(2)).timerange.min_time
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.max_price-rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.min_price))^2+(((leaftemp(k1).time- leaftemp(k2).time)/(rootnode(j).internode_1(w(1)).internode(w(2)).timerange.max_time-rootnode(j).internode_1(w(1)).internode(w(2)).timerange.min_time))^2));           
            else 
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.max_price-rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.min_price))^2);    
            end
            if  waste>worst            
                worst=waste;
                seed0=k1;
                seed1=k2;
                          
            end
        end 
        
     end 
  end
 
  if (rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.max_price-rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.min_price)==0       
                seed0=1;
                seed1=leaf_num+1;
  end
  
[tempinternode1, tempinternode2]=splitleaf(leaftemp, seed0, seed1, indexleaftemp, rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.max_price, rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.min_price, rootnode(j).internode_1(w(1)).internode(w(2)).timerange.max_time, rootnode(j).internode_1(w(1)).internode(w(2)).timerange.min_time, n_maxcount);

  if  internode1_num+1<=n_maxcount1
      %rootnode(j).n_count=rootnode(j).n_count+1;
      
    if  rootnode(j).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ��С
        rootnode(j).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end 
    
    if rootnode(j).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ����
        rootnode(j).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end 
    
    rootnode(j).timerange.max_time=timechange(cell2mat(CC.time(i)));  
    
    for k=1:1:n_maxcount1
       if k~= w(2)
        tempinternode_1(k)=rootnode(j).internode_1(w(1)).internode(k);
        indexinternode_1(k)=0;
       else
        tempinternode_1(k)=tempinternode1;
        indexinternode_1(k)=0;
       end
    end
        tempinternode_1(k+1)=tempinternode2;    
        indexinternode_1(k+1)=0;
 
   worst=0;
         seed0=1;
         seed1=size(tempinternode_1,2);
   
      for k1=1:1:(size(tempinternode_1,2)-1)  
        for  k2=(k1+1):1:(size(tempinternode_1,2))
 waste=(rootnode(j).internode_1(w(1)).pricerange.max_price-rootnode(j).internode_1(w(1)).pricerange.min_price)*(rootnode(j).internode_1(w(1)).timerange.max_time-rootnode(j).internode_1(w(1)).timerange.min_time)-(tempinternode_1(k1).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k1).timerange.max_time-tempinternode_1(k1).timerange.min_time)-(tempinternode_1(k2).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k2).timerange.max_time-tempinternode_1(k2).timerange.min_time);
            if  waste>worst                
                worst=waste;
                seed0=k1;
                seed1=k2;           
            end
        end 
        
      end 
      
          [internode_1]=splitnode(tempinternode_1, seed0, seed1, indexinternode_1); 
    rootnode(j).internode_1(internode1_num+1)=internode_1(1);  
    rootnode(j).internode_1(w(1))=internode_1(2);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  else %% rootnode(j).n_count+1<=n_maxcount     
     for k=1:1:leaf_num       
        leaftemp(k)=rootnode(j).internode_1(w(1)).internode(w(2)).leafnode(k);
        indexleaftemp(k)=0;
     end
    leaftemp(k+1).itemname=CC.itemtitle(i);
    leaftemp(k+1).sum=1;
    leaftemp(k+1).rating(1)=str2double((CC.rating1(i)));
    leaftemp(k+1).rating(2)=str2double((CC.rating2(i)));
    leaftemp(k+1).rating(3)=str2double((CC.rating3(i)));
    leaftemp(k+1).rating(4)=str2double((CC.rating4(i)));
    leaftemp(k+1).rating(5)=str2double((CC.rating5(i)));
    leaftemp(k+1).price=round(str2double(cell2mat(CC.itemprice(i))));
    leaftemp(k+1).time=timechange(cell2mat(CC.time(i)));
    indexleaftemp(k+1)=0;
     
        worst=0;
   if (rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.max_price-rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.min_price)>0
    for k1=1:1:leaf_num       
        for  k2=(k1+1):1:(leaf_num+1)                    
            if rootnode(j).internode_1(w(1)).internode(w(2)).timerange.max_time>rootnode(j).internode_1(w(1)).internode(w(2)).timerange.min_time
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.max_price-rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.min_price))^2+(((leaftemp(k1).time- leaftemp(k2).time)/(rootnode(j).internode_1(w(1)).internode(w(2)).timerange.max_time-rootnode(j).internode_1(w(1)).internode(w(2)).timerange.min_time))^2));           
            else 
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.max_price-rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.min_price))^2);    
            end
            if  waste>worst            
                worst=waste;
                seed0=k1;
                seed1=k2;
                          
            end
        end 
        
     end 
  end
 
  if (rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.max_price-rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.min_price)==0                       
                seed0=1;
                seed1=leaf_num+1;    
  end
    
[tempinternode1, tempinternode2]=splitleaf(leaftemp, seed0, seed1, indexleaftemp, rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.max_price, rootnode(j).internode_1(w(1)).internode(w(2)).pricerange.min_price, rootnode(j).internode_1(w(1)).internode(w(2)).timerange.max_time, rootnode(j).internode_1(w(1)).internode(w(2)).timerange.min_time, n_maxcount);
   
      for k=1:1:n_maxcount1
       if k~= w(2)
        tempinternode_1(k)=rootnode(j).internode_1(w(1)).internode(k);
        indexinternode_1(k)=0;
       else
        tempinternode_1(k)=tempinternode1;
        indexinternode_1(k)=0;
       end
     end
        tempinternode_1(k+1)=tempinternode2;    
        indexinternode_1(k+1)=0;
 
   worst=0;
            seed0=1;
         seed1=size(tempinternode_1,2);
      for k1=1:1:(size(tempinternode_1,2)-1)               
        for  k2=(k1+1):1:(size(tempinternode_1,2))
 waste=(rootnode(j).internode_1(w(1)).pricerange.max_price-rootnode(j).internode_1(w(1)).pricerange.min_price)*(rootnode(j).internode_1(w(1)).timerange.max_time-rootnode(j).internode_1(w(1)).timerange.min_time)-(tempinternode_1(k1).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k1).timerange.max_time-tempinternode_1(k1).timerange.min_time)-(tempinternode_1(k2).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k2).timerange.max_time-tempinternode_1(k2).timerange.min_time);
            if  waste>worst                
                worst=waste;
                seed0=k1;
                seed1=k2;           
            end
        end 
      end 
  [internode_1]=splitnode(tempinternode_1, seed0, seed1, indexinternode_1); 
        
        for k=1:1:n_maxcount1
       if k~= w(1)
        tempinternode_2(k)=rootnode(j).internode_1(k);
        indexinternode_1(k)=0;
       else
        tempinternode_2(k)=internode_1(1);
        indexinternode_1(k)=0;
       end
        end
        tempinternode_2(k+1)=internode_1(2);    
        indexinternode_1(k+1)=0;
        rootnode(j).internode_1=[];  
   worst=0;
            seed0=1;
         seed1=size(tempinternode_2,2);
      for k1=1:1:(size(tempinternode_2,2)-1)             
        for  k2=(k1+1):1:(size(tempinternode_2,2))
 waste=(rootnode(j).pricerange.max_price-rootnode(j).pricerange.min_price)*(rootnode(j).timerange.max_time-rootnode(j).timerange.min_time)-(tempinternode_2(k1).pricerange.max_price-tempinternode_2(k1).pricerange.min_price)*(tempinternode_2(k1).timerange.max_time-tempinternode_2(k1).timerange.min_time)-(tempinternode_2(k2).pricerange.max_price-tempinternode_2(k1).pricerange.min_price)*(tempinternode_2(k2).timerange.max_time-tempinternode_2(k2).timerange.min_time);
            if  waste>worst                
                worst=waste;
                seed0=k1;
                seed1=k2;           
            end
        end     
      end 
      
     rootnode(j).n_level=rootnode(j).n_level+1; %%��������1 
   
    if  rootnode(j).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ��С
        rootnode(j).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end 
    
    if rootnode(j).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ����
        rootnode(j).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end 
    
    rootnode(j).timerange.max_time=timechange(cell2mat(CC.time(i)));  
                 [internode_2]=splitnode1(tempinternode_2, seed0, seed1, indexinternode_1);       
      %%925��  
 rootnode(j).internode_2=internode_2;
      
          
  end  %%rootnode(j).n_count+1<=n_maxcount
  
  
        
    end  %% (rootnode(j).internode_1(w(1)).n_count+1<=n_maxcount)
         
    end  %% ((rootnode(j).internode_1(w(1)).internode(w(2)).n_count+1) <= n_maxcount)
                
 end   
      
elseif   rootnode(j).n_level==3 %%(�������ﶥ����)    
    
    
   if  rootnode(j).internode_2(1).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode_2(1).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end 
   if  rootnode(j).internode_2(1).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode_2(1).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end     
   if (u1~=u2) && (rootnode(j).internode_2(1).pricerange.max_price~=rootnode(j).internode_2(1).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode_2(1).timerange.min_time)
   v=((abs(u1-rootnode(j).internode_2(1).pricerange.max_price)+abs(u2-rootnode(j).internode_2(1).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode_2(1).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode_2(1).timerange.min_time));
   end
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode_2(1).timerange.min_time
       
       if (u1~=u2) && (rootnode(j).internode_2(1).pricerange.max_price~=rootnode(j).internode_2(1).pricerange.min_price)
            v=(abs(u1-rootnode(j).internode_2(1).pricerange.max_price)+abs(u2-rootnode(j).internode_2(1).pricerange.min_price))/(u1-u2);
       else 
            v=0;
       end
       
   end 
   w(1)=1;
   internode2_num=size(rootnode(j).internode_2, 2);
     for p=2:1:internode2_num
   if  rootnode(j).internode_2(p).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode_2(p).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end
  
   if  rootnode(j).internode_2(p).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode_2(p).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end  
   if (u1~=u2) && (rootnode(j).internode_2(p).pricerange.max_price~=rootnode(j).internode_2(p).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode_2(p).timerange.min_time)
   v1=((abs(u1-rootnode(j).internode_2(p).pricerange.max_price)+abs(u2-rootnode(j).internode_2(p).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode_2(p).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode_2(p).timerange.min_time));
   end  
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode_2(p).timerange.min_time     
       if (u1~=u2) && (rootnode(j).internode_2(p).pricerange.max_price~=rootnode(j).internode_2(p).pricerange.min_price)
            v1=(abs(u1-rootnode(j).internode_2(p).pricerange.max_price)+abs(u2-rootnode(j).internode_2(p).pricerange.min_price))/(u1-u2);
       else 
            v1=0;
       end      
   end     
   if   v1<v     
       w(1)=p;
       v=v1;
   end  
    end %% p=2:1:rootnode(j).n_count
   if  rootnode(j).internode_2(w(1)).internode_1(1).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode_2(w(1)).internode_1(1).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end
   if  rootnode(j).internode_2(w(1)).internode_1(1).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode_2(w(1)).internode_1(1).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end
   if (u1~=u2) && (rootnode(j).internode_2(w(1)).internode_1(1).pricerange.max_price~=rootnode(j).internode_2(w(1)).internode_1(1).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode_2(w(1)).internode_1(1).timerange.min_time)
   v=((abs(u1-rootnode(j).internode_2(w(1)).internode_1(1).pricerange.max_price)+abs(u2-rootnode(j).internode_2(w(1)).internode_1(1).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode_2(w(1)).internode_1(1).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode_2(w(1)).internode_1(1).timerange.min_time));
   end
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode_2(w(1)).internode_1(1).timerange.min_time   
       if (u1~=u2) && (rootnode(j).internode_2(w(1)).internode_1(1).pricerange.max_price~=rootnode(j).internode_2(w(1)).internode_1(1).pricerange.min_price)
            v=(abs(u1-rootnode(j).internode_2(w(1)).internode_1(1).pricerange.max_price)+abs(u2-rootnode(j).internode_2(w(1)).internode_1(1).pricerange.min_price))/(u1-u2);
       else 
            v=0;
       end      
   end
   w(2)=1;
     internode1_num=size(rootnode(j).internode_2(w(1)).internode_1, 2);
   for p=2:1:internode1_num
   if  rootnode(j).internode_2(w(1)).internode_1(p).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode_2(w(1)).internode_1(p).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end  
   if  rootnode(j).internode_2(w(1)).internode_1(p).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode_2(w(1)).internode_1(p).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end
   
   if (u1~=u2) && (rootnode(j).internode_2(w(1)).internode_1(p).pricerange.max_price~=rootnode(j).internode_2(w(1)).internode_1(p).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode_2(w(1)).internode_1(p).timerange.min_time)
   v1=((abs(u1-rootnode(j).internode_2(w(1)).internode_1(p).pricerange.max_price)+abs(u2-rootnode(j).internode_2(w(1)).internode_1(p).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode_2(w(1)).internode_1(p).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode_2(w(1)).internode_1(p).timerange.min_time));
   end
   
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode_2(w(1)).internode_1(p).timerange.min_time
       
       if (u1~=u2) && (rootnode(j).internode_2(w(1)).internode_1(p).pricerange.max_price~=rootnode(j).internode_2(w(1)).internode_1(p).pricerange.min_price)
            v1=(abs(u1-rootnode(j).internode_2(w(1)).internode_1(p).pricerange.max_price)+abs(u2-rootnode(j).internode_2(w(1)).internode_1(p).pricerange.min_price))/(u1-u2);
       else 
            v1=0;
       end
       
   end    
   if   v1<v      
       w(2)=p;
       v=v1;
   end
    end %% p=2:1:rootnode(j).n_count
   if  rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(1).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(1).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end
   if  rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(1).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(1).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end
   if (u1~=u2) && (rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(1).pricerange.max_price~=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(1).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(1).timerange.min_time)
   v=((abs(u1-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(1).pricerange.max_price)+abs(u2-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(1).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(1).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(1).timerange.min_time));
   end
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(1).timerange.min_time   
       if (u1~=u2) && (rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(1).pricerange.max_price~=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(1).pricerange.min_price)
            v=(abs(u1-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(1).pricerange.max_price)+abs(u2-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(1).pricerange.min_price))/(u1-u2);
       else 
            v=0;
       end      
   end
   w(3)=1;  
    node_num=size(rootnode(j).internode_2(w(1)).internode_1(w(2)).internode, 2);
   for p=2:1:node_num
   if  rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(p).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(p).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end  
   if  rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(p).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(p).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end
   
   if (u1~=u2) && (rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(p).pricerange.max_price~=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(p).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(p).timerange.min_time)
   v1=((abs(u1-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(p).pricerange.max_price)+abs(u2-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(p).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(p).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(p).timerange.min_time));
   end
   
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(p).timerange.min_time
       
       if (u1~=u2) && (rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(p).pricerange.max_price~=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(p).pricerange.min_price)
            v1=(abs(u1-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(p).pricerange.max_price)+abs(u2-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(p).pricerange.min_price))/(u1-u2);
       else 
            v1=0;
       end
       
   end    
   if   v1<v      
       w(3)=p;
       v=v1;
   end
    end %% p=2:1:rootnode(j).n_count
%%��Ӧ��
      [pot, same]=sameitem(rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode, CC.itemtitle(i), CC.time(i));
 if  same==1
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(pot).sum=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(pot).sum+1;
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(pot).rating(1)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(pot).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(pot).rating(2)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(pot).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(pot).rating(3)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(pot).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(pot).rating(4)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(pot).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(pot).rating(5)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(pot).rating(5)+str2double((CC.rating5(i)));
    
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).sum=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).sum+1;
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(1)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(2)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(3)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(4)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(5)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(5)+str2double((CC.rating5(i)));
    
    rootnode(j).internode_2(w(1)).internode_1(w(2)).sum=rootnode(j).internode_2(w(1)).internode_1(w(2)).sum+1;
    rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(1)=rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(2)=rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(3)=rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(4)=rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(5)=rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(5)+str2double((CC.rating5(i)));
    
    rootnode(j).internode_2(w(1)).sum=rootnode(j).internode_2(w(1)).sum+1;
    rootnode(j).internode_2(w(1)).rating(1)=rootnode(j).internode_2(w(1)).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode_2(w(1)).rating(2)=rootnode(j).internode_2(w(1)).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode_2(w(1)).rating(3)=rootnode(j).internode_2(w(1)).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode_2(w(1)).rating(4)=rootnode(j).internode_2(w(1)).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode_2(w(1)).rating(5)=rootnode(j).internode_2(w(1)).rating(5)+str2double((CC.rating5(i)));
    
 elseif same==0
    leaf_num=size(rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode, 2);
     if ((leaf_num+1) <= n_maxcount)
%     %% ??��?????????node 
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).sum=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).sum+1;
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(1)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(2)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(3)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(4)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(5)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).rating(5)+str2double((CC.rating5(i)));
   
    if  rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) 
        rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end 
    
    if rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i))))
        rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end 
      
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.max_time=timechange(cell2mat(CC.time(i))); 
    %%
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(leaf_num+1).itemname=CC.itemtitle(i);
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(leaf_num+1).price=round(str2double(cell2mat(CC.itemprice(i))));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(leaf_num+1).time=timechange(cell2mat(CC.time(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(leaf_num+1).sum=1;
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(leaf_num+1).rating(1)=str2double((CC.rating1(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(leaf_num+1).rating(2)=str2double((CC.rating2(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(leaf_num+1).rating(3)=str2double((CC.rating3(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(leaf_num+1).rating(4)=str2double((CC.rating4(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(leaf_num+1).rating(5)=str2double((CC.rating5(i)));
    
    rootnode(j).internode_2(w(1)).internode_1(w(2)).sum=rootnode(j).internode_2(w(1)).internode_1(w(2)).sum+1;
    rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(1)=rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(2)=rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(3)=rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(4)=rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(5)=rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(5)+str2double((CC.rating5(i)));
    
    if  rootnode(j).internode_2(w(1)).internode_1(w(2)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��??
        rootnode(j).internode_2(w(1)).internode_1(w(2)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end    
    if rootnode(j).internode_2(w(1)).internode_1(w(2)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��?��
        rootnode(j).internode_2(w(1)).internode_1(w(2)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end      
    rootnode(j).internode_2(w(1)).internode_1(w(2)).timerange.max_time=timechange(cell2mat(CC.time(i))); 
    
    rootnode(j).internode_2(w(1)).sum=rootnode(j).internode_2(w(1)).sum+1;
    rootnode(j).internode_2(w(1)).rating(1)=rootnode(j).internode_2(w(1)).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode_2(w(1)).rating(2)=rootnode(j).internode_2(w(1)).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode_2(w(1)).rating(3)=rootnode(j).internode_2(w(1)).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode_2(w(1)).rating(4)=rootnode(j).internode_2(w(1)).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode_2(w(1)).rating(5)=rootnode(j).internode_2(w(1)).rating(5)+str2double((CC.rating5(i)));
    if  rootnode(j).internode_2(w(1)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��??
        rootnode(j).internode_2(w(1)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end    
    if rootnode(j).internode_2(w(1)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��?��
        rootnode(j).internode_2(w(1)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end      
    rootnode(j).internode_2(w(1)).timerange.max_time=timechange(cell2mat(CC.time(i)));    
     elseif  ( (leaf_num+1) > n_maxcount )    
     for k=1:1:leaf_num       
        leaftemp(k)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(k);
        indexleaftemp(k)=0;
     end
    leaftemp(k+1).itemname=CC.itemtitle(i);
    leaftemp(k+1).sum=1;
    leaftemp(k+1).rating(1)=str2double((CC.rating1(i)));
    leaftemp(k+1).rating(2)=str2double((CC.rating2(i)));
    leaftemp(k+1).rating(3)=str2double((CC.rating3(i)));
    leaftemp(k+1).rating(4)=str2double((CC.rating4(i)));
    leaftemp(k+1).rating(5)=str2double((CC.rating5(i)));
    leaftemp(k+1).price=round(str2double(cell2mat(CC.itemprice(i))));
    leaftemp(k+1).time=timechange(cell2mat(CC.time(i)));
    indexleaftemp(k+1)=0;       
   
        worst=0;
   if (rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price)>0
    for k1=1:1:leaf_num              
        for  k2=(k1+1):1:(leaf_num+1)
           if  rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.max_time>rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.min_time          
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price))^2+(((leaftemp(k1).time- leaftemp(k2).time)/(rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.max_time-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.min_time))^2));
           else
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price))^2);
           end
            if  waste>worst               
                worst=waste;
                seed0=k1;
                seed1=k2;                      
            end
        end      
   end    
   end
  if (rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price)==0                           
                seed0=1;
                seed1=leaf_num+1;  
  end
  [tempinternode1, tempinternode2]=splitleaf(leaftemp, seed0, seed1, indexleaftemp, rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price, rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price, rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.max_time, rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.min_time, n_maxcount);
   
    if (node_num+1<=n_maxcount1)    
         rootnode(j).internode_2(w(1)).internode_1(w(2)).sum=rootnode(j).internode_2(w(1)).internode_1(w(2)).sum+1;
         rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(1)=rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(1)+str2double((CC.rating1(i)));
         rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(2)=rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(2)+str2double((CC.rating2(i)));
         rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(3)=rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(3)+str2double((CC.rating3(i)));
         rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(4)=rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(4)+str2double((CC.rating4(i)));
         rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(5)=rootnode(j).internode_2(w(1)).internode_1(w(2)).rating(5)+str2double((CC.rating5(i)));
         rootnode(j).internode_2(w(1)).sum=rootnode(j).internode_2(w(1)).sum+1;
         rootnode(j).internode_2(w(1)).rating(1)=rootnode(j).internode_2(w(1)).rating(1)+str2double((CC.rating1(i)));
          rootnode(j).internode_2(w(1)).rating(2)=rootnode(j).internode_2(w(1)).rating(2)+str2double((CC.rating2(i)));
           rootnode(j).internode_2(w(1)).rating(3)=rootnode(j).internode_2(w(1)).rating(3)+str2double((CC.rating3(i)));
            rootnode(j).internode_2(w(1)).rating(4)=rootnode(j).internode_2(w(1)).rating(4)+str2double((CC.rating4(i)));
             rootnode(j).internode_2(w(1)).rating(5)=rootnode(j).internode_2(w(1)).rating(5)+str2double((CC.rating5(i)));
             if  rootnode(j).internode_2(w(1)).internode_1(w(2)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i))))%% ?????????????��??
        rootnode(j).internode_2(w(1)).internode_1(w(2)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
             end 
    
          if rootnode(j).internode_2(w(1)).internode_1(w(2)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��?��
        rootnode(j).internode_2(w(1)).internode_1(w(2)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
          end 
    
          rootnode(j).internode_2(w(1)).internode_1(w(2)).timerange.max_time=timechange(cell2mat(CC.time(i))); 
          
             if  rootnode(j).internode_2(w(1)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��??
        rootnode(j).internode_2(w(1)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
             end 
    
          if rootnode(j).internode_2(w(1)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i))))%% ?????????????��?��
        rootnode(j).internode_2(w(1)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
          end 
    
           rootnode(j).internode_2(w(1)).timerange.max_time=timechange(cell2mat(CC.time(i))); 
             if  rootnode(j).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��??
        rootnode(j).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
             end 
    
          if rootnode(j).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��?��
            rootnode(j).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
          end 
    
          rootnode(j).internode_2(w(1)).internode_1(w(2)).timerange.max_time=timechange(cell2mat(CC.time(i))); 
          rootnode(j).internode_2(w(1)).timerange.max_time=timechange(cell2mat(CC.time(i))); 
           rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3))=tempinternode1;
           rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(node_num+1)=tempinternode2;
    else %%%%mark  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
     for k=1:1:leaf_num       
        leaftemp(k)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(k);
        indexleaftemp(k)=0;
     end
    leaftemp(k+1).itemname=CC.itemtitle(i);
    leaftemp(k+1).sum=1;
    leaftemp(k+1).rating(1)=str2double((CC.rating1(i)));
    leaftemp(k+1).rating(2)=str2double((CC.rating2(i)));
    leaftemp(k+1).rating(3)=str2double((CC.rating3(i)));
    leaftemp(k+1).rating(4)=str2double((CC.rating4(i)));
    leaftemp(k+1).rating(5)=str2double((CC.rating5(i)));
    leaftemp(k+1).price=round(str2double(cell2mat(CC.itemprice(i))));
    leaftemp(k+1).time=timechange(cell2mat(CC.time(i)));
    indexleaftemp(k+1)=0;       
   
        worst=0;
   if (rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price)>0
    for k1=1:1:leaf_num              
        for  k2=(k1+1):1:(leaf_num+1)
           if  rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.max_time>rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.min_time          
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price))^2+(((leaftemp(k1).time- leaftemp(k2).time)/(rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.max_time-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.min_time))^2));
           else
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price))^2);
           end
            if  waste>worst               
                worst=waste;
                seed0=k1;
                seed1=k2;                      
            end
        end      
   end    
   end
  if (rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price)==0                           
                seed0=1;
                seed1=leaf_num+1;  
  end
  [tempinternode1, tempinternode2]=splitleaf(leaftemp, seed0, seed1, indexleaftemp, rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price, rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price, rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.max_time, rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.min_time, n_maxcount);
                       
  if  internode1_num+1<=n_maxcount1

         rootnode(j).internode_2(w(1)).sum=rootnode(j).internode_2(w(1)).sum+1;
         rootnode(j).internode_2(w(1)).rating(1)=rootnode(j).internode_2(w(1)).rating(1)+str2double((CC.rating1(i)));
         rootnode(j).internode_2(w(1)).rating(2)=rootnode(j).internode_2(w(1)).rating(2)+str2double((CC.rating2(i)));
         rootnode(j).internode_2(w(1)).rating(3)=rootnode(j).internode_2(w(1)).rating(3)+str2double((CC.rating3(i)));
         rootnode(j).internode_2(w(1)).rating(4)=rootnode(j).internode_2(w(1)).rating(4)+str2double((CC.rating4(i)));
         rootnode(j).internode_2(w(1)).rating(5)=rootnode(j).internode_2(w(1)).rating(5)+str2double((CC.rating5(i)));
    if  rootnode(j).internode_2(w(1)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��??
        rootnode(j).internode_2(w(1)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end 
    
    if rootnode(j).internode_2(w(1)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��?��
        rootnode(j).internode_2(w(1)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end     
    rootnode(j).internode_2(w(1)).timerange.max_time=timechange(cell2mat(CC.time(i)));             
     if  rootnode(j).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i))))%% ?????????????��??
        rootnode(j).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end 
    
    if rootnode(j).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��?��
        rootnode(j).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end   
    rootnode(j).timerange.max_time=timechange(cell2mat(CC.time(i))); 
     for k=1:1:n_maxcount1
       if k~= w(3)
        tempinternode_1(k)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(k);
        indexinternode_1(k)=0;
       else
        tempinternode_1(k)=tempinternode1;
        indexinternode_1(k)=0;
       end
    end
        tempinternode_1(k+1)=tempinternode2;    
        indexinternode_1(k+1)=0;
 
   worst=0;
            seed0=1;
         seed1=size(tempinternode_1,2);
      for k1=1:1:(size(tempinternode_1,2)-1)        
        for  k2=(k1+1):1:(size(tempinternode_1,2))
 waste=(rootnode(j).internode_2(w(1)).internode_1(w(2)).pricerange.max_price-rootnode(j).internode_2(w(1)).internode_1(w(2)).pricerange.min_price)*(rootnode(j).internode_2(w(1)).internode_1(w(2)).timerange.max_time-rootnode(j).internode_2(w(1)).internode_1(w(2)).timerange.min_time)-(tempinternode_1(k1).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k1).timerange.max_time-tempinternode_1(k1).timerange.min_time)-(tempinternode_1(k2).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k2).timerange.max_time-tempinternode_1(k2).timerange.min_time);
            if  waste>worst                
                worst=waste;
                seed0=k1;
                seed1=k2;           
            end
        end 
      end 
       [internode_1]=splitnode(tempinternode_1, seed0, seed1, indexinternode_1); 

           rootnode(j).internode_2(w(1)).internode_1(w(2))=internode_1(1);
           rootnode(j).internode_2(w(1)).internode_1(internode1_num+1)=internode_1(2);
           
  else

      if  internode2_num+1<=n_maxcount1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          
     for k=1:1:leaf_num       
        leaftemp(k)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(k);
        indexleaftemp(k)=0;
     end
    leaftemp(k+1).itemname=CC.itemtitle(i);
    leaftemp(k+1).sum=1;
    leaftemp(k+1).rating(1)=str2double((CC.rating1(i)));
    leaftemp(k+1).rating(2)=str2double((CC.rating2(i)));
    leaftemp(k+1).rating(3)=str2double((CC.rating3(i)));
    leaftemp(k+1).rating(4)=str2double((CC.rating4(i)));
    leaftemp(k+1).rating(5)=str2double((CC.rating5(i)));
    leaftemp(k+1).price=round(str2double(cell2mat(CC.itemprice(i))));
    leaftemp(k+1).time=timechange(cell2mat(CC.time(i)));
    indexleaftemp(k+1)=0;       
   
        worst=0;
   if (rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price)>0
    for k1=1:1:leaf_num              
        for  k2=(k1+1):1:(leaf_num+1)
           if  rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.max_time>rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.min_time          
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price))^2+(((leaftemp(k1).time- leaftemp(k2).time)/(rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.max_time-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.min_time))^2));
           else
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price))^2);
           end
            if  waste>worst               
                worst=waste;
                seed0=k1;
                seed1=k2;                      
            end
        end      
   end    
   end
  if (rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price)==0                           
                seed0=1;
                seed1=leaf_num+1;  
  end
  [tempinternode1, tempinternode2]=splitleaf(leaftemp, seed0, seed1, indexleaftemp, rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price, rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price, rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.max_time, rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.min_time, n_maxcount);
          
 
       %  rootnode(j).n_count=rootnode(j).n_count+1;
          
     if  rootnode(j).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��??
        rootnode(j).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end 
    
    if rootnode(j).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i))))%% ?????????????��?��
        rootnode(j).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end   
    rootnode(j).timerange.max_time=timechange(cell2mat(CC.time(i))); 
    
     for k=1:1:n_maxcount1
       if k~= w(3)
        tempinternode_1(k)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(k);
        indexinternode_1(k)=0;
       else
        tempinternode_1(k)=tempinternode1;
        indexinternode_1(k)=0;
       end
    end
        tempinternode_1(k+1)=tempinternode2;    
        indexinternode_1(k+1)=0;
 
   worst=0;
            seed0=1;
         seed1=size(tempinternode_1,2);
      for k1=1:1:(size(tempinternode_1,2)-1)
               
        for  k2=(k1+1):1:(size(tempinternode_1,2))
 waste=(rootnode(j).internode_2(w(1)).internode_1(w(2)).pricerange.max_price-rootnode(j).internode_2(w(1)).internode_1(w(2)).pricerange.min_price)*(rootnode(j).internode_2(w(1)).internode_1(w(2)).timerange.max_time-rootnode(j).internode_2(w(1)).internode_1(w(2)).timerange.min_time)-(tempinternode_1(k1).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k1).timerange.max_time-tempinternode_1(k1).timerange.min_time)-(tempinternode_1(k2).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k2).timerange.max_time-tempinternode_1(k2).timerange.min_time);
            if  waste>worst                
                worst=waste;
                seed0=k1;
                seed1=k2;           
            end
        end 
        
      end 
      
 [internode_1]=splitnode(tempinternode_1, seed0, seed1, indexinternode_1); 

  
     for k=1:1:n_maxcount1
       if k~= w(2)
        tempinternode_2(k)=rootnode(j).internode_2(w(1)).internode_1(k);
        indexinternode_1(k)=0;
       else
        tempinternode_2(k)=internode_1(1);
        indexinternode_1(k)=0;
       end
    end
        tempinternode_2(k+1)=internode_1(2);    
        indexinternode_1(k+1)=0; 
                 seed0=1;
         seed1=size(tempinternode_2,2);
      for k1=1:1:(size(tempinternode_2,2)-1)
               
        for  k2=(k1+1):1:(size(tempinternode_2,2))
 waste=(rootnode(j).internode_2(w(1)).pricerange.max_price-rootnode(j).internode_2(w(1)).pricerange.min_price)*(rootnode(j).internode_2(w(1)).timerange.max_time-rootnode(j).internode_2(w(1)).timerange.min_time)-(tempinternode_1(k1).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k1).timerange.max_time-tempinternode_1(k1).timerange.min_time)-(tempinternode_1(k2).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k2).timerange.max_time-tempinternode_1(k2).timerange.min_time);
            if  waste>worst                
                worst=waste;
                seed0=k1;
                seed1=k2;           
            end
        end 
        
      end       
        
       
   [internode_2]=splitnode1(tempinternode_2, seed0, seed1, indexinternode_1);
    rootnode(j).internode_2(w(1))=internode_2(2);
    rootnode(j).internode_2(internode2_num+1)=internode_2(1);
       
      else
         % test='���а���������'    %#ok<NOPTS>
      for k=1:1:leaf_num       
        leaftemp(k)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).leafnode(k);
        indexleaftemp(k)=0;
     end
    leaftemp(k+1).itemname=CC.itemtitle(i);
    leaftemp(k+1).sum=1;
    leaftemp(k+1).rating(1)=str2double((CC.rating1(i)));
    leaftemp(k+1).rating(2)=str2double((CC.rating2(i)));
    leaftemp(k+1).rating(3)=str2double((CC.rating3(i)));
    leaftemp(k+1).rating(4)=str2double((CC.rating4(i)));
    leaftemp(k+1).rating(5)=str2double((CC.rating5(i)));
    leaftemp(k+1).price=round(str2double(cell2mat(CC.itemprice(i))));
    leaftemp(k+1).time=timechange(cell2mat(CC.time(i)));
    indexleaftemp(k+1)=0;       
   
        worst=0;
   if (rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price)>0
    for k1=1:1:leaf_num              
        for  k2=(k1+1):1:(leaf_num+1)
           if  rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.max_time>rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.min_time          
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price))^2+(((leaftemp(k1).time- leaftemp(k2).time)/(rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.max_time-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.min_time))^2));
           else
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price))^2);
           end
            if  waste>worst               
                worst=waste;
                seed0=k1;
                seed1=k2;                      
            end
        end      
   end    
   end
  if (rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price-rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price)==0                           
                seed0=1;
                seed1=leaf_num+1;  
  end
  [tempinternode1, tempinternode2]=splitleaf(leaftemp, seed0, seed1, indexleaftemp, rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.max_price, rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).pricerange.min_price, rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.max_time, rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(w(3)).timerange.min_time, n_maxcount);
     for k=1:1:n_maxcount1
       if k~= w(3)
        tempinternode_1(k)=rootnode(j).internode_2(w(1)).internode_1(w(2)).internode(k);
        indexinternode_1(k)=0;
       else
        tempinternode_1(k)=tempinternode1;
        indexinternode_1(k)=0;
       end
    end
        tempinternode_1(k+1)=tempinternode2;    
        indexinternode_1(k+1)=0;
 
   worst=0;
            seed0=1;
         seed1=size(tempinternode_1,2);
      for k1=1:1:(size(tempinternode_1,2)-1)
               
        for  k2=(k1+1):1:(size(tempinternode_1,2))
 waste=(rootnode(j).internode_2(w(1)).internode_1(w(2)).pricerange.max_price-rootnode(j).internode_2(w(1)).internode_1(w(2)).pricerange.min_price)*(rootnode(j).internode_2(w(1)).internode_1(w(2)).timerange.max_time-rootnode(j).internode_2(w(1)).internode_1(w(2)).timerange.min_time)-(tempinternode_1(k1).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k1).timerange.max_time-tempinternode_1(k1).timerange.min_time)-(tempinternode_1(k2).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k2).timerange.max_time-tempinternode_1(k2).timerange.min_time);
            if  waste>worst                
                worst=waste;
                seed0=k1;
                seed1=k2;           
            end
        end 
        
      end 
      
 [internode_1]=splitnode(tempinternode_1, seed0, seed1, indexinternode_1); 

  
     for k=1:1:n_maxcount1
       if k~= w(2)
        tempinternode_2(k)=rootnode(j).internode_2(w(1)).internode_1(k);
        indexinternode_1(k)=0;
       else
        tempinternode_2(k)=internode_1(1);
        indexinternode_1(k)=0;
       end
    end
        tempinternode_2(k+1)=internode_1(2);    
        indexinternode_1(k+1)=0; 
       worst=0;
                seed0=1;
         seed1=size(tempinternode_2,2);
      for k1=1:1:(size(tempinternode_2,2)-1)
               
        for  k2=(k1+1):1:(size(tempinternode_2,2))
 waste=(rootnode(j).internode_2(w(1)).pricerange.max_price-rootnode(j).internode_2(w(1)).pricerange.min_price)*(rootnode(j).internode_2(w(1)).timerange.max_time-rootnode(j).internode_2(w(1)).timerange.min_time)-(tempinternode_1(k1).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k1).timerange.max_time-tempinternode_1(k1).timerange.min_time)-(tempinternode_1(k2).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k2).timerange.max_time-tempinternode_1(k2).timerange.min_time);
            if  waste>worst                
                worst=waste;
                seed0=k1;
                seed1=k2;           
            end
        end 
        
      end    
              
   [internode_2]=splitnode1(tempinternode_2, seed0, seed1, indexinternode_1);              
      
       for k=1:1:n_maxcount1
       if k~= w(1)
        tempinternode_3(k)=rootnode(j).internode_2(k);
        indexinternode_1(k)=0;
       else
        tempinternode_3(k)=internode_2(1);
        indexinternode_1(k)=0;
       end
        end
        tempinternode_3(k+1)=internode_2(2);    
        indexinternode_1(k+1)=0;
        rootnode(j).internode_2=[];  
   worst=0;
            seed0=1;
         seed1=size(tempinternode_3,2);
      for k1=1:1:(size(tempinternode_3,2)-1)             
        for  k2=(k1+1):1:(size(tempinternode_3,2))
 waste=(rootnode(j).pricerange.max_price-rootnode(j).pricerange.min_price)*(rootnode(j).timerange.max_time-rootnode(j).timerange.min_time)-(tempinternode_3(k1).pricerange.max_price-tempinternode_3(k1).pricerange.min_price)*(tempinternode_3(k1).timerange.max_time-tempinternode_3(k1).timerange.min_time)-(tempinternode_3(k2).pricerange.max_price-tempinternode_3(k1).pricerange.min_price)*(tempinternode_3(k2).timerange.max_time-tempinternode_3(k2).timerange.min_time);
            if  waste>worst                
                worst=waste;
                seed0=k1;
                seed1=k2;           
            end
        end     
      end 
        rootnode(j).n_level=rootnode(j).n_level+1; %%��������1 
   
    if  rootnode(j).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ��С
        rootnode(j).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end 
    
    if rootnode(j).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ����
        rootnode(j).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end 
    
    rootnode(j).timerange.max_time=timechange(cell2mat(CC.time(i)));  
    
    [internode_3]=splitnode2(tempinternode_3, seed0, seed1, indexinternode_1);
     rootnode(j).internode_3=internode_3;
         
      end
    
      
   end
        
        
    end
                  
     end %%�����
       
 end

elseif   rootnode(j).n_level==4 %%(�������ﶥ����)    
    
   %%%%% 1208
 
   if  rootnode(j).internode_3(1).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode_3(1).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end 
   if  rootnode(j).internode_3(1).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode_3(1).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end     
   if (u1~=u2) && (rootnode(j).internode_3(1).pricerange.max_price~=rootnode(j).internode_3(1).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode_3(1).timerange.min_time)
   v=((abs(u1-rootnode(j).internode_3(1).pricerange.max_price)+abs(u2-rootnode(j).internode_3(1).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode_3(1).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode_3(1).timerange.min_time));
   end
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode_3(1).timerange.min_time
       
       if (u1~=u2) && (rootnode(j).internode_3(1).pricerange.max_price~=rootnode(j).internode_3(1).pricerange.min_price)
            v=(abs(u1-rootnode(j).internode_3(1).pricerange.max_price)+abs(u2-rootnode(j).internode_3(1).pricerange.min_price))/(u1-u2);
       else 
            v=0;
       end
       
   end 
   w(1)=1;
   internode3_num=size(rootnode(j).internode_3, 2);
     for p=2:1:internode3_num
   if  rootnode(j).internode_3(p).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode_3(p).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end
  
   if  rootnode(j).internode_3(p).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode_3(p).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end  
   if (u1~=u2) && (rootnode(j).internode_3(p).pricerange.max_price~=rootnode(j).internode_3(p).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode_3(p).timerange.min_time)
   v1=((abs(u1-rootnode(j).internode_3(p).pricerange.max_price)+abs(u2-rootnode(j).internode_3(p).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode_3(p).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode_3(p).timerange.min_time));
   end  
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode_3(p).timerange.min_time     
       if (u1~=u2) && (rootnode(j).internode_3(p).pricerange.max_price~=rootnode(j).internode_3(p).pricerange.min_price)
            v1=(abs(u1-rootnode(j).internode_3(p).pricerange.max_price)+abs(u2-rootnode(j).internode_3(p).pricerange.min_price))/(u1-u2);
       else 
            v1=0;
       end      
   end     
   if   v1<v     
       w(1)=p;
       v=v1;
   end  
    end %% p=2:1:rootnode(j).n_count
   if  rootnode(j).internode_3(w(1)).internode_2(1).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode_3(w(1)).internode_2(1).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end
   if  rootnode(j).internode_3(w(1)).internode_2(1).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode_3(w(1)).internode_2(1).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end
   if (u1~=u2) && (rootnode(j).internode_3(w(1)).internode_2(1).pricerange.max_price~=rootnode(j).internode_3(w(1)).internode_2(1).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode_3(w(1)).internode_2(1).timerange.min_time)
   v=((abs(u1-rootnode(j).internode_3(w(1)).internode_2(1).pricerange.max_price)+abs(u2-rootnode(j).internode_3(w(1)).internode_2(1).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode_3(w(1)).internode_2(1).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode_3(w(1)).internode_2(1).timerange.min_time));
   end
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode_3(w(1)).internode_2(1).timerange.min_time   
       if (u1~=u2) && (rootnode(j).internode_3(w(1)).internode_2(1).pricerange.max_price~=rootnode(j).internode_3(w(1)).internode_2(1).pricerange.min_price)
            v=(abs(u1-rootnode(j).internode_3(w(1)).internode_2(1).pricerange.max_price)+abs(u2-rootnode(j).internode_3(w(1)).internode_2(1).pricerange.min_price))/(u1-u2);
       else 
            v=0;
       end      
   end
   w(2)=1;
     internode2_num=size(rootnode(j).internode_3(w(1)).internode_2, 2);
   for p=2:1:internode2_num
   if  rootnode(j).internode_3(w(1)).internode_2(p).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode_3(w(1)).internode_2(p).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end  
   if  rootnode(j).internode_3(w(1)).internode_2(p).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode_3(w(1)).internode_2(p).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end
   
   if (u1~=u2) && (rootnode(j).internode_3(w(1)).internode_2(p).pricerange.max_price~=rootnode(j).internode_3(w(1)).internode_2(p).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode_3(w(1)).internode_2(p).timerange.min_time)
   v1=((abs(u1-rootnode(j).internode_3(w(1)).internode_2(p).pricerange.max_price)+abs(u2-rootnode(j).internode_3(w(1)).internode_2(p).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode_3(w(1)).internode_2(p).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode_3(w(1)).internode_2(p).timerange.min_time));
   end
   
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode_3(w(1)).internode_2(p).timerange.min_time
       
       if (u1~=u2) && (rootnode(j).internode_3(w(1)).internode_2(p).pricerange.max_price~=rootnode(j).internode_3(w(1)).internode_2(p).pricerange.min_price)
            v1=(abs(u1-rootnode(j).internode_3(w(1)).internode_2(p).pricerange.max_price)+abs(u2-rootnode(j).internode_3(w(1)).internode_2(p).pricerange.min_price))/(u1-u2);
       else 
            v1=0;
       end
       
   end    
   if   v1<v      
       w(2)=p;
       v=v1;
   end
    end %% p=2:1:rootnode(j).n_count
   if  rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(1).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(1).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end
   if  rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(1).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(1).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end
   if (u1~=u2) && (rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(1).pricerange.max_price~=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(1).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(1).timerange.min_time)
   v=((abs(u1-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(1).pricerange.max_price)+abs(u2-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(1).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(1).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(1).timerange.min_time));
   end
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(1).timerange.min_time   
       if (u1~=u2) && (rootnode(j).internode_3(w(1)).internode_3(w(2)).internode_1(1).pricerange.max_price~=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(1).pricerange.min_price)
            v=(abs(u1-rootnode(j).internode_3(w(1)).internode_3(w(2)).internode_1(1).pricerange.max_price)+abs(u2-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(1).pricerange.min_price))/(u1-u2);
       else 
            v=0;
       end      
   end
   w(3)=1;  
    internode1_num=size(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1, 2);
   for p=2:1:internode1_num
   if  rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(p).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(p).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end  
   if  rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(p).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(p).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end
   
   if (u1~=u2) && (rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(p).pricerange.max_price~=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(p).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(p).timerange.min_time)
   v1=((abs(u1-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(p).pricerange.max_price)+abs(u2-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(p).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(p).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(p).timerange.min_time));
   end
   
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(p).timerange.min_time
       
       if (u1~=u2) && (rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(p).pricerange.max_price~=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(p).pricerange.min_price)
            v1=(abs(u1-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(p).pricerange.max_price)+abs(u2-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(p).pricerange.min_price))/(u1-u2);
       else 
            v1=0;
       end
       
   end    
   if   v1<v      
       w(3)=p;
       v=v1;
   end
    end %% p=2:1:rootnode(j).n_count

   if  rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(1).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(1).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end 
   if  rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(1).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(1).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end     
   if (u1~=u2) && (rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(1).pricerange.max_price~=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(1).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(1).timerange.min_time)
   v=((abs(u1-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(1).pricerange.max_price)+abs(u2-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(1).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(1).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(1).timerange.min_time));
   end
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(1).timerange.min_time
       
       if (u1~=u2) && (rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(1).pricerange.max_price~=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(1).pricerange.min_price)
            v=(abs(u1-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(1).pricerange.max_price)+abs(u2-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(1).pricerange.min_price))/(u1-u2);
       else 
            v=0;
       end
       
   end 
   w(4)=1;
   node_num=size(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode, 2);
     for p=2:1:node_num
   if  rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(p).pricerange.max_price>round(str2double(cell2mat(CC.itemprice(i))))
       u1=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(p).pricerange.max_price;
   else
       u1=round(str2double(cell2mat(CC.itemprice(i))));
   end
  
   if  rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(p).pricerange.min_price<round(str2double(cell2mat(CC.itemprice(i))))
       u2=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(p).pricerange.min_price;
   else
       u2=round(str2double(cell2mat(CC.itemprice(i))));
   end  
   if (u1~=u2) && (rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(p).pricerange.max_price~=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(p).pricerange.min_price) && (timechange(cell2mat(CC.time(i)))~=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(p).timerange.min_time)
   v1=((abs(u1-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(p).pricerange.max_price)+abs(u2-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(p).pricerange.min_price))/(u1-u2))+((timechange(cell2mat(CC.time(i)))-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(p).timerange.max_time)/(timechange(cell2mat(CC.time(i)))-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(p).timerange.min_time));
   end  
   if timechange(cell2mat(CC.time(i)))==rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(p).timerange.min_time     
       if (u1~=u2) && (rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(p).pricerange.max_price~=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(p).pricerange.min_price)
            v1=(abs(u1-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(p).pricerange.max_price)+abs(u2-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(p).pricerange.min_price))/(u1-u2);
       else 
            v1=0;
       end      
   end     
   if   v1<v     
       w(4)=p;
       v=v1;
   end  
    end %% p=2:1:rootnode(j).n_count
   
      [pot, same]=sameitem(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode, CC.itemtitle(i), CC.time(i));
 if  same==1
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(pot).sum=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(pot).sum+1;
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(pot).rating(1)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(pot).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(pot).rating(2)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(pot).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(pot).rating(3)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(pot).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(pot).rating(4)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(pot).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(pot).rating(5)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(pot).rating(5)+str2double((CC.rating5(i)));
    
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).sum=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).sum+1;
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(1)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(2)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(3)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(4)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(5)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(5)+str2double((CC.rating5(i)));
    
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).sum=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).sum+1;
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(1)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(2)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(3)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(4)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(5)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(5)+str2double((CC.rating5(i)));
    
    rootnode(j).internode_3(w(1)).internode_2(w(2)).sum=rootnode(j).internode_3(w(1)).internode_2(w(2)).sum+1;
    rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(1)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(2)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(3)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(4)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(5)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(5)+str2double((CC.rating5(i)));
   
    rootnode(j).internode_3(w(1)).sum=rootnode(j).internode_3(w(1)).sum+1;
    rootnode(j).internode_3(w(1)).rating(1)=rootnode(j).internode_3(w(1)).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode_3(w(1)).rating(2)=rootnode(j).internode_3(w(1)).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode_3(w(1)).rating(3)=rootnode(j).internode_3(w(1)).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode_3(w(1)).rating(4)=rootnode(j).internode_3(w(1)).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode_3(w(1)).rating(5)=rootnode(j).internode_3(w(1)).rating(5)+str2double((CC.rating5(i)));
          
 elseif same==0
    leaf_num=size(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode, 2); 
     if ((leaf_num+1) <= n_maxcount)
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).sum=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).sum+1;
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(1)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(2)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(3)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(4)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(5)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).rating(5)+str2double((CC.rating5(i)));
   
    if  rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) 
        rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end 
    
    if rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i))))
        rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end 
      
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.max_time=timechange(cell2mat(CC.time(i))); 
    %%
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(leaf_num+1).itemname=CC.itemtitle(i);
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(leaf_num+1).price=round(str2double(cell2mat(CC.itemprice(i))));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(leaf_num+1).time=timechange(cell2mat(CC.time(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(leaf_num+1).sum=1;
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(leaf_num+1).rating(1)=str2double((CC.rating1(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(leaf_num+1).rating(2)=str2double((CC.rating2(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(leaf_num+1).rating(3)=str2double((CC.rating3(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(leaf_num+1).rating(4)=str2double((CC.rating4(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(leaf_num+1).rating(5)=str2double((CC.rating5(i)));
    
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).sum=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).sum+1;
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(1)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(2)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(3)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(4)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(5)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(5)+str2double((CC.rating5(i)));
    
    if  rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��??
        rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end    
    if rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��?��
        rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end      
    rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).timerange.max_time=timechange(cell2mat(CC.time(i))); 
    
    rootnode(j).internode_3(w(1)).internode_2(w(2)).sum=rootnode(j).internode_3(w(1)).internode_2(w(2)).sum+1;
    rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(1)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(2)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(3)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(4)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(5)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(5)+str2double((CC.rating5(i)));
    if  rootnode(j).internode_3(w(1)).internode_2(w(2)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��??
        rootnode(j).internode_3(w(1)).internode_2(w(2)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end    
    if rootnode(j).internode_3(w(1)).internode_2(w(2)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��?��
        rootnode(j).internode_3(w(1)).internode_2(w(2)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end      
    rootnode(j).internode_3(w(1)).internode_2(w(2)).timerange.max_time=timechange(cell2mat(CC.time(i))); 
                   
    rootnode(j).internode_3(w(1)).sum=rootnode(j).internode_3(w(1)).sum+1;
    rootnode(j).internode_3(w(1)).rating(1)=rootnode(j).internode_3(w(1)).rating(1)+str2double((CC.rating1(i)));
    rootnode(j).internode_3(w(1)).rating(2)=rootnode(j).internode_3(w(1)).rating(2)+str2double((CC.rating2(i)));
    rootnode(j).internode_3(w(1)).rating(3)=rootnode(j).internode_3(w(1)).rating(3)+str2double((CC.rating3(i)));
    rootnode(j).internode_3(w(1)).rating(4)=rootnode(j).internode_3(w(1)).rating(4)+str2double((CC.rating4(i)));
    rootnode(j).internode_3(w(1)).rating(5)=rootnode(j).internode_3(w(1)).rating(5)+str2double((CC.rating5(i)));
    if  rootnode(j).internode_3(w(1)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��??
        rootnode(j).internode_3(w(1)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end    
    if rootnode(j).internode_3(w(1)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��?��
        rootnode(j).internode_3(w(1)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end      
    rootnode(j).internode_3(w(1)).timerange.max_time=timechange(cell2mat(CC.time(i))); 
    elseif ( (leaf_num+1) > n_maxcount )
      for k=1:1:leaf_num       
        leaftemp(k)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(k);
        indexleaftemp(k)=0;
     end
    leaftemp(k+1).itemname=CC.itemtitle(i);
    leaftemp(k+1).sum=1;
    leaftemp(k+1).rating(1)=str2double((CC.rating1(i)));
    leaftemp(k+1).rating(2)=str2double((CC.rating2(i)));
    leaftemp(k+1).rating(3)=str2double((CC.rating3(i)));
    leaftemp(k+1).rating(4)=str2double((CC.rating4(i)));
    leaftemp(k+1).rating(5)=str2double((CC.rating5(i)));
    leaftemp(k+1).price=round(str2double(cell2mat(CC.itemprice(i))));
    leaftemp(k+1).time=timechange(cell2mat(CC.time(i)));
    indexleaftemp(k+1)=0;       
        worst=0;
   if (rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price)>0
    for k1=1:1:leaf_num              
        for  k2=(k1+1):1:(leaf_num+1)
           if  rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.max_time>rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.min_time          
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price))^2+(((leaftemp(k1).time- leaftemp(k2).time)/(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.max_time-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.min_time))^2));
           else
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price))^2);
           end
            if  waste>worst               
                worst=waste;
                seed0=k1;
                seed1=k2;                      
            end
        end      
   end    
   end
  if (rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price)==0                           
                seed0=1;
                seed1=leaf_num+1;  
  end
  [tempinternode1, tempinternode2]=splitleaf(leaftemp, seed0, seed1, indexleaftemp, rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price, rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price, rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.max_time, rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.min_time, n_maxcount);
         
   if (node_num+1<=n_maxcount1)   
       
          rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).sum=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).sum+1;
         rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(1)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(1)+str2double((CC.rating1(i)));
         rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(2)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(2)+str2double((CC.rating2(i)));
         rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(3)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(3)+str2double((CC.rating3(i)));
         rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(4)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(4)+str2double((CC.rating4(i)));
         rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(5)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).rating(5)+str2double((CC.rating5(i)));
         rootnode(j).internode_3(w(1)).internode_2(w(2)).sum=rootnode(j).internode_3(w(1)).internode_2(w(2)).sum+1;
         rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(1)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(1)+str2double((CC.rating1(i)));
         rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(2)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(2)+str2double((CC.rating2(i)));
         rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(3)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(3)+str2double((CC.rating3(i)));
         rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(4)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(4)+str2double((CC.rating4(i)));
         rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(5)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(5)+str2double((CC.rating5(i)));
             
         rootnode(j).internode_3(w(1)).sum=rootnode(j).internode_3(w(1)).sum+1;
         rootnode(j).internode_3(w(1)).rating(1)=rootnode(j).internode_3(w(1)).rating(1)+str2double((CC.rating1(i)));
         rootnode(j).internode_3(w(1)).rating(2)=rootnode(j).internode_3(w(1)).rating(2)+str2double((CC.rating2(i)));
         rootnode(j).internode_3(w(1)).rating(3)=rootnode(j).internode_3(w(1)).rating(3)+str2double((CC.rating3(i)));
         rootnode(j).internode_3(w(1)).rating(4)=rootnode(j).internode_3(w(1)).rating(4)+str2double((CC.rating4(i)));
         rootnode(j).internode_3(w(1)).rating(5)=rootnode(j).internode_3(w(1)).rating(5)+str2double((CC.rating5(i)));
             if  rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i))))%% ?????????????��??
        rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
             end 
    
          if rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��?��
        rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
          end 
    
          rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).timerange.max_time=timechange(cell2mat(CC.time(i))); 
          
             if  rootnode(j).internode_3(w(1)).internode_2(w(2)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��??
        rootnode(j).internode_3(w(1)).internode_2(w(2)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
             end 
    
          if rootnode(j).internode_3(w(1)).internode_2(w(2)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i))))%% ?????????????��?��
        rootnode(j).internode_3(w(1)).internode_2(w(2)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
          end 
    
           rootnode(j).internode_3(w(1)).internode_2(w(2)).timerange.max_time=timechange(cell2mat(CC.time(i))); 
           
             if  rootnode(j).internode_3(w(1)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��??
        rootnode(j).internode_3(w(1)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
             end 
    
          if rootnode(j).internode_3(w(1)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i))))%% ?????????????��?��
        rootnode(j).internode_3(w(1)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
          end    
           
           
            if  rootnode(j).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��??
        rootnode(j).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
             end 
    
          if rootnode(j).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��?��
            rootnode(j).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
          end 
    
          rootnode(j).internode_3(w(1)).timerange.max_time=timechange(cell2mat(CC.time(i))); 
          
           rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4))=tempinternode1;
           rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(node_num+1)=tempinternode2; 
   else   %%(node_num+1>n_maxcount1) 
     for k=1:1:leaf_num       
        leaftemp(k)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(k);
        indexleaftemp(k)=0;
     end
    leaftemp(k+1).itemname=CC.itemtitle(i);
    leaftemp(k+1).sum=1;
    leaftemp(k+1).rating(1)=str2double((CC.rating1(i)));
    leaftemp(k+1).rating(2)=str2double((CC.rating2(i)));
    leaftemp(k+1).rating(3)=str2double((CC.rating3(i)));
    leaftemp(k+1).rating(4)=str2double((CC.rating4(i)));
    leaftemp(k+1).rating(5)=str2double((CC.rating5(i)));
    leaftemp(k+1).price=round(str2double(cell2mat(CC.itemprice(i))));
    leaftemp(k+1).time=timechange(cell2mat(CC.time(i)));
    indexleaftemp(k+1)=0;       
        worst=0;
   if (rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price)>0
    for k1=1:1:leaf_num              
        for  k2=(k1+1):1:(leaf_num+1)
           if  rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.max_time>rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.min_time          
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price))^2+(((leaftemp(k1).time- leaftemp(k2).time)/(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.max_time-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.min_time))^2));
           else
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price))^2);
           end
            if  waste>worst               
                worst=waste;
                seed0=k1;
                seed1=k2;                      
            end
        end      
   end    
   end
  if (rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price)==0                           
                seed0=1;
                seed1=leaf_num+1;  
  end
  [tempinternode1, tempinternode2]=splitleaf(leaftemp, seed0, seed1, indexleaftemp, rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price, rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price, rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.max_time, rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.min_time, n_maxcount);
      
       if  internode1_num+1<=n_maxcount1 
           
         rootnode(j).internode_3(w(1)).internode_2(w(2)).sum=rootnode(j).internode_3(w(1)).internode_2(w(2)).sum+1;
         rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(1)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(1)+str2double((CC.rating1(i)));
         rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(2)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(2)+str2double((CC.rating2(i)));
         rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(3)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(3)+str2double((CC.rating3(i)));
         rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(4)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(4)+str2double((CC.rating4(i)));
         rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(5)=rootnode(j).internode_3(w(1)).internode_2(w(2)).rating(5)+str2double((CC.rating5(i)));
         
         rootnode(j).internode_3(w(1)).sum=rootnode(j).internode_3(w(1)).internode_2(w(2)).sum+1;
         rootnode(j).internode_3(w(1)).rating(1)=rootnode(j).internode_3(w(1)).rating(1)+str2double((CC.rating1(i)));
         rootnode(j).internode_3(w(1)).rating(2)=rootnode(j).internode_3(w(1)).rating(2)+str2double((CC.rating2(i)));
         rootnode(j).internode_3(w(1)).rating(3)=rootnode(j).internode_3(w(1)).rating(3)+str2double((CC.rating3(i)));
         rootnode(j).internode_3(w(1)).rating(4)=rootnode(j).internode_3(w(1)).rating(4)+str2double((CC.rating4(i)));
         rootnode(j).internode_3(w(1)).rating(5)=rootnode(j).internode_3(w(1)).rating(5)+str2double((CC.rating5(i)));
         
         
    if  rootnode(j).internode_3(w(1)).internode_2(w(2)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��??
        rootnode(j).internode_3(w(1)).internode_2(w(2)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end 
    
    if rootnode(j).internode_3(w(1)).internode_2(w(2)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��?��
        rootnode(j).internode_3(w(1)).internode_2(w(2)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end     
    rootnode(j).internode_3(w(1)).internode_2(w(2)).timerange.max_time=timechange(cell2mat(CC.time(i)));
    
    if  rootnode(j).internode_3(w(1)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��??
        rootnode(j).internode_3(w(1)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end 
    
    if rootnode(j).internode_3(w(1)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��?��
        rootnode(j).internode_3(w(1)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end     
    rootnode(j).internode_3(w(1)).timerange.max_time=timechange(cell2mat(CC.time(i)));
    
    
     if  rootnode(j).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i))))%% ?????????????��??
        rootnode(j).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end 
    
    if rootnode(j).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��?��
        rootnode(j).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end   
    rootnode(j).timerange.max_time=timechange(cell2mat(CC.time(i))); 
     for k=1:1:n_maxcount1
       if k~= w(4)
        tempinternode_1(k)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(k);
        indexinternode_1(k)=0;
       else
        tempinternode_1(k)=tempinternode1;
        indexinternode_1(k)=0;
       end
    end
        tempinternode_1(k+1)=tempinternode2;    
        indexinternode_1(k+1)=0;
 
   worst=0;
            seed0=1;
         seed1=size(tempinternode_1,2);
      for k1=1:1:(size(tempinternode_1,2)-1)
               
        for  k2=(k1+1):1:(size(tempinternode_1,2))
 waste=(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).pricerange.min_price)*(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).timerange.max_time-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).timerange.min_time)-(tempinternode_1(k1).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k1).timerange.max_time-tempinternode_1(k1).timerange.min_time)-(tempinternode_1(k2).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k2).timerange.max_time-tempinternode_1(k2).timerange.min_time);
            if  waste>worst                
                worst=waste;
                seed0=k1;
                seed1=k2;           
            end
        end 
        
      end 
       [internode_1]=splitnode(tempinternode_1, seed0, seed1, indexinternode_1); 

           rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3))=internode_1(1);
           rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(internode1_num+1)=internode_1(2);
                       
       else %% internode1_num+1<=n_maxcount1 
           if  internode2_num+1<=n_maxcount1
               
     for k=1:1:leaf_num       
        leaftemp(k)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(k);
        indexleaftemp(k)=0;
     end
    leaftemp(k+1).itemname=CC.itemtitle(i);
    leaftemp(k+1).sum=1;
    leaftemp(k+1).rating(1)=str2double((CC.rating1(i)));
    leaftemp(k+1).rating(2)=str2double((CC.rating2(i)));
    leaftemp(k+1).rating(3)=str2double((CC.rating3(i)));
    leaftemp(k+1).rating(4)=str2double((CC.rating4(i)));
    leaftemp(k+1).rating(5)=str2double((CC.rating5(i)));
    leaftemp(k+1).price=round(str2double(cell2mat(CC.itemprice(i))));
    leaftemp(k+1).time=timechange(cell2mat(CC.time(i)));
    indexleaftemp(k+1)=0;       
        worst=0;
   if (rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price)>0
    for k1=1:1:leaf_num              
        for  k2=(k1+1):1:(leaf_num+1)
           if  rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.max_time>rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.min_time          
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price))^2+(((leaftemp(k1).time- leaftemp(k2).time)/(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.max_time-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.min_time))^2));
           else
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price))^2);
           end
            if  waste>worst               
                worst=waste;
                seed0=k1;
                seed1=k2;                      
            end
        end      
   end    
   end
  if (rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price)==0                           
                seed0=1;
                seed1=leaf_num+1;  
  end
  [tempinternode1, tempinternode2]=splitleaf(leaftemp, seed0, seed1, indexleaftemp, rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price, rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price, rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.max_time, rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.min_time, n_maxcount);
        
     for k=1:1:n_maxcount1
       if k~= w(4)
        tempinternode_1(k)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(k);
        indexinternode_1(k)=0;
       else
        tempinternode_1(k)=tempinternode1;
        indexinternode_1(k)=0;
       end
    end
        tempinternode_1(k+1)=tempinternode2;    
        indexinternode_1(k+1)=0;
 
   worst=0;
            seed0=1;
         seed1=size(tempinternode_1,2);
      for k1=1:1:(size(tempinternode_1,2)-1)
               
        for  k2=(k1+1):1:(size(tempinternode_1,2))
 waste=(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).pricerange.min_price)*(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).timerange.max_time-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).timerange.min_time)-(tempinternode_1(k1).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k1).timerange.max_time-tempinternode_1(k1).timerange.min_time)-(tempinternode_1(k2).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k2).timerange.max_time-tempinternode_1(k2).timerange.min_time);
            if  waste>worst                
                worst=waste;
                seed0=k1;
                seed1=k2;           
            end
        end 
        
      end 
       [internode_1]=splitnode(tempinternode_1, seed0, seed1, indexinternode_1); 
  
     for k=1:1:n_maxcount1
       if k~= w(3)
        tempinternode_2(k)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(k);
        indexinternode_1(k)=0;
       else
        tempinternode_2(k)=internode_1(1);
        indexinternode_1(k)=0;
       end
    end
        tempinternode_2(k+1)=internode_1(2);    
        indexinternode_1(k+1)=0; 
                seed0=1;
         seed1=size(tempinternode_2,2);
      for k1=1:1:(size(tempinternode_2,2)-1)
               
        for  k2=(k1+1):1:(size(tempinternode_2,2))
 waste=(rootnode(j).internode_3(w(1)).internode_2(w(2)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).pricerange.min_price)*(rootnode(j).internode_3(w(1)).internode_2(w(2)).timerange.max_time-rootnode(j).internode_3(w(1)).internode_2(w(2)).timerange.min_time)-(tempinternode_1(k1).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k1).timerange.max_time-tempinternode_1(k1).timerange.min_time)-(tempinternode_1(k2).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k2).timerange.max_time-tempinternode_1(k2).timerange.min_time);
            if  waste>worst                
                worst=waste;
                seed0=k1;
                seed1=k2;           
            end
        end 
        
      end       
        
   [internode_2]=splitnode1(tempinternode_2, seed0, seed1, indexinternode_1);
    rootnode(j).internode_3(w(1)).internode_2(w(2))=internode_2(2);
    rootnode(j).internode_3(w(1)).internode_2(internode2_num+1)=internode_2(1);
       
  
         rootnode(j).internode_3(w(1)).sum=rootnode(j).internode_3(w(1)).internode_2(w(2)).sum+1;
         rootnode(j).internode_3(w(1)).rating(1)=rootnode(j).internode_3(w(1)).rating(1)+str2double((CC.rating1(i)));
         rootnode(j).internode_3(w(1)).rating(2)=rootnode(j).internode_3(w(1)).rating(2)+str2double((CC.rating2(i)));
         rootnode(j).internode_3(w(1)).rating(3)=rootnode(j).internode_3(w(1)).rating(3)+str2double((CC.rating3(i)));
         rootnode(j).internode_3(w(1)).rating(4)=rootnode(j).internode_3(w(1)).rating(4)+str2double((CC.rating4(i)));
         rootnode(j).internode_3(w(1)).rating(5)=rootnode(j).internode_3(w(1)).rating(5)+str2double((CC.rating5(i)));    
     if  rootnode(j).internode_3(w(1)).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��??
        rootnode(j).internode_3(w(1)).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end 
    
    if rootnode(j).internode_3(w(1)).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ?????????????��?��
        rootnode(j).internode_3(w(1)).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end     
    rootnode(j).internode_3(w(1)).timerange.max_time=timechange(cell2mat(CC.time(i)));
                                               
           else %%%%internode2_num+1>
               if internode3_num+1<=n_maxcount1
      for k=1:1:leaf_num       
        leaftemp(k)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).leafnode(k);
        indexleaftemp(k)=0;
     end
    leaftemp(k+1).itemname=CC.itemtitle(i);
    leaftemp(k+1).sum=1;
    leaftemp(k+1).rating(1)=str2double((CC.rating1(i)));
    leaftemp(k+1).rating(2)=str2double((CC.rating2(i)));
    leaftemp(k+1).rating(3)=str2double((CC.rating3(i)));
    leaftemp(k+1).rating(4)=str2double((CC.rating4(i)));
    leaftemp(k+1).rating(5)=str2double((CC.rating5(i)));
    leaftemp(k+1).price=round(str2double(cell2mat(CC.itemprice(i))));
    leaftemp(k+1).time=timechange(cell2mat(CC.time(i)));
    indexleaftemp(k+1)=0;       
        worst=0;
   if (rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price)>0
    for k1=1:1:leaf_num              
        for  k2=(k1+1):1:(leaf_num+1)
           if  rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.max_time>rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.min_time          
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price))^2+(((leaftemp(k1).time- leaftemp(k2).time)/(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.max_time-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.min_time))^2));
           else
            waste=sqrt(((leaftemp(k1).price- leaftemp(k2).price)/(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price))^2);
           end
            if  waste>worst               
                worst=waste;
                seed0=k1;
                seed1=k2;                      
            end
        end      
   end    
   end
  if (rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price)==0                           
                seed0=1;
                seed1=leaf_num+1;  
  end
  [tempinternode1, tempinternode2]=splitleaf(leaftemp, seed0, seed1, indexleaftemp, rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.max_price, rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).pricerange.min_price, rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.max_time, rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(w(4)).timerange.min_time, n_maxcount);
        
     for k=1:1:n_maxcount1
       if k~= w(4)
        tempinternode_1(k)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).internode(k);
        indexinternode_1(k)=0;
       else
        tempinternode_1(k)=tempinternode1;
        indexinternode_1(k)=0;
       end
    end
        tempinternode_1(k+1)=tempinternode2;    
        indexinternode_1(k+1)=0;
 
   worst=0;
            seed0=1;
         seed1=size(tempinternode_1,2);
      for k1=1:1:(size(tempinternode_1,2)-1)
               
        for  k2=(k1+1):1:(size(tempinternode_1,2))
 waste=(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).pricerange.min_price)*(rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).timerange.max_time-rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(w(3)).timerange.min_time)-(tempinternode_1(k1).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k1).timerange.max_time-tempinternode_1(k1).timerange.min_time)-(tempinternode_1(k2).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k2).timerange.max_time-tempinternode_1(k2).timerange.min_time);
            if  waste>worst                
                worst=waste;
                seed0=k1;
                seed1=k2;           
            end
        end 
        
      end 
       [internode_1]=splitnode(tempinternode_1, seed0, seed1, indexinternode_1); 
  
     for k=1:1:n_maxcount1
       if k~= w(3)
        tempinternode_2(k)=rootnode(j).internode_3(w(1)).internode_2(w(2)).internode_1(k);
        indexinternode_1(k)=0;
       else
        tempinternode_2(k)=internode_1(1);
        indexinternode_1(k)=0;
       end
    end
        tempinternode_2(k+1)=internode_1(2);    
        indexinternode_1(k+1)=0; 
                 seed0=1;
         seed1=size(tempinternode_2,2);
       for k1=1:1:(size(tempinternode_2,2)-1)
               
        for  k2=(k1+1):1:(size(tempinternode_2,2))
 waste=(rootnode(j).internode_3(w(1)).internode_2(w(2)).pricerange.max_price-rootnode(j).internode_3(w(1)).internode_2(w(2)).pricerange.min_price)*(rootnode(j).internode_3(w(1)).internode_2(w(2)).timerange.max_time-rootnode(j).internode_3(w(1)).internode_2(w(2)).timerange.min_time)-(tempinternode_1(k1).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k1).timerange.max_time-tempinternode_1(k1).timerange.min_time)-(tempinternode_1(k2).pricerange.max_price-tempinternode_1(k1).pricerange.min_price)*(tempinternode_1(k2).timerange.max_time-tempinternode_1(k2).timerange.min_time);
            if  waste>worst                
                worst=waste;
                seed0=k1;
                seed1=k2;           
            end
        end 
        
      end          
        
   [internode_2]=splitnode1(tempinternode_2, seed0, seed1, indexinternode_1);                 
                   
       for k=1:1:n_maxcount1
       if k~= w(2)
        tempinternode_3(k)=rootnode(j).internode_3(w(1)).internode_2(k);
        indexinternode_1(k)=0;
       else
        tempinternode_3(k)=internode_2(1);
        indexinternode_1(k)=0;
       end
        end
        tempinternode_3(k+1)=internode_2(2);    
        indexinternode_1(k+1)=0; 
   worst=0;
            seed0=1;
         seed1=size(tempinternode_3,2);
      for k1=1:1:(size(tempinternode_3,2)-1)             
        for  k2=(k1+1):1:(size(tempinternode_3,2))
 waste=(rootnode(j).internode_3(w(1)).pricerange.max_price-rootnode(j).internode_3(w(1)).pricerange.min_price)*(rootnode(j).internode_3(w(1)).timerange.max_time-rootnode(j).internode_3(w(1)).timerange.min_time)-(tempinternode_3(k1).pricerange.max_price-tempinternode_3(k1).pricerange.min_price)*(tempinternode_3(k1).timerange.max_time-tempinternode_3(k1).timerange.min_time)-(tempinternode_3(k2).pricerange.max_price-tempinternode_3(k1).pricerange.min_price)*(tempinternode_3(k2).timerange.max_time-tempinternode_3(k2).timerange.min_time);
            if  waste>worst                
                worst=waste;
                seed0=k1;
                seed1=k2;           
            end
        end     
      end 
   
     if  rootnode(j).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ��С
        rootnode(j).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));      
    end 
    
    if rootnode(j).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i)))) %% ��������ֵ����
        rootnode(j).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    end 
    
    rootnode(j).timerange.max_time=timechange(cell2mat(CC.time(i)));  
    
    [internode_3]=splitnode2(tempinternode_3, seed0, seed1, indexinternode_1);
    
         rootnode(j).internode_3(w(1))=internode_3(1);
         rootnode(j).internode_3(internode3_num+1)=internode_3(2);
   
                   
               else

                   test='���а���������';
                   
               end
               
           end
       end
   end
     end
 end
end  %%if  rootnode(j).n_level==0
  
       
    if  rootnode(j).pricerange.min_price>round(str2double(cell2mat(CC.itemprice(i))))  %% ��������ֵ��С
        rootnode(j).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i)))) ;      
    end 
    
    if rootnode(j).pricerange.max_price<round(str2double(cell2mat(CC.itemprice(i))))  %% ��������ֵ����
        rootnode(j).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i)))) ;
    end         
        rootnode(j).timerange.max_time=timechange(cell2mat(CC.time(i))); 
        rootnode(j).sum_number=rootnode(j).sum_number+1;
    rootnode(j).sum_rating(1)=rootnode(j).sum_rating(1)+str2double((CC.rating1(i)));
    rootnode(j).sum_rating(2)=rootnode(j).sum_rating(2)+str2double((CC.rating2(i)));
    rootnode(j).sum_rating(3)=rootnode(j).sum_rating(3)+str2double((CC.rating3(i)));
    rootnode(j).sum_rating(4)=rootnode(j).sum_rating(4)+str2double((CC.rating4(i)));
    rootnode(j).sum_rating(5)=rootnode(j).sum_rating(5)+str2double((CC.rating5(i)));
    %% �ʼ�ĸ��ڵ��ʼ��    
    break;
   end 

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    
  end

    
   if rootexistmark==0
    rootnumber=rootnumber+1;
    rootnode(rootnumber).ctree=CC.cid(i);
    rootnode(rootnumber).sum_number=1;
    rootnode(rootnumber).sum_rating(1)=str2double((CC.rating1(i)));
    rootnode(rootnumber).sum_rating(2)=str2double((CC.rating2(i)));
    rootnode(rootnumber).sum_rating(3)=str2double((CC.rating3(i)));
    rootnode(rootnumber).sum_rating(4)=str2double((CC.rating4(i)));
    rootnode(rootnumber).sum_rating(5)=str2double((CC.rating5(i)));
    rootnode(rootnumber).pricerange.min_price=round(str2double(cell2mat(CC.itemprice(i))));
    rootnode(rootnumber).pricerange.max_price=round(str2double(cell2mat(CC.itemprice(i))));
    rootnode(rootnumber).timerange.min_time=timechange(cell2mat(CC.time(i)));
    rootnode(rootnumber).timerange.max_time=timechange(cell2mat(CC.time(i)));
  
    %% Ҷ�Ӷ��ڵ�0��
    rootnode(rootnumber).n_level=0;
    %%
    rootnode(rootnumber).leafnode(1).itemname=CC.itemtitle(i);
    rootnode(rootnumber).leafnode(1).price=round(str2double(cell2mat(CC.itemprice(i))));
    rootnode(rootnumber).leafnode(1).time=timechange(cell2mat(CC.time(i)));
    rootnode(rootnumber).leafnode(1).sum=1;
    rootnode(rootnumber).leafnode(1).rating(1)=str2double((CC.rating1(i)));
    rootnode(rootnumber).leafnode(1).rating(2)=str2double((CC.rating2(i)));
    rootnode(rootnumber).leafnode(1).rating(3)=str2double((CC.rating3(i)));
    rootnode(rootnumber).leafnode(1).rating(4)=str2double((CC.rating4(i)));
    rootnode(rootnumber).leafnode(1).rating(5)=str2double((CC.rating5(i)));
    
   end
        
       rootexistmark=0;
        
end
       
end             
        

 


