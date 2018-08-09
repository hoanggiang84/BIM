clear all;
close all;

rgb = imread('solder_bump_full.jpg');
I = rgb2gray(rgb);
figure(1)
imshow(I);

[nr, nc] = size(I);
col_offset = 3;
col_edge_len = 18;
col_len = (nc - col_offset * 2 - col_edge_len * 2) / 16;

row_offset = 3;
row_edge_len = 18;  
row_len = (nr - row_offset * 2 - row_edge_len * 2) / 16;

defect_row = [2,6,9,12,14,16];
defect_col = [3,4,5,10,11,14,15];

gain = 50;
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
seD = strel('diamond',1);
idx = 1;
for row = 0:17
    % Size of bumps at the edge of image is different from inside bumps
    if(row == 0)
        len = row_edge_len;
    else
        len = row_len;
    end
    
    % Calculate row range of bump 
    first_row = int32(row_offset + row * len);
    last_row = first_row + len;
    last_row = min(last_row, nr - row_offset);
    row_range = first_row:last_row;
            
    for col = 0:17
        [row col]
        if((row == 0 || row == 17) && (col == 0 || col == 1 || col == 17))
            continue;  % Dont have bump in this spot
        end
        
        if((ismember(row,defect_row) && ismember(col, defect_col)) || (row == 17 && col == 2) )
            'defect bump'
            Y(idx) = -1;
        else
            Y(idx) = 1;
        end
        % Size of bumps at the edge of image is different from inside bumps
        if(col == 0)
            len = col_edge_len;
        else
            len = col_len;
        end
        
        % Calculate column range of bump
        first_col = int32(col_offset + len * col);
        last_col = first_col + len;
        last_col = min(last_col, (nc - col_offset));
        col_range = first_col:last_col;
        
        subI =I(row_range, col_range);
        [subr, subc] = size(subI);
        
        % Extract bump image from chip image
        bumpI = subI(1:min(19,subr),1: min(19,subc));
        [br, bc] = size(bumpI);

%         figure(1)
%         imshow(bumpI);
%         [dx,dy] = gradient(double(bumpI));  % Compute gradient and display
%         [x, y] = meshgrid(1:bc,1:br);       % with bump image
%         u = dx * gain;
%         v = dy * gain;
%         hold on
%         quiver(x,y,u,v);
%         hold off
     
        % Extract bump binary image
%         [gm, gd] = imgradient(bumpI,'intermediate');
%         bin_gm = find(gm > 15);
%         binI = zeros(br,bc);
%         blen = length(bin_gm);
%         i = 1;
%         while(i<=blen)
%             index = bin_gm(i);
%             brow = mod(index,br) + 1;
%             bcol = int32(index/br) + 1;
%             binI(brow,bcol) = 1;
%             i = i + 1;
%         end
       
%         figure(2)
 %        hold on
  %       hold off
%         imshow(binI);
        
        % Edge detection by Canny method
%         edgeI = edge(bumpI,'Canny');
        
        [~, threshold] = edge(bumpI, 'sobel');
        fudgeFactor = .5;
        edgeI = edge(bumpI,'sobel', threshold * fudgeFactor);
        dilateI = imdilate(edgeI, [se90 se0]);
        fillI = imfill(dilateI,'holes');
        if(row ==0 || col == 0)
            fillI = imerode(fillI, seD);
        end
        
        A = fillI;
        T = bumpI;
        T(A==0) = 0;

        [N M P S2 K] = extract_features(T, A)
        NA(idx) = N;
        MA(idx) = M;
        PA(idx) = P;
        SA(idx) = S2;
        KA(idx) = K;
%        imshow(T);
        %pause;
        idx = idx + 1
%         close all;
    end
end
T = table(NA',MA',PA',SA',KA',Y');
writetable(T,'solderbump.xlsx');

