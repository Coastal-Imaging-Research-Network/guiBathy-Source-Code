function gridGenerationSolutionChoose(app)
global  vedir  o_origin

%% Load Solution
vsol=app.ListBox_11.Value;

%% Load Mat File UvD
load(fullfile(vedir,vsol));



%% Determine Default Grid Parameters

%% Rotation angle
% Set X axis to be alinged with azimuth of camera

ang=90-rad2deg(extrinsicsVariable(1,4));



if ang<0
    ang=mod(ang,360);
end
if ang>360
    ang=360-mod(ang,360);
end
app.AngledegEditField.Value=num2str(ang);
app.RotationSlider.Value=(ang);

%% Camera Origin
eo=extrinsicsVariable(1,1);
no=extrinsicsVariable(1,2);
app.UITable10.Data{1,1}=eo;
app.UITable10.Data{1,2}=no;

o_origin=[eo no];

%% Default Grid Limits
dxdy=2;
app.ResolutionEditField.Value=num2str(dxdy);
app.ResolutionSlider.Value=dxdy;

app.UITable10_2.Data{1,1}=0;
app.UITable10_2.Data{1,2}=200;
app.UITable10_2.Data{2,1}=-200;
app.UITable10_2.Data{2,2}=200;
app.MWLElevationEditField.Value=num2str(0);


%% Plot Grid
replotGridOrtho(app)

%% Change Up Units
app.UITable10.ColumnName{1}=['Eo', ' ' ,'[', initialCamSolutionMeta.worldCoordSysUnits,']'];
app.UITable10.ColumnName{2}=['No', ' ' ,'[', initialCamSolutionMeta.worldCoordSysUnits,']'];

app.UITable10_2.ColumnName{1}=['Min', ' ' ,'[', initialCamSolutionMeta.worldCoordSysUnits,']'];
app.UITable10_2.ColumnName{2}=['Max', ' ' ,'[', initialCamSolutionMeta.worldCoordSysUnits,']'];

app.Label_315.Text=[ '[' initialCamSolutionMeta.worldCoordSysUnits ']'];
app.Label_316.Text=[ '[' initialCamSolutionMeta.worldCoordSysUnits ']'];
app.Label_352.Text=[ '[' initialCamSolutionMeta.worldCoordSysUnits ']'];

app.Label_356.Text=[ 'Datum: ' ' ' initialCamSolutionMeta.worldCoordSysH];
app.Label_357.Text=[ 'Datum: ' ' ' initialCamSolutionMeta.worldCoordSysV];


%% Change Lamp
app.Lamp_14.Color=[.5 .5 .5];