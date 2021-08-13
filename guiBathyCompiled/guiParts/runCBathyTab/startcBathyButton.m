function startcBathyButton(app)
global bathytran bathytran_2


%% Start Making Parameters File--> Stuff that is Pre-programmed
params.tideFunction = 'cBathyTide'; % tide level function for evel...I dont think this is working???
params.QTOL = 0.5; % reject skill below this in csm
params.minLam = 10; % min normalized eigenvalue to proceed

params.DECIMATE = 0; % decimate pixels to reduce work load.
params.maxNPix = 80; % max num pixels per tile (decimate excess)
params.maxNx=20;
params.maxNy=50;

params.minValsForBathyEst = 4;
params.nKeep= params.minValsForBathyEst;

% default offshore wave angle. For search seeds.
params.offshoreRadCCWFromx = 0;
params.nlinfit=1;

%% debugging options
params.debug.production = 1;
params.DOPLOTTRANSECTS=1;
params.debug.DOPLOTSTACKANDPHASEMAPS = 1; % top level debug of phase
params.debug.DOSHOWPROGRESS = 1; % show progress of tiles
params.debug.DOPLOTPHASETILE = 1; % observed and EOF results per pt
params.debug.TRANSECTX = 385; % for plotStacksAndPhaseMaps
params.debug.TRANSECTY = 385; % for plotStacksAndPhaseMaps
%% Stuff Loaded From GUI
% Format Correctly into meters/feet
if strcmp(bathytran.stackMeta.Units,'m')==1
    fc=1;
end
if strcmp(bathytran.stackMeta.Units,'m')==0
    fc=12.*2.54./100;
end

bathytran.xyz=bathytran.xyz.*fc;


params.stationStr = app.ListBox_19.Value;

params.dxm = str2num(app.ListBox_20.Value).*fc;
params.dym = str2num(app.ListBox_21.Value).*fc;
params.xyMinMax = [ (app.UITable10_3.Data{1,1}) (app.UITable10_3.Data{1,2}) (app.UITable10_3.Data{2,1}) (app.UITable10_3.Data{2,2})].*fc; % min, max of x, then y

params.MINDEPTH = app.UITable10_4.Data{1,1}.*fc;
params.MAXDEPTH = app.UITable10_4.Data{1,2}.*fc;

params.Lx = str2num(app.ListBox_22.Value).*fc;
params.Ly = str2num(app.ListBox_23.Value).*fc;


if app.Button_5.Value==1
    params.kappa0 = 1; 
end
if app.Button_6.Value==1
    params.kappa0 = 2;
end
if app.Button_7.Value==1
    params.kappa0 =3;
end

%% For Now this is preprogrammed
%  params.fB = [(1/18):(2/100):(1/4)]; % frequencies for analysis
% params.fB=[(1/app.MaximumPeriodsEditField.Value):app.FrequencyReolutionHzEditField.Value:(1./app.MinimumPeriodsEditField.Value)];
% % If frequencies are specified

% If number of frequencies are specified
 params.fB=linspace((1/app.MaximumPeriodsEditField.Value),(1./app.MinimumPeriodsEditField.Value),app.NumberofFrequenciesEditField.Value)
 
%  disp(params.fB)


 
 %% Run C=bathy
 bathy.sName=params.stationStr;
 bathy.params=params;
 epoch=bathytran.t;
 bathy.epoch=epoch;
 cam=bathytran.xyz.*0+1;
 


% Run Bathy
bathy = analyzeBathyCollect(bathytran.xyz, epoch, bathytran.data,cam, bathy);

%% Convert Back
bathy.xm=bathy.xm./fc;
bathy.ym=bathy.ym./fc;
bathy.fDependent.k=bathy.fDependent.k.*fc;
bathy.fDependent.kErr=bathy.fDependent.k.*fc;
bathy.fDependent.kSeed=bathy.fDependent.k.*fc;
bathy.fDependent.hTemp=bathy.fDependent.hTemp./fc;
bathy.fDependent.hTempErr=bathy.fDependent.hTempErr./fc;
bathy.fCombined.h=bathy.fCombined.h./fc;
bathy.fCombined.hErr=bathy.fCombined.hErr./fc;

bathy.params.dxm = bathy.params.dxm./fc;
bathy.params.dym = bathy.params.dym./fc;
bathy.params.xyMinMax = bathy.params.xyMinMax./fc;

bathy.params.MINDEPTH = bathy.params.MINDEPTH./fc;
bathy.params.MAXDEPTH = bathy.params.MAXDEPTH./fc;

bathy.params.Lx = bathy.params.Lx./fc;
bathy.params.Ly = bathy.params.Ly ./fc;
bathy.params.Units=bathytran.stackMeta.Units;


% Ge rid of Values that do not have an error estimate
bind=find(isnan(bathy.fCombined.hErr)==1);
bathy.fCombined.h(bind)=nan;


bathytran_2.bathy=bathy;
bathytran_2.mwlElevation=nanmean(bathytran.xyz(:,3))-bathytran.tide;



%% Change Status Lamp
app.Lamp_19.Color=[0 1 0];