function timestackOrthoSelect(app)
global ordir gdir


%% Load Grid File and Pull Appropriate Resolutions
main_d=fullfile(ordir,app.ListBox_16.Value);
if strcmp(main_d,'-')==0

L=dir(main_d);

for k=1:length(L)
    chk=strfind(L(k).name,'.mat');
    if isempty(chk)==0
        load(fullfile(main_d,L(k).name));
    end
end

load(fullfile(gdir,gridFile))

% Get Resolutions
res(1)=nanmean(diff(X(1,:)));
res(2)= res(1)*2;
res(3)=res(1)*5;
res(4)=res(1).*10;

for k=1:length(res)
    app.ListBox_18.Items{k}=[num2str(res(k)) 'x' num2str(res(k)) initialCamSolutionMeta.worldCoordSysUnits  ' grid'] ;
end

app.ListBox_18.Value=app.ListBox_18.Items{1};

%% Plot Image
timestackPlotRes(app)


%% Enter Default Saving Name
app.FilenameEditField_10.Value=strcat(app.ListBox_16.Value,'_Timestack');

%% Enter number of Frames
app.UITable3_5.Data{1,1}=0;
app.UITable3_5.Data{1,2}=length(t);


%% reset
timestackReset(app)

end