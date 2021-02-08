# -*- coding: utf-8 -*-
"""
Created on Mon Feb  3 01:32:57 2020

@author: ebrahim
"""

import cv2
import numpy as np

pi = 3.1415926

cap = cv2.VideoCapture('Movie1.mov')
frame_count = 0

while cap.isOpened():
    ret, frame = cap.read()

    if not ret:
        print("Can't read from video file!")
        break
    else:
        frame_count = frame_count + 1
    
    if frame_count % 30 != 0:
        pass # Do Nothing

    else:

        ## Perform Image Proccessing on Frame
        size = frame.shape

        gray = cv2.cvtColor(frame,cv2.COLOR_BGR2GRAY)
        blur = cv2.GaussianBlur(gray, (25,25), cv2.BORDER_DEFAULT)

        cv2.imwrite('Blur.jpg', blur)

        edges = cv2.Canny(blur,10,50)# The parameters are the thresholds for Canny

        cv2.imwrite('Canny.jpg', edges)

        dilate = cv2.dilate(edges, (7,7), iterations=2)

        cv2.imwrite('Dilate.jpg', dilate)

        lines = cv2.HoughLines(edges,1.0,0.001,50) # The parameters are accuracies and threshold
        num = len(lines)

        HorizontalLines = []
        VerticalLines = []

        # Cycle through Original Line List

        for n in range(num):
            rho, theta = lines[n][0]
            a = np.cos(theta)
            b = np.sin(theta)
            x0 = a*rho
            y0 = b*rho
            x1 = int(x0 + size[1]*(-b))
            y1 = int(y0 + size[0]*(a))
            x2 = int(x0 - size[1]*(-b))
            y2 = int(y0 - size[0]*(a))

            degrees = (theta/pi * 180)

            # Horizontal lines
            if (degrees >= 89.0) and (degrees <= 91.0):
                HorizontalLines.append((x1,y1,x2,y2))
            elif (degrees >= 0) and (degrees <= 1):
                VerticalLines.append((x1,y1,x2,y2))

        # Cycle through and remove similar lines

        HorizontalLines_Good = []
        VerticalLines_Good = []

        HorizontalLines_Good.append(HorizontalLines[0])
        VerticalLines_Good.append(VerticalLines[0])

        for line in VerticalLines:

            dx = line[2] - line[0]
            dy = line[3] - line[1]

            if dx == 0:
                dx = 1

            # Find parameters of the line
            line_m = dy/dx
            line_b = line[1] - line_m*line[0]  

            # Find X when y is zero
            line_x = -line_b/line_m

            flag_similar = False

            for goodline in VerticalLines_Good:
                dx = goodline[2] - goodline[0]
                dy = goodline[3] - goodline[1]

                if dx == 0:
                    dx = 1

                # Find parameters of the line
                line_m = dy/dx
                line_b = goodline[1] - line_m*goodline[0]  

                # Find X when y is zero
                goodline_x = -line_b/line_m
            
                if abs(goodline_x-line_x) <= 50:
                        flag_similar = True
            
            if flag_similar != True:
                VerticalLines_Good.append(line)

        for line in HorizontalLines:

            dx = line[2] - line[0]
            dy = line[3] - line[1]

            if dx == 0:
                dx = 1

            # Find parameters of the line
            line_m = dy/dx
            line_b = line[1] - line_m*line[0]  

            flag_similar = False

            for goodline in HorizontalLines_Good:
                dx = goodline[2] - goodline[0]
                dy = goodline[3] - goodline[1]

                if dx == 0:
                    dx = 1

                # Find parameters of the line
                line_m = dy/dx
                goodline_b = goodline[1] - line_m*goodline[0]  
            
                if abs(goodline_b-line_b) <= 50:
                        flag_similar = True
            
            if flag_similar != True:
                HorizontalLines_Good.append(line)


        # Cycle through Vertical Lines and find intercepts with Horizontal lines

        for line in HorizontalLines_Good:
            # Horizontal Line = RED
            cv2.line(frame,(line[0],line[1]),(line[2],line[3]),(0,0,255),2)

        for line in VerticalLines_Good:
            # Vertical Line = BLUE
            cv2.line(frame,(line[0],line[1]),(line[2],line[3]),(255,0,0),2)

        intersects = []

        for vertline in VerticalLines_Good:
            for horzline in HorizontalLines_Good:

                a1 = (vertline[0], vertline[1]) # Point on Vertical Line
                a2 = (vertline[2], vertline[3]) # Second point on Vertical Line

                b1 = (horzline[0], horzline[1]) # Point on Horizontal Line
                b2 = (horzline[2], horzline[3]) # Second point on Horizontal Line

                s = np.vstack([a1,a2,b1,b2])        # s for stacked
                h = np.hstack((s, np.ones((4, 1)))) # h for homogeneous
                l1 = np.cross(h[0], h[1])           # get first line
                l2 = np.cross(h[2], h[3])           # get second line
                x, y, z = np.cross(l1, l2)          # point of intersection
                if z == 0:                          # lines are parallel
                    break
                else:
                    intersects.append((int(x/z), int(y/z)))

        for point in intersects:
            cv2.circle(frame, (point[0], point[1]), radius=20, color=(0,255,0), thickness=-1)

        # Resize image to see on 1080p monitor

        scale_percent = 40 # percent of original size
        width = int(frame.shape[1] * scale_percent / 100)
        height = int(frame.shape[0] * scale_percent / 100)
        dim = (width, height)
  
        resized = cv2.resize(frame, dim, interpolation = cv2.INTER_AREA)

        cv2.imshow('Hough Result', resized)
        cv2.waitKey(0)
        cv2.destroyWindow("Hough Result")
        

cap.release() 
cv2.destroyAllWindows()