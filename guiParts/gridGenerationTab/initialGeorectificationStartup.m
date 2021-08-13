function initialGeorectificationStartup(app)

%% Populate Frame Set 
global fdir
%% Check Project Loaded
if isempty(fdir)==1
    return
end

%% Set up the Frame ListBox
v= app.ListBox_10.Value;
L=dir(fdir);
app.ListBox_10.Items={}; 
for k=3:length(L)
    app.ListBox_10.Items{k-2}=L(k).name;
end
app.ListBox_10.Value=v;
app.ListBox_10.Items{end+1}='-';


%% Set Up Table 
for k=1:2
    for j=1:2
        app.UITable10_2.Data{k,j}='';
    end
end

app.UITable10_2.RowName{1}='X';
app.UITable10_2.RowName{2}='Y';