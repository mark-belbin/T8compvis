%%%~~        Engi 8410         ~~%%%
%%%~~ Design Assignment #1, Q4 ~~%%%
%%%~~         Group 13         ~~%%%
%%%~~        Feb 1, 2021       ~~%%%

close all
clear

% ~~~~~~ Canny inputs ~~~~~~~~~~~~ %
         sigma = 6.0;              %
            TL = 0.10;             %
            TH = 0.15;             %
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %

% Import Lena image and convert to grayscale %
lenna_rgb = imread('lenna_rgb.png');
lenna_gray = rgb2gray(lenna_rgb);

figure;
subplot(121);
imshow(lenna_rgb);
title('Original Lenna');
subplot(122);
imshow(lenna_gray);
title('Grayscale Lenna');

% Step 1: Apply Gaussian Filter %

% Create gaussian filter 5x5 kernel
Hg = zeros(5,5);
k = (5-1)/2;

for j = 1:1:5
    for i = 1:1:5
        Hg(j, i) = exp(-((j-(k+1))^2+(i-(k+1))^2)/(2*sigma^2));
    end
end

Hg_sum = sum(Hg, 'all');
H = Hg.*(1/Hg_sum); % Normalize kernel

h = fspecial('gaussian',5,sigma); % Matlab generated gaussian kernel

% Apply gaussian filter %
lenna_gray_pad = padarray(lenna_gray,[2,2],0,'both'); % pad with zeros
height = size(lenna_gray_pad, 1);
width = size(lenna_gray_pad, 2);

lenna_blur = zeros(height, width);

% Convolute kernel with image
for j = 3:1:(height-2)
    for i = 3:1:(width-2)
        for hj = 1:1:5
            for hi = 1:1:5
                lenna_blur(j, i) = lenna_blur(j, i) + H(hj, hi)*lenna_gray_pad(j-(3-hj), i-(3-hi));
            end
        end
    end
end

lenna_blur = uint8(lenna_blur(3:514, 3:514));
lenna_blur_matlab = imfilter(lenna_gray, h, 'conv');

% Show comparison of gaussian filters
figure;
subplot(131);
imshow(lenna_gray);
title('Grayscale Lenna');
subplot(132);
imshow(lenna_blur_matlab);
title('MATLAB Gaussian Blur Lenna');
subplot(133);
imshow(lenna_blur);
title('DIY Gaussian Lenna');


% Step 2: Find Intensity Graidents of the Image %

sobelx = [-1 0 1; -2 0 2; -1 0 1];
sobely = [-1 -2 -1; 0 0 0; 1 2 1];

lenna_gray_pad = double(padarray(lenna_gray,[1,1],0,'both')); % pad with zeros
height = size(lenna_gray_pad, 1);
width = size(lenna_gray_pad, 2);

lenna_sobelx = zeros(height, width);
lenna_sobely = zeros(height, width);

% Convolute sobel kernels with image
for j = 2:1:(height-1)
    for i = 2:1:(width-1)
        for hj = 1:1:3
            for hi = 1:1:3
                lenna_sobelx(j, i) = lenna_sobelx(j, i) + sobelx(hj, hi)*lenna_gray_pad(j-(2-hj), i-(2-hi));
                lenna_sobely(j, i) = lenna_sobely(j, i) + sobely(hj, hi)*lenna_gray_pad(j-(2-hj), i-(2-hi));
            end
        end
    end
end

lenna_sobelx = lenna_sobelx(2:513, 2:513);
lenna_sobely = lenna_sobely(2:513, 2:513);

lenna_sobelx_int = uint8(abs(lenna_sobelx));
lenna_sobely_int = uint8(abs(lenna_sobely));

% Show comparison of sobel operators
figure;
subplot(131);
imshow(lenna_gray);
title('Grayscale Lenna');
subplot(132);
imshow(lenna_sobelx_int);
title('Sobel X Lenna');
subplot(133);
imshow(lenna_sobely_int);
title('Sobel Y Lenna');

