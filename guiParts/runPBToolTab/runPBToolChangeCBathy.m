function runPBToolChangeCBathy(app)
global prodir pbTran  cbpcolor 

%% Load Cbathy FIle
L=dir(prodir);
count=0;

for k=3:length(L)
    chk=strcmp(app.ListBox_29.Value,L(k).name);
    if chk==1
        L2=dir(fullfile(prodir,L(k).name));
            for j=1:length(L2)
            chk2=strfind(L2(j).name,'cBathyDepthProduct.mat');
            if isempty(chk2)==0
            load(fullfile(prodir,L(k).name,L2(j).name));
            end
            end
    end
end





cbi=interp2(localX,localY,localDepth-mwlElevation,pbTran.X,pbTran.Y);

cbpcolor.CData=cbi;
cbpcolor.FaceAlpha=1-app.cBathySlider.Value/100;
pbTran.Depth=localDepth-mwlElevation;
pbTran.tide=tide;

%% Initialize And Start Alongshore Coordinate For Cbathy Estimate


cb=colorbar(app.UIAxes_15,'location','south');
cb.Label.String=[ '[' pbTran.Units ']'];
cb.Color='y';


%% Give suggested Resolution for Tool
app.UITable12.Data{1,1}=cbathyMeta.params.dxm;
app.UITable12.Data{1,2}=cbathyMeta.params.dym;

%% REset Lamp
app.Lamp_25.Color=[.5 .5 .5];
app.Lamp_26.Color=[.5 .5 .5];