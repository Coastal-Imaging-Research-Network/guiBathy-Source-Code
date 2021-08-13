function exportBathymetryClim(app)

caxis(app.UIAxes2_3,[app.UITable10_5.Data{1,1}  app.UITable10_5.Data{1,2}]);
caxis(app.UIAxes2_4,[app.UITable10_5.Data{1,1}  app.UITable10_5.Data{1,2}]);
ylim(app.UIAxes6,[app.UITable10_5.Data{1,1}  app.UITable10_5.Data{1,2}])

%% Reset
app.Lamp_21.Color=[.5 .5 .5];
