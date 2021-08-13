function  clickSCPsFrameChoose(app)
global fdir Iscp sUVdClick

%% Grab Value
fname=app.ListBox_6.Value;

if strcmp(fname,'-')==0

sUVdClick=nan(1,3);
%% Change Lamp Color
app.Lamp_11.Color=[.5 .5 .5];
%% Load First Image
L=dir(fullfile(fdir,fname));
I=imread(fullfile(fdir,fname,L(3).name));
imshow(I,'Parent',app.UIAxes_7) % Show Example Frame
Iscp=I;

%% Change Default Value to Save AS
app.FilenameEditField_6.Value=strcat(fname,'_SCPsUVd');

end