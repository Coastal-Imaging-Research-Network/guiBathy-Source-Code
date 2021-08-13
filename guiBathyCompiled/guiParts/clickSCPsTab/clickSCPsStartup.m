function clickSCPsStartup(app)
global fdir addSCPValue sUVdClick

%% Check Project Loaded
if isempty(fdir)==1 
    return
end
%% Change List Box Values

L=dir(fdir);
v= app.ListBox_6.Value;

app.ListBox_6.Items={}; 
for k=3:length(L)
    app.ListBox_6.Items{k-2}=L(k).name;
end
app.ListBox_6.Items{end+1}='-';

app.ListBox_6.Value=v;


%% Initialize Vector for clicking gcps
addSCPValue=0;


%% Initialize Matrix for UV points
if sum(sum(isnan(sUVdClick)))~=0 | isempty(sUVdClick)==1
sUVdClick=nan(1,3);
end