% testing computeH part
im1 = imread('wdc1.jpg');
im2 = imread('wdc2.jpg');

cpselect(im1,im2)

%% save
points1 = movingPoints
points2 = fixedPoints
save ./points.mat points1 points2

%% making points jpg (manually dotted img are added)
im1_dot = imread('wdc1_dot.jpg');
im2_dot = imread('wdc2_dot.jpg');
figure
subplot(1,2,1);
imshow(im1_dot);
subplot(1,2,2);
imshow(im2_dot);

%% calculate H of wdc img
load ./points.mat
H_wdc = computeH(points1', points2');
    
%% verify
N = size(points1, 1);
im2_warp = H_wdc * [points1';ones(1,N)];
im2_norm = zeros(size(im2_warp));
for i=1:N
    im2_norm(:,i) = im2_warp(:,i) / im2_warp(3,i);
end

%% calculate H of crop img
load ./cc1.mat 
load ./cc2.mat
H_crop = computeH(cc1, cc2);

%% verify
N = size(cc1, 2);
im2_warp = H_crop * [cc1;ones(1,N)];
im2_norm = zeros(size(im2_warp));
for i=1:N
    im2_norm(:,i) = im2_warp(:,i) / im2_warp(3,i);
end