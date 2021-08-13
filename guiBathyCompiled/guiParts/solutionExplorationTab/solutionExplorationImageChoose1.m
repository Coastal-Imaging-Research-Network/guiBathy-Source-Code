function solutionExplorationImageChoose1(app)
global cBathyPlotTran
%% Pull Ortho to Plot
if app.NoneButton.Value==1
    I=flipud(imread(cBathyPlotTran.sfile)).*0;
end

if app.SnapshotButton.Value==1
    I=flipud(imread(cBathyPlotTran.sfile));
end

if app.BrightestButton.Value==1
    I=flipud(imread(cBathyPlotTran.bfile));
end
if app.TimexButton.Value==1
    I=flipud(imread(cBathyPlotTran.tfile));
end

% Plot
app.UIAxes2.Children(end).CData=I;
app.UIAxes2_2.Children(end).CData=I;
