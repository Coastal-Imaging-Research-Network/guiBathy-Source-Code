function SolutionExplorationColorbarMin1(app)
cc=get(app.UIAxes2,'cLim');

caxis(app.UIAxes2,[app.DepthSlider.Value cc(2)]);

ylim(app.UIAxes5,[app.DepthSlider.Value app.DepthSlider_2.Value])