function [N M P S2 K] = extract_features(I, B)
% Extract features from bump image and binary mask
% I : bump image
% B : binary mask
% N : the area of the solder bump
% M : the mean gray-value
% P : the range gray-value
% S2 : the variance gray-value
% K : the skewness gray-value
    [br, bc] = size(I);
    N = double(0);
    for i = 1:br
        for j = 1:bc
            N = N + double(B(i,j));
        end
    end

    M = double(0);
    for i = 1:br
        for j = 1:bc
            M = M + double(I(i,j));
        end
    end
    M = M/N;

    P = double(max(I(:))) - double(min(I(:)));

    S2 = double(0);
    for i = 1:br
        for j = 1:bc
            if(I(i,j) ~= 0)
                S2 = S2 + (double(I(i,j)) - M);
            end
        end
    end
    S2 = abs(S2/N);

    K = double(0);
    for i = 1:br
        for j = 1:bc
            if(I(i,j) ~= 0)
                K = K + (double(I(i,j)) - M)^3;
            end
        end
    end
    K = (K/N)^(1/3);
end