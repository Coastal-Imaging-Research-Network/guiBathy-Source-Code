function clickGCPsStartup(app)
global fdir addGCPValue UVdClick
%% Check Project Loaded
if isempty(fdir)==1 
    return
end

%% Change List Box Values

L=dir(fdir);

v= app.ListBox.Value;

app.ListBox.Items={}; 
for k=3:length(L)
    app.ListBox.Items{k-2}=L(k).name;
end
app.ListBox.Items{end+1}='-';

app.ListBox.Value=v;

%% Initialize Vector for clicking gcps
addGCPValue=0;


%% Initialize Matrix for UV points
if sum(sum(isnan(UVdClick)))~=0 | isempty(UVdClick)==1
UVdClick=nan(1,3);
end