function noDistStabilizationStartup(app)
global fdir

%% Check Project Loaded
if isempty(fdir)==1
    return
end
%% Set up the Frame ListBox

L=dir(fdir);
v= app.ListBox_34.Value;
app.ListBox_34.Items={}; 
for k=3:length(L)
    app.ListBox_34.Items{k-2}=L(k).name;
end
app.ListBox_34.Items{end+1}='-';

app.ListBox_34.Value=v;

