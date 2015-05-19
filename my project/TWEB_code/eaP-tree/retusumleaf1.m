function [number1, number2, number3, number4, number5, number6]=retusumleaf1(pricerange, internode, totalleafnode, j)

number1=0;
number2=0;
number3=0;
number4=0;
number5=0;
number6=0;

for i=1:1:size(totalleafnode(j, internode.leafnode).leaf, 2)
    
if (pricerange(1)<=totalleafnode(j, internode.leafnode).leaf(i).price)&&(totalleafnode(j, internode.leafnode).leaf(i).price<=pricerange(2))


end
end

end