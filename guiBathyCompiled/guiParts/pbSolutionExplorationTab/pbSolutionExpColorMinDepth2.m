function pbSolutionExpColorMinDepth1(app)
cc=get(app.UIAxes2_6,'cLim');

caxis(app.UIAxes2_6,[  cc(1) app.DepthSlider_6.Value  ]);

ylim(app.UIAxes5_2,[app.DepthSlider_5.Value app.DepthSlider_6.Value])