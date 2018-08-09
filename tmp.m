binI = zeros(19,19);
len = length(bin_gm);
i = 1;
while(i<=len)
    index = bin_gm(i);
    row = mod(index,19)
    col = int32(index/19) + 1;
    binI(row,col) = 1;
    i = i + 1;
end

imshow(binI);