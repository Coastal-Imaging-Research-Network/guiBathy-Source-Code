function pbExportBathyPlotProfile(app)

global pbExporTran pc9 
cla(app.UIAxes6_2);
hold(app.UIAxes6_2,'on')


%% Clear Lines off of Ortho If it Exists
for k=1:length(app.UIAxes2_10.Children)
    if strcmp(app.UIAxes2_10.Children(k).Type,'line')==1
        app.UIAxes2_10.Children(k).Visible='off';
    end
end

for k=1:length(app.UIAxes2_8.Children)
    if strcmp(app.UIAxes2_8.Children(k).Type,'line')==1
        app.UIAxes2_8.Children(k).Visible='off';
    end
end

for k=1:length(app.UIAxes2_9.Children)
    if strcmp(app.UIAxes2_9.Children(k).Type,'line')==1
        app.UIAxes2_9.Children(k).Visible='off';
    end
end




%% Pick The Point
yt=app.EnterYCoordinatetoPlotCrossshoreprofilebelowEditField_4.Value;

%% Find Corresponding Cbathy
if isempty(pbExporTran.cY)==0
chk=abs(yt-pbExporTran.cY(:,1));
[m i]=min(chk);

if yt<=max(pbExporTran.cY(:,1)) &    yt>=min(pbExporTran.cY(:,1)) 
plot(pbExporTran.cX(i,:),(pc9.CData(i,:)),'parent',app.UIAxes6_2,'color','r')
box(app.UIAxes6_2,'on')
plot(pbExporTran.cX(i,:),pbExporTran.cY(i,:),'parent',app.UIAxes2_9,'color','r')
else
 plot(pbExporTran.cX(i,:),(pc9.CData(i,:))*nan,'parent',app.UIAxes6_2,'color','r')
box(app.UIAxes6_2,'on')
plot(pbExporTran.cX(i,:),pbExporTran.cY(i,:)*0+yt,'parent',app.UIAxes2_9,'color','r')   
    
    
end
end

%% Find Corresponding PBTool
if isempty(pbExporTran.pbY)==0
chk=abs(yt-pbExporTran.pbY(:,1));
[m i2]=min(chk);
if yt<=max(pbExporTran.pbY(:,1)) &    yt>=min(pbExporTran.pbY(:,1)) 
plot(pbExporTran.pbX(i2,:),(pbExporTran.pbZ(i2,:)),'parent',app.UIAxes6_2,'color','b')
plot(pbExporTran.pbX(i2,:),pbExporTran.pbY(i2,:),'parent',app.UIAxes2_10,'color','b')
else
plot(pbExporTran.pbX(i2,:),(pbExporTran.pbZ(i2,:)).*nan,'parent',app.UIAxes6_2,'color','b')
plot(pbExporTran.pbX(i2,:),pbExporTran.pbY(i2,:)*0+yt,'parent',app.UIAxes2_10,'color','b')  
end
end


%% Find Corresponding Blended
if isempty(pbExporTran.pbBlend)==0
chk=abs(yt-pbExporTran.Y(:,1));
[m i2]=min(chk);
plot(pbExporTran.X(i2,:),(pbExporTran.pbBlend(i2,:)),'parent',app.UIAxes6_2,'color','m')
plot(pbExporTran.X(i2,:),pbExporTran.Y(i2,:),'parent',app.UIAxes2_8,'color','m')
end



%% Plot 0 Line
plot(pbExporTran.X(i2,:),pbExporTran.X(i2,:).*0,'k--','parent',app.UIAxes6_2)
grid(app.UIAxes6_2,'on')

if length(app.UIAxes6_2.Children)>3
legend(app.UIAxes6_2,'cBathy','PB Tool','Blended','MWL','location','southwest')
end
 if length(app.UIAxes6_2.Children)<4
legend(app.UIAxes6_2,'PB Tool','Blended','MWL','location','southwest')
 end

 
 if isempty(pbExporTran.pbBlend)==1 & isempty(pbExporTran.cZ)==1
 legend(app.UIAxes6_2,'PB Tool','MWL','location','southwest')
 end
  if isempty(pbExporTran.pbBlend)==1 & isempty(pbExporTran.cZ)==0
 legend(app.UIAxes6_2,'cBathy','PB Tool','MWL','location','southwest')
  end
  if isempty(pbExporTran.pbBlend)==0 & isempty(pbExporTran.cZ)==0
 legend(app.UIAxes6_2,'cBathy','PB Tool','Blended','MWL','location','southwest')
  end
  
  
 
ylim(app.UIAxes6_2,[app.UITable10_6.Data{1,1} app.UITable10_6.Data{1,2}])