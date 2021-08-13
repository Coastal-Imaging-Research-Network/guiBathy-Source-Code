function pbExportBathyCBChoose(app)
global cbdir pbExporTran pc9

%% Reset Lamp
app.Lamp_27.Color=[.5 .5 .5];
%% Load Cbathy
load(fullfile(cbdir,app.ListBox_33.Value));


%% Load The Data
[pbExporTran.cX pbExporTran.cY]=meshgrid(bathy.xm,bathy.ym);
pbExporTran.cZ=-bathy.fCombined.h+bathy.tide.zt;
cbathyMeta.params=bathy.params;
pbExporTran.cbathyMeta=cbathyMeta;
pbExporTran.hErr=bathy.fCombined.hErr;
pbExporTran.bathy=bathy;

%% Plot Data
if isempty(pc9)==1
pc9=pcolor(pbExporTran.cX,pbExporTran.cY,pbExporTran.cZ,'parent',app.UIAxes2_9);
end

if isempty(pc9)==0
   for k=1:length(app.UIAxes2_9.Children)
        if strcmp(app.UIAxes2_9.Children(k).Type,'surface')==1
        app.UIAxes2_9.Children(k).Visible='off';
        end
    end
 pc9=pcolor(pbExporTran.cX,pbExporTran.cY,pbExporTran.cZ,'parent',app.UIAxes2_9);   
end

hold(app.UIAxes2_9,'on')
axis(app.UIAxes2_9,'equal')


xlim(app.UIAxes2_9,[min(min(pbExporTran.cX)) max(max(pbExporTran.cX))])
ylim(app.UIAxes2_9,[min(min(pbExporTran.cY)) max(max(pbExporTran.cY))])

shading(app.UIAxes2_9,'flat');

