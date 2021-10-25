%% Part 1
%% Detect user Skin
addpath('./Chalearn');
addpath('./ChalearnUser');

I0 = imread('1.png');
I = double(rgb2ycbcr(I0));
U = imread('U1.png');

load('skinSamplesRGB.mat');

%% Part 1 Skin Tracking
skinSamples = double(rgb2ycbcr(skinSamplesRGB));
mCb = mean(mean(skinSamples(:,:,2)));
mCr = mean(mean(skinSamples(:,:,3)));
mean_vec = [mCb mCr];
covariance = cov(skinSamples(:,:,2),skinSamples(:,:,3));

boundingBox = fd(I, mean_vec, covariance);
x = boundingBox(1);
y = boundingBox(2);
w = boundingBox(3);
h = int32(boundingBox(4));
initBox = boundingBox;

%% Part 2 Hand Observation
%% Part 2.1 Lucas-Kanade Implementation

part2_1_path = './part2_2/%03d.png';
fig = figure('visible','off');
imshow(I0);
hold on
rectangle('Position',boundingBox,'EdgeColor','g','LineWidth',2);
st = sprintf(part2_1_path, 1);
saveas(fig,st,'png');
hold off

epsilon = 0.015;
rho = 7.5;
d_x0 = zeros(h+1,w+1);
d_y0 = zeros(h+1,w+1);

 root = './Chalearn';
 root2 = './ChalearnUser';
 Chalearn_path = [root '/' '%0d.png']; 
 ChalearnUser_path = [root2 '/U' '%0d.png'];
for i = 1:60
    % RGB to grayscale
    I1_rgb = imread(sprintf(Chalearn_path,i));
    I2_rgb = imread(sprintf(Chalearn_path,i+1));
    I1_gray = im2double(rgb2gray(I1_rgb));
    I2_gray = im2double(rgb2gray(I2_rgb));
    
    % User masking 
    I1_user = imread(sprintf(ChalearnUser_path,i));
    I2_user = imread(sprintf(ChalearnUser_path,i+1));
    I1_gray = I1_gray.*double(I1_user);
    I2_gray = I2_gray.*double(I2_user);
    
    % Cropping
    I1 = imcrop(I1_gray,boundingBox);
    I2 = imcrop(I2_gray,boundingBox);   
    
    %Lucas-Kanade algorithm application
    [d_x, d_y] = lk(I1, I2, rho, epsilon, d_x0, d_y0);
    d_x_r = imresize(d_x, 0.3);
    d_y_r = imresize(d_y, 0.3);    											
    [displ_x, displ_y] = displ(d_x, d_y);
    x = x - displ_x;
    y = y - displ_y;
   
    boundingBox = [x,y,w,h];
    
    fig = figure('visible','off');
    imshow(I2_rgb);
    hold on;
    rectangle('Position', boundingBox,'EdgeColor','g','LineWidth',2);
    st = sprintf(part2_1_path, i+1);
    saveas(fig,st,'png');
    hold off;
    
    close all
end



%% Part 2.2 Multiscale optical flow computation
% sc = 5;
% part2_2_path = './part2_2/%03d.png';
% boundingBox = initBox;
% x = boundingBox(1);
% y = boundingBox(2);
% 
% % 1st Frame save
% fig = figure('visible','off');
% imshow(I0);
% hold on;
% rectangle('Position', boundingBox,'EdgeColor','g','LineWidth',2);
% st = sprintf(part2_2_path, 1);
% saveas(fig,st,'png');
% hold off;
% %the rest 
% for i = 1:60
%     % RGB to grayscale 
%     I1_rgb = imread(sprintf(Chalearn_path,i));
%     I2_rgb = imread(sprintf(Chalearn_path,i+1));
%     I1_gray = im2double(rgb2gray(I1_rgb));
%     I2_gray = im2double(rgb2gray(I2_rgb));
%     % User masking
%     I1_user = imread(sprintf(ChalearnUser_path,i));
%     I2_user = imread(sprintf(ChalearnUser_path,i+1));
%     I1_gray = I1_gray.*double(I1_user);
%     I2_gray = I2_gray.*double(I2_user);
%     % Cropping 
%     I1 = imcrop(I1_gray,boundingBox);
%     I2 = imcrop(I2_gray,boundingBox);
%     %Multiscale Lucas-Kanade algorithm
%     [d_x, d_y] = multiscaleLK(I1, I2, rho, epsilon, sc);
%     d_x_r = imresize(d_x, 0.3);
%     d_y_r = imresize(d_y, 0.3);    
%     % New bounding box and displacement computation
%     [displ_x, displ_y] = displ(d_x, d_y);
%     x = x - displ_x;
%     y = y - displ_y;
%     boundingBox = [x,y,w,h];
%   
%     
%     % Frame i+1
%     fig = figure('visible','off');
%     imshow(I2_rgb);
%     hold on;
%     rectangle('Position', boundingBox,'EdgeColor','g','LineWidth',2);
%     st = sprintf(part2_2_path, i+1);
%     saveas(fig,st,'png');
%     hold off;
%     
%     close all
%     
%     
% end

%% Part 3 Hand motion computation from optical flow

% I1 = im2double(imread(sprintf(Chalearn_path,1)));
% 
% part2_3_path = './part2_3/%d.jpg';
% for i = 2:60
% 
%     I2 = im2double(imread(sprintf(Chalearn_path, i)));
%     Ia = rgb2gray(I1(round(x):round(x)+h -1, round(y):round(y)+w -1,:));
%     Ib = rgb2gray(I2(round(x):round(x)+h -1, round(y):round(y)+w -1,:));
%     
%     [d_x, d_y] = lk(Ia, Ib, 2.5, 0.035, 0, 0);							
%     d_x_r=imresize(d_x,0.3);											
%     d_y_r=imresize(d_y,0.3);
%     
%     figure_flow = figure(i+1);
%     quiver(-d_x_r, -d_y_r);
%     
%     
%     
%     Energy = d_x.^2+d_y.^2;								
%     figure_ener = figure(i+60);
%     imshow(Energy, []);									
%             
%     [displx, disply] = displ(d_x, d_y);		
%     
%     x = x - displx;
%     y = y - disply;
%     hand_fig = figure('visible','off');
%     imshow(I2);
%     hold on;
%     rectangle('Position', [x, y, w, h], 'EdgeColor', 'g');
%     hold off;
%     I1 = I2;
%     
% end
