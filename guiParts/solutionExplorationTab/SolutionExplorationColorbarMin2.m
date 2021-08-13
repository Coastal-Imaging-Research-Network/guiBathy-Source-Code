function SolutionExplorationColorbarMin2(app)
cc=get(app.UIAxes2_2,'cLim');

caxis(app.UIAxes2_2,[app.ErrorSlider.Value cc(2)]);