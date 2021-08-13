function loadIntrinsicsStartup(app)
global idir

%% Check Project Loaded
if isempty(idir)==1
    return
end

%% Define Table Entries for Intrinsics (Default)
iCell{1,1}='NU';
iCell{2,1}='NV';
iCell{3,1}='cUo';
iCell{4,1}='cVo';
iCell{5,1}='fx';
iCell{6,1}='fy';
iCell{7,1}='d1';
iCell{8,1}='d2';
iCell{9,1}='d3';
iCell{10,1}='t1';
iCell{11,1}='t2';


for k=1:length(iCell)
    iCell{k,2}='';
end

app.UITable4.Data=iCell;


%% Enter Saving FileName
app.FilenameEditField.Value='iPlatform_VideoMode';


%% Check if intrinsics exist
L=ls(idir);
if length(L)>2
app.Label_39.FontColor='k';
app.Label_39.Text='Project has intrinsics';   
    
end