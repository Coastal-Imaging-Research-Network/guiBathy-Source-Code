function orthophotoGenerationStartup(app)

%% Populate Frame Set 
global fdir gdir

%% Check Project Loaded
if isempty(fdir)==1
    return
end
%% Set up the Frame ListBox
v= app.ListBox_13.Value;

L=dir(fdir);
app.ListBox_13.Items={}; 
for k=3:length(L)
    app.ListBox_13.Items{k-2}=L(k).name;
end

app.ListBox_13.Value=v;
app.ListBox_13.Items{end+1}='-';


