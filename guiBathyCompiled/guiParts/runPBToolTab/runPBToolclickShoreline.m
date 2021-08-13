function runPBToolclickShoreline(app)
global  pbTran slLine
app.Lamp_25.Color=[.5 .5 .5];
app.Lamp_26.Color=[.5 .5 .5];
%% Get Clicking Point
temp = app.UIAxes_15.CurrentPoint; % Returns 2x3 array of points
loc = [temp(1,1) temp(1,2)]; % Gets the (x,y) coordinates 


%% Asign To Global Variable
pbTran.slx=cat(1,pbTran.slx,loc(1));
pbTran.sly=cat(1,pbTran.sly,loc(2));


%% Change Plot
slLine.YData=pbTran.sly;
slLine.XData=pbTran.slx;


%% Change Status Lamp
    if app.Lamp_24.Color==[.5 .5 .5] | app.Lamp_24.Color==[0 1 0]
    app.Lamp_24.Color==[.5 .5 .5];
    end
    app.Lamp_22.Color=[1 0 0];
