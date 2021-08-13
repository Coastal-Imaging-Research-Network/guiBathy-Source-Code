function pbSolutionExpCBathyChoose(app)
global prodir pbPlotTran pc7


%% Load Cbathy
load(fullfile(prodir,app.ListBox_31.Value,'cBathyDepthProduct.mat'));


%% Plot Data


pbPlotTran.cX=localX;
pbPlotTran.cY=localY;
pbPlotTran.cZ=localDepth;

hold(app.UIAxes2_6,'on')
 axis(app.UIAxes2_6,'equal')


xlim(app.UIAxes2_6,[min(min(pbPlotTran.X)) max(max(pbPlotTran.X))])
ylim(app.UIAxes2_6,[min(min(pbPlotTran.Y)) max(max(pbPlotTran.Y))])
[min(min(pbPlotTran.cY)) max(max(pbPlotTran.cY))]
% Plot Data
pc7=pcolor(pbPlotTran.cX,pbPlotTran.cY,pbPlotTran.cZ,'parent',app.UIAxes2_6);
shading(app.UIAxes2_6,'flat');
c=colorbar(app.UIAxes2_6,'location','eastOutside');
c.Label.String=['[' pbPlotTran.Units ']'];
caxis(app.UIAxes2_6,[-50 0])

%% Change Profile
pbSolutionExpPlotProfile(app)