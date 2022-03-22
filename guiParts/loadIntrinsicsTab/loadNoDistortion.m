function loadNoDistortion(app)
global mdir




%% Initialize No Distortion Values
app.UITable4.Data{5,2}='NaN';
app.UITable4.Data{6,2}='NaN';
app.UITable4.Data{7,2}='0';
app.UITable4.Data{8,2}='0';
app.UITable4.Data{9,2}='0';
app.UITable4.Data{10,2}='0';
app.UITable4.Data{11,2}='0';


%% Load Image To Determine Other Values

I=imread(fullfile(mdir,'exampleFrame.jpg'));
[NV NU]=size(I(:,:,1));

 app.UITable4.Data{1,2}=num2str(NU);
 app.UITable4.Data{2,2}=num2str(NV);
 app.UITable4.Data{3,2}=num2str(NU/2);
 app.UITable4.Data{4,2}=num2str(NV/2);




%% Change Status Lamp
app.Lamp_30.Color=[0 1 0];