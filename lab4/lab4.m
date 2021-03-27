%%%~~        Engi 8410        ~~%%%
%%%~~     Lab Assignment #4   ~~%%%
%%%~~         Group 13        ~~%%%
%%%~~       Mar 26, 2021      ~~%%%

clear;
close all;
format shortG

%% Import Test Images %
img_ref = imread('ref.jpg');
im1 = imread('01.jpg');
im2 = imread('02.jpg');
im3 = imread('03.jpg');
im4 = imread('04.jpg');
im5 = imread('05.jpg');
im6 = imread('06.jpg');
im7 = imread('07.jpg');
im8 = imread('08.jpg');
im9 = imread('09.jpg');
im10 = imread('10.jpg');
im11 = imread('11.jpg');
im12 = imread('12.jpg');

%% Extract SIFT Features %
[f_ref, d_ref] = vl_sift(im2single(rgb2gray(img_ref)));
[f1, d1] = vl_sift(im2single(rgb2gray(im1)));
[f2, d2] = vl_sift(im2single(rgb2gray(im2)));
[f3, d3] = vl_sift(im2single(rgb2gray(im3)));
[f4, d4] = vl_sift(im2single(rgb2gray(im4)));
[f5, d5] = vl_sift(im2single(rgb2gray(im5)));
[f6, d6] = vl_sift(im2single(rgb2gray(im6)));
[f7, d7] = vl_sift(im2single(rgb2gray(im7)));
[f8, d8] = vl_sift(im2single(rgb2gray(im8)));
[f9, d9] = vl_sift(im2single(rgb2gray(im9)));
[f10, d10] = vl_sift(im2single(rgb2gray(im10)));
[f11, d11] = vl_sift(im2single(rgb2gray(im11)));
[f12, d12] = vl_sift(im2single(rgb2gray(im12)));

% Show all SIFT features for test image 1
%figure, imshow(rgb2gray(im1),[]);
%h = vl_plotframe(f1);
%set(h,'color','y','linewidth',2);

%% Match Ref img features to Test images via SIFT descriptors%
match_thresh = 2.75;
[matches1, scores1] = vl_ubcmatch(d_ref, d1, match_thresh);
[matches2, scores2] = vl_ubcmatch(d_ref, d2, match_thresh);
[matches3, scores3] = vl_ubcmatch(d_ref, d3, match_thresh);
[matches4, scores4] = vl_ubcmatch(d_ref, d4, match_thresh);
[matches5, scores5] = vl_ubcmatch(d_ref, d5, match_thresh);
[matches6, scores6] = vl_ubcmatch(d_ref, d6, match_thresh);
[matches7, scores7] = vl_ubcmatch(d_ref, d7, match_thresh);
[matches8, scores8] = vl_ubcmatch(d_ref, d8, match_thresh);
[matches9, scores9] = vl_ubcmatch(d_ref, d9, match_thresh);
[matches10, scores10] = vl_ubcmatch(d_ref, d10, match_thresh);
[matches11, scores11] = vl_ubcmatch(d_ref, d11, match_thresh);
[matches12, scores12] = vl_ubcmatch(d_ref, d12, match_thresh);

