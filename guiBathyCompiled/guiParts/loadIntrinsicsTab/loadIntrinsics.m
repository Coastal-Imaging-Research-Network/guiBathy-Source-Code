function  loadIntrinsics(app)

%% Select + load Caltech File
[ctfile, path] = uigetfile(cd,'Select Caltech Calibration File');
load(fullfile(path,ctfile))


%% Enter Into Table

app.UITable4.Data{1,2}=num2str(nx);
app.UITable4.Data{2,2}=num2str(ny);
app.UITable4.Data{3,2}=num2str(cc(1));
app.UITable4.Data{4,2}=num2str(cc(2));
app.UITable4.Data{5,2}=num2str(fc(1));
app.UITable4.Data{6,2}=num2str(fc(2));
app.UITable4.Data{7,2}=num2str(kc(1));
app.UITable4.Data{8,2}=num2str(kc(2));
app.UITable4.Data{9,2}=num2str(kc(5));
app.UITable4.Data{10,2}=num2str(kc(3));
app.UITable4.Data{11,2}=num2str(kc(4));






%% Change Status Lamp
app.Lamp_5.Color=[0 1 0];


