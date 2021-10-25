function boundingBox = fd(I, m, s)

addpath('./ChalearnUser');
U = imread('U1.png');



[line,col] = size(I(:,:,1));
for i=1:line
    for j=1:col
        c = double([I(i,j,2) I(i,j,3)]);
        P(i,j) = exp(-0.5*(c-m)*inv(s)*(c-m)')/sqrt(det(s)*(2*pi)^2);
    end
end

p_max = max(max(P));
P = P / p_max;

A =( (P > 0.3 ) & (U == 1) );
se = strel('disk',1,6);
A = imopen(A,se);
se = strel('disk',10,6);
A = imclose(A,se);

l = regionprops(A,'BoundingBox');
boundingBox = l.BoundingBox;

boundingBox(1) = boundingBox(1) - boundingBox(3)/4;
boundingBox(2) = boundingBox(2) - boundingBox(4)/4;
boundingBox(3) = boundingBox(3) +3* boundingBox(3)/4;
boundingBox(4) = boundingBox(4) + boundingBox(4)/2;

end