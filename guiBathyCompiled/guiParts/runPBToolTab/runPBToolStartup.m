function runPBToolStartup(app)
global ordir 
%% Check Project Loaded
if isempty(ordir)==1
    return
end
 %% Set up the Ortho ListBox
v= app.ListBox_28.Value;
L=dir(ordir);
app.ListBox_28.Items={}; 
for k=3:length(L)
    app.ListBox_28.Items{k-2}=L(k).name;
end 
app.ListBox_28.Value=v;
app.ListBox_28.Items{end+1}='-';

