function  exportBathymetryOverlaySlider(app)
global pc1 pc2
pc1.FaceAlpha=1-app.OverlaySlider_3.Value/100;
pc2.FaceAlpha=1-app.OverlaySlider_3.Value/100;

%% Reset
app.Lamp_21.Color=[.5 .5 .5];
