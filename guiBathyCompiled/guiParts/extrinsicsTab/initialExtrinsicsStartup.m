function initialExtrinsicsStartup(app)
global  idir fdir

%% Check Project Loaded
if isempty(fdir)==1
    return
end
%% Populate List Box
v= app.ListBox_5.Value;

L=dir(fdir);
app.ListBox_5.Items={}; 
for k=3:length(L)
    app.ListBox_5.Items{k-2}=L(k).name;
end
app.ListBox_5.Items{end+1}='-';

app.ListBox_5.Value=v;


%% Populate List Box
L=dir(idir);
v= app.ListBox_4.Value;
app.ListBox_4.Items={}; 
for k=3:length(L)
    app.ListBox_4.Items{k-2}=L(k).name;
end
app.ListBox_4.Value=v;


%% Populate Solution Metrics
solList{1,1}='E';
solList{2,1}='N';
solList{3,1}='Z';
solList{4,1}='Azimuth';
solList{5,1}='Tilt';
solList{6,1}='Swing';

for k=1:6
    solList{k,2}='';
    solList{k,3}='';
end
app.UITable7.Data=solList;
