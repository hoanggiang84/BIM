function V = vector_substract(v1, v2)
% V = v1 - v2
% v1 and v2 should have same length
len = length(v1);
for i = 1:len
    V(i) = v1(i) - v2(i);
end
end