function  saveGCP(app)
global gcudir UVdClick

%% Find Which GCPs are good
ind=find(UVdClick(:,3)==1);
UVd=UVdClick(ind,1:2);

%% Get into Correct GCP Format
for k=1:length(UVd(:,1))
        gcp(k).UVd=UVd(k,1:2);
        gcp(k).num=k;
        gcp(k).frameSet=app.ListBox.Value;
end


%% Save File 
save( fullfile(gcudir, app.FilenameEditField_2.Value),'gcp')

%% Change Status Lamp
app.Lamp_7.Color=[0 1 0];