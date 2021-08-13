function replotGridOrtho(app)
cla(app.UIAxes)
cla(app.UIAxes_9)


%% Pull Relevent Values
global  vedir fdir gridToTransfer

%% Load Solution
vsol=app.ListBox_11.Value;
load(fullfile(vedir,vsol));


%% Load First Image
fname=app.ListBox_10.Value;

L=dir(fullfile(fdir,fname));
I=imread(fullfile(fdir,fname,L(3).name));


%% Get Grid Parameters
localAngle=(app.RotationSlider.Value);
localOrigin=[(app.UITable10.Data{1,1}) (app.UITable10.Data{1,2});];
idxdy=(app.ResolutionSlider.Value);
ixlim=[(app.UITable10_2.Data{1,1}) (app.UITable10_2.Data{1,2})];
iylim=[(app.UITable10_2.Data{2,1}) (app.UITable10_2.Data{2,2})];
iz=str2num(app.MWLElevationEditField.Value);


%% Create Grid
[iX iY]=meshgrid([ixlim(1):idxdy:ixlim(2)],[iylim(1):idxdy:iylim(2)]);
%  Make Elevation Input Grid
iZ=iX*0+iz;

% Assign local Grid as Input Grid
        localX=iX;
        localY=iY;
        localZ=iZ;
        
        % Assign world Grid as Rotated local Grid
        [ X Y]=localTransformEquiGrid(localOrigin,localAngle,0,iX,iY);
        Z=X*.0+iz;   
        
        
% World Rectification
[Ir]= imageRectifier(I,intrinsics,extrinsicsVariable(1,:),X,Y,Z,0);

% Make Local Extrinsics
localExtrinsics = localTransformExtrinsics(localOrigin,localAngle,1,extrinsicsVariable(1,:));

% Local Rectification 
[localIr]= imageRectifier(I,intrinsics,localExtrinsics,localX,localY,localZ,0);



%% Plot Images
% Geographical
imagesc(X(1,:),Y(:,1),Ir,'parent',app.UIAxes);
hold(app.UIAxes,'on')
axis(app.UIAxes,'equal')
xlim(app.UIAxes,[min(min(X)) max(max(X))])
ylim(app.UIAxes,[min(min(Y)) max(max(Y))])
set(app.UIAxes,'ydir','normal')

% Local
imagesc(localX(1,:),localY(:,1),localIr,'parent',app.UIAxes_9);
hold(app.UIAxes_9,'on')
axis(app.UIAxes_9,'equal')
xlim(app.UIAxes_9,ixlim)
ylim(app.UIAxes_9,iylim)
set(app.UIAxes_9,'ydir','normal')

%% Plot Local Axes
L=abs(diff(ixlim)).*.5;

xa=[ 0 L];
ya=[0 0];
[ Xout Yout]= localTransformPoints(localOrigin,localAngle,0,xa,ya);
plot(Xout,Yout,'parent',app.UIAxes,'color','m','linewidth',3)
text(Xout(2),Yout(2),'X','parent',app.UIAxes,'color','m','fontweight','bold','Fontsize',18)
xa=[ 0 0];
ya=[0 L];
[ Xout Yout]= localTransformPoints(localOrigin,localAngle,0,xa,ya);
plot(Xout,Yout,'parent',app.UIAxes,'color','m','linewidth',3)
text(Xout(2),Yout(2),'Y','parent',app.UIAxes,'color','m','fontweight','bold','Fontsize',18)



%% Units
xlabel(app.UIAxes,['E ',' ', '[', initialCamSolutionMeta.worldCoordSysUnits,']'])
ylabel(app.UIAxes,['N ',' ','[', initialCamSolutionMeta.worldCoordSysUnits,']'])
xlabel(app.UIAxes_9,['E ',' ','[', initialCamSolutionMeta.worldCoordSysUnits,']'])
ylabel(app.UIAxes_9,['N ',' ','[', initialCamSolutionMeta.worldCoordSysUnits,']'])

%% Save
gridToTransfer.X=X;
gridToTransfer.Y=Y;
gridToTransfer.Z=Z;
gridToTransfer.localAngle=localAngle;
gridToTransfer.localOrigin=localOrigin;
gridToTransfer.localX=localX;
gridToTransfer.localY=localY;
gridToTransfer.localZ=localZ;
gridToTransfer.worldCoordSysH=initialCamSolutionMeta.worldCoordSysH;
gridToTransfer.worldCoordSysV=initialCamSolutionMeta.worldCoordSysV;
gridToTransfer.worldCoordSysUnits=initialCamSolutionMeta.worldCoordSysUnits;

%% Change Lamp
app.Lamp_14.Color=[.5 .5 .5];