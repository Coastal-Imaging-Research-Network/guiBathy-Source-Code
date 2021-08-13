function stabilizationInitialSolChoose(app)

global fdir iedir

%% Grab Value
isol=app.ListBox_9.Value;

%% Load Mat File UvD
load(fullfile(iedir,isol));



%% Enter Datum Information 
  %% Enter Datum Information
 app.Label_133.Text= ['Horizontal: ', ' ' ,initialCamSolutionMeta.worldCoordSysH];
  app.Label_134.Text= ['Vertical: ', ' ',initialCamSolutionMeta.worldCoordSysV];
  app.Label_135.Text= ['Units: ', ' ', 'degrees, ',' ',initialCamSolutionMeta.worldCoordSysUnits];
  
  
  
tag=initialCamSolutionMeta.worldCoordSysUnits;
app.UITable9.ColumnName{1}=['E', ' ', '[', tag, ']'];
app.UITable9.ColumnName{2}=['N', ' ', '[', tag, ']'];
app.UITable9.ColumnName{3}=['Z', ' ', '[', tag, ']'];
app.UITable9.ColumnName{4}=['Azimuth', ' ', '[deg]'];
app.UITable9.ColumnName{5}=['Tilt', ' ', '[deg]'];
app.UITable9.ColumnName{6}=['Swing', ' ', '[deg]'];



app.UITable9_2.ColumnName{1}=['Z', ' ', '[', tag, '-',initialCamSolutionMeta.worldCoordSysV,' ]'];

%% Reset Tables
stablizationReset(app)