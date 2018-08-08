clear all;
close all;

rgb = imread('solder_bump_full.jpg');
I = rgb2gray(rgb);
figure(1)
imshow(I);
% [Gx, Gy] = imgradientxy(I,'intermediate');
% [Gmag, Gdir] = imgradient(Gx,Gy);
% figure(2)
% imshowpair(Gmag, Gdir, 'montage');
% 
% hm = HeatMap(Gmag,'DisplayRange', 25, 'Colormap', redgreencmap, 'Symmetric', false);

[nr, nc] = size(I);
row_offset = 3;
col_offset = 2;
col_len = 21.6875; 
row_len = 21.4375;
edge_len = 19;  
gain = 25;
for row = 0:17
    if(row == 0)
        len = edge_len;
    else
        len = row_len;
    end
    
    first_row = int32(row_offset + row * len);
    last_row = first_row + len;
    last_row = min(last_row, nr - row_offset);
    row_range = first_row:last_row;
            
    for col = 0:17
        [row col]
        if((row == 0 || row == 17) && (col == 0 || col == 1 || col == 17))
            continue;  
        end
        
        if(col == 0)
            len = edge_len;
        else
            len = col_len;
        end
        
        first_col = int32(col_offset + len * col);
        last_col = first_col + len;
        last_col = min(last_col, nc - col_offset                                                                                                                                                                                                 );
        col_range = first_col:last_col;
        
        subI =I(row_range, col_range);
        [subr, subc] = size(subI);
        bumpI = subI(1:min(19,subr),1: min(19,subc));
        imshow(bumpI);
        %hold on
%         
%         [br, bc] = size(bumpI);
%         [dx,dy] = gradient(double(bumpI)); 
%         [x, y] = meshgrid(1:bc,1:br);
%         u = dx * gain;
%         v = dy * gain;
%         
%         quiver(x,y,u,v);
%         hold off
%         
%         [gm, gd] = imgradient(subI,'Roberts');
%         fg = find(gm > 25);
%         imshow(gm);

        pause;
    end
end
