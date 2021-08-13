function pbSolutionExpColorMaxDepth2(app)
cc=get(app.UIAxes2_6,'cLim');

caxis(app.UIAxes2_6,[  app.DepthSlider_5.Value cc(2) ]);

ylim(app.UIAxes5_2,[app.DepthSlider_5.Value app.DepthSlider_6.Value])