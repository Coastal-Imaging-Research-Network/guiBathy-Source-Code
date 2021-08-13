function pbExportBathyPBChoose(app)

global pbdir cbdir ordir pbExporTran gdir pc8 pc10



%% Reset Lamp
app.Lamp_27.Color=[.5 .5 .5];
app.Lamp_29.Color=[.5 .5 .5];

if strcmp(app.ListBox_32.Value,'-')==0

%% Load PB File
load(fullfile(pbdir,app.ListBox_32.Value));
pbExporTran.pbMeta=pbMeta;
pbExporTran.cbathyMeta=[];

%% Give Defaults for Values
app.cBathyEditField.Value=10;
app.XSmoothingDistanceEditField_3.Value=3*pbData.xres;
app.YSmoothingDistanceEditField_3.Value=3*pbData.yres;



%% Get Directory for Ortthos
pbExporTran.orthoDir=fullfile(ordir,pbMeta.OrthoSet,'Local_grid','images');
L=dir(pbExporTran.orthoDir);

for k=3:length(L)
    chk=strfind(L(k).name,'timex.png');
    if isempty(chk)==0
        pbExporTran.tfile=fullfile(pbExporTran.orthoDir,L(k).name);
    end
    chk=strfind(L(k).name,'bright.png');
    if isempty(chk)==0
        pbExporTran.bfile=fullfile(pbExporTran.orthoDir,L(k).name);
    end
    if k==3
        pbExporTran.sfile=fullfile(pbExporTran.orthoDir,L(k).name);
    end
end

%% Load Potential Cbathy List (checking for units)
L=dir(cbdir);
count=0;
clist={};
for k=3:length(L)
    
    load(fullfile(cbdir,L(k).name));
    chk1=strcmp(stackMeta.Units,pbMeta.Units);
    chk2=strcmp(stackMeta.worldCoordSysH,pbMeta.worldCoordSysH);
    chk3=strcmp(stackMeta.worldCoordSysV,pbMeta.worldCoordSysV);
    
    if chk2==1 & chk3==1 & chk1==1
        count=count+1;
        clist{count}=L(k).name;
    end
end
    


app.ListBox_33.Items=clist;




%% Pull out Data
cla(app.UIAxes2_10)
cla(app.UIAxes2_9)
cla(app.UIAxes2_8)
cla(app.UIAxes2_8)
cla(app.UIAxes6_2)

pbExporTran.pbZ=-pbData.h;%+ pbMeta.tide;
[pbExporTran.pbX,  pbExporTran.pbY]= meshgrid(pbData.x,pbData.y);
 pbExporTran.pbData=pbData;
pbExporTran.pbMeta=pbMeta;
%% Load Camera Grid File 
main_d=fullfile(ordir,pbMeta.OrthoSet);
L=dir(main_d);

for k=1:length(L)
    chk=strfind(L(k).name,'.mat');
    if isempty(chk)==0
        load(fullfile(main_d,L(k).name));
    end
end
load(fullfile(gdir,gridFile));
pbExporTran.X=localX;
pbExporTran.Y=localY;


% %% Interopate PB Data onto Ortho Grid
% pbExporTran.pbZi=interp2(pbExporTran.pbX,pbExporTran.pbY,pbExporTran.pbZ,pbExporTran.X,pbExporTran.Y);
% pbExporTran.Zout=pbExporTran.pbZi;

%% Get Mask
Isum=sum(double(flipud(imread(pbExporTran.tfile))),3);
msk=pbExporTran.X.*0+1;
bind=find(Isum<=min(min(Isum)));
msk(bind)=nan;
pbExporTran.camMsk=msk;

%Interpolate onto pB
pbExporTran.pbMsk=griddata(pbExporTran.X(:),pbExporTran.Y(:),pbExporTran.camMsk(:),pbExporTran.pbX,pbExporTran.pbY);
pbExporTran.pbMsk=round(pbExporTran.pbMsk);
pbExporTran.pbMsk(find(pbExporTran.pbMsk>1))=1;
pbExporTran.pbMsk(find(pbExporTran.pbMsk<=0))=nan;
pbExporTran.pbZ=pbExporTran.pbZ.*pbExporTran.pbMsk;




%% Initiate cBathy Variables
pbExporTran.cZ=[];
pbExporTran.cX=[];
pbExporTran.cY=[];

pbExporTran.pbBlend=[];
%% Set Up Default Profile Value
app.EnterYCoordinatetoPlotCrossshoreprofilebelowEditField_4.Value=min(min(localY));


%% Pull Ortho to Plot
if app.NoneButton.Value==1
    I=flipud(imread(pbExporTran.sfile)).*0;
