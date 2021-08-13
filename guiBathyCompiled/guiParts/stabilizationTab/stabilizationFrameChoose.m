function stabilizationFrameChoose(app)
global fdir iedir scudir
%% Grab Value
fname=app.ListBox_8.Value;

if strcmp(fname,'-')==0

%% Load First Image
cla(app.UIAxes_8)
L=dir(fullfile(fdir,fname));
I=imread(fullfile(fdir,fname,L(3).name));
imshow(I,'Parent',app.UIAxes_8) % Show Example Frame
title(app.UIAxes_8,['Frame 1 of ' num2str(length(L(3:end,1)))])

%% Change Default Value to Save AS
app.FilenameEditField_7.Value=strcat(fname,'_variableIEO');


%% Provide Acceptable Initial Solutions and SCPs Files

%% Populate List Box Initial Solutions
L=dir(iedir);
app.ListBox_9.Items={}; 
for k=3:length(L)
    
load(fullfile(iedir,L(k).name));
    if strcmp(initialCamSolutionMeta.frameSet,fname)==1
    
    
    app.ListBox_9.Items{k-2}=L(k).name;
    end
end


%% Populate List Box SCP file
L=dir(scudir);
app.ListBox_7.Items={}; 
for k=3:length(L)
    
load(fullfile(scudir,L(k).name));
    if strcmp(scp(1).frameSet,fname)==1
    
    
    app.ListBox_7.Items{k-2}=L(k).name;
    end
end

%% Clear Tables and Lamps
stablizationReset(app)
end