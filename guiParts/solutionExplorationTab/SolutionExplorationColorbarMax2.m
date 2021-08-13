function SolutionExplorationColorbarMax2(app)
cc=get(app.UIAxes2_2,'cLim');

caxis(app.UIAxes2_2,[ cc(1) app.ErrorSlider_2.Value]);