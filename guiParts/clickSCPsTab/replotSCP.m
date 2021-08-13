function replotSCP(app)
global Iscp sUVdClick

%% Get Radius
R=app.SearchRadiusEditField.Value;


%% Get Slider Value
Th=app.IntensityThresholdSlider.Value;


%% Get Dark or Bright Feature
if app.BrightButton_2.Value==1
    brightFlag='bright';
end
if app.DarkButton.Value==1
    brightFlag='dark';
end


%% Get Click of Udo Vdo
Udo=sUVdClick(end,1);
Vdo=sUVdClick(end,2);



%% Calculate Radius and Threshold
 [ Udn, Vdn, i, udi,vdi] = thresholdCenter(Iscp,Udo,Vdo,R,Th,brightFlag);
 
%% Plot Full Intensity Image
 imagesc(udi,vdi,i,'parent',app.UIAxes);
 set(app.UIAxes,'ydir','reverse')
 app.UIAxes.XLim=[udi(1) udi(end)];
 app.UIAxes.YLim=[vdi(1) vdi(end)];
colorbar(app.UIAxes);
caxis(app.UIAxes,[0 256])


%% Plot Thresholded Image
 if strcmp(brightFlag,'bright')==1
                        imagesc(udi,vdi,i>Th,'parent',app.UIAxes_2); 
                        set(app.UIAxes_2,'ydir','reverse')  
                    end
                    if strcmp(brightFlag,'dark')==1
                        imagesc(udi,vdi,i<Th,'parent',app.UIAxes_2); 
                        set(app.UIAxes_2,'ydir','reverse')  
                    end

 app.UIAxes_2.XLim=[udi(1) udi(end)];
 app.UIAxes_2.YLim=[vdi(1) vdi(end)];
hh=colorbar(app.UIAxes_2);

cmap=parula(100);
cmap=cmap([1 100],:);
colormap(app.UIAxes_2,cmap)
 hh.Ticks=[0 1];
 
 
 %% Plot Center Point
 hold(app.UIAxes_2,'on')
 plot(Udn,Vdn,'ko','markersize',10,'markerfacecolor','w','parent',app.UIAxes_2);
 title(app.UIAxes_2,['Threshold Intensity: ' num2str(Th)])
 hold(app.UIAxes,'on')
 plot(Udn,Vdn,'ko','markersize',10,'markerfacecolor','w','parent',app.UIAxes);
  hold(app.UIAxes,'off')
  hold(app.UIAxes_2,'off')
