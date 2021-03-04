%%%~~        Engi 8410        ~~%%%
%%%~~   Design Assignment #3  ~~%%%
%%%~~         Group 13        ~~%%%
%%%~~       Mar 04, 2021      ~~%%%

close all
clear

% Import images and convert to grayscale
im1_rgb = imread('im1.jpg');
im2_rgb = imread('im2.jpg');
im1_gray = rgb2gray(im1_rgb);
im2_gray = rgb2gray(im2_rgb);

[height, width] = size(im1_gray); % get image size, both are the same size

% Plot grayscale images
figure;
subplot(121);
imshow(im1_gray);
title('GrayScale Im1');
subplot(122);
imshow(im2_gray);
title('GrayScale Im2');

% Detect SURF / harris features
points1 = detectSURFFeatures(im1_gray);%detectHarrisFeatures(im1_gray);
points2 = detectSURFFeatures(im2_gray);%detectHarrisFeatures(im2_gray);

% Extract feature descriptors
[features1, points1] = extractFeatures(im1_gray, points1);
[features2, points2] = extractFeatures(im1_gray, points2);

% Plot valid corners after descriptor calculation
figure;
subplot(121);
imshow(im1_gray); hold on;
plot(points1);
title('Im1 with Harris Points');
subplot(122);
imshow(im2_gray); hold on;
plot(points2);
title('Im2 with Harris Points');

% Match the features between im1 and im2
indexPairs = matchFeatures(features2, features1, 'Unique', true);

matchedPoints2 = points2(indexPairs(:,1), :);
matchedPoints1 = points1(indexPairs(:,2), :);

% Estimate the transformation between im1 and im2
tform = estimateGeometricTransform2D(matchedPoints2, matchedPoints1, 'affine', 'Confidence', 99.999, 'MaxNumTrials', 2000);

im2_transform = imwarp(im2_gray, tform);
figure;
imshow(im2_transform);



