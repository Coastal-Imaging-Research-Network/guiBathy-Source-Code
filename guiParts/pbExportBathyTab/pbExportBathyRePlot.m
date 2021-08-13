function pbExportBathyRePlot(app)
global pbExporTran pc8 pc9

%% Replot Blended Stuff

 pc8.CData=pbExporTran.pbBlend;

 %% Rplot Error Cbathy
 obs.x = pbExporTran.bathy.xm;
obs.y = pbExporTran.bathy.ym;
indx = pbExporTran.bathy.fCombined.hErr > app.cBathyEditField.Value;
obs.h = pbExporTran.bathy.fCombined.h-pbExporTran.bathy.tide.zt;
obs.h(indx) = NaN;
pc9.CData=-obs.h;

%% REplot Profiles
pbExportBathyPlotProfile(app)
%% Reset Lamp
app.Lamp_27.Color=[.5 .5 .5];