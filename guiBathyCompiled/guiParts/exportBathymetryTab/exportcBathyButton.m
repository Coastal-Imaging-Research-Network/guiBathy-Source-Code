function exportcBathyButton(app)
global cBathyPlotTran filtdepth prodir ordir gdir

%% Make Folder
mkdir(fullfile(prodir,app.FoldernameEditField.Value))


%% Transform to Real World Grid
%% Load Grid File 
main_d=fullfile(ordir,cBathyPlotTran.stackMeta.Orthoset);
L=dir(main_d);

for k=1:length(L)
    chk=strfind(L(k).name,'.mat');
    if isempty(chk)==0
        load(fullfile(main_d,L(k).name));
    end
end
load(fullfile(gdir,gridFile))


%% Interpolate onto Grid

% Make filt depth relative to Absolute elvation, not mwl
filtdepth=filtdepth+nanmean(nanmean(Z));

localDepth=interp2(cBathyPlotTran.cX,cBathyPlotTran.cY,filtdepth,localX,localY);
localErrMsk=interp2(cBathyPlotTran.cX,cBathyPlotTran.cY,cBathyPlotTran.errMsk,localX,localY);

[ Xout Yout]= localTransformPoints(localOrigin,localAngle,0,cBathyPlotTran.cX,cBathyPlotTran.cY);
Depth=griddata(Xout(:),Yout(:),filtdepth(:),X,Y);
ErrMsk=griddata(Xout(:),Yout(:),cBathyPlotTran.errMsk(:),X,Y);


localErrMsk=round(localErrMsk);
ErrMsk=round(ErrMsk);

ErrMsk(find(ErrMsk>1))=1;
ErrMsk(find(ErrMsk<=0))=nan;
localErrMsk(find(localErrMsk>1))=1;
localErrMsk(find(localErrMsk<=0))=nan;

%% Pull Important Meta Data
gridMeta.gridFile=gridFile;
gridMeta.localAngle=localAngle;
gridMeta.localOrigin=localOrigin;
gridMeta.worldCoordSysH=worldCoordSysH;
gridMeta.worldCoordSysV=worldCoordSysV;
gridMeta.worldCoordSysUnits=worldCoordSysUnits;
gridMeta.mwlElevation=nanmean(nanmean(Z));

cbathyMeta.params=cBathyPlotTran.bathy.params;
cbathyMeta.cbathyFile=app.ListBox_27.Value;
depthMeta.FiltMaxError=app.MaximumErrorEditField.Value;
depthMeta.FiltXsmoothDist=app.XSmoothingDistanceEditField.Value;
depthMeta.FiltYsmoothDist=app.YSmoothingDistanceEditField.Value;

cbathyMeta.stackMeta=cBathyPlotTran.stackMeta;


%% Export MatFiles
mwlElevation=nanmean(nanmean(Z));
t=cBathyPlotTran.bathy.epoch(1)/24/3600+datenum(1970,1,1);
tide=cBathyPlotTran.bathy.tide.zt;
% Change so Z is actually ortho elevations. 
Z=Z+tide;
localZ=localZ+tide;
save(fullfile(prodir,app.FoldernameEditField.Value,'cBathyDepthProduct'), 'X','Y','Z','localZ','localY','localX','localDepth','Depth','t','tide','mwlElevation','gridMeta','depthMeta','cbathyMeta','ErrMsk','localErrMsk');


%% Export XYZ Files
% Local
Fl=fopen(fullfile(prodir,app.FoldernameEditField.Value,'cBathyDepthProductLocal.xyz'),'w');
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Project Name:', app.NewProjectLabel.Text));
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Product Folder:', app.FoldernameEditField.Value));
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Collection Time:', datestr(t)));
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Vertical Datum:', worldCoordSysV));
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Horizontal Datum:', worldCoordSysH));
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Units:', worldCoordSysUnits));
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Local Grid Angle: (+ CW Deg From East)', num2str(localAngle)));
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Local Grid Origin E:', num2str(localOrigin(1))));
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Local Grid Origin N:', num2str(localOrigin(2))));

fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'MWL Elevation:', num2str(mwlElevation)));
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Tide:', num2str(tide)));

%Only Output Good Points
gind=find(isnan(localDepth)==0);
A=[localX(gind)'; localY(gind)'; (localDepth(gind)')];

fprintf(Fl,'%f %f %f\r\n',A);
fclose(Fl);
% World
Fl=fopen(fullfile(prodir,app.FoldernameEditField.Value,'cBathyDepthProductGeo.xyz'),'w');
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Project Name:', app.NewProjectLabel.Text));
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Product Folder:', app.FoldernameEditField.Value));
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Collection Time:', datestr(t)));
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Vertical Datum:', worldCoordSysV));
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Horizontal Datum:', worldCoordSysH));
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Units:', worldCoordSysUnits));
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Local Grid Angle: (+ CW Deg From East)', num2str(localAngle)));
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Local Grid Origin E:', num2str(localOrigin(1))));
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Local Grid Origin N:', num2str(localOrigin(2))));

fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'MWL Elevation:', num2str(mwlElevation)));
fprintf(Fl,'%s\r\n',strcat('# ' ,' ', 'Tide:', num2str(tide)));

