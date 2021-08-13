function  exportBathymetryPlotProfile(app)
global   cBathyPlotTran filtdepth

bathy=cBathyPlotTran.bathy;
cla(app.UIAxes6);
%% Clear Grid 

if length(app.UIAxes2_3.Children)>2
    for k=3:length(app.UIAxes2_3.Children)
app.UIAxes2_3.Children(length(app.UIAxes2_3.Children)-k+1).Visible='off';
    end
end

if length(app.UIAxes2_4.Children)>2
    for k=3:length(app.UIAxes2_4.Children)
app.UIAxes2_4.Children(length(app.UIAxes2_4.Children)-k+1).Visible='off';
    end
end


%% Pick The Point
yt=app.EnterYCoordinatetoPlotCrossshoreprofilebelowEditField_2.Value;
[cX cY]=meshgrid(bathy.xm,bathy.ym);


%% Find Corresponding
chk=abs(yt-cY(:,1));
[m i]=min(chk);

plot(cX(i,:),-(cBathyPlotTran.bathy.fCombined.h(i,:)-bathy.tide.zt),'parent',app.UIAxes6,'color','r')
box(app.UIAxes5,'on')
plot(cX(i,:),filtdepth(i,:),'parent',app.UIAxes6,'color','b')


%% Plot Transet
plot(cX(i,:),cY(i,:),'parent',app.UIAxes2_3,'color','r')
plot(cX(i,:),cY(i,:),'parent',app.UIAxes2_4,'color','b')

%% Plot 0 Line
hold(app.UIAxes6,'on')
plot(cX(i,:),cX(i,:).*0,'k--','parent',app.UIAxes6)
grid(app.UIAxes6,'on')


legend(app.UIAxes6,'Raw Depth','Filtered Depth','MWL','location','southwest')
