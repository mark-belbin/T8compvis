%%%~~        Engi 8410        ~~%%%
%%%~~   Design Assignment #2  ~~%%%
%%%~~         Group 13        ~~%%%
%%%~~       Feb 12, 2021      ~~%%%

close all
clear

% ~~~~~~ Hough inputs ~~~~~~~~~~~ %
r_max = 120;   % Maximum circle radius                 
thresh = 1000;  % Hough accumulator threshold    
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %


% Import images and convert to grayscale %
im1_rgb = imread('im1.png');
im2_rgb = imread('im2.png');
im1 = rgb2gray(im1_rgb);
im2 = rgb2gray(im2_rgb);
im2 = im2(1:469, 1:625); % Crop im2 to match im1 dimensions

% Height and width of im1/im2
height = size(im1, 1);
width = size(im1, 2);

% Plot Original grayscale images
figure;
subplot(121);
imshow(im1);
title('GrayScale Im1');
subplot(122);
imshow(im2);
title('GrayScale Im1');

% Apply gaussian filter
im1 = imgaussfilt(im1, 7.0);
im2 = imgaussfilt(im2, 3.0);

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

a = width; % x0
b = height; % y0
r = r_max; %r

A_im1 = zeros(a,b,r); % 3D Accumulator Array

% Accumulator Lööp for im1
for r = 1:1:r_max
    for y = 1:1:height
        for x = 1:1:width
            if im1(y,x) == 1
                for theta = 0:0.1:2*pi
                    % Calculate circle pixel locations
                    a = uint8(x - r * cos(theta));
                    b = uint8(y - r * sin(theta));
                    
                    % Check if circle is within accumulator bounds
                    if (a < 1) || (a > width)
                        break
                    elseif (b < 1) || (b > height)
                        break
                    else
                        A_im1(a,b,r) = A_im1(a,b,r) + 1; % Add to accumulator
                    end
                end
            end
        end
    end
end

% Find local maxima in 3D array
maxima = islocalmax(A_im1);

circle_count = 0;
for r = 1:1:r_max
    for y = 1:1:height
        for x = 1:1:width
            if (maxima(x,y,r) == 1) && (A_im1(x,y,r) > thresh)
               circle_count = circle_count + 1;
               im1_rgb = insertShape(im1_rgb,'circle',[x y r],'LineWidth',3,'Color','red');
            end
        end
    end
end

disp(circle_count)

% Plot Result image
figure;
imshow(im1_rgb);
title('Im1 With Detected Circles');

