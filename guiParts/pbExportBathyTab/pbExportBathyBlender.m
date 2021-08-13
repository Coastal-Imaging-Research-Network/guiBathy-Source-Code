function pbExportBathyBlender(app)
global pbExporTran pc9

%% Pull Important Values
pbZ=pbExporTran.pbZ;
X=pbExporTran.X;
Y=pbExporTran.Y;

cX=pbExporTran.cX;
cY=pbExporTran.cY;
cZ=pbExporTran.cZ;

%% If no cBathy is selected, output just PB Tool, and Smooth
if isempty(app.ListBox_33.Value)==1
    Zout=pbZi;    
end


%% If cbathy is slected, blend the two
if isempty(app.ListBox_33.Value)==0
    
    %Weighting Factors
    scale_factor=1-app.PBToolEditField.Value/100;
    if scale_factor==0
        scale_factor=.001;
    end
    %Smoothing Factors
    if app.XSmoothingDistanceEditField_3.Value>1 & app.YSmoothingDistanceEditField_3.Value>1
    length_scale = [app.XSmoothingDistanceEditField_3.Value,app.YSmoothingDistanceEditField_3.Value];
    else
    length_scale =[1,1];
    end



obs.x = pbExporTran.bathy.xm;
obs.y = pbExporTran.bathy.ym;
indx = pbExporTran.bathy.fCombined.hErr > app.cBathyEditField.Value;
obs.h = pbExporTran.bathy.fCombined.h-pbExporTran.bathy.tide.zt;
obs.h(indx) = NaN;
prior.x = pbExporTran.pbData.x;
prior.y = pbExporTran.pbData.y;
prior.h = -pbExporTran.pbZ;
prior.h = pbExporTran.pbData.h-pbExporTran.pbMeta.tide;




options = struct('length_scale',length_scale,'scale_factor',scale_factor);
datar = merge_data(prior,obs,options);
 
    
   Zout=-datar.h;
end


% Get Mask
Zout=interp2(pbExporTran.pbX,pbExporTran.pbY,-Zout,pbExporTran.X,pbExporTran.Y);
%% Get Mask
Isum=sum(double(flipud(imread(pbExporTran.tfile))),3);
msk=Zout.*0+1;
bind=find(Isum<=min(min(Isum)));
msk(bind)=nan;
pbExporTran.pbBlend=Zout.*msk;  



%% Plot Data
pbExportBathyRePlot(app)
app.Lamp_29.Color=[0 1 0];
