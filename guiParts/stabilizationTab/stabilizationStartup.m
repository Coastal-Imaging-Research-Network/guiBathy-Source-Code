function stabilizationStartup(app)
global fdir

%% Check Project Loaded
if isempty(fdir)==1
    return
end
%% Set up the Frame ListBox

L=dir(fdir);
v= app.ListBox_8.Value;
app.ListBox_8.Items={}; 
for k=3:length(L)
    app.ListBox_8.Items{k-2}=L(k).name;
end
app.ListBox_8.Items{end+1}='-';

app.ListBox_8.Value=v;


%% Set Up Table 
for k=1:2
    for j=1:6
        app.UITable9.Data{k,j}='';
    end
end

app.UITable9.RowName{1}='Mean';
app.UITable9.RowName{2}='Std Dev';
