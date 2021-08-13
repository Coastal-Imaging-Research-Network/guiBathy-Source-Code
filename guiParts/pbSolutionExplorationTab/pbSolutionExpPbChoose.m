function pbSolutionExpPbChoose(app)
global pbdir prodir ordir pbPlotTran gdir pc6

%% Load PB File
if strcmp(app.ListBox_30.Value,'-')==0

load(fullfile(pbdir,app.ListBox_30.Value));


%% Get Directory for Ortthos
pbPlotTran.orthoDir=fullfile(ordir,pbMeta.OrthoSet,'Local_grid','images');
L=dir(pbPlotTran.orthoDir);

for k=3:length(L)
    chk=strfind(L(k).name,'timex.png');
    if isempty(chk)==0
        pbPlotTran.tfile=fullfile(pbPlotTran.orthoDir,L(k).name);
    end
    chk=strfind(L(k).name,'bright.png');
    if isempty(chk)==0
        pbPlotTran.bfile=fullfile(pbPlotTran.orthoDir,L(k).name);
    end
    if k==3
        pbPlotTran.sfile=fullfile(pbPlotTran.orthoDir,L(k).name);
    end
end


%% Load Potential Cbathy List (checking for units)
L=dir(prodir);
count=0;
clist={};
for k=3:length(L)
    L2=dir(fullfile(prodir,L(k).name));
    
    for j=1:length(L2)
            chk=strfind(L2(j).name,'cBathyDepthProduct.mat');
            if isempty(chk)==0
               
            load(fullfile(prodir,L(k).name,L2(j).name));
             chk1=strcmp(gridMeta.worldCoordSysUnits,pbMeta.Units);
             chk2=strcmp(gridMeta.worldCoordSysH,pbMeta.worldCoordSysH);
             chk3=strcmp(gridMeta.worldCoordSysV,pbMeta.worldCoordSysV);
             if chk2==1 & chk3==1 & chk1==1
                 count=count+1;
                 clist{count}=L(k).name;
             end 
           end 
    end    
end

app.ListBox_31.Items=clist;


%% Pull out Data
cla(app.UIAxes2_5)
cla(app.UIAxes2_6)
pbPlotTran.pbZ=-pbData.h%+pbMeta.tide;
[pbPlotTran.pbX,  pbPlotTran.pbY]= meshgrid(pbData.x,pbData.y);

%% Load Grid File 
main_d=fullfile(ordir,pbMeta.OrthoSet);
L=dir(main_d);

for k=1:length(L)
    chk=strfind(L(k).name,'.mat');
    if isempty(chk)==0
        load(fullfile(main_d,L(k).name));
    end
end
load(fullfile(gdir,gridFile));
pbPlotTran.X=localX;
pbPlotTran.Y=localY;

%% Set Up Default Profile Value
app.EnterYCoordinatetoPlotCrossshoreprofilebelowEditField_3.Value=min(min(localY));

%% Pull Ortho to Plot
if app.NoneButton.Value==1
    I=flipud(imread(pbPlotTran.sfile)).*0;
end

if app.SnapshotButton.Value==1
    I=flipud(imread(pbPlotTran.sfile));
end

if app.BrightestButton.Value==1
    I=flipud(imread(pbPlotTran.bfile));
end
if app.TimexButton.Value==1
    I=flipud(imread(pbPlotTran.tfile));
end



%% Get Mask
Isum=sum(double(flipud(imread(pbPlotTran.tfile))),3);
msk=pbPlotTran.X.*0+1;
bind=find(Isum<=min(min(Isum)));
msk(bind)=nan;
pbPlotTran.camMsk=msk;

%Interpolate onto pB
pbPlotTran.pbMsk=griddata(pbPlotTran.X(:),pbPlotTran.Y(:),pbPlotTran.camMsk(:),pbPlotTran.pbX,pbPlotTran.pbY);
pbPlotTran.pbMsk=round(pbPlotTran.pbMsk);
pbPlotTran.pbMsk(find(pbPlotTran.pbMsk>1))=1;
pbPlotTran.pbMsk(find(pbPlotTran.pbMsk<=0))=nan;
pbPlotTran.pbZ=pbPlotTran.pbZ.*pbPlotTran.pbMsk;






%% Plot Image (panel 1)

X=pbPlotTran.X;
Y=pbPlotTran.Y;
pbPlotTran.cZ=pbPlotTran.Y.*nan;
pbPlotTran.cY=pbPlotTran.Y;
pbPlotTran.cX=pbPlotTran.X;

hold(app.UIAxes2_5,'on')
axis(app.UIAxes2_5,'equal')


imagesc(X(1,:),Y(:,1),I,'parent',app.UIAxes2_5 )
xlim(app.UIAxes2_5,[min(min(X)) max(max(X))])
ylim(app.UIAxes2_5,[min(min(Y)) max(max(Y))])


% Plot Data
pc6=pcolor(pbPlotTran.pbX,pbPlotTran.pbY,pbPlotTran.pbZ,'parent',app.UIAxes2_5);
cdefault=[-50 1];
shading(app.UIAxes2_5,'flat');
c=colorbar(app.UIAxes2_5,'location','eastOutside');
c.Label.String=['[' pbMeta.Units ']'];
caxis(app.UIAxes2_5,cdefault)




%% Plot Image (panel 2)
hold(app.UIAxes2_6,'on')
axis(app.UIAxes2_6,'equal')


imagesc(X(1,:),Y(:,1),I,'parent',app.UIAxes2_6 )
xlim(app.UIAxes2_6,[min(min(X)) max(max(X))])
ylim(app.UIAxes2_6,[min(min(Y)) max(max(Y))])


%% Set Limits for Sliders
app.DepthSlider_3.Limits=cdefault;
app.DepthSlider_4.Limits=cdefault;

app.DepthSlider_3.Value=cdefault(1);
app.DepthSlider_4.Value=cdefault(2);

app.DepthSlider_5.Limits=cdefault;
app.DepthSlider_6.Limits=cdefault;

app.DepthSlider_5.Value=cdefault(1);
app.DepthSlider_6.Value=cdefault(2);

app.OverlaySlider_4.Value=0;
app.OverlaySlider_5.Value=0;


%% Add Unit Stuff

xlabel(app.UIAxes5_2,['X ' ,' ', '[', pbMeta.Units ']'])
ylabel(app.UIAxes5_2,['Y ' ,' ', '[', pbMeta.Units ']'])
xlabel(app.UIAxes2_5,['X ' ,' ', '[', pbMeta.Units ']'])
ylabel(app.UIAxes2_5,['Y ' ,' ', '[', pbMeta.Units ']'])
xlabel(app.UIAxes2_6,['X ' ,' ', '[', pbMeta.Units ']'])
ylabel(app.UIAxes2_6,['Y ' ,' ', '[', pbMeta.Units ']'])

app.Label_337.Text=['[', pbMeta.Units ']'];
app.Label_339.Text=['[', pbMeta.Units ']'];
app.Label_338.Text=['[', pbMeta.Units ']'];
app.Label_342.Text=['[', pbMeta.Units ']'];
app.Label_341.Text=['[', pbMeta.Units ']'];

pbPlotTran.Units=pbMeta.Units;

%% Clear Out Cbathy Tab
app.ListBox_31.Value={};

% %% Plot Profile
pbSolutionExpPlotProfile(app)
end