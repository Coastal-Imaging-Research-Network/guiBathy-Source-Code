function SolutionExplorationColorbarMax1(app)
cc=get(app.UIAxes2,'cLim');

caxis(app.UIAxes2,[ cc(1) app.DepthSlider_2.Value]);

ylim(app.UIAxes5,[app.DepthSlider.Value app.DepthSlider_2.Value])