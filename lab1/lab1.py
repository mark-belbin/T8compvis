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
    else:
        # Horizontal Line = RED
        cv2.line(img,(x1,y1),(x2,y2),(255,0,0),2)


cv2.imwrite('HoughOut.jpg', img)