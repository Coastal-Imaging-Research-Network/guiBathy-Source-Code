function pbToolResetSandbar(app)
global pbTran sbLine exSbFlag


% Clear Variables
pbTran.sbx=[];
pbTran.sby=[];

% REplot
sbLine.YData=pbTran.sby;
sbLine.XData=pbTran.sbx;

exSbFlag=0;

%% Change Status Lamp
    
    app.Lamp_23.Color=[.5 .5 .5];
    app.Lamp_28.Color=[1 0 0];
app.Lamp_25.Color=[.5 .5 .5];
app.Lamp_26.Color=[.5 .5 .5];



if app.Lamp_24.Color==[.5 .5 .5] | app.Lamp_24.Color==[0 1 0]
    app.Lamp_24.Color==[.5 .5 .5]
end