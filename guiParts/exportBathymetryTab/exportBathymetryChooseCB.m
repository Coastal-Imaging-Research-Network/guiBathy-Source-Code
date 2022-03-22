function exportBathymetryChooseCB(app)
global cbdir  cBathyPlotTran ordir gdir pc1 pc2 filtdepth

%% Load CBAthy Solution
if strcmp(app.ListBox_27.Value,'-')==0

load(fullfile(cbdir,app.ListBox_27.Value));



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
load(fullfile(gdir,gridFile))
cBathyPlotTran.X=localX;
cBathyPlotTran.Y=localY;


%% Set Up Default Profile Location
app.EnterYCoordinatetoPlotCrossshoreprofilebelowEditField_2.Value=min(min(localY));
%% Assign bathy for Transfer
cBathyPlotTran.bathy=bathy;
cBathyPlotTran.stackMeta=stackMeta;
%% Change Output Name
A=strsplit(app.ListBox_27.Value,'.mat');
app.FoldernameEditField.Value=strcat(A{1},'_products');




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



%% Get Mask
X=cBathyPlotTran.X;
Y=cBathyPlotTran.Y;
[cX cY]=meshgrid(bathy.xm,bathy.ym);
cBathyPlotTran.cX=cX;
cBathyPlotTran.cY=cY;

Isum=sum(double(flipud(imread(cBathyPlotTran.tfile))),3);
Vq = interp2(X,Y,Isum,cX,cY);
msk=cBathyPlotTran.bathy.fCombined.h.*0+1;
bind=find(Vq<=min(min(Vq)));
msk(bind)=nan;


% Make Default Error Mask
cBathyPlotTran.errMsk=msk;

%% Plot Images
cla(app.UIAxes2_3)
cla(app.UIAxes2_4)



%% Raw
hold(app.UIAxes2_3,'on')
axis(app.UIAxes2,'equal')


imagesc(X(1,:),Y(:,1),I,'parent',app.UIAxes2_3 )
xlim(app.UIAxes2_3,[min(min(X)) max(max(X))])
ylim(app.UIAxes2_3,[min(min(Y)) max(max(Y))])

% Plot Data
dplot=-(bathy.fCombined.h-bathy.tide.zt);
filtdepth=dplot;

pc1=pcolor(cX,cY,dplot.*msk,'parent',app.UIAxes2_3);
shading(app.UIAxes2_3,'flat');
c1=colorbar(app.UIAxes2_3,'location','eastOutside');
c1.Label.String='Depth';
caxis(app.UIAxes2_3,[-50 0])


%% Filtered
hold(app.UIAxes2_4,'on')
axis(app.UIAxes2,'equal')


imagesc(X(1,:),Y(:,1),I,'parent',app.UIAxes2_4 )
xlim(app.UIAxes2_4,[min(min(X)) max(max(X))])
ylim(app.UIAxes2_4,[min(min(Y)) max(max(Y))])

pc2=pcolor(cX,cY,dplot.*msk,'parent',app.UIAxes2_4);
shading(app.UIAxes2_4,'flat');
c1=colorbar(app.UIAxes2_4,'location','eastOutside');
c1.Label.String='Depth';
caxis(app.UIAxes2_4,[-50 0])



%% Set Up Color bar limits, 
app.UITable10_5.Data{1,1}=[-50];
app.UITable10_5.Data{1,2}=[0];


%% Set Limits and Values For sliders
app.OverlaySlider_3.Value=0;

app.Slider.Limits=[0 10];
app.Slider.Value=0;


app.Slider_2.Limits=[0 300];
app.Slider_2.Value=0;

app.Slider_3.Limits=[0 300];
app.Slider_3.Value=0;

app.MaximumErrorEditField.Value=0;
app.XSmoothingDistanceEditField.Value=0;
app.YSmoothingDistanceEditField.Value=0;



%% Label Units
xlabel(app.UIAxes2_3,['X ' ,' ', '[', stackMeta.Units ']'])
 ylabel(app.UIAxes2_3,['Y ' ,' ', '[', stackMeta.Units ']'])
xlabel(app.UIAxes2_4,['X ' ,' ', '[', stackMeta.Units ']'])
 ylabel(app.UIAxes2_4,['Y ' ,' ', '[', stackMeta.Units ']']) 
xlabel(app.UIAxes6,['X ' ,' ', '[', stackMeta.Units ']'])
ylabel(app.UIAxes6,['Z ' ,' ', '[', stackMeta.Units ']'])


app.Label_332.Text=['[', stackMeta.Units ']'];
app.Label_331.Text=['[', stackMeta.Units ']'];
app.Label_330.Text=['[', stackMeta.Units ']'];
app.Label_325.Text=['[', stackMeta.Units ']'];
app.Label_328.Text=['[', stackMeta.Units ']'];
app.Label_327.Text=['[', stackMeta.Units ']'];
app.Label_329.Text=['[', stackMeta.Units ']'];


app.UITable10_5.ColumnName{1}=[ 'Max ' ' ' '[' stackMeta.Units ']'];
app.UITable10_5.ColumnName{2}=[ 'Min ' ' ' '[' stackMeta.Units ']'];


%% Reset
app.Lamp_21.Color=[.5 .5 .5];

end