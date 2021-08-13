function pbSolutionExpColorMaxDepth1(app)
cc=get(app.UIAxes2_5,'cLim');

caxis(app.UIAxes2_5,[  app.DepthSlider_3.Value cc(2) ]);

ylim(app.UIAxes5_2,[app.DepthSlider_3.Value app.DepthSlider_4.Value])