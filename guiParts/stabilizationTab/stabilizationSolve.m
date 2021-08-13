function stabilizationSolve(app)


global fdir iedir scudir twoSave_variableIOEO

%% Get and Load Values
fname=app.ListBox_8.Value;
isol=app.ListBox_9.Value;
scpfile=app.ListBox_7.Value;

%% Load 
load(fullfile(iedir,isol));
L=dir(fullfile(fdir,fname));
load(fullfile(scudir,scpfile));

for k=1:length(scp)
    scp(k).z=str2num(app.UITable9_2.Data{k,1});
end

%% Format SCP
% Put SCP in format for distUV2XYZ
for k=1:length(scp)
scpZ(k)=scp(k).z;
scpUVd(:,k)=[scp(k).UVdo'];
end
% Find Center of Area About Click
In=imread(fullfile(fdir,fname, L(3).name));

for j=1:length(scp)
[ Udn, Vdn, i, udi,vdi] = thresholdCenter(In,scpUVd(1,j),scpUVd(2,j),scp(j).R,scp(j).T,scp(j).brightFlag);
scpUVd(:,j)=[Udn Vdn];
end


%% Load Image Information
% Get List of Indicies (first frame to last). (Assumes that images are in
% order, and only images are in folder). 
ind=3:length(L);

% Make A time Vector

for k=ind
    iname=L(k).name;
    tstring=strsplit(iname,'.');
    tstring=strsplit(tstring{1},'_');
    t(k-2)=str2num(tstring{2})/1000; %in EpochTime
end

t=t/24/3600+datenum(1970,1,1); % Date num Format

%% Initiate Extrinsics Matrix and First Frame Imagery
extrinsicsVariable=nan(length(ind),6);
extrinsicsVariable(1,:)=extrinsicsInitial(:); % First Value is first frame extrinsics.


%  Determine XYZ Values of SCP UVdo points
%  We find the XYZ values of the first frame SCP UVdo points, assuming the 
%  z coordinate is the elevations we entered in Section 2. We find xyz, 
%  so when we find the corresponding SCP feature in our next images In, 
%  we can treat our SCPs as gcps, and solve for a new extrinsics_n for each
 % iteration
[xyzo] = distUV2XYZ(intrinsics,extrinsicsInitial,scpUVd,'z',scpZ);

% Initiate and rename initial image, Extrinsics, and SCPUVds for loop

extrinsics_n=extrinsicsInitial;
scpUVdn=scpUVd;





%% Section 7: Start Solving Extrinsics for Each image.
imCount=1;

for k=ind(2:end)

% Assign last Known Extrinsics and SCP UVd coords
extrinsics_o=extrinsics_n; 
scpUVdo=scpUVdn;


%  Load the New Image
In=imread(fullfile(fdir,fname, L(k).name));


% Find the new UVd coordinate for each SCPs
for j=1:length(scp)
% Using the Previous scpUVdo as a guess, find the new SCP with prescribed
% Radius and Threshold

[ Udn, Vdn, i, udi,vdi] = thresholdCenter(In,scpUVdo(1,j),scpUVdo(2,j),scp(j).R,scp(j).T,scp(j).brightFlag);
    % If the function errors here, most likely your threshold was too high or
    % your radius too small for  a scp. Look at scpUVdo to see if there is a
    % nan value, if so  you will have to redo E_scpSelection with bigger
    % tolerances.
    
%Assingning New Coordinate Location
scpUVdn(:,j)=[Udn; Vdn];
end


% Solve For new Extrinsics using last frame extrinsics as initial guess and
% scps as gcps
extrinsicsInitialGuess=extrinsics_o;
extrinsicsKnownsFlag=[0 0 0 0 0 0];
[extrinsics_n extrinsicsError]= extrinsicsSolver(extrinsicsInitialGuess,extrinsicsKnownsFlag,intrinsics,scpUVdo',xyzo);


% Save Extrinsics in Matrix
imCount=imCount+1;
extrinsicsVariable(imCount,:)=extrinsics_n;



% Plot new Image and new UV coordinates, found by threshold and reprojected
cla(app.UIAxes_8)
imshow(In,'Parent',app.UIAxes_8) 
title(app.UIAxes_8,['Frame ' num2str(imCount) ' of ' num2str(length(L(3:end,1)))])
hold(app.UIAxes_8,'on')

% % Plot Newly Found UVdn by Threshold
 plot(scpUVdn(1,:),scpUVdn(2,:),'ro','linewidth',2,'markersize',10,'Parent',app.UIAxes_8)
% 
% % Plot Reprojected UVd using new Extrinsics and original xyzo coordinates
[UVd] = xyz2DistUV(intrinsics,extrinsics_n,xyzo);
 uvchk = reshape(UVd,[],2);
plot(uvchk(:,1),uvchk(:,2),'yx','linewidth',2,'markersize',10,'Parent',app.UIAxes_8)

legend(app.UIAxes_8,'SCP AutoDetect','SCP Reprojected')
 pause(.01)

end

%% Section 8: Plot Change in Extrinsics from Initial Frame

f2=figure;

% XCoordinate
subplot(6,1,1)
plot(t(2:end),extrinsicsVariable(2:end,1)-extrinsicsVariable(1,1))
ylabel(['\Delta x',' ', '[', initialCamSolutionMeta.worldCoordSysUnits, ']'])
title('Change in Extrinsics over Collection')

% YCoordinate
subplot(6,1,2)
plot(t(2:end),extrinsicsVariable(2:end,2)-extrinsicsVariable(1,2))
ylabel(['\Delta y', ' ','[', initialCamSolutionMeta.worldCoordSysUnits, ']'])

% ZCoordinate
subplot(6,1,3)
plot(t(2:end),extrinsicsVariable(2:end,3)-extrinsicsVariable(1,3))
ylabel(['\Delta z',' ', '[', initialCamSolutionMeta.worldCoordSysUnits, ']'])

% Azimuth
subplot(6,1,4)
plot(t(2:end),rad2deg(extrinsicsVariable(2:end,4)-extrinsicsVariable(1,4)))
ylabel('\Delta Azimuth [^o]')

% Tilt
subplot(6,1,5)
plot(t(2:end),rad2deg(extrinsicsVariable(2:end,5)-extrinsicsVariable(1,5)))
ylabel('\Delta Tilt[^o]')

% Swing
subplot(6,1,6)
plot(t(2:end),rad2deg(extrinsicsVariable(2:end,6)-extrinsicsVariable(1,6)))
ylabel('\Delta Swing [^o]')


% Set grid and datetick if time is provided
for k=1:6
subplot(6,1,k)
grid on
datetick
end

%% Calculate Solution metrics
for j=1:6
ii = ~isnan(extrinsicsVariable(:,j));
m(j)=mean(extrinsicsVariable(ii,j));
sd(j)=sqrt(var(extrinsicsVariable(ii,j)));
end
for k=1:length(m)
    app.UITable9.Data{1,k}=m(k);
    app.UITable9.Data{2,k}=sd(k);
    
    if k>3
        app.UITable9.Data{1,k}=rad2deg(m(k));
    app.UITable9.Data{2,k}=rad2deg(sd(k));
    end
end


%% Pulltogether Informationfor saving
twoSave_variableIOEO.extrinsicsVariable=extrinsicsVariable;
twoSave_variableIOEO.intrinsics=intrinsics;
twoSave_variableIOEO.initialCamSolutionMeta=initialCamSolutionMeta;
variableCamSolutionMeta.initialSolutionFile=isol;
variableCamSolutionMeta.scpFile=scpfile;

twoSave_variableIOEO.variableCamSolutionMeta=variableCamSolutionMeta;
twoSave_variableIOEO.t=t;


%% Change Status Lamp
app.Lamp_12.Color=[0 1 0];