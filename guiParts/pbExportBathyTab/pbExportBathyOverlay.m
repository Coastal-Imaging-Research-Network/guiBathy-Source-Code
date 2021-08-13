function pbExportBathyOverlay(app)
global pc8 pc9 pc10 

pc10.FaceAlpha=1-app.OverlaySlider_6.Value/100;
pc9.FaceAlpha=1-app.OverlaySlider_6.Value/100;
pc8.FaceAlpha=1-app.OverlaySlider_6.Value/100;

%% Reset Lamp
app.Lamp_27.Color=[.5 .5 .5];