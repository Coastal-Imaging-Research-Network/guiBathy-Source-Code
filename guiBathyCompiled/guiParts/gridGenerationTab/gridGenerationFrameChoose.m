function gridGenerationFrameChoose(app)
global  vedir 
%% Grab Value
fname=app.ListBox_10.Value;

if strcmp(fname,'-')==0

%% Change Default Value to Save AS
app.FilenameEditField_8.Value=strcat(fname,'_Grid');


%% Provide Acceptable Initial Solutions and SCPs Files

%% Populate List Box Initial Solutions
L=dir(vedir);
app.ListBox_11.Items={}; 
for k=3:length(L)
    
load(fullfile(vedir,L(k).name));
    if strcmp(initialCamSolutionMeta.frameSet,fname)==1
    
    
    app.ListBox_11.Items{k-2}=L(k).name;
    end
end
end