end

if app.SnapshotButton.Value==1
    I=flipud(imread(pbExporTran.sfile));
end

if app.BrightestButton.Value==1
    I=flipud(imread(pbExporTran.bfile));
end
if app.TimexButton.Value==1
    I=flipud(imread(pbExporTran.tfile));
end

%% Plot Image (panel 1)

X=pbExporTran.X;
Y=pbExporTran.Y;
hold(app.UIAxes2_10,'on')
axis(app.UIAxes2_10,'equal')
imagesc(X(1,:),Y(:,1),I,'parent',app.UIAxes2_10 )
xlim(app.UIAxes2_10,[min(min(X)) max(max(X))])
ylim(app.UIAxes2_10,[min(min(Y)) max(max(Y))])


% Plot Data
pc10=pcolor(pbExporTran.pbX,pbExporTran.pbY,pbExporTran.pbZ,'parent',app.UIAxes2_10);
cdefault=[-50 1];
shading(app.UIAxes2_10,'flat');
c=colorbar(app.UIAxes2_10,'location','south');
c.Label.String=['[' pbMeta.Units ']'];
caxis(app.UIAxes2_10,cdefault)
c.Color='y';

%% Plot Image (panel 2)
hold(app.UIAxes2_9,'on')
axis(app.UIAxes2_9,'equal')


imagesc(X(1,:),Y(:,1),I,'parent',app.UIAxes2_9 )
xlim(app.UIAxes2_9,[min(min(X)) max(max(X))])
ylim(app.UIAxes2_9,[min(min(Y)) max(max(Y))])
% pc9=pcolor(pbExporTran.X,pbExporTran.Y,pbExporTran.cZ,'parent',app.UIAxes2_9);

c=colorbar(app.UIAxes2_9,'location','south');
c.Label.String=['[' pbMeta.Units ']'];
caxis(app.UIAxes2_9,cdefault)
c.Color='y';

%% Plot Image Panel 3
hold(app.UIAxes2_8,'on')
axis(app.UIAxes2_8,'equal')

imagesc(X(1,:),Y(:,1),I,'parent',app.UIAxes2_8 )
xlim(app.UIAxes2_8,[min(min(X)) max(max(X))])
ylim(app.UIAxes2_8,[min(min(Y)) max(max(Y))])


% Plot Data
 pc8=pcolor(pbExporTran.X,pbExporTran.Y,localZ.*nan,'parent',app.UIAxes2_8);
cdefault=[-50 1];
shading(app.UIAxes2_8,'flat');
c=colorbar(app.UIAxes2_8,'location','south');
c.Label.String=['[' pbMeta.Units ']'];
caxis(app.UIAxes2_8,cdefault)
c.Color='y';

%% Set Limits for Sliders

% Weighing
app.PBToolEditField.Value=100;

% Overlay Transparance
app.OverlaySlider_6.Value=0;

% Depth Limits
app.UITable10_6.Data{1,1}=cdefault(1);
app.UITable10_6.Data{1,2}=cdefault(2);

%% Add Unit Stuff

xlabel(app.UIAxes2_10,['X ' ,' ', '[', pbMeta.Units ']'])
ylabel(app.UIAxes2_10,['Y ' ,' ', '[', pbMeta.Units ']'])
xlabel(app.UIAxes2_9,['X ' ,' ', '[', pbMeta.Units ']'])
ylabel(app.UIAxes2_9,['Y ' ,' ', '[', pbMeta.Units ']'])
xlabel(app.UIAxes2_8,['X ' ,' ', '[', pbMeta.Units ']'])
ylabel(app.UIAxes2_8,['Y ' ,' ', '[', pbMeta.Units ']'])

xlabel(app.UIAxes6_2,['X ' ,' ', '[', pbMeta.Units ']'])
ylabel(app.UIAxes6_2,['Z ' ,' ', '[', pbMeta.Units ']'])


app.Label_351.Text=['[', pbMeta.Units ']'];
app.Label_350.Text=['[', pbMeta.Units ']'];
app.Label_346.Text=['[', pbMeta.Units ']'];
app.Label_364.Text=['[', pbMeta.Units ']'];

app.UITable10_6.ColumnName{1}=['Max ' ' ' '[' pbMeta.Units ']'];
app.UITable10_6.ColumnName{2}=['Min ' ' ' '[' pbMeta.Units ']'];

%% Clear Out Cbathy Tab
app.ListBox_33.Value={};

%% Export Name
A=strsplit(app.ListBox_32.Value,'.mat');
app.FoldernameEditField_2.Value=strcat(A{1},'_products');

%% Reset Image Button
app.NoneButton_5.Value=1;

end
