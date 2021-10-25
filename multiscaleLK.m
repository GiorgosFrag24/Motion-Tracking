function [dx,dy] = multiscaleLK(I1, I2, rho, epsilon, Nsc)
% Anti-aliasing Gaussian
G_3 = fspecial('gaussian',ceil(3*3)*2+1,3);

org_I1 = zeros([size(I1),Nsc]);
org_I2 = zeros([size(I2),Nsc]);

org_I1(:,:,1) = I1;
org_I2(:,:,1) = I2;
sizeMat = zeros(Nsc, 2);
sizeMat(1,:) = size(I1);

for k = 2:Nsc
    I1 = imfilter(I1, G_3, 'conv');
    I2 = imfilter(I2, G_3, 'conv');
    I1=impyramid(I1,'reduce');
    I2=impyramid(I2,'reduce');
    sizeMat(k, :) = size(I1);
    org_I1(1:size(I1,1),1:size(I1,2),k) = I1;
    org_I2(1:size(I2,1),1:size(I2,2),k) = I2;
    
end
d_x_0 = zeros(sizeMat(k,1:2));
d_y_0 = zeros(sizeMat(k,1:2));
for k = Nsc:-1:1
    
    [dx,dy]=lk(org_I1(1:sizeMat(k,1),1:sizeMat(k,2),k), ...
        org_I2(1:sizeMat(k,1),1:sizeMat(k,2),k),...
            rho, epsilon, d_x_0, d_y_0);
    if k ~= 1
        d_x_0 = 2*imresize(dx, [sizeMat(k-1,1), sizeMat(k-1,2)]);
        d_y_0 = 2*imresize(dy, [sizeMat(k-1,1), sizeMat(k-1,2)]);
    end       
    
end

    

