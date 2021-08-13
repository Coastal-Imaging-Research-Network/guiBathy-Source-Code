            
%% Function Description
%  This function is designed to make a new folder and associated folders
%  for a new project.

 function newProject(app)
 global pdir idir iedir vedir  gdir  mdir pname fdir gcudir gcuxdir scudir ordir tsdir cbdir prodir pbdir
% 

%% Making and Initiating Directories

            % Ask User for New Name of File
            prompt = {'Enter New Project Name \n Please No Spaces or Symbols'};
            dlgtitle = 'Project Name';
            dims = [1 35];
            definput = {'uasFlight_DateTime'};
            pname = inputdlg(prompt,dlgtitle,dims,definput);
            
            % Ask User where to Save File
            [ppdir] = uigetdir(cd,'Select Directory to Save Project');
            
            % Combine Directory and Path to get full directory Path
            pdir=string(fullfile(ppdir,pname));
            
            % Make Directories Associated With Steps
            idir=string(fullfile(pdir,'intrinsics'));
            iedir=string(fullfile(pdir,'initialExtrinsics'));
            vedir=string(fullfile(pdir,'variableExtrinsics'));
            cbdir=string(fullfile(pdir,'cBathy'));

            gdir=string(fullfile(pdir,'grids'));
            
            mdir= string(fullfile(pdir,'rawVideos'));
            fdir= string(fullfile(pdir,'frames'));
            gcudir= string(fullfile(pdir,'gcpsUVd'));
            gcuxdir= string(fullfile(pdir,'gcpsUVdXYZ'));
            scudir= string(fullfile(pdir,'scpsUVd'));
            ordir= string(fullfile(pdir,'orthos'));
            tsdir= string(fullfile(pdir,'timestacks'));
            prodir= string(fullfile(pdir,'products'));
            pbdir= string(fullfile(pdir,'pbTool'));

            mkdir(pdir); 
            mkdir(idir);
            mkdir(iedir);
            mkdir(vedir);
            mkdir(prodir); 
            mkdir(pbdir);
            mkdir(gdir);
            mkdir(cbdir);

            mkdir(mdir);
            mkdir(fdir);
            mkdir(gcudir);
            mkdir(gcuxdir);
            mkdir(scudir);
            mkdir(ordir);
            mkdir(tsdir);

%% Change the title of the App
            app.NewProjectLabel.Text=pname; % Change Title
            
%% Change Status Lamp
app.Lamp_3.Color=[0 1 0];
app.Lamp_2.Color=[.5 .5 .5];
app.Lamp.Color=[.5 .5 .5];

%% Reset Image
imshow(imread('lby_use.png'),'parent',app.UIAxes_2);