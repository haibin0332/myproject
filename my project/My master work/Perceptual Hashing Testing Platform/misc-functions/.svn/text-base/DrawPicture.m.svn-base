% 小芳给的，特定用途，所以对我不能直接用
function G = DrawPicture(G, PCR, ICR)
    for k = -5:1:5
        G(PCR(1) + k, PCR(2)) = 255;
        G(PCR(1), PCR(2) + k) = 255;
    end
    SZE = size(G);
    sita = 2 * pi / 180;
    for k = 1:180
        dx = sin(sita * k);
        dy = cos(sita * k);
        x1 = round(PCR(1) - PCR(3) * dx);
        y1 = round(PCR(2) + PCR(3) * dy);
        G(x1,y1) = 255;
        x2 = round(ICR(1) - ICR(3) * dx);
        y2 = round(ICR(2) - ICR(3) * dy);
        if x2 > SZE(1) || x2 < 1 || y2 > SZE(2) || y2 < 1
            continue;
        end
        G(x2, y2) = 255;        
    end
    %    imwrite(G, outFile);
    return;