function gcpSolveButton(app)
global gcuxdir idir twoSave_initialIOEO ioeoflag
%% Grab Value
gcname=app.ListBox_3.Value;


%% Load Mat File UvDXYZ
load(fullfile(gcuxdir,gcname));



%% Pull Values From Table for Intitial Guess
for k=1:6
    extrinsicsInitialGuess(k)=str2num(app.UITable8.Data{1,k});
end
extrinsicsInitialGuess(4:6)=deg2rad(extrinsicsInitialGuess(4:6));

%% Pull Value to See what Should be Fixed
extrinsicsKnownsFlag=[app.CheckBox.Value app.CheckBox_4.Value app.CheckBox_5.Value app.CheckBox_6.Value app.CheckBox_7.Value app.CheckBox_8.Value];


%% Pull Value to See what GCPS are to be used

C=strsplit(app.GCPNumbersEditField.Value,',');
for k=1:length(C)
    gcpsUsed(k)=str2num(C{k});
end


%% Load Intrinsics
iname=app.ListBox_4.Value;
load(fullfile(idir,iname));



%% Solve For Extrinsics
% Format GCP World and UV coordinates into correctly sized matrices for
% non-linear solver and transformation functions (xyzToDistUV). Also, use only 
% selected GCPs specified by gcps_used in Section 3. 

% Match gcp numbers with those specified
for k=1:length(gcp)
    gnum(k)=gcp(k).num;
end
[Lia,gcpInd] = ismember(gcpsUsed,gnum);

