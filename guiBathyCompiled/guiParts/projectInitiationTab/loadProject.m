%% Function Description
%  This function is designed to load a project folder and associated folders
%  for a new project.

function loadProject(app)
global pdir idir iedir vedir  gdir  pname mdir fdir gcudir gcuxdir scudir ordir tsdir cbdir prodir pbdir


%% Code

% Get User Folder
[pdir] = uigetdir;

% Pull Out Directory Name

ps=strsplit(pdir,'\');
if length(ps) == 1
    ps = strsplit(pdir,'/');
end
pname=string(ps{end});


% Make Directory names
            idir=string(fullfile(pdir,'intrinsics'));
            iedir=string(fullfile(pdir,'initialExtrinsics'));
            vedir=string(fullfile(pdir,'variableExtrinsics'));
            gdir=string(fullfile(pdir,'grids'));
            mdir= string(fullfile(pdir,'rawVideos'));
            fdir= string(fullfile(pdir,'frames'));
            gcudir= string(fullfile(pdir,'gcpsUVd'));
            gcuxdir= string(fullfile(pdir,'gcpsUVdXYZ'));
            scudir= string(fullfile(pdir,'scpsUVd'));
            ordir= string(fullfile(pdir,'orthos'));
            tsdir= string(fullfile(pdir,'timestacks'));
            cbdir=string(fullfile(pdir,'cBathy'));
            prodir=string(fullfile(pdir,'products'));
            pbdir=string(fullfile(pdir,'pbTool'));

            % Change the Title of the App            
app.NewProjectLabel.Text=pname; % Change Title

% Show the first from the first video
imshow(imread(fullfile(mdir,'exampleFrame.jpg')),'Parent',app.UIAxes_2) % Show Example Frame

%% Change Status Lamp
app.Lamp.Color=[0 1 0];