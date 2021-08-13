function runPBToolSaveBathy(app)
global pbTran pbdir
disp(pbdir)
%% Define Variables
pbData=pbTran.data;
pbMeta.input=pbTran.input;
pbMeta.OrthoSet=app.ListBox_28.Value;
pbMeta.cBathyFile=app.ListBox_29.Value;
pbMeta.Units=pbTran.Units;
pbMeta.worldCoordSysV=pbTran.worldCoordSysV;
pbMeta. worldCoordSysH=pbTran.worldCoordSysH;
pbMeta.tide=pbTran.tide;
pbMeta.mwlElevation=pbTran.mwlElevation;

%% Save File

save(fullfile(pbdir,app.FilenameEditField_12.Value),'pbData','pbMeta');


%% Change Status Lamp
app.Lamp_26.Color=[0 1 0];