% Format into matrix for extrinsicsSolver
x=[gcp(gcpInd).x];
y=[gcp(gcpInd).y];
z=[gcp(gcpInd).z];
xyz = [x' y' z'];  % N x 3 matrix with rows= N gcps, columns= x,y,z
UVd=reshape([gcp(gcpInd).UVd],2,length(x))'; % N x 2 matrix with rows=gcps, columns= U,V

%% Choose if IOEO Is solved for Or not


%  Function extrinsicsolver will solve for the unknown extrinsics EO as well as
%  provide error estimates for each value. Function extrinsicsSolver requires the
%  function xyzToDistUV, which requires intrinsicsExtrinsics2P and distortUV.

if ioeoflag==0
try
[extrinsics extrinsicsError]= extrinsicsSolver(extrinsicsInitialGuess,extrinsicsKnownsFlag,intrinsics,UVd,xyz);
erFlag=0;
catch
    erFlag=1; %flag to turn lamp red if function doesnt work
end
end


if ioeoflag==1
try
 IOEOInitialguess(1:6)=extrinsicsInitialGuess;
 IOEOInitialguess(7)=str2num(app.FocalLengthEditField.Value);
 focalLengthIntialGuess=app.FocalLengthEditField.Value;
 focalLengthKnownFlag=app.CheckBox_9.Value;
 IOEOKnownFlag(1:6)=extrinsicsKnownsFlag;
 IOEOKnownFlag(7)=app.CheckBox_9.Value;
 
 
[IOEO IOEOError]= IOEOSolver(IOEOInitialguess,IOEOKnownFlag,intrinsics,UVd,xyz);
erFlag=0;


% OutPut
extrinsics(1:6)=IOEO(1:6);
intrinsics(5:6)=IOEO(7);
solvedFocalLength=IOEO(7);
focalLengthError=IOEOError(7);
extrinsicsError=IOEOError(1:6);

catch
    erFlag=1 %flag to turn lamp red if function doesnt work
end
end




%% Display the results in Table
for k=1:6
app.UITable7.Data{k,2}=extrinsics(k);
app.UITable7.Data{k,3}=extrinsicsError(k);

if k>3
    app.UITable7.Data{k,2}=rad2deg(extrinsics(k));
app.UITable7.Data{k,3}=rad2deg(extrinsicsError(k));
end
end

if ioeoflag==1
    app.UITable7.Data{7,2}=solvedFocalLength;
        app.UITable7.Data{7,3}=focalLengthError;
end




%%  Reproject GCPs into UVd Space
%  Use the newly solved  extrinsics to calculate new UVd coordinates for the
%  GCP xyz points and compare to original clicked UVd. All GCPs will be
%  evaluated, not just those used for the solution.

% Format All GCP World and UVd coordinates into correctly sized matrices for
% non-linear solver and transformation functions (xyzToDistUV).
xCheck=[gcp(:).x];
yCheck=[gcp(:).y];
zCheck=[gcp(:).z];
xyzCheck = [xCheck' yCheck' zCheck'];  % N x 3 matrix with rows= N gcps, columns= x,y,z

% Transform xyz World Coordinates to Distorted Image Coordinates
[UVdReproj ] = xyz2DistUV(intrinsics,extrinsics,xyzCheck);

%  Reshape UVdCheck so easier to interpret
UVdReproj = reshape(UVdReproj ,[],2);


%% Plot Reprojection in Image
resetIOEOFig(app)

 %% Plot GCPs
for k=1:length(UVdReproj(:,1))
    plot(UVdReproj(k,1),UVdReproj(k,2),'gx','markersize',10,'linewidth',3,'parent',app.UIAxes_6);
    text(UVdReproj(k,1).*.95,UVdReproj(k,2),num2str(gcp(k).num),'parent',app.UIAxes_6,'color','g','fontweight','bold','fontsize',15);

end













%%  Determine Reprojection Error
%  Use the newly solved  extrinsics to calculate new xyz coordinates for the
%  clicked UVd points and compare to original gcp xyzs. All GCPs will be
%  evaluated, not just those used for the solution.
for k=1:length(gcp)

% Assumes Z is the known value; Reproject World XYZ from Clicked UVd    
[xyzReproj(k,:)] = distUV2XYZ(intrinsics,extrinsics,[gcp(k).UVd(1); gcp(k).UVd(2)],'z',gcp(k).z);

% Calculate Difference from Surveyd GCP World Coordinates
gcp(k).xReprojError=xyzCheck(k,1)-xyzReproj(k,1);
gcp(k).yReprojError=xyzCheck(k,2)-xyzReproj(k,2);


end

rms=sqrt(nanmean((xyzCheck-xyzReproj).^2));

%% Display Reprojection Erro
for k=1:length(gcp)
app.UITable7_2.Data{k,2}=gcp(k).xReprojError;
app.UITable7_2.Data{k,3}=gcp(k).yReprojError;
end



%% Pull Together Information for saving
twoSave_initialIOEO.extrinsics=extrinsics;
twoSave_initialIOEO.intrinsics=intrinsics;

initialCamSolutionMeta.gcpXyzFile=app.ListBox_3.Value;
initialCamSolutionMeta.iopath=app.ListBox_4.Value;
initialCamSolutionMeta.gcpsUsed=gcpsUsed;
initialCamSolutionMeta.gcpRMSE=rms; 
initialCamSolutionMeta.gcps=gcp;
initialCamSolutionMeta.extrinsicsInitialGuess=extrinsicsInitialGuess;
initialCamSolutionMeta.extrinsicsKnownsFlag=extrinsicsKnownsFlag;
initialCamSolutionMeta.extrinsicsUncert=extrinsicsError';
initialCamSolutionMeta.worldCoordSysH=gcp(1).hDatum;
initialCamSolutionMeta.worldCoordSysV=gcp(1).vDatum;
initialCamSolutionMeta.worldCoordSysUnits=gcp(1).units;
initialCamSolutionMeta.frameSet=gcp(1).frameSet;
initialCamSolutionMeta.intrinsicsMethod='Calibrated';

if ioeoflag==1
initialCamSolutionMeta.focalLengthIntialGuess=focalLengthIntialGuess;
initialCamSolutionMeta.focalLengthKnownFlag= focalLengthKnownFlag;
initialCamSolutionMeta.solvedFocalLength=solvedFocalLength;
initialCamSolutionMeta.intrinsicsMethod='SolvedWithNoDistortion';
initialCamSolutionMeta.focalLengthError=focalLengthError;
end

twoSave_initialIOEO.initialCamSolutionMeta=initialCamSolutionMeta;

%% Change Status Lamp
if erFlag==1
        app.Lamp_9.Color=[1 0 0];
else
app.Lamp_9.Color=[0 1 0];
end