function cbathyRunReplot(app)
global bathytran
cla(app.UIAxes_14);

%% Switch over
data=bathytran.data;
t=bathytran.t;
xyz=bathytran.xyz;
stackMeta=bathytran.stackMeta;
x=bathytran.x;
y=bathytran.y;
z=bathytran.z;


%% Plot Figure


d=bathytran.Io;

imagesc(x(1,:),y(:,1),d,'parent',app.UIAxes_14)
colormap(app.UIAxes_14,gray);
set(app.UIAxes_14,'ydir','normal')
axis(app.UIAxes_14,'equal')
xlim(app.UIAxes_14,[min(min(x)) max(max(x))])
ylim(app.UIAxes_14,[min(min(y)) max(max(y))])
%% Plot analysis area
hold(app.UIAxes_14,'on')
patch([app.UITable10_3.Data{1,1} app.UITable10_3.Data{1,1} app.UITable10_3.Data{1,2} app.UITable10_3.Data{1,2}], [app.UITable10_3.Data{2,1} app.UITable10_3.Data{2,2} app.UITable10_3.Data{2,2} app.UITable10_3.Data{2,1}],'r','FaceColor','none','edgecolor','r','parent',app.UIAxes_14,'linewidth',2)

%% Plot Grid
byx=str2num(app.ListBox_20.Value);
byy=str2num(app.ListBox_20.Value);

%% Plot OnshorePoint
% min edge of onshore analysis area
xon=(app.UITable10_3.Data{1,1});
%Analysis area
xa=str2num(app.ListBox_22.Value);
ya=str2num(app.ListBox_23.Value);

% % Find mean Point of view
bind=find((d)>0);
ny=mean(y(bind));
nx=xon+xa/2;
xloc=nx+[-xa/2 xa/2 xa/2 -xa/2];
yloc=ny+[-ya/2 -ya/2 ya/2 ya/2];
patch(xloc,yloc,'g','facecolor','none','edgecolor','g','linewidth',2,'parent',app.UIAxes_14);

xsub=x(1:byy:end,1:byx:end);
ysub=y(1:byy:end,1:byx:end);

gind=find( xsub >=xloc(1) &  xsub <=xloc(2) & ysub >=yloc(1) & ysub <=yloc(4));
plot(xsub(gind),ysub(gind),'ro','linewidth',.5,'parent',app.UIAxes_14)
plot(nx,ny,'g*','parent',app.UIAxes_14)



%% Plot OffshorePoint

%% Determine Kappa

if app.Button_5.Value==1
    K=1;
end
if app.Button_6.Value==1
    K=2;
end
if app.Button_7.Value==1
    K=3;
end

xa=xa.*K;
ya=ya.*K;




% min edge of onshore analysis area
xon=(app.UITable10_3.Data{1,2});
% % Find mean Point of view
nx=xon-xa/2;
xloc=nx+[-xa/2 xa/2 xa/2 -xa/2];
yloc=ny+[-ya/2 -ya/2 ya/2 ya/2];
patch(xloc,yloc,'g','facecolor','none','edgecolor','g','linewidth',2,'parent',app.UIAxes_14);

xsub=x(1:byy:end,1:byx:end);
ysub=y(1:byy:end,1:byx:end);

gind=find( xsub >=xloc(1) &  xsub <=xloc(2) & ysub >=yloc(1) & ysub <=yloc(4));
plot(xsub(gind),ysub(gind),'ro','linewidth',.5,'parent',app.UIAxes_14)
plot(nx,ny,'g*','parent',app.UIAxes_14)


