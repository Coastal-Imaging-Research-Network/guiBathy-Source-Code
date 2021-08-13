function orthoGenSelectGrid(app)
global  fdir  gdir vedir
%% Load Grid
gname=app.ListBox_12.Value;
load(fullfile(gdir,gname));
ixlim=[min(min(localX)) max(max(localX))];
iylim=[min(min(localY)) max(max(localY))];

%% Load Solution
vename=app.ListBox_14.Value;
load(fullfile(vedir,vename));
%% Load First Image
fname=app.ListBox_13.Value;
L=dir(fullfile(fdir,fname));
I=imread(fullfile(fdir,fname,L(3).name));


%% Rectify and Plot First Image
localExtrinsics = localTransformExtrinsics(localOrigin,localAngle,1,extrinsicsVariable(1,:));
[localIr]= imageRectifier(I,intrinsics,localExtrinsics,localX,localY,localZ+(app.EditField.Value),0);
% Timex Build
imagesc(localX(1,:),localY(:,1),localIr,'parent',app.UIAxes_10);
hold(app.UIAxes_10,'on')
axis(app.UIAxes_10,'equal')
xlim(app.UIAxes_10,ixlim)
ylim(app.UIAxes_10,iylim)
set(app.UIAxes_10,'ydir','normal')

% Brightest Build
imagesc(localX(1,:),localY(:,1),localIr,'parent',app.UIAxes_11);
hold(app.UIAxes_11,'on')
axis(app.UIAxes_11,'equal')
xlim(app.UIAxes_11,ixlim)
ylim(app.UIAxes_11,iylim)
set(app.UIAxes_11,'ydir','normal')

