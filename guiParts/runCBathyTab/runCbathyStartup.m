function runCbathyStartup(app)
global tsdir

%% Check Project Loaded
if isempty(tsdir)==1
    return
end

%% Find Timestack Directories
v= app.ListBox_19.Value;

L=dir(tsdir);
app.ListBox_19.Items={}; 
for k=3:length(L)
    app.ListBox_19.Items{k-2}=L(k).name;
end
app.ListBox_19.Value=v;
app.ListBox_19.Items{end+1}='-';

