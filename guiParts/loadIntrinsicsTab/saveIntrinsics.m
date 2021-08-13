function saveIntrinsics(app)
global idir


%% Put in correct format

intrinsics(1) = str2num(app.UITable4.Data{1,2});            % Number of pixel columns
intrinsics(2) = str2num(app.UITable4.Data{2,2});            % Number of pixel rows
intrinsics(3) = str2num(app.UITable4.Data{3,2});         % U component of principal point  
intrinsics(4)= str2num(app.UITable4.Data{4,2});          % V component of principal point
intrinsics(5) = str2num(app.UITable4.Data{5,2});         % U components of focal lengths (in pixels)
intrinsics(6) = str2num(app.UITable4.Data{6,2});         % V components of focal lengths (in pixels)
intrinsics(7) = str2num(app.UITable4.Data{7,2});         % Radial distortion coefficient
intrinsics(8) = str2num(app.UITable4.Data{8,2});         % Radial distortion coefficient
intrinsics(9) = str2num(app.UITable4.Data{9,2});         % Radial distortion coefficient
intrinsics(10) = str2num(app.UITable4.Data{10,2});        % Tangential distortion coefficients
intrinsics(11) = str2num(app.UITable4.Data{11,2});        % Tangential distortion coefficients


%% Save
save( fullfile(idir, app.FilenameEditField.Value),'intrinsics')


%% Change Label 
app.Label_39.FontColor='k';
app.Label_39.Text='Project has intrinsics';
app.Label_31.Text='New Intrinsics Loaded';
app.Label_31.FontColor='k';



%% Change Status Lamp
app.Lamp_6.Color=[0 1 0];