G = sqrt((lenna_sobelx.^2 + lenna_sobely.^2));
G = uint8(normalize(G, 'range')*255);
theta = atan2(lenna_sobely, lenna_sobelx)*180/pi;

figure;
imshow(G);
title('Gradient Magnitude of Lenna');

% Step 3: Perform non-maximum supression %

G_pad = double(padarray(G,[1,1],0,'both')); % pad with zeros
theta_pad = double(padarray(theta,[1,1],0,'both')); % pad with zeros
G_Suppressed = G_pad;

% Find best fit direction according to notes and complete suppression
for j = 2:1:513
    for i = 2:1:513
        a = theta_pad(j, i);
        
        % Horizontal edge
        if (a <= 22.5) && (a >= -22.5) || (a >= 157.5) || (a <= -157.5)
            if G_pad(j+1, i) > G_pad(j, i) || G_pad(j-1, i) > G_pad(j, i)
                G_Suppressed(j, i) = 0;
            end
        end
        
        % -45 Degree edge
        if (a > 22.5) && (a < 67.5) || (a <-157.5) && (a > -112.5)
            if G_pad(j-1, i-1) > G_pad(j, i) || G_pad(j+1, i+1) > G_pad(j, i)
                G_Suppressed(j, i) = 0;
            end
        end
        
        % +45 Degree edge
        if (a < -22.5) && (a > -67.5) || (a > 112.5) && (a <157.5)
            if G_pad(j-1, i+1) > G_pad(j, i) || G_pad(j+1, i-1) > G_pad(j, i)
                G_Suppressed(j, i) = 0;
            end
        end
        
        % Vertical edge
        if (a >= 67.5) && (a <= 112.5) || (a <= -67.5) && (a >= -112.5)
            if G_pad(j, i-1) > G_pad(j, i) || G_pad(j, i+1) > G_pad(j, i)
                G_Suppressed(j, i) = 0;
            end
        end
        
    end
end

G_Suppressed = uint8(G_Suppressed(2:513, 2:513));

figure;
imshow(G_Suppressed);
title('Suppressed Gradient Magnitude');

% Step 4: Perform Double Threshold to find strong and weak pixels %

Mag_norm = double(G_Suppressed)./255.0;
Strong = zeros(512, 512);
Weak = zeros(512, 512);

for j = 1:1:512
    for i = 1:1:512
        if Mag_norm(j, i) >= TH
            Strong(j, i) = 1;
        elseif Mag_norm(j, i) >= TL
            Weak(j, i) = 1;
        end
    end
end

figure;
subplot(121);
imshow(Weak);
title('Weak Edge Pixels');
subplot(122);
imshow(Strong);
title('Strong Edge Pixels');


% Step 5: Add weak pixels if 8-connected to strong pixel%

Weak_pad = padarray(Weak,[1,1],0,'both'); % pad with zeros
Strong_pad = padarray(Strong,[1,1],0,'both'); % pad with zeros
Canny_Final = Strong_pad;

for j = 2:1:513
    for i = 2:1:513
        if Weak_pad(j, i) == 1
            Strong_8 = Strong_pad(j-1, i-1) + Strong_pad(j-1, i) + Strong_pad(j-1, i+1) + Strong_pad(j, i-1)  + Strong_pad(j, i+1) + Strong_pad(j+1, i-1) + Strong_pad(j+1, i) + Strong_pad(j+1, i+1);
            if Strong_8 >=1
                Canny_Final(j, i) = 1; % Add weak pixel if 8-connected to strong pixel
            end
        end
    end
end

Canny_Final = Canny_Final(2:513, 2:513); % Crop padded final image

% Plot final image against MATLAB built in canny function
figure;
subplot(121)
imshow(edge(lenna_gray, 'canny'));
title('MATLAB Canny Implementation');
subplot(122)
imshow(Canny_Final);
title('Custom Canny Implementation');
