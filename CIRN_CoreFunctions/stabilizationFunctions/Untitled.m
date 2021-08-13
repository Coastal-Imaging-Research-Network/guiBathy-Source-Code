close all
clear all


I=imread('D:\UASFLIGHTS\PBTTest_1\frames\uasFlight_2Hz\Frame_1597689067568.jpg');
pv=2042
pu=326
w=50
I=I( (pv-50):(pv+50),(pu-50):(pu+50),:);
imshow(I)
I=rgb2gray(I);
[regions,mserCC] = detectMSERFeatures(I);
 points = detectBRISKFeatures(I);
 hold on
   plot(points.selectStrongest(1));