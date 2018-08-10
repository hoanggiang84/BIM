function z = calculate_fuzzy(X, i)
% X: input vector with 5 elements [m n p s k] 
% i: 1 for good class, -1 for defect class
% 
V1 = [170 122 186 0 6];  % Good class center
V2 = [170 155 253 0 33]; % Defect class center
m = 0.5;

minz = 0.001;
dv1 = norm(vector_substract(X,V1));
dv2 = norm(vector_substract(X,V2));    
z = minz;
if (i == 1)
    if(dv1 == 0)
        z = 1;
    elseif (dv2 == 0)
        z = minz;
    else
        z = (1 + (dv1/dv2)^(2/(m-1)))^(-1);
    end
    
elseif (i == -1)
    if (dv2 == 0)
        z = 1;
    elseif (dv1 == 0)
        z = minz;
    else
        z = (1 + (dv2/dv1)^(2/(m-1)) )^(-1);
    end
else
    z = 0;  
end

end