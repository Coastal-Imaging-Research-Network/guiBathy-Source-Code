clear all
close all

load D:\UASFLIGHTS\Pre_Isiais\preIsias\pbTool\res5_con0_10_25_40_pbestimate
data = run_parametric(pbMeta.input);

figure(1) 
h = pcolor(data.x,data.y,data.h*-1.0);
set(h,'edgecolor','none')
xlabel('Cross-shore distance (m)')
ylabel('Along-shore distance (m)')


figure(2)
hold on
for ii = 1:length(data.y)
    plot(data.x,data.h(ii,:)*-1.0);
end
xlabel('Cross-shore distance (m)')
ylabel('Elevation (m)')
hold off