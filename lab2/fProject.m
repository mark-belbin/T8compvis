function p = fProject(x, P_M, K)

%STUDENTS IMPLEMENT THIS ALGORITHM:
% Project 3D points onto image
% Get pose params (theta and t from the passed parameter x
% calculate Rx, Ry, Rz (use yaw pitch roll notation)
% Calculate R_m_c1=Rz * Ry * Rx  
% Define Pmorg_c=[tx;ty;tz]
% calculate the Extrinsic camera matrix from R_m_c1 and Pmorg_c - call it Mext
% Project the real life point by multiplying P_M by K and Mext - call 
%the projected points ph
% Convert back to the eacludean coordinate system by dividing through 
%3rd element of each column

% get pose params
ax=x(1); ay=x(2); az=x(3); tx=x(4); ty=x(5); tz=x(6);

% Rotation matrix
Rx=[1 0 0;0 cos(ax) -sin(ax); 0 sin(ax) cos(ax)];
Ry=[cos(ay) 0 sin(ay);0 1 0; -sin(ay) 0 cos(ay)];
Rz=[ cos(az) -sin(az) 0; sin(az) cos(az) 0;0 0 1];
R=Rz*Ry*Rx;

%Extrinsic camera matrix
Mext=[R [tx;ty;tz]];

%project point
ph=K*Mext*P_M;
ph(1,:)=ph(1,:)./ph(3,:);
ph(2,:)=ph(2,:)./ph(3,:);
ph = ph(1:2,:); % Get rid of 3rd row
p = reshape(ph, [], 1); % reshape into 2Nx1 vector
return

end