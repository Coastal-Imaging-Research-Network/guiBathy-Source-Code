function gcpXYZChoose(app)
global fdir gcuxdir gcpie

%% Grab Value
gcname=app.ListBox_3.Value;

%% Load Mat File UvD
load(fullfile(gcuxdir,gcname));
gcpie=gcp;




%% Enter Datum Information
 app.Label_72.Text= ['Horizontal: ', ' ' ,gcp(1).hDatum];
  app.Label_73.Text= ['Vertical: ', ' ',gcp(1).vDatum];
  app.Label_74.Text= ['Units: ', ' ', 'degrees, ',' ',gcp(1).units];
  

  
  %% Prepopulate GCPs to Use box
  glist=num2str(gcp(1).num);
  for k=2:length(gcp)
      glist=strcat(glist,',',num2str(gcp(k).num));
  end
  
 
  app.GCPNumbersEditField.Value=glist;
  
  
  
  %% Prepopulate Saving Box
 app.FilenameEditField_5.Value=string(strcat(gcp(1).frameSet,'_initialEO'));
 
 
 %% Prepopulate GCP Box
 for k=1:length(gcp)
     gCell{k,1}= gcp(k).num;
     gCell{k,2}='';
      gCell{k,3}='';
 end
 app.UITable7_2.Data=gCell;
 
 %% Prepopulate Initial Guess
 for k=1:6
app.UITable8.Data{1,k}='';
 end
 %% Load and Plot Figure
extrinsicsResetSolve(app)
resetIOEOFig(app)
 %% Add Units to Stuff
 tag=gcp(1).units;
 
app.UITable8.ColumnName{1}=['E', ' ', '[', tag, ']'];
app.UITable8.ColumnName{2}=['N', ' ', '[', tag, ']'];
app.UITable8.ColumnName{3}=['Z', ' ', '[', tag, ']'];
app.UITable8.ColumnName{4}=['Azimuth', ' ', '[deg]'];
app.UITable8.ColumnName{5}=['Tilt', ' ', '[deg]'];
app.UITable8.ColumnName{6}=['Swing', ' ', '[deg]'];



app.UITable7.Data{1,1}=['E', ' ', '[', tag, ']'];
app.UITable7.Data{2,1}=['N', ' ', '[', tag, ']'];
app.UITable7.Data{3,1}=['Z', ' ', '[', tag, ']'];
app.UITable7.Data{4,1}=['Azimuth', ' ', '[deg]'];
app.UITable7.Data{5,1}=['Tilt', ' ', '[deg]'];
app.UITable7.Data{6,1}=['Swing', ' ', '[deg]'];


app.UITable7_2.ColumnName{2}=['E Error', ' ', '[', tag, ']'];
app.UITable7_2.ColumnName{3}=['N Error', ' ', '[', tag, ']'];