%Only Output Good Points
gind=find(isnan(Depth)==0);
A=[X(gind)'; Y(gind)'; (Depth(gind)'+mwlElevation+tide)];
fprintf(Fl,'%f %f %f\r\n',A);
fclose(Fl);

%% Export Image Plot


%% Get World Directory for Ortthos
cBathyPlotTran.orthoDir=fullfile(ordir,cBathyPlotTran.stackMeta.Orthoset,'Geo_grid','images');
L=dir(cBathyPlotTran.orthoDir);

for k=3:length(L)
    chk=strfind(L(k).name,'timex.png');
    if isempty(chk)==0
        cBathyPlotTran.wtfile=fullfile(cBathyPlotTran.orthoDir,L(k).name);
    end
    chk=strfind(L(k).name,'bright.png');
    if isempty(chk)==0
        cBathyPlotTran.wbfile=fullfile(cBathyPlotTran.orthoDir,L(k).name);
    end
    if k==3
        cBathyPlotTran.wsfile=fullfile(cBathyPlotTran.orthoDir,L(k).name);
    end
end







%% Pull Ortho to Plot
if app.NoneButton_3.Value==1
    I=flipud(imread(cBathyPlotTran.wsfile)).*0+1;
end

if app.SnapshotButton_3.Value==1
    I=flipud(imread(cBathyPlotTran.wsfile));
end

if app.BrightestButton_3.Value==1
    I=flipud(imread(cBathyPlotTran.wbfile));
end
if app.TimexButton_3.Value==1
    I=flipud(imread(cBathyPlotTran.wtfile));
end

%% Pull Ortho to Plot
if app.NoneButton_3.Value==1
    Il=flipud(imread(cBathyPlotTran.sfile)).*0+1;
end

if app.SnapshotButton_3.Value==1
    Il=flipud(imread(cBathyPlotTran.sfile));
end

if app.BrightestButton_3.Value==1
    Il=flipud(imread(cBathyPlotTran.bfile));
end
if app.TimexButton_3.Value==1
    Il=flipud(imread(cBathyPlotTran.tfile));
end

%% Plot Data
    set(0,'DefaultFigureVisible','off')
f1=figure;
hold on
axis equal
xlim([min(min(X)) max(max(X))])
ylim([min(min(Y)) max(max(Y))])
imagesc(X(1,:),Y(:,1),I )
pc3=pcolor(X,Y,Depth);
shading flat
c1=colorbar('location','eastOutside');
c1.Label.String=['[' worldCoordSysV '-' worldCoordSysUnits ']'];
caxis([app.UITable10_5.Data{1,1},app.UITable10_5.Data{1,2}])
pc3.FaceAlpha=1-app.OverlaySlider_3.Value/100;
xlabel(['E' '[' worldCoordSysUnits ']'])
ylabel( ['N' '[' worldCoordSysUnits ']'])
title(datestr(t))
F=getframe(f1);
    imwrite(F.cdata,fullfile(prodir,app.FoldernameEditField.Value,'cBathyDepthProductGeoPlot.png'));
    set(0,'DefaultFigureVisible','on')

set(f1,'visible','on')
saveas(f1, fullfile(prodir,app.FoldernameEditField.Value,'cBathyDepthProductGeoPlot.fig'));
close(f1)

%% Plot Data
    set(0,'DefaultFigureVisible','off')
f1=figure;
hold on
axis equal
xlim([min(min(localX)) max(max(localX))])
ylim([min(min(localY)) max(max(localY))])
imagesc(localX(1,:),localY(:,1),Il )
pc3=pcolor(localX,localY,localDepth);
shading flat
c1=colorbar('location','eastOutside');
c1.Label.String=['[' worldCoordSysV '-' worldCoordSysUnits ']'];
caxis([app.UITable10_5.Data{1,1},app.UITable10_5.Data{1,2}])
pc3.FaceAlpha=1-app.OverlaySlider_3.Value/100;
xlabel(['X' '[' worldCoordSysUnits ']'])
ylabel( ['Y' '[' worldCoordSysUnits ']'])
title(datestr(t))
F=getframe(f1);
    imwrite(F.cdata,fullfile(prodir,app.FoldernameEditField.Value,'cBathyDepthProductLocalPlot.png'));
    set(0,'DefaultFigureVisible','on')
set(f1,'visible','on')
saveas(f1, fullfile(prodir,app.FoldernameEditField.Value,'cBathyDepthProductLocalPlot.fig'));
close(f1)


%% Change Status Lamp
app.Lamp_21.Color=[0 1 0];
