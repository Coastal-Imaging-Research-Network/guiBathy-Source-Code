function exportBathymetryReplot(app)
global   cBathyPlotTran pc2  filtdepth


dplot=-(cBathyPlotTran.bathy.fCombined.h-cBathyPlotTran.bathy.tide.zt);
dplotE=cBathyPlotTran.bathy.fCombined.hErr;

%% Apply Error Filter
if app.MaximumErrorEditField.Value>0
    bind=find(dplotE>app.MaximumErrorEditField.Value);
    dplot(bind)=nan;
    
end
cBathyPlotTran.errMsk=dplot./dplot;

%% Apply X Smoothing Filter


if app.XSmoothingDistanceEditField.Value>1
    xspan=app.XSmoothingDistanceEditField.Value/(cBathyPlotTran.bathy.xm(end)-cBathyPlotTran.bathy.xm(1));
    for k=1:length(cBathyPlotTran.bathy.ym)
        
        % Find Las non zero value
        gind=find(isnan(dplot(k,:))==0);
        iss=[min(gind):max(gind)];
        
        dplot(k,:)=smooth(dplot(k,:),xspan);
        dplot(k,iss)=dplot(k,iss);
         noiss = setdiff(1:length(dplot(k,:)),iss);
        dplot(k,noiss)=nan;
    end
end

if app.YSmoothingDistanceEditField.Value>1
    yspan=app.YSmoothingDistanceEditField.Value/(cBathyPlotTran.bathy.ym(end)-cBathyPlotTran.bathy.ym(1));
    for k=1:length(cBathyPlotTran.bathy.xm)
        
        gind=find(isnan(dplot(:,k))==0);
        iss=[min(gind):max(gind)];
        
        dplot(:,k)=smooth(dplot(:,k),yspan);
        dplot(iss,k)=dplot(iss,k);
             noiss = setdiff(1:length(dplot(:,k)),iss);
        dplot(noiss,k)=nan;
        
    end
end



%% Replot 
%% Pull Ortho to Plot
if app.NoneButton_3.Value==1
    I=flipud(imread(cBathyPlotTran.sfile)).*0+1;
end

if app.SnapshotButton_3.Value==1
    I=flipud(imread(cBathyPlotTran.sfile));
end

if app.BrightestButton_3.Value==1
    I=flipud(imread(cBathyPlotTran.bfile));
end
if app.TimexButton_3.Value==1
    I=flipud(imread(cBathyPlotTran.tfile));
end
X=cBathyPlotTran.X;
Y=cBathyPlotTran.Y;
[cX cY]=meshgrid(cBathyPlotTran.bathy.xm,cBathyPlotTran.bathy.ym);

%% Get Mask
Isum=sum(double(flipud(imread(cBathyPlotTran.tfile))),3);
Vq = interp2(X,Y,Isum,cX,cY);
msk=cBathyPlotTran.bathy.fCombined.h.*0+1;
bind=find(Vq<=min(min(Vq)));
msk(bind)=nan;




%% Plot Data
dplot=dplot.*msk;
cBathyPlotTran.errMsk=cBathyPlotTran.errMsk.*msk;
cla(app.UIAxes2_4)


hold(app.UIAxes2_4,'on')
axis(app.UIAxes2,'equal')

imagesc(X(1,:),Y(:,1),I,'parent',app.UIAxes2_4 )
xlim(app.UIAxes2_4,[min(min(X)) max(max(X))])
ylim(app.UIAxes2_4,[min(min(Y)) max(max(Y))])
pc2=pcolor(cX,cY,dplot,'parent',app.UIAxes2_4);
shading(app.UIAxes2_4,'flat');
c1=colorbar(app.UIAxes2_4,'location','eastOutside');
c1.Label.String='Depth';
caxis(app.UIAxes2_4,[app.UITable10_5.Data{1,1},app.UITable10_5.Data{1,2}])
pc2.FaceAlpha=1-app.OverlaySlider_3.Value/100;


filtdepth=dplot;
exportBathymetryPlotProfile(app)

%% Reset
app.Lamp_21.Color=[.5 .5 .5];
