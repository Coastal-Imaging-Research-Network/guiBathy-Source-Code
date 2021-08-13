function pbExportBathyCLim(app)
cc=get(app.UIAxes2_10,'cLim');

caxis(app.UIAxes2_10,[  app.UITable10_6.Data{1,1} app.UITable10_6.Data{1,2} ]);
caxis(app.UIAxes2_8,[  app.UITable10_6.Data{1,1} app.UITable10_6.Data{1,2} ]);
caxis(app.UIAxes2_9,[  app.UITable10_6.Data{1,1} app.UITable10_6.Data{1,2} ]);

ylim(app.UIAxes6_2,[  app.UITable10_6.Data{1,1} app.UITable10_6.Data{1,2} ])

%% Reset Lamp
app.Lamp_27.Color=[.5 .5 .5];