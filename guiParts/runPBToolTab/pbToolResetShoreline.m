function pbToolResetShoreline(app)
global pbTran slLine exSlFlag


% Clear Variables
pbTran.slx=[];
pbTran.sly=[];
exSlFlag=0;


% REplot
slLine.YData=pbTran.sly;
slLine.XData=pbTran.slx;

%% Change Status Lamp
  
    app.Lamp_22.Color=[.5 .5 .5];
    app.Lamp_28.Color=[1 0 0];
    app.Lamp_25.Color=[.5 .5 .5];
    app.Lamp_26.Color=[.5 .5 .5];
