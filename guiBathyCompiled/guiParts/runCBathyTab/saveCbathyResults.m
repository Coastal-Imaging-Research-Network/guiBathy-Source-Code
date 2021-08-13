function saveCbathyResults(app)
global bathytran_2 bathytran cbdir

%% Pull Params
bathy=bathytran_2.bathy;
bathy.tide.zt=bathytran.tide;
stackMeta=bathytran.stackMeta;
stackMeta.stackName=app.ListBox_19.Value;

%% Save File

save(fullfile(cbdir,app.FilenameEditField_11.Value),'bathy','stackMeta');


%% Change Status Lamp
app.Lamp_20.Color=[0 1 0];

