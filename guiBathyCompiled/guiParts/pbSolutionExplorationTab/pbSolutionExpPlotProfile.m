function pbSolutionExpPlotProfile(app)

global pbPlotTran
cla(app.UIAxes5_2);
hold(app.UIAxes5_2,'on')
%% Clear Lines off of Ortho If it Exists
    for k=1:length(app.UIAxes2_5.Children)
        if strcmp(app.UIAxes2_5.Children(k).Type,'line')==1
        app.UIAxes2_5.Children(k).Visible='off';
        end
    end


% 
    for k=1:length(app.UIAxes2_6.Children)
        if strcmp(app.UIAxes2_6.Children(k).Type,'line')==1
        app.UIAxes2_6.Children(k).Visible='off';
        end
    end

%% Pick The Point
yt=app.EnterYCoordinatetoPlotCrossshoreprofilebelowEditField_3.Value;




%% Find Corresponding PBTool
chk=abs(yt-pbPlotTran.pbY(:,1));
[m i2]=min(chk);

if yt<=max(max(pbPlotTran.pbY(:,1))) & yt>=min(min(pbPlotTran.pbY(:,1)))
plot(pbPlotTran.pbX(i2,:),(pbPlotTran.pbZ(i2,:)),'parent',app.UIAxes5_2,'color','b')
else
    plot(pbPlotTran.pbX(i2,:)*nan,(pbPlotTran.pbZ(i2,:)),'parent',app.UIAxes5_2,'color','b')
end
%% Find Corresponding Cbathy
chk=abs(yt-pbPlotTran.cY(:,1));
[m i]=min(chk);
plot(pbPlotTran.cX(i,:),(pbPlotTran.cZ(i,:)),'parent',app.UIAxes5_2,'color','r')
box(app.UIAxes5_2,'on')

%% Plot Transet
if yt<=max(max(pbPlotTran.pbY(:,1))) & yt>=min(min(pbPlotTran.pbY(:,1)))
plot(pbPlotTran.pbX(i2,:),pbPlotTran.pbY(i2,:),'parent',app.UIAxes2_5,'color','b')
else
    plot(pbPlotTran.cX(i,:),pbPlotTran.cY(i,:),'parent',app.UIAxes2_5,'color','b')
end
plot(pbPlotTran.cX(i,:),pbPlotTran.cY(i,:),'parent',app.UIAxes2_6,'color','r')

%% Plot 0 Line
hold(app.UIAxes5_2,'on')
plot(pbPlotTran.cX(i,:),pbPlotTran.cX(i,:).*0,'k--','parent',app.UIAxes5_2)
grid(app.UIAxes5,'on')

legend(app.UIAxes5_2,'PB Tool','cBathy','MWL','location','southwest')


%% Set Y limits
ylim(app.UIAxes5_2, [app.DepthSlider_3.Value  app.DepthSlider_4.Value ])