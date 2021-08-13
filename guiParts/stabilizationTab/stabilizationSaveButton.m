function stabilizationSaveButton(app)
global twoSave_variableIOEO vedir

%% Save
veoname=app.FilenameEditField_7.Value;

extrinsicsVariable=twoSave_variableIOEO.extrinsicsVariable;
intrinsics=twoSave_variableIOEO.intrinsics;
initialCamSolutionMeta=twoSave_variableIOEO.initialCamSolutionMeta;
variableCamSolutionMeta=twoSave_variableIOEO.variableCamSolutionMeta;
t=twoSave_variableIOEO.t;

save( fullfile(vedir, veoname),'extrinsicsVariable','intrinsics','initialCamSolutionMeta','variableCamSolutionMeta','t');

%% Change Status Lamp
app.Lamp_13.Color=[0 1 0];