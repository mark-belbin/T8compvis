%%%~~        Engi 8410        ~~%%%
%%%~~          Lab #3         ~~%%%
%%%~~         Group 13        ~~%%%
%%%~~       Mar 17, 2021      ~~%%%

close all
clear

% Read image 1 and image 2
im1 = imread('myofficePos1.jpg');
im2 = imread('myofficePos2.jpg');

% Plot images
figure;
subplot(121);
imshow(im1);
title('Im1, Camera 1 View');
subplot(122);
imshow(im2);
title('Im2, Camera 2 View');

% Define camera and image parameters % 
% Values taken from lab 2 results and given intrinsic matrix

% Points on the cube wrt cube origin
X_coord=[1.5 3.5 5.5 7.5 4.5 1.5 3.5 5.5 7.5 4.5 1.5 3.5 5.5 7.5 0 0 0 0 0 0 0 0 0 0 0];
Y_coord=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 1.5 3.5 5.5 2.5 1.5 3.5 5.5 2.5 1.5 3.5 5.5];
Z_coord=[0.5 0.5 0.5 0.5 1.5 2.5 2.5 2.5 2.5 3.5 4.5 4.5 4.5 4.5 0.5 0.5 0.5 1.5 2.5 2.5 2.5 3.5 4.5 4.5 4.5];
P_M = [X_coord; Y_coord; Z_coord; ones(1,25)];

% intrinsic parameter matrix
K = [ 636 0 317; 0 636 240; 0 0 1 ];

% Camera pose results from lab 2 
pose1 = [1.4012 -0.5715 0.1061 8.4533 17.4056 59.0472] ; %[ax ay az tx ty tz]
pose2 = [1.2023 -1.1886 0.3397 -16.3270 16.8507 51.8341] ; %[ax ay az tx ty tz]

% Calculate homeogenous transformation from camera to cube origin

% Camera 1 transform
Rx1=[1 0 0;
    0 cos(pose1(1)) -sin(pose1(1));
    0 sin(pose1(1)) cos(pose1(1))];

Ry1=[cos(pose1(2)) 0 sin(pose1(2));
     0 1 0;
   -sin(pose1(2)) 0 cos(pose1(2))];

Rz1=[cos(pose1(3)) -sin(pose1(3)) 0;
    sin(pose1(3)) cos(pose1(3)) 0;
    0 0 1];

R_m_c1=Rz1*Ry1*Rx1;
Pmorg_c1=[pose1(4) pose1(5) pose1(6)]';
M1=[R_m_c1 Pmorg_c1];
H_m_c1=[R_m_c1 Pmorg_c1; 0 0 0 1];

% Camera 2 transform
Rx2=[1 0 0;
    0 cos(pose2(1)) -sin(pose2(1));
    0 sin(pose2(1)) cos(pose2(1))];

Ry2=[cos(pose2(2)) 0 sin(pose2(2));
     0 1 0;
   -sin(pose2(2)) 0 cos(pose2(2))];

Rz2=[cos(pose2(3)) -sin(pose2(3)) 0;
    sin(pose2(3)) cos(pose2(3)) 0;
    0 0 1];

R_m_c2=Rz2*Ry2*Rx2;
Pmorg_c2=[pose2(4) pose2(5) pose2(6)]';
M2=[R_m_c2 Pmorg_c2];
H_m_c2=[R_m_c2 Pmorg_c2; 0 0 0 1];

% Find Transformation of camera 2 wrt camera 1
H_c2_c1 = H_m_c1 * inv(H_m_c2);
R_c2_c1 = H_c2_c1(1:3,1:3);
Pc2org_c1 = H_c2_c1(1:3,4);

% Plot P_M points onto image 1 and image 2
p1=M1*P_M;
p1(1,:)=p1(1,:)./p1(3,:);
p1(2,:)=p1(2,:)./p1(3,:);
p1(3,:)=p1(3,:)./p1(3,:);

p2=M2*P_M;
p2(1,:)=p2(1,:)./p2(3,:);
p2(2,:)=p2(2,:)./p2(3,:);
p2(3,:)=p2(3,:)./p2(3,:);

figure;
subplot(121);
imshow(im1), title('Camera View 1 with Points');
%convert image points from normalized to unnormalized
u=K*p1;
for i=1:length(u)
    rectangle('Position',[u(1,i)-2 u(2,i)-2 4 4], 'FaceColor', 'r');
