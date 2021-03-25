%%%~~        Engi 8410        ~~%%%
%%%~~   Design Assignment #4  ~~%%%
%%%~~         Group 13        ~~%%%
%%%~~       Mar 24, 2021      ~~%%%

clear;
close all;

% Import image
img_rgb = imread('im1.jpg');
img = rgb2gray(img_rgb);

%Show original image in grayscale
figure;
subplot(121);
imshow(img_rgb);
title('Original Image');
subplot(122);
imshow(img);
title('GrayScale Image');

% Harris corner detector input parameters %
sigma=1;
thresh=4500;
radius=5;
alpha=0.08;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Derivative Masks
dx = [-1 0 1; -1 0 1; -1 0 1];
dy = dx';

% Find x and y moments of the image
Ix = imfilter(img, dx, 'same');
Iy = imfilter(img, dy, 'same');

%perform gaussian filtering on the moments
g = fspecial('gaussian', round(6*sigma), sigma);
Ixx = conv2(Ix.^2, g);
Iyy = conv2(Iy.^2, g);
Ixy = conv2(Ix.*Iy, g);

% Harris corner measure creation
R_Harris = (Ixx.*Iyy - Ixy.^2)-alpha*((Ixx + Iyy).^2);

figure;
clims = [4500, 5000];
imagesc(R_Harris, clims);

% Find local maxima from corner measure
N = 2*radius+1; % Size of mask.
mx=imdilate(R_Harris, strel('disk',N)); % Grey-scale dilate.
Lmax = (R_Harris==mx)& (R_Harris>thresh); % Find maxima.
[r,c] = find(Lmax); % Find row,col coords.

% Overlay detected corners on the original RGB image
figure;
imagesc(img_rgb), axis image, colormap(gray), hold on
plot(c,r,'r*')
title('Detected Corners');



