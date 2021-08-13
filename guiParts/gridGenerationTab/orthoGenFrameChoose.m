function orthoGenFrameChoose(app)

global  vedir 
%% Grab Value
fname=app.ListBox_10.Value;

%% Change Default Value to Save AS
app.FilenameEditField_8.Value=strcat(fname,'_Orthos');


%% Provide Acceptable Variable Solutions 

%% Populate List Box Initial Solutions
L=dir(vedir);
app.ListBox_14.Items={}; 
for k=3:length(L)
    
load(fullfile(vedir,L(k).name));
    if strcmp(initialCamSolutionMeta.frameSet,fname)==1
    app.ListBox_14.Items{k-2}=L(k).name;
    end
end

%% Change Lamp
app.Lamp_14.Color=[.5 .5 .5];

%% Clear Axes
cla(app.UIAxes)
cla(app.UIAxes_9)