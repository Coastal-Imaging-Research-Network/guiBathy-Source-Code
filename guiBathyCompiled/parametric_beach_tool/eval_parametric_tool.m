%parametric_bar test
clear all
close all
%test = [6,8,10,12,14];
%xtest = [500,800,1000,1400,1800];
%testname = 'Offshore Location';

%hsea
%test = [3.5,4,4.5,5,5.5,6,6.5,7.0];
%testname = 'Hsea';

%feature
test = [1,2,3];
testname='FeatureRes';

tic
survey = read_survey_lines('FRF_20200805_1189_FRF_NAVD88_LARC_GPS_UTC_v20200807.xls');

figure(1)
hold on
[~,idg] = min(abs(survey.x - 800));
hh(1) = plot(survey.x,survey.elev(idg,:),'k');
tname{1} = 'survey';

load('standardparsm.mat');
%temp = pbData;
for ii = 1:length(test)

input = struct('xres',5,'yres',20,'hsea',4.5, ...
    'xoff',700,'hoff',7.5,'beta_off', ...
    0.0088,'beta_shore',0.1, ...
    'x0',0,'xmax',1000,'y0',500,'ymax', ...
    1500,'feature_res',1);%,'tide',0.5);
input.tide = pbData.tide;
input.bar = pbData.bar;
input.bar(:,1) = input.bar(:,1) + 40.0;
input.shoreline = pbData.shoreline;
input.shoreline(:,1) = input.shoreline(:,1) + 40.0;%test(ii);
%input.hoff = test(ii);
%input.xoff = xtest(ii);
%input.hsea = test(ii);
input.feature_res = test(ii);

data = run_parametric(input);
[~,idy] = min(abs(data.y - 800));
hh(ii+1) = plot(data.x,data.h(idy,:)*-1.0);
tname{ii+1} = num2str(test(ii));
%xlim([0,1000])
end
legend(tname);
hold off
xlabel('Cross-shore distance (m)')
ylabel('Elevation (m)')
title(testname)
xlim([0,1000])
% figure(1) 
% h = pcolor(data.x,data.y,data.h*-1.0);
% set(h,'edgecolor','none')
% xlabel('Cross-shore distance (m)')
% ylabel('Along-shore distance (m)')
% colorbar

% figure(2)
% h = pcolor(survey.x,survey.y,survey.elev);
% set(h,'edgecolor','none')
% xlabel('Cross-shore distance (m)')
% ylabel('Along-shore distance (m)')
% colorbar

% figure(2)
% hold on
% for ii = 1:length(data.y)
%     plot(data.x,data.h(ii,:)*-1.0)
% end
% xlabel('Cross-shore distance (m)')
% ylabel('Elevation (m)')
% hold off


toc