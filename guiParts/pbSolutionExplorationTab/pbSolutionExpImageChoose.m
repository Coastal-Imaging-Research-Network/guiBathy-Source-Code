function pbSolutionExpImageChoose(app)
global pbPlotTran
%% Pull Ortho to Plot
if app.NoneButton_4.Value==1
    I=flipud(imread(pbPlotTran.sfile)).*0;
end

if app.SnapshotButton_4.Value==1
    I=flipud(imread(pbPlotTran.sfile));
end

if app.BrightestButton_4.Value==1
    I=flipud(imread(pbPlotTran.bfile));
end
if app.TimexButton_4.Value==1
    I=flipud(imread(pbPlotTran.tfile));
end

% Plot
app.UIAxes2_5.Children(end).CData=I;
app.UIAxes2_6.Children(end).CData=I;