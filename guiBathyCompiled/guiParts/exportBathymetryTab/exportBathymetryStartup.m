function exportBathymetryStartup(app)

global cbdir

%% Check Project Loaded
if isempty(cbdir)==1
    return
end

v= app.ListBox_27.Value;

%% Populate List Box
L=dir(cbdir);
app.ListBox_27.Items={}; 
for k=3:length(L)
    app.ListBox_27.Items{k-2}=L(k).name;
end
app.ListBox_27.Value=v;
app.ListBox_27.Items{end+1}='-';

