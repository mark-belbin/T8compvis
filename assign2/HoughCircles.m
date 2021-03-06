
function good_circles = HoughCircles(edges,r_max,thresh)

% edges = canny edge detection of desired image
% r_max = maximum radius of circle that is desired to be detected
% thresh = threshold of hough space accumulator value 

a = size(edges,2); % x0
b = size(edges,1); % y0
r = r_max; %r

A = zeros(a,b,r); % 3D Accumulator Array

% Accumulator Lööp
for r = 1:1:r_max
    for y = 1:1:b
        for x = 1:1:a
            if edges(y,x) == 1
                for theta = 0:0.1:2*pi
                    % Calculate circle pixel locations
                    x0 = uint16(x - r * cos(theta));
                    y0 = uint16(y - r * sin(theta));
                    
                    % Check if circle is within accumulator bounds
                    if (x0 < 1) || (x0 > a)
                        break
                    elseif (y0 < 1) || (y0 > b)
                        break
                    else
                        A(x0,y0,r) = A(x0,y0,r) + 1; % Add to accumulator
                    end
                end
            end
        end
    end
end

% Find local maxima in 3D array
maxima = islocalmax(A);

circle_count = 0;
circle_x = [];
circle_y = [];
circle_r = [];

% Create array of circles
for r = r_max:-1:20
    for y = 1:1:b
        for x = 1:1:a
            if (maxima(x,y,r) == 1) && (A(x,y,r) > thresh)
               circle_count = circle_count + 1;
               circle_x = [circle_x; x];
               circle_y = [circle_y; y];
               circle_r = [circle_r; r];
            end
        end
    end
end

% matrix of circle values
circles = [circle_x circle_y circle_r];

good_circles = circles(1,:);
good_circle_count = 1;

% Eliminate redundant circles
for circ = 1:1:circle_count
    x0 = circles(circ,1);
    y0 = circles(circ,2);
    
    flag_similar = 0;
    for good_circ = 1:1:good_circle_count
        x1 = good_circles(good_circ, 1);
        y1 = good_circles(good_circ, 2);
        r1 = good_circles(good_circ, 3);
        
        d = sqrt((x1-x0)^2+(y1-y0)^2);
        
        if d <= 0.5*r1
            flag_similar = 1;
        end
    end
    % If circle is unique, add it to the good circle list
    if flag_similar == 0
        good_circles = [good_circles; circles(circ,:)];
        good_circle_count = good_circle_count + 1;
    end  
   
end


end