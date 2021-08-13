function assignGCPstartup(app)
global  gcudir

%% Check Project Loaded
if isempty(gcudir)==1
    return
end

%% Change List Box Values
L=dir(gcudir);

v= app.ListBox_2.Value;
app.ListBox_2.Items={}; 
for k=3:length(L)
    app.ListBox_2.Items{k-2}=L(k).name;
end
app.ListBox_2.Items{end+1}='-';

app.ListBox_2.Value=v;
