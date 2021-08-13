%parametric_bar test
clear all
tic
load('standardparsm.mat');
input = pbData;
%temp = pbData;
%input = struct('xres',5,'yres',20,'hsea',4.5, ...
%    'xoff',700,'hoff',7.5,'beta_off', ...
%    0.0088,'beta_shore',0.1, ...
%    'x0',0,'xmax',1000,'y0',500,'ymax', ...
%    1500,'feature_res',1);%,'tide',0.5);
%input.tide = pbData.tide;
%input.bar = pbData.bar;
%input.bar(:,1) = input.bar(:,1) + 40;
%input.shoreline = pbData.shoreline;
%input.shoreline(:,1) = input.shoreline(:,1) + 40;
%input.hoff = 10.0;
%input.xoff = 1096;
%input.hsea = 6.0;
input.feature_res = 1.0;
%input.tide = 1.0;

%input.hsea = 5.0;
% input.bar = [179.8014956225681, -454.99141006638047;
% 184.95409776264594, -386.94991800937595;
% 188.974343385214, -295.17755709797507;
% 187.58359678988327, -204.69848748227224;
% 186.00285749027236, -109.59025616530096;
% 200.6398954280156, -17.017286356563204;
% 200.0775170233463, 53.7750157579577;
% 200.0775170233463, 118.37799524306661;
% 206.87165612840465, 194.89773023853604;
% 208.85517996108948, 289.88279095591713;
% 202.31183122568095, 393.9414191764498;
% 199.37074416342412, 474.43340600870636;
% 208.95397616731518, 608.2479982469274;
% 199.7051313229572, 671.7013854691932;
% 188.33596789883268, 748.2313846812954;
% 185.8736624513619, 803.9147599127402;
% 180.92625243190662, 876.5854136710134;
% 174.61089494163423, 957.4777049519382;
% 174.61089494163423, 1022.3783467193903;
% 180.39427285992218, 1100.6122058924914;
% 191.34545233463035, 1169.556949013158;
% 191.34545233463035, 1243.1616464849906;
% 189.2175340466926, 1275.935290192641;
% 189.71911478599222, 1332.0292340893868;
% 194.12694552529183, 1403.7658441341002;
% 195.52529182879377, 1461.9228955739839];
% input.shoreline = [110.26416585603113, -269.2912027507485;
% 111.76890807392998, -168.7737292684368;
% 113.32684824902725, 15.889792167310134;
% 113.32684824902725, 124.55705365584629;
% 113.32684824902725, 210.48907530334066;
% 109.53459387159533, 255.9595549854239;
% 107.1786843385214, 303.95503195910817;
% 116.81511429961088, 356.04593136916947;
% 128.99744649805447, 440.98232400330915;
% 120.356578307393, 508.17188607981416;
% 124.58201605058366, 560.5193909056886;
% 117.76507782101167, 655.3504883735818;
% 109.32940175097275, 746.5069962870311;
% 109.96017752918289, 795.6212728736607;
% 114.58080009727625, 859.7828910435708;
% 98.64421206225683, 933.613401281319;
% 97.86904182879377, 1018.0776399503625;
% 106.41111381322956, 1095.1003215608257;
% 95.05714980544747, 1166.5700619730935;
% 97.22306663424123, 1251.9478159224316;
% 105.7347397859922, 1327.4616576879137;
% 102.07168044747081, 1409.3803706320912;
% 104.97476896887159, 1457.0268642402696];
%input.shoreline = load('duck_20151003_shoreline_xy.txt');
%input.bar = load('duck_20151003_bar_xy.txt');

data = run_parametric(input);

survey = read_survey_lines('FRF_20200805_1189_FRF_NAVD88_LARC_GPS_UTC_v20200807.xls');

figure(1) 
h = pcolor(data.x,data.y,data.h*-1.0);
set(h,'edgecolor','none')
xlabel('Cross-shore distance (m)')
ylabel('Along-shore distance (m)')
colorbar

figure(2)
h = pcolor(survey.x,survey.y,survey.elev);
set(h,'edgecolor','none')
xlabel('Cross-shore distance (m)')
ylabel('Along-shore distance (m)')
colorbar

% figure(2)
% hold on
% for ii = 1:length(data.y)
%     plot(data.x,data.h(ii,:)*-1.0)
% end
% xlabel('Cross-shore distance (m)')
% ylabel('Elevation (m)')
% hold off

[~,idy] = min(abs(data.y - 900));
[~,idg] = min(abs(survey.x - 900));
figure(3)
hold on
plot(data.x,data.h(idy,:)*-1.0)
plot(survey.x,survey.elev(idg,:),'k')
xlabel('Cross-shore distance (m)')
ylabel('Elevation (m)')
xlim([0,1000])
legend({'PBT','Survey'})
hold off

toc
