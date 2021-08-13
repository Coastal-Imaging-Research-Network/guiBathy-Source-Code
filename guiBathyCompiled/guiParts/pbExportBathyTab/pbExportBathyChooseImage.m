function pbExportBathyChooseImage(app)

global pbExporTran
%% Pull Ortho to Plot
if app.NoneButton_5.Value==1
    I=flipud(imread(pbExporTran.sfile)).*0;
end

if app.SnapshotButton_5.Value==1
    I=flipud(imread(pbExporTran.sfile));
end

if app.BrightestButton_5.Value==1
    I=flipud(imread(pbExporTran.bfile));
end
if app.TimexButton_5.Value==1
    I=flipud(imread(pbExporTran.tfile));
end

% Plot
app.UIAxes2_9.Children(end).CData=I;
app.UIAxes2_8.Children(end).CData=I;
app.UIAxes2_10.Children(end).CData=I;

%% Reset Lamp
app.Lamp_27.Color=[.5 .5 .5];