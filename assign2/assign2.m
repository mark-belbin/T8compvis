%%%~~        Engi 8410        ~~%%%
%%%~~   Design Assignment #2  ~~%%%
%%%~~         Group 13        ~~%%%
%%%~~       Feb 12, 2021      ~~%%%

close all
clear

% ~~~~~~ Hough inputs ~~~~~~~~~~~ %
r_max = 120;   % Maximum circle radius                 
thresh = 25;  % Hough accumulator threshold
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %


% Import images and convert to grayscale %
im1_rgb = imread('im1.png');
im2_rgb = imread('im2.png');
im1_gray = rgb2gray(im1_rgb);
im2_gray = rgb2gray(im2_rgb);
im2_gray = im2_gray(1:469, 1:625); % Crop im2 to match im1 dimensions

% Height and width of im1/im2
height = size(im1_gray, 1);
width = size(im1_gray, 2);

% Plot Original grayscale images
figure;
subplot(121);
imshow(im1_gray);
title('GrayScale Im1');
subplot(122);
imshow(im2_gray);
title('GrayScale Im2');

% Apply gaussian filter
im1 = imgaussfilt(im1_gray, 7.0);
im2 = imgaussfilt(im2_gray, 3.0);

% Put images through canny edge detector
im1 = edge(im1, 'canny');
im2 = edge(im2, 'canny');


% Plot canny images
figure;
subplot(121);
imshow(im1);
title('Canny Im1');
subplot(122);
imshow(im2);
title('Canny Im2');

% Perform Custom Hough Circle Transform on Im1
circles1 = HoughCircles(im1, r_max, thresh);

% Perform Custom Hough Circle Transform on Im1
circles2 = HoughCircles(im2, r_max, thresh);

% Draw Circles
im1_rgb = insertShape(im1_rgb,'circle',circles1,'LineWidth',3,'Color','red');
im2_rgb = insertShape(im2_rgb,'circle',circles2,'LineWidth',3,'Color','red');

% Plot Result image for im1
figure;
subplot(121);
imshow(im1_gray);
title('Im1 Original');
subplot(122);
imshow(im1_rgb);
title('Im1 With Detected Circles');

% Plot Result image for im2
figure;
subplot(121);
imshow(im2_gray);
title('Im2 Original');
subplot(122);
imshow(im2_rgb);
title('Im2 With Detected Circles');


