function exportBathymetryImageChoose(app)

global cBathyPlotTran
%% Pull Ortho to Plot
if app.NoneButton_3.Value==1
    I=flipud(imread(cBathyPlotTran.sfile)).*0+1;
end

if app.SnapshotButton_3.Value==1
    I=flipud(imread(cBathyPlotTran.sfile));
end

if app.BrightestButton_3.Value==1
    I=flipud(imread(cBathyPlotTran.bfile));
end
if app.TimexButton_3.Value==1
    I=flipud(imread(cBathyPlotTran.tfile));
end

app.UIAxes2_3.Children(end).CData=I;


app.UIAxes2_4.Children(end).CData=I;

%% Reset
app.Lamp_21.Color=[.5 .5 .5];
