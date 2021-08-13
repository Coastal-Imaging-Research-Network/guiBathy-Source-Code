function orthoGenFrameChoose2(app)


global  vedir 
%% Grab Value
fname=app.ListBox_13.Value;
if strcmp(fname,'-')==0

%% Change Default Value to Save AS
app.OutputDirectoryNameEditField.Value=strcat(fname,'_Orthos');


%% Populate List Box Initial Solutions
L=dir(vedir);
app.ListBox_14.Items={}; 
for k=3:length(L)
    
load(fullfile(vedir,L(k).name));
    if strcmp(initialCamSolutionMeta.frameSet,fname)==1
    app.ListBox_14.Items{k-2}=L(k).name;
    end
end

%% Clear Tab
orthoGenReset(app)
cla(app.UIAxes_10)
cla(app.UIAxes_11)
end