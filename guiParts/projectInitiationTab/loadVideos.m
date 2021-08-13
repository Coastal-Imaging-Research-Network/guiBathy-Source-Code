%% Function Description
%  Function Copies User Selected Movies to Folder Structure

function loadVideos(app)
global mdir 

%% Ask User To Load Movies
[mfile mfilepath] = uigetfile('*.*','Load Movie Files','MultiSelect','on');

if iscell(mfile)==0
    mfile2=mfile;
    clear mfile
    mfile{1}=mfile2;
    clear mfile2
end
%% Copy Files to Movie Directory
for k=1:length(mfile)
    
    
   %[status]=copyfile(string(strcat(mfilepath,'\',mfile{k})), mdir); 
   [status]=copyfile(string(fullfile(mfilepath,mfile{k})), mdir); 

   disp([mfile{k} ' successfully loaded'])
end


%% Pull Example Frame
v=VideoReader(string(fullfile(mfilepath,mfile{1})));
eframe=readFrame(v);
imwrite(eframe,fullfile(mdir,  'exampleFrame.jpg'))

% Display Example Frame
 imshow(imread(fullfile(mdir,'exampleFrame.jpg')),'Parent',app.UIAxes_2) % Show Example Frame
 
 %% Change Status Lamp
app.Lamp_2.Color=[0 1 0];