function noDistStabilizationFrameChoose(app)
global fdir iedir rCount R
%% Grab Value
fname=app.ListBox_34.Value;

if strcmp(fname,'-')==0

%% Load First Image
cla(app.UIAxes_16)

L=dir(fullfile(fdir,fname));
I=imread(fullfile(fdir,fname,L(3).name));
imshow(I,'Parent',app.UIAxes_16) % Show Example Frame
title(app.UIAxes_16,['Frame 1 of ' num2str(length(L(3:end,1)))])




%% Change Default Value to Save AS
app.FilenameEditField_13.Value=strcat(fname,'_variableIEO_NoDist');



%% Populate List Box Initial Solutions
L=dir(iedir);
app.ListBox_35.Items={}; 
for k=3:length(L)
    
load(fullfile(iedir,L(k).name));
    if strcmp(initialCamSolutionMeta.frameSet,fname)==1 & strcmp(initialCamSolutionMeta.intrinsicsMethod,'SolvedWithNoDistortion')==1
        app.ListBox_35.Items{k-2}=L(k).name;
    end
    
end
%AutoChoose First
app.ListBox_35.Value=app.ListBox_35.Items{1};


%% Set Up THreshold Value
app.ThresholdEditField.Value='.1';


end
if strcmp(fname,'-')==1

%% Clear Tables and Lamps
noDistStablizationReset(app)
end


%% Reset Count
rCount=0;
R=[];
