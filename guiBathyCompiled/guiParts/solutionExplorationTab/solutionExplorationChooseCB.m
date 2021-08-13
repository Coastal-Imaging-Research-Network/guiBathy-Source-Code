function solutionExplorationChooseCB(app)
global cbdir  cBathyPlotTran ordir  gdir pc1 pc2

%% Load CBAthy Solution
if strcmp(app.ListBox_24.Value,'-')==0

load(fullfile(cbdir,app.ListBox_24.Value));



%% Get Directory for Ortthos
cBathyPlotTran.orthoDir=fullfile(ordir,stackMeta.Orthoset,'Local_grid','images');
L=dir(cBathyPlotTran.orthoDir);

for k=3:length(L)
    chk=strfind(L(k).name,'timex.png');
    if isempty(chk)==0
        cBathyPlotTran.tfile=fullfile(cBathyPlotTran.orthoDir,L(k).name);
    end
    chk=strfind(L(k).name,'bright.png');
    if isempty(chk)==0
        cBathyPlotTran.bfile=fullfile(cBathyPlotTran.orthoDir,L(k).name);
    end
    if k==3
        cBathyPlotTran.sfile=fullfile(cBathyPlotTran.orthoDir,L(k).name);
    end
end



%% Load Grid File 
main_d=fullfile(ordir,stackMeta.Orthoset);
L=dir(main_d);

for k=1:length(L)
    chk=strfind(L(k).name,'.mat');
    if isempty(chk)==0
        load(fullfile(main_d,L(k).name));
    end
end
load(fullfile(gdir,gridFile));
cBathyPlotTran.X=localX;
cBathyPlotTran.Y=localY;

%% Assign Initial Profile Value
app.EnterYCoordinatetoPlotCrossshoreprofilebelowEditField.Value=min(min(localY));


%% Assign bathy for Transfer
cBathyPlotTran.bathy=bathy;


%% Pull Data To Plot For Depth
% Combined Estimated Depth
    cla(app.UIAxes5)

    cla(app.UIAxes2)
    dplot=-(bathy.fCombined.h-bathy.tide.zt);
    units=['[' stackMeta.Units ']'];
    cdefault=[-50 1];
    
%% Pull Ortho to Plot
if app.NoneButton.Value==1
    I=flipud(imread(cBathyPlotTran.sfile)).*0;
end

if app.SnapshotButton.Value==1
    I=flipud(imread(cBathyPlotTran.sfile));
end

if app.BrightestButton.Value==1
    I=flipud(imread(cBathyPlotTran.bfile));
end
if app.TimexButton.Value==1
    I=flipud(imread(cBathyPlotTran.tfile));
end

%% Plot Image

X=cBathyPlotTran.X;
Y=cBathyPlotTran.Y;
hold(app.UIAxes2,'on')
axis(app.UIAxes2,'equal')


imagesc(X(1,:),Y(:,1),I,'parent',app.UIAxes2 )
xlim(app.UIAxes2,[min(min(X)) max(max(X))])
ylim(app.UIAxes2,[min(min(Y)) max(max(Y))])

% Plot Data
[cX cY]=meshgrid(bathy.xm,bathy.ym);
pc1=pcolor(cX,cY,dplot,'parent',app.UIAxes2);
shading(app.UIAxes2,'flat');
c=colorbar(app.UIAxes2,'location','eastOutside');
c.Label.String=units;
caxis(app.UIAxes2,cdefault)


%% Set Limits for Sliders
app.DepthSlider.Limits=cdefault;
app.DepthSlider_2.Limits=cdefault;
app.DepthSlider.Value=cdefault(1);
app.DepthSlider_2.Value=cdefault(2);
app.OverlaySlider.Value=0;






%% Pull Data To Plot For Depth Error
% Combined Estimated Depth
    cla(app.UIAxes2_2)
    dplot=bathy.fCombined.hErr;
    units=['[' stackMeta.Units ']'];
    cdefault=[0 10];
    

%% Plot Image

X=cBathyPlotTran.X;
Y=cBathyPlotTran.Y;
hold(app.UIAxes2_2,'on')
axis(app.UIAxes2_2,'equal')


imagesc(X(1,:),Y(:,1),I,'parent',app.UIAxes2_2 )
xlim(app.UIAxes2_2,[min(min(X)) max(max(X))])
ylim(app.UIAxes2_2,[min(min(Y)) max(max(Y))])

% Plot Data
[cX cY]=meshgrid(bathy.xm,bathy.ym);
pc2=pcolor(cX,cY,dplot,'parent',app.UIAxes2_2);
shading(app.UIAxes2_2,'flat');
c=colorbar(app.UIAxes2_2,'location','eastOutside');
c.Label.String=units;
caxis(app.UIAxes2_2,cdefault)


%% Set Limits for Sliders
app.ErrorSlider.Limits=cdefault;
app.ErrorSlider_2.Limits=cdefault;
app.ErrorSlider.Value=cdefault(1);
app.ErrorSlider_2.Value=cdefault(2);
app.OverlaySlider_2.Value=0;


%% Add Unit Stuff

xlabel(app.UIAxes5,['X ' ,' ', '[', stackMeta.Units ']'])
ylabel(app.UIAxes5,['Z ' ,' ', '[', stackMeta.Units ']'])
xlabel(app.UIAxes2,['X ' ,' ', '[', stackMeta.Units ']'])
ylabel(app.UIAxes2,['Y ' ,' ', '[', stackMeta.Units ']'])
xlabel(app.UIAxes2_2,['X ' ,' ', '[', stackMeta.Units ']'])
ylabel(app.UIAxes2_2,['Y ' ,' ', '[', stackMeta.Units ']'])

app.Label_318.Text=['[', stackMeta.Units ']'];
app.Label_319.Text=['[', stackMeta.Units ']'];
app.Label_321.Text=['[', stackMeta.Units ']'];
app.Label_322.Text=['[', stackMeta.Units ']'];
app.Label_324.Text=['[', stackMeta.Units ']'];
end