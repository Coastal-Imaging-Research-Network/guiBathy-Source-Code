function saveGCPXYZ(app)
global gcudir gcuxdir


%% Grab Value
gcname=app.ListBox_2.Value;

%% Load Mat File UvD
load(fullfile(gcudir,gcname));



%% Enter Value Into GCPS structures
for k=1:length(gcp)
    
    if app.ftButton.Value==1
        gcp(k).units='ft';
    end
     if app.mButton.Value==1
        gcp(k).units='m';
    end
    
    gcp(k).hDatum=app.HorizontalEditField.Value;
    gcp(k).vDatum=app.VerticalEditField.Value;

    gcp(k).x=app.UITable5.Data{k,2};
    gcp(k).y=app.UITable5.Data{k,3};
    gcp(k).z=app.UITable5.Data{k,4};
end


%% Save
gcname=app.FilenameEditField_4.Value;


save(fullfile(gcuxdir, gcname),'gcp')


%% Change Status Lamp
app.Lamp_8.Color=[0 1 0];