% Sort maches in descending order by score
matches1 = [matches1; scores1];
matches1 = (sortrows(matches1', 3, 'descend'))';
matches2 = [matches2; scores2];
matches2 = (sortrows(matches2', 3, 'descend'))';
matches3 = [matches3; scores3];
matches3 = (sortrows(matches3', 3, 'descend'))';
matches4 = [matches4; scores4];
matches4 = (sortrows(matches4', 3, 'descend'))';
matches5 = [matches5; scores5];
matches5 = (sortrows(matches5', 3, 'descend'))';
matches6 = [matches6; scores6];
matches6 = (sortrows(matches6', 3, 'descend'))';
matches7 = [matches7; scores7];
matches7 = (sortrows(matches7', 3, 'descend'))';
matches8 = [matches8; scores8];
matches8 = (sortrows(matches8', 3, 'descend'))';
matches9 = [matches9; scores9];
matches9 = (sortrows(matches9', 3, 'descend'))';
matches10 = [matches10; scores10];
matches10 = (sortrows(matches10', 3, 'descend'))';
matches11 = [matches11; scores11];
matches11 = (sortrows(matches11', 3, 'descend'))';
matches12 = [matches12; scores12];
matches12 = (sortrows(matches12', 3, 'descend'))';

%% Get matching features and display top 10 for each image %%%%%%%

%match_and_display(img_ref, im1, matches1, f_ref, d_ref, f1, d1, 1);
%match_and_display(img_ref, im2, matches2, f_ref, d_ref, f2, d2, 2);
%match_and_display(img_ref, im3, matches3, f_ref, d_ref, f3, d3, 3);
%match_and_display(img_ref, im4, matches4, f_ref, d_ref, f4, d4, 4);
%match_and_display(img_ref, im5, matches5, f_ref, d_ref, f5, d5, 5);
%match_and_display(img_ref, im6, matches6, f_ref, d_ref, f6, d6, 6);
%match_and_display(img_ref, im7, matches7, f_ref, d_ref, f7, d7, 7);
%match_and_display(img_ref, im8, matches8, f_ref, d_ref, f8, d8, 8);
match_and_display(img_ref, im9, matches9, f_ref, d_ref, f9, d9, 9);
%match_and_display(img_ref, im10, matches10, f_ref, d_ref, f10, d10, 10);
%match_and_display(img_ref, im11, matches11, f_ref, d_ref, f11, d11, 11);
%match_and_display(img_ref, im12, matches12, f_ref, d_ref, f12, d12, 12);

%% Get matching features and compute affine transform, display number of inliers %

%[transform1, inliers1] = match_and_get_transform(matches1, f_ref, d_ref, f1, d1, 1);
%[transform2, inliers2] = match_and_get_transform(matches2, f_ref, d_ref, f2, d2, 2);
%[transform3, inliers3] = match_and_get_transform(matches3, f_ref, d_ref, f3, d3, 3);
%[transform4, inliers4] = match_and_get_transform(matches4, f_ref, d_ref, f4, d4, 4);
%[transform5, inliers5] = match_and_get_transform(matches5, f_ref, d_ref, f5, d5, 5);
%[transform6, inliers6] = match_and_get_transform(matches6, f_ref, d_ref, f6, d6, 6);
%[transform7, inliers7] = match_and_get_transform(matches7, f_ref, d_ref, f7, d7, 7);
%[transform8, inliers8] = match_and_get_transform(matches8, f_ref, d_ref, f8, d8, 8);
[transform9, inliers9] = match_and_get_transform(matches9, f_ref, d_ref, f9, d9, 9);
%[transform10, inliers10] = match_and_get_transform(matches10, f_ref, d_ref, f10, d10, 10);
%[transform11, inliers11] = match_and_get_transform(matches11, f_ref, d_ref, f11, d11, 11);
%[transform12, inliers12] = match_and_get_transform(matches12, f_ref, d_ref, f12, d12, 12);

%% Show transform result on best inlier image, test image 9
% Original rect coordinates 
rect_coord = [1201 1735 1648 1122 1201;
              783 838 1295 1218 783;  
              1 1 1 1 1];

% Transform coordinates based on SIFT feature matched transform
rect_coord_transform = inv(transform9.T)' * rect_coord;
o = size(img_ref,2);

% Show original and transformed rectangle
figure;
imshow([img_ref,im9],[])
hold on;
line(rect_coord(1,:),rect_coord(2,:),'Color', 'red', 'LineWidth', 2)
line(rect_coord_transform(1,:)+o,rect_coord_transform(2,:),'Color', 'red', 'LineWidth', 2)


%% Functions
function match_and_display(img_ref, img, matches, f_ref, d_ref, f, d, num)
    % Get matching features %
    indices1 = matches(1,:);
    f_refmatch = f_ref(:,indices1);
    d_refmatch = d_ref(:,indices1);
    indices2 = matches(2,:);
    f1match = f(:,indices2);
    d1match = d(:,indices2);

    % Show matches %
    y_ref = size(img_ref,1);
    x_ref = size(img_ref,2);
    y_img = size(img,1);
    x_img = size(img,2);

    % Pad test image with zeros to match ref size
    img_pad = padarray(img,[y_ref-y_img, x_ref-x_img],0,'post');

    % Only Display top 10 matches
    figure, imshow([img_ref,img_pad],[]);
    o = size(img_ref,2);
    line([f_refmatch(1,1:10);f1match(1,1:10)+o], ...
    [f_refmatch(2,1:10);f1match(2,1:10)]);

    for i=1:10
    x = f_refmatch(1,i);
    y = f_refmatch(2,i);
    text(x,y,sprintf('%d',i), 'Color', 'g');
    end

    for i=1:10
    x = f1match(1,i);
    y = f1match(2,i);
    text(x+o,y,sprintf('%d',i), 'Color', 'g');
    end
    
    title(['Top 10 SIFT Matches for Test Image ' num2str(num,'%02d')]);
end

function [transform, inliers] = match_and_get_transform(matches, f_ref, d_ref, f, d, num)
    % Get matching features %
    indices1 = matches(1,:);
    f_refmatch = f_ref(:,indices1);
    d_refmatch = d_ref(:,indices1);
    indices2 = matches(2,:);
    f1match = f(:,indices2);
    d1match = d(:,indices2);
    
    % Convert points to SURF object to use MATLAB library
    f_refmatch_points = SURFPoints([f_refmatch(1, :); f_refmatch(2, :)]');
    f1match_points = SURFPoints([f1match(1, :); f1match(2, :)]');

    % Estimate the affine transformation between f1match and f_refmatch
    % using RANSAC
    [transform, inliers] = estimateGeometricTransform2D(f1match_points, f_refmatch_points,...
        'affine', 'Confidence', 99.9, 'MaxNumTrials', 5000);
    
    % Calculate amount of inliers
    in_count = 0;
    score_total = 0;
    for n = 1:1:size(inliers,1)
        if inliers(n,1) == 1
            in_count = in_count + 1;
            score_total = score_total + matches(3, n);
        end
    end
    
    disp(['Image ' num2str(num,'%02d') ' to Image Ref Transform']);
    disp(transform.T);
    
    disp(['Image ' num2str(num,'%02d') ' to Image Ref Number of Inliers'])
    disp(in_count);
    disp(score_total);
    
end

