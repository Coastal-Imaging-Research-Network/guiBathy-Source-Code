%% Function to compare to survey data
close all
clear all


%% Load FRF DEM- Oct1
ncfile='FRF_20150915_1105_FRF_NAVD88_LARC_GPS_UTC_v20160309_grid_latlon.nc';

xFRF = ncread(ncfile,'xFRF');
yFRF = ncread(ncfile,'yFRF');
z = ncread(ncfile,'elevation');
[x y]=meshgrid(xFRF,yFRF);

figure
title('larc survey 9/15')
pcolor(x',y',z)
shading flat
hold on
caxis([-10 2])
colorbar

%% Load PBtool Merged
load('C:\Users\Brittany\Documents\MATLAB\20200703_GUITEST\brittany_test\products\uasFlight_2Hz_Orthos_PBTool_products\PBToolCombinedDepthProduct.mat')
% load('C:\Users\Brittany\Documents\MATLAB\20200703_GUITEST\brittany_test\products\uasFlight_2Hz_Orthos_Timestack_cbathy_products\cBathyDepthProduct.mat')
figure
pcolor(localX,localY,localDepth)
shading flat
caxis([-10 2])
title('UAS 10/1')
colorbar


%% Interpolate
zi=interp2(localX,localY,localDepth,x',y');
figure
pcolor(x',y',zi-z)
shading flat
caxis([-2 2])
title('uas-larc')
colorbar

c1=[1 0 0];
c2=[1 1 1];
c3=[0 0 1];

n=100;

for k=1:3
    Ca(:,k)=linspace(c1(k),c2(k),n);
    Cb(:,k)=linspace(c2(k),c3(k),n);
end

C=cat(1,Ca,Cb(2:end,:));

colormap(C)
