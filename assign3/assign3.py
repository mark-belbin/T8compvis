'''
@author: Mark Belbin
         Rodney Windsor
         Raylene Mitchell
'''

import cv2
import numpy as np

# Read images and convert to grayscale
im1 = cv2.imread('im1.jpg')
im2 = cv2.imread('im2.jpg')

# Shift images towards the center so after transform all of the pano is shown
T = np.float32([[1, 0, im2.shape[1]/2],[0, 1, im2.shape[0]/2]])
im2 = cv2.warpAffine(im2, T,  (im1.shape[1]*2,  im1.shape[0]*2))
im1 = cv2.warpAffine(im1, T,  (im1.shape[1]*2,  im1.shape[0]*2))

im1_gray = cv2.cvtColor(im1,cv2.COLOR_BGR2GRAY)
im2_gray = cv2.cvtColor(im2,cv2.COLOR_BGR2GRAY)

# Display / write grayscale images
#cv2.imshow('Im1 Grayscale', im1_gray)
#cv2.waitKey(0)
#cv2.imshow('Im2 Grayscale', im2_gray)
#cv2.waitKey(0)
cv2.imwrite('Results/Im1_gray.jpg', im1_gray)
cv2.imwrite('Results/Im2_gray.jpg', im2_gray)


# Find features using BRISK. 
# SURF/SIFT are not included in opencv pypi due to a patent, BRISK worked better than ORB
brisk = cv2.BRISK_create()
keypoints1, descriptors1 = brisk.detectAndCompute(im1,None)
keypoints2, descriptors2 = brisk.detectAndCompute(im2,None)

# Display / write keypoints and features
#cv2.imshow('Im1 Keypoints', cv2.drawKeypoints(im1_gray,keypoints1,None,color=(0,255,0)))
#cv2.waitKey(0)
#cv2.imshow('Im2 Keypoints', cv2.drawKeypoints(im2_gray,keypoints2,None,color=(0,255,0)))
#cv2.waitKey(0)
cv2.imwrite('Results/Im1_Keypoints.jpg', cv2.drawKeypoints(im1_gray,keypoints1,None,color=(0,255,0)))
cv2.imwrite('Results/Im2_Keypoints.jpg', cv2.drawKeypoints(im2_gray,keypoints2,None,color=(0,255,0)))

# Brute-force match the descriptors
bf = cv2.BFMatcher(cv2.NORM_HAMMING, crossCheck=True)
matches = bf.match(descriptors1, descriptors2)
matches = sorted(matches, key = lambda x:x.distance)

# Show / write match pairs
#cv2.imshow('Im1/Im2 Feature Matches', cv2.drawMatches(im1,keypoints1,im2,keypoints2,matches[:75], None,flags=cv2.DrawMatchesFlags_NOT_DRAW_SINGLE_POINTS))
#cv2.waitKey(0)
cv2.imwrite('Results/Im1_Im2_Feature_Matches.jpg', cv2.drawMatches(im1,keypoints1,im2,keypoints2,matches[:75], None,flags=cv2.DrawMatchesFlags_NOT_DRAW_SINGLE_POINTS))

# convert the keypoints to numpy arrays
keypoints1 = np.float32([kp.pt for kp in keypoints1])
keypoints2 = np.float32([kp.pt for kp in keypoints2])

# construct the two sets of points
pts1 = np.float32([keypoints1[m.queryIdx] for m in matches])
pts2 = np.float32([keypoints2[m.trainIdx] for m in matches])

# estimate the homography between the sets of points using RANSAC 
(homography, status) = cv2.findHomography(pts2, pts1, cv2.RANSAC, 4)

# Generate result for RGB cropping
pano = cv2.warpPerspective(im2, homography, (int(im2.shape[1]*1.25), im2.shape[0]))

for y in range(im1.shape[0]):
    for x in range(im1.shape[1]):
        if im1[y, x].any():
            pano[y, x] = im1[y, x]

# Generate result for grayscale overlapping
im1_gray = im1_gray.astype(float)
im2_gray = im2_gray.astype(float)

gray_pano = cv2.warpPerspective(im2_gray, homography, (int(im2_gray.shape[1]*1.25), im2_gray.shape[0])).astype(float)

for y in range(im1_gray.shape[0]):
    for x in range(im1_gray.shape[1]):
        if gray_pano[y, x] != 0:
            gray_pano[y, x] = (gray_pano[y, x] + im1_gray[y,x])
        else:
            gray_pano[y,x] = im1_gray[y,x]

gray_pano = gray_pano / np.amax(gray_pano) * 255.0 # Normalize
gray_pano = gray_pano.astype(np.uint8)

# Display / write RGB cropped result
#cv2.imshow('RGB Pano', pano)
#cv2.waitKey(0)
cv2.imwrite('Results/RGB_Pano.jpg', pano)

# Display / write Grayscale overlapped result
#cv2.imshow('Grayscale Overlapping Pano', gray_pano)
#cv2.waitKey(0)
cv2.imwrite('Results/Grayscale_Overlapping_Pano.jpg', gray_pano)