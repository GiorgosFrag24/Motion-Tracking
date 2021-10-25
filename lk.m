function [d_x, d_y] = lk(I1, I2, rho, epsilon, d_x0, d_y0)

% Gaussian filter
n = ceil(3*rho)*2+1;
G_p = fspecial('gaussian', [n,n], rho);

% Grid
[x_0, y_0] = meshgrid(1:size(I1,2),1:size(I1,1));

dx_i = d_x0;
dy_i = d_y0;

for k = 1:50
    I1_int = interp2(I1, x_0+dx_i, y_0+dy_i, 'linear', 0);
    [I1x, I1y] = gradient(I1);
    I1x_int = interp2(I1x, x_0+dx_i, y_0+dy_i, 'linear', 0);
    I1y_int = interp2(I1y, x_0+dx_i, y_0+dy_i, 'linear', 0);
       
    E = I2 - I1_int;
    
    B11 = imfilter( I1x_int.^2,G_p, 'conv')+epsilon;
    B12 = imfilter( I1x_int.*I1y_int,G_p,'conv');
    B21 = imfilter( I1x_int.*I1y_int,G_p,'conv');
    B22 = imfilter( I1y_int.^2,G_p, 'conv')+epsilon;
    C1 = imfilter( I1x_int.*E,G_p, 'conv');
    C2 = imfilter( I1y_int.*E,G_p, 'conv');
    
    for i = 1:size(I1_int,1)
        for j = 1:size(I1_int,2)
    
            u = ([B11(i, j),B12(i, j);B21(i, j),B22(i, j)]^(-1)) *[C1(i, j);C2(i, j)];
            u1(i, j) = u(1);
            u2(i, j) = u(2);
        end
    end
    dx_i = dx_i + u1;
    dy_i = dy_i + u2;
end
d_x = dx_i;
d_y = dy_i;
end
    
    
    
    