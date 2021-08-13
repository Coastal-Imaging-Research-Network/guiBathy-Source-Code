function orthoGenSolutionChoose(app)

global  vedir  gdir

%% Load Solution
vsol=app.ListBox_14.Value;
load(fullfile(vedir,vsol));


  
  %% Find Appropriate Grids
 
L=dir(gdir);
app.ListBox_12.Items={}; 
for k=3:length(L)
    
load(fullfile(gdir,L(k).name));
    if (strcmp(initialCamSolutionMeta.worldCoordSysH,worldCoordSysH)==1) & (strcmp(initialCamSolutionMeta.worldCoordSysV,worldCoordSysV)==1)  & (strcmp(initialCamSolutionMeta.worldCoordSysUnits,worldCoordSysUnits)==1)
    app.ListBox_12.Items{k-2}=L(k).name;
    end
end


%% Populate Number of Frames to Output
numFrames=length(extrinsicsVariable(:,1));
app.UITable3_3.Data{1,1}=0;
app.UITable3_3.Data{1,2}=numFrames;



%% Add Units
app.Label_317.Text=['[', initialCamSolutionMeta.worldCoordSysUnits,']'];

xlabel(app.UIAxes_10,['X ',' ', '[', initialCamSolutionMeta.worldCoordSysUnits,']'])
ylabel(app.UIAxes_10,['Y ',' ', '[', initialCamSolutionMeta.worldCoordSysUnits,']'])

xlabel(app.UIAxes_11,['X ',' ', '[', initialCamSolutionMeta.worldCoordSysUnits,']'])
ylabel(app.UIAxes_11,['Y ',' ', '[', initialCamSolutionMeta.worldCoordSysUnits,']'])


%% Reset Tab
orthoGenReset(app)
cla(app.UIAxes_10)
cla(app.UIAxes_11)