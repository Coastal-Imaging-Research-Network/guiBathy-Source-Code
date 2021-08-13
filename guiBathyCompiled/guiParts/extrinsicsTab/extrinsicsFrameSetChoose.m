function extrinsicsFrameSetChoose(app)
global fdir gcuxdir

%% Grab Value
fname=app.ListBox_5.Value;
if strcmp(fname,'-')==0



%% Populate List Box
L=dir(gcuxdir);
app.ListBox_3.Items={}; 
for k=3:length(L)
    
load(fullfile(gcuxdir,L(k).name));
    if strcmp(gcp(1).frameSet,fname)==1
    
    
    app.ListBox_3.Items{k-2}=L(k).name;
    end
end

%% Reset Tab
extrinsicsResetSolve(app)
end