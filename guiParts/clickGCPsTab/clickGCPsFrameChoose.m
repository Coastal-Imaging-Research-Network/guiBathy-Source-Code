function  clickGCPsFrameChoose(app)
global fdir UVdClick
%% Clearing
cla(app.UIAxes_5)

%% Grab Value
fname=app.ListBox.Value;


%% Function
if strcmp(fname,'-')==0

UVdClick=nan(1,3);

%% Load First Image
L=dir(fullfile(fdir,fname));
I=imread(fullfile(fdir,fname,L(3).name)); %might need a bracket tjh
imshow(I,'Parent',app.UIAxes_4) % Show Example Frame

%% Change Default Value to Save AS
app.FilenameEditField_2.Value=strcat(fname,'_GCPsUVd');
end