function  saveSCP(app)
global scudir sUVdClick scpList

%% Find Which GCPs are good
ind=find(sUVdClick(:,3)==1);
UVd=sUVdClick(ind,1:2);
scpList=scpList(ind);
%% Get into Correct GCP Format
for k=1:length(UVd(:,1))
        scp(k).UVdo=UVd(k,1:2);
        scp(k).num=k;
        scp(k).frameSet=app.ListBox_6.Value;
        scp(k).R=scpList(k).R;
        scp(k).T=scpList(k).T;
        scp(k).brightFlag=scpList(k).brightFlag;

end


%% Save File 
save( fullfile(scudir, app.FilenameEditField_6.Value),'scp')

%% Change Status Lamp
app.Lamp_11.Color=[0 1 0];