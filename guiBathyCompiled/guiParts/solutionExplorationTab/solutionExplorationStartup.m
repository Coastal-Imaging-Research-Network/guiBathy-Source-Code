function solutionExplorationStartup(app)

global cbdir

%% Check Project Loaded
if isempty(cbdir)==1
    return
end

v= app.ListBox_24.Value;

%% Populate List Box
L=dir(cbdir);
app.ListBox_24.Items={}; 
for k=3:length(L)
    app.ListBox_24.Items{k-2}=L(k).name;
end
app.ListBox_24.Value=v;
app.ListBox_24.Items{end+1}='-';
