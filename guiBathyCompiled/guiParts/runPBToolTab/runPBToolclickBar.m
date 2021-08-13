function runPBToolclickBar(app)
global  pbTran sbLine
app.Lamp_25.Color=[.5 .5 .5];
app.Lamp_26.Color=[.5 .5 .5];

%% Get Clicking Point
temp = app.UIAxes_15.CurrentPoint; % Returns 2x3 array of points
loc = [temp(1,1) temp(1,2)]; % Gets the (x,y) coordinates 


%% Asign To Global Variable
pbTran.sbx=cat(1,pbTran.sbx,loc(1));
pbTran.sby=cat(1,pbTran.sby,loc(2));


%% Change Plot
sbLine.YData=pbTran.sby;
sbLine.XData=pbTran.sbx;


%% Change Status Lamp
    app.Lamp_23.Color=[1 0 0];
    if app.Lamp_24.Color==[.5 .5 .5] | app.Lamp_24.Color==[0 1 0]
    app.Lamp_24.Color==[.5 .5 .5]
    end