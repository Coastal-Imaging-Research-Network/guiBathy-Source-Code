function clickCbathyStartup(app)


global ordir 
%% Check Project Loaded
if isempty(ordir)==1
    return
end
 %% Set up the Ortho ListBox
v= app.ListBox_16.Value;

L=dir(ordir);
app.ListBox_16.Items={}; 
for k=3:length(L)
    app.ListBox_16.Items{k-2}=L(k).name;
end 
app.ListBox_16.Value=v;
app.ListBox_16.Items{end+1}='-';

