# -*- coding: utf-8 -*-
"""
Created on Mon Feb  3 01:32:57 2020

@author: ebrahim
"""

import cv2
import numpy as np

pi = 3.1415926

img = cv2.imread('test4.jpg') # Remember to add the path for the test1.jpg
size = img.shape

gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
blur = cv2.GaussianBlur(gray, (25,25), cv2.BORDER_DEFAULT)

cv2.imwrite('Blur.jpg', blur)

edges = cv2.Canny(blur,10,50)# The parameters are the thresholds for Canny

cv2.imwrite('Canny.jpg', edges)

dilate = cv2.dilate(edges, (7,7), iterations=2)

cv2.imwrite('Dilate.jpg', dilate)

lines = cv2.HoughLines(edges,0.8,0.005,400) # The parameters are accuracies and threshold
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

    # Horizontal lines
    if (theta >= pi/2-0.2) and (theta <= pi/2+0.2):
        # Vertical Line = BLUE
        cv2.line(img,(x1,y1),(x2,y2),(0,0,255),2)
        VerticalLines.append((x1,y1,x2,y2))
    else:
        # Horizontal Line = RED
        cv2.line(img,(x1,y1),(x2,y2),(255,0,0),2)
        HorizontalLines.append((x1,y1,x2,y2))

# Cycle through Vertical Lines and find intercepts with Horizontal lines

intersects = []

for vertline in VerticalLines:
    for horzline in HorizontalLines:

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
    img = cv2.circle(img, (point[0], point[1]), radius=20, color=(0,255,0), thickness=-1)

cv2.imwrite('HoughOut.jpg', img)