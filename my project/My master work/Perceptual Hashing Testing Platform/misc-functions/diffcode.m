function h = diffcode(vector,numdiff)   % vector为输入的实数向量，numdiff为步长
iA = [1:length(vector)];
    hashvector = zeros(1,length(vector) * numdiff);
    for i = 1:numdiff
        for j = 1:length(vector)
            if i + j <= length(vector)
                iB(j) = iA(i+j);
            else
                iB(j) = iA(mod(j + i,length(vector)));
            end
        end
        % 差分
        h((i-1)*length(vector)+1:(i*length(vector))) = vector(iA) >= vector(iB);
    end