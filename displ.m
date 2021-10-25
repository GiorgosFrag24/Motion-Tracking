function [displ_x, displ_y] = displ(d_x, d_y)
perc = 0.8;
[l,c] = size(d_x);
dx = 0;
dy = 0;
count = 0;

d = d_x.^2 + d_y.^2;

d_max = max(max(d));
ka = d_max*perc;

for i=1:l
    for j=1:c
        if d_x(i,j)^2 + d_y(i,j)^2 > ka
            dx = dx + d_x(i,j);
            dy = dy + d_y(i,j);
            count = count +1;
        end
    end
end
displ_x = dx/count;
displ_y = dy/count;
