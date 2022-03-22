function noDistStabilizationSave(app)
global Ro iedir ptThresh fdir TFORM vedir


%% Load Initial Solution
load(fullfile(iedir,app.ListBox_35.Value))


% Create Extrinsics Structure
extrinsicsVariable=repmat(extrinsicsInitial,length(TFORM),1)
intrinsics=intrinsics;



%% Get TimeVector
L=dir(fullfile(fdir,app.ListBox_34.Value));
ind=3:length(L);

% Make A time Vector

for k=ind
    iname=L(k).name;
    tstring=strsplit(iname,'.');
    tstring=strsplit(tstring{1},'_');
    t(k-2)=str2num(tstring{2})/1000; %in EpochTime
end

t=t/24/3600+datenum(1970,1,1); % Date num Format



%% Save
veoname=app.FilenameEditField_13.Value;


% MetaData
variableCamSolutionMeta.method='FAST';
variableCamSolutionMeta.ptThresh=ptThresh;
variableCamSolutionMeta.RectanglePositions=Ro;







save( fullfile(vedir, veoname),'extrinsicsVariable','intrinsics','initialCamSolutionMeta','variableCamSolutionMeta','t','TFORM');

%% Change Status Lamp
app.Lamp_31.Color=[0 1 0];