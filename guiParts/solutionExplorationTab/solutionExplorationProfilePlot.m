function solutionExplorationProfilePlot(app)

global cBathyPlotTran
bathy=cBathyPlotTran.bathy;
cla(app.UIAxes5);
%% Clear Grid 

if length(app.UIAxes2_2.Children)>2
    for k=3:length(app.UIAxes2_2.Children)
app.UIAxes2_2.Children(length(app.UIAxes2_2.Children)-k+1).Visible='off';
    end
end

if length(app.UIAxes2.Children)>2
    for k=3:length(app.UIAxes2.Children)
app.UIAxes2.Children(length(app.UIAxes2.Children)-k+1).Visible='off';
    end
end


%% Pick The Point
yt=app.EnterYCoordinatetoPlotCrossshoreprofilebelowEditField.Value;
[cX cY]=meshgrid(bathy.xm,bathy.ym);


%% Find Corresponding
chk=abs(yt-cY(:,1));
[m i]=min(chk);
disp(i)
plot(cX(i,:),-(cBathyPlotTran.bathy.fCombined.h(i,:)-bathy.tide.zt),'parent',app.UIAxes5,'color','r')
box(app.UIAxes5,'on')


%% Plot Transet
plot(cX(i,:),cY(i,:),'parent',app.UIAxes2,'color','r')
plot(cX(i,:),cY(i,:),'parent',app.UIAxes2_2,'color','r')

%% Plot 0 Line
hold(app.UIAxes5,'on')
plot(cX(i,:),cX(i,:).*0,'k--','parent',app.UIAxes5)
grid(app.UIAxes5,'on')


%% Figure Out Surface Area for Error
ul=-(bathy.fCombined.h(i,:)-bathy.tide.zt)+bathy.fCombined.hErr(i,:);
ll=-(bathy.fCombined.h(i,:)-bathy.tide.zt)-bathy.fCombined.hErr(i,:);
xx= [cX(i,:)]';
xtag=cat(1,nan,-(bathy.fCombined.h(i,:)-bathy.tide.zt)',nan);
chk=isnan(xtag);
chk2=diff(chk);

i1=find(chk2==-1);
i2=find(chk2==1);
for k=1:length(i1)
    ii1=i1(k);
    ii2=i2(k)-1;
    
    xp=[xx(ii1:ii2)' flip(xx(ii1:ii2))'];
    yp=[ll(ii1:ii2) flip(ul(ii1:ii2))];

    patch(xp,yp,'r','FaceColor','r','EdgeColor','none','FaceAlpha',.1,'parent',app.UIAxes5)
end
    
    



xlim(app.UIAxes5,[min(min(cBathyPlotTran.X))  max(max(cBathyPlotTran.X))])
ylim(app.UIAxes5,[  app.DepthSlider.Value  app.DepthSlider_2.Value])

legend(app.UIAxes5,'Estimated Depth','MWL','Error','location','southwest')





