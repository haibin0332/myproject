function [pot, mark]=sameitem(leaf, item, time)

mark=0;
pot=0;
leaf_num=size(leaf, 2);

for i=1:1:leaf_num
    if  (strcmp(leaf(i).itemname, item)==1)&&(leaf(i).time==timechange(cell2mat(time)))%%�������ͬ�Ľڵ����ȥ  ��ͬʱ���Ӧ���ǲ�ͬ�Ľڵ� ����Ҫ����Ū��                         
         mark=1;  
         pot=i; 
         break;   
    end
end

end
