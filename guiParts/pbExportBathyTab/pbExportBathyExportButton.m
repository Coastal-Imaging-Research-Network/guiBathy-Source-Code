function pbExportBathyExportButton(app)
global pbExporTran  prodir ordir gdir


%% Make Folder
mkdir(fullfile(prodir,app.FoldernameEditField_2.Value))

%% Transform to Real World Grid
main_d=fullfile(ordir,pbExporTran.pbMeta.OrthoSet);
L=dir(main_d);

for k=1:length(L)
    chk=strfind(L(k).name,'.mat');
    if isempty(chk)==0
        load(fullfile(main_d,L(k).name));
    end
end
load(fullfile(gdir,gridFile))


%% If No Blending Occured- assign to just pb tool
pbflag=0;
if isempty(pbExporTran.pbBlend)==1
    pbflag=1; % to clear it out for plotting purposes later
% Get Mask

Zout=interp2(pbExporTran.pbX,pbExporTran.pbY,-pbExporTran.pbData.h,pbExporTran.X,pbExporTran.Y);
%% Get Mask
Isum=sum(double(flipud(imread(pbExporTran.tfile))),3);
msk=Zout.*0+1;
bind=find(Isum<=min(min(Isum)));
msk(bind)=nan;
pbExporTran.pbBlend=Zout.*msk;  
end



%% Interpolate onto Grid
% Make absolute Depth
pbExporTran.pbBlend=pbExporTran.pbBlend+nanmean(nanmean(Z));
[ Xout Yout]= localTransformPoints(localOrigin,localAngle,0,pbExporTran.X,pbExporTran.Y);
Depth=griddata(Xout(:),Yout(:),pbExporTran.pbBlend(:),X,Y);
localDepth=pbExporTran.pbBlend;
%% Pull Important Meta Data
gridMeta.gridFile=gridFile;
gridMeta.localAngle=localAngle;
gridMeta.localOrigin=localOrigin;
gridMeta.worldCoordSysH=worldCoordSysH;
gridMeta.worldCoordSysV=worldCoordSysV;
gridMeta.worldCoordSysUnits=worldCoordSysUnits;
gridMeta.mwlElevation=nanmean(nanmean(Z));

pbMeta=pbExporTran.pbMeta;

depthMeta.PBWeight=app.PBToolEditField.Value;
depthMeta.FiltXsmoothDist=app.XSmoothingDistanceEditField_3.Value;
depthMeta.FiltYsmoothDist=app.YSmoothingDistanceEditField_3.Value;
depthMeta.FiltcBathyErrorThreshold=app.cBathyEditField.Value;


if isempty(app.ListBox_33.Value)==0
cbathyMeta=pbExporTran.cbathyMeta;
else
   cbathyMeta='No cBathy Blend';
end

%% Export MatFiles
mwlElevation=nanmean(nanmean(Z));
Z=Z+tide;
localZ=localZ+tide;

t=t(1);
tide=tide;
save(fullfile(prodir,app.FoldernameEditField_2.Value,'PBToolCombinedDepthProduct'), 'X','Y','Z','localZ','localY','localX','localDepth','Depth','t','tide','mwlElevation','gridMeta','depthMeta','cbathyMeta','pbMeta');


%% Export XYZ Files
% Local
Fl=fopen(fullfile(prodir,app.FoldernameEditField_2.Value,'PBToolCombinedDepthProductLocal.xyz'),'w');
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

gind=find(isnan(localDepth)==0);
A=[localX(gind)'; localY(gind)'; (localDepth(gind))'];

fprintf(Fl,'%f %f %f\r\n',A);
fclose(Fl);



% World
Fl=fopen(fullfile(prodir,app.FoldernameEditField_2.Value,'PBToolCombinedDepthProductGeo.xyz'),'w');
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

gind=find(isnan(Depth)==0);
A=[X(gind)'; Y(gind)'; (Depth(gind)'+mwlElevation)];

fprintf(Fl,'%f %f %f\r\n',A);
fclose(Fl);


%% Get World Directory for Ortthos
pbExporTran.orthoDir=fullfile(ordir,pbExporTran.pbMeta.OrthoSet,'Geo_grid','images');
L=dir(pbExporTran.orthoDir);

for k=3:length(L)
    chk=strfind(L(k).name,'timex.png');
    if isempty(chk)==0
        pbExporTran.wtfile=fullfile(pbExporTran.orthoDir,L(k).name);
    end
    chk=strfind(L(k).name,'bright.png');
    if isempty(chk)==0
        pbExporTran.wbfile=fullfile(pbExporTran.orthoDir,L(k).name);
    end
    if k==3
        pbExporTran.wsfile=fullfile(pbExporTran.orthoDir,L(k).name);
    end
end

%% Pull Ortho to Plot
if app.NoneButton_5.Value==1
    I=flipud(imread(pbExporTran.wsfile)).*0+1;
end

if app.SnapshotButton_5.Value==1
    I=flipud(imread(pbExporTran.wsfile));
end

if app.BrightestButton_5.Value==1
    I=flipud(imread(pbExporTran.wbfile));
end
if app.TimexButton_5.Value==1
    I=flipud(imread(pbExporTran.wtfile));
end

%% Pull Ortho to Plot
if app.NoneButton_5.Value==1
    Il=flipud(imread(pbExporTran.sfile)).*0+1;
end

if app.SnapshotButton_5.Value==1
    Il=flipud(imread(pbExporTran.sfile));
end

if app.BrightestButton_5.Value==1
    Il=flipud(imread(pbExporTran.bfile));
end
if app.TimexButton_5.Value==1
    Il=flipud(imread(pbExporTran.tfile));
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
caxis([app.UITable10_6.Data{1,1},app.UITable10_6.Data{1,2}])
pc3.FaceAlpha=1-app.OverlaySlider_6.Value/100;
xlabel(['E' '[' worldCoordSysUnits ']'])
ylabel( ['N' '[' worldCoordSysUnits ']'])
title(datestr(t))
F=getframe(f1);
    imwrite(F.cdata,fullfile(prodir,app.FoldernameEditField_2.Value,'PBToolCombinedDepthProductGeoPlot.png'));
    set(0,'DefaultFigureVisible','on')

set(f1,'visible','on')
saveas(f1, fullfile(prodir,app.FoldernameEditField_2.Value,'PBToolCombinedDepthProductGeoPlot.fig'));
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
caxis([app.UITable10_6.Data{1,1},app.UITable10_6.Data{1,2}])
pc3.FaceAlpha=1-app.OverlaySlider_6.Value/100;
xlabel(['X' '[' worldCoordSysUnits ']'])
ylabel( ['Y' '[' worldCoordSysUnits ']'])
title(datestr(t))
F=getframe(f1);
    imwrite(F.cdata,fullfile(prodir,app.FoldernameEditField_2.Value,'PBToolCombinedDepthProductLocalPlot.png'));
    set(0,'DefaultFigureVisible','on')
set(f1,'visible','on')
saveas(f1, fullfile(prodir,app.FoldernameEditField_2.Value,'PBToolCombinedDepthProductLocalPlot.fig'));
close(f1)

%% Change Status Lamp
app.Lamp_27.Color=[0 1 0];

%% Clear Out pbBlend for plotting
if pbflag==1
    pbExporTran.pbBlend=[];
end