end

subplot(122);
imshow(im2), title('Camera View 2 with Points');
%convert image points from normalized to unnormalized
u=K*p2;
for i=1:length(u)
    rectangle('Position',[u(1,i)-2 u(2,i)-2 4 4], 'FaceColor', 'r');
end

% Calculating the essential matrix
t=Pc2org_c1;
E_true = [0 -t(3) t(2); t(3) 0 -t(1); -t(2) t(1) 0]*R_c2_c1;
disp('True E = ');
disp(E_true);

% Drawing epipolar lines for im1
figure;
subplot(121);
imshow(im1), title('Camera View 1 with Epipolar Lines');
for i=1:length(p2)
    %rectangle('Position',[u(1,i)-2 u(2,i)-2 4 4], 'FaceColor', 'r');
    %compute el=E*p2 where el=[a,b,c] and the equation of the line
    %is ax=by=c=0
    el=E_true*p2(:,i);
    %to find two points we assume x =1 and solve for y then assume
    % x=2 and solve for y
    px=1;
    pLine0=[px; (-el(3)-el(1)*px)/el(2); 1];
    px=-2;
    pLine1=[px; (-el(3)-el(1)*px)/el(2); 1];
    %convert to unnormalized
    pLine0=K*pLine0; pLine1=K*pLine1;
    %draw the line
    line([pLine0(1) pLine1(1)], [pLine0(2) pLine1(2)], 'Color', 'r');
end

% Drawing epipolar lines for im2
subplot(122);
imshow(im2), title('Camera View 2 with Epipolar Lines');
for i=1:length(p1)
    %rectangle('Position',[u(1,i)-2 u(2,i)-2 4 4], 'FaceColor', 'r');
    % Compute el2 = (p1'*E)'
    el2 = (p1(:,i)' * E_true)';
    
    %to find two points we assume x =1 and solve for y then assume
    % x=2 and solve for y
    px=1;
    pLine0=[px; (-el2(3)-el2(1)*px)/el2(2); 1];
    px=-2;
    pLine1=[px; (-el2(3)-el2(1)*px)/el2(2); 1];
    %convert to unnormalized
    pLine0=K*pLine0; pLine1=K*pLine1;
    %draw the line
    line([pLine0(1) pLine1(1)], [pLine0(2) pLine1(2)], 'Color', 'r');
end


% Calculating E using the 8 point algorithm

% Apply preconditioning
xn=p1(1:2, :); %xn is a 2xN matrix
N=size(xn,2);
t=(1/N)* sum(xn,2); %(x,y) centroid of the points
xnc=xn-t*ones(1,N); % center the points
%dc is 1xN vector = distance of each new position to (0,0)
dc=sqrt(sum(xnc.^2));
davg=(1/N)*sum(dc); %average distance to the origin
s=sqrt(2)/davg; %the scale factor so that the avg dist is sqrt(2)
T1=[s*eye(2), -s*t; 0 0 1]; %transformation matrix
p1s=T1*p1;

xn=p2(1:2, :);
N=size(xn,2);
t=(1/N)* sum(xn,2); %(x,y) centroid of the points
xnc=xn-t*ones(1,N);
dc=sqrt(sum(xnc.^2));
davg=(1/N)*sum(dc);
s=sqrt(2)/davg;
T2=[s*eye(2), -s*t; 0 0 1];
p2s=T2*p2;

A=[p1s(1,:)'.*p2s(1,:)' p1s(1,:)'.*p2s(2,:)' p1s(1,:)' p1s(2,:)'.*p2s(1,:)' p1s(2,:)'.*p2s(2,:)' p1s(2,:)' p2s(1,:)' p2s(2,:)' ones(length(p1s),1)];

[U,D,V]=svd(A);
x=V(:,size(V,2));
Escale=reshape(x,3,3)';

%postcondition
[U,D,V] = svd(Escale);
%D should be[1 0 0], we enforce that by replacing
%it as shown in this line
Escale=U*diag([1 1 0])*V';
%undo scaling done in preconditioning using

E = T1' * Escale * T2;
disp('Calculated E = ');
disp(E);

%Although the above is different but as we said it
%is up to a scale, hence divide by E(1,2)
disp('calculated E after scaling= ');
disp(E/(-E(1,2)));

