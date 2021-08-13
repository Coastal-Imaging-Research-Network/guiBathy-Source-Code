function runCbathyTSChoose(app)
global tsdir bathytran
cla(app.UIAxes_14)
%% Load TS File
if strcmp(app.ListBox_19.Value,'-')==0
load(fullfile(tsdir,app.ListBox_19.Value));

%% Assign Point Resolution
xres=mean(diff(x(1,:)));
yres=mean(diff(y(:,1)));
mplier1=[1 2 5 10 ];

for k=1:length(mplier1)
  app.ListBox_20.Items{k}= num2str(xres.*mplier1(k));
    app.ListBox_21.Items{k}= num2str(yres.*mplier1(k));
end
app.ListBox_20.Value=app.ListBox_20.Items{1};
app.ListBox_21.Value=app.ListBox_21.Items{1};

%% Asignn Area Resoltuion
mplier2=[2 3 4];
for k=1:length(mplier2)
    app.ListBox_22.Items{k}= num2str(str2num(app.ListBox_20.Value).*mplier2(k));
    app.ListBox_23.Items{k}= num2str(str2num(app.ListBox_21.Value).*mplier2(k));
end

app.ListBox_23.Value=app.ListBox_23.Items{2};
app.ListBox_22.Value=app.ListBox_22.Items{2};
%% Assign Domain Limits
app.UITable10_3.RowName{1}='X';
app.UITable10_3.RowName{2}='Y';
app.UITable10_3.Data{1,1}=min(x(1,:));
app.UITable10_3.Data{2,1}=min(y(:,1));
app.UITable10_3.Data{1,2}=max(x(1,:));
app.UITable10_3.Data{2,2}=max(y(:,1));

app.UITable10_4.Data{1,1}=.25;
app.UITable10_4.Data{1,2}=10;








%% Make Saving Name
A=strsplit(app.ListBox_19.Value,'.mat');
app.FilenameEditField_11.Value=strcat(A{1},'_cbathy');

%% Transfer Varaible to other functions

bathytran.data=data;
bathytran.t=t;
bathytran.xyz=xyz;
bathytran.stackMeta=stackMeta;
bathytran.x=x;
bathytran.y=y;
bathytran.z=z;
bathytran.tide=tide;
bathytran.Io=Io;

%% Plot
cbathyRunReplot(app)


%% Units stuff
xlabel(app.UIAxes_14,['X ',' ', '[', stackMeta.Units ']']);
ylabel(app.UIAxes_14,['Y ',' ', '[', stackMeta.Units ']']);
app.Label_218.Text=['Cross-shore Resolution',' ', '[', stackMeta.Units ']'];
app.Label_219.Text=['Alongshore Resolution',' ', '[', stackMeta.Units ']'];
app.Label_222.Text=['Cross-shore Exent',' ', '[', stackMeta.Units ']'];
app.Label_223.Text=['Alongshore Exent',' ', '[', stackMeta.Units ']'];


app.UITable10_3.ColumnName{1}=['Min ' ,' ', '[', stackMeta.Units ']'];
app.UITable10_3.ColumnName{2}=['Max ' ,' ', '[', stackMeta.Units ']'];

app.UITable10_4.ColumnName{1}=['Min ' ,' ', '[', stackMeta.Units ']'];
app.UITable10_4.ColumnName{2}=['Max ' ,' ', '[', stackMeta.Units ']'];

end