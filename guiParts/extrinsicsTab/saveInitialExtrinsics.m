function saveInitialExtrinsics(app)
global twoSave_initialIOEO iedir

%% Save
ieoname=app.FilenameEditField_5.Value;

extrinsicsInitial=twoSave_initialIOEO.extrinsics;
intrinsics=twoSave_initialIOEO.intrinsics;
intrinsics=twoSave_initialIOEO.intrinsics;
initialCamSolutionMeta=twoSave_initialIOEO.initialCamSolutionMeta;
save( fullfile(iedir, ieoname),'extrinsicsInitial','intrinsics','initialCamSolutionMeta')


%% Change Status Lamp
app.Lamp_10.Color=[0 1 0];