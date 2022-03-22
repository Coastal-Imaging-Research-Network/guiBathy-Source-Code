function addROI(app)
global R rCount

app.Lamp_33.Color=[0 1 0];



%% Draw Rectangle
rCount=rCount+1;
R{rCount}=drawrectangle(app.UIAxes_16);
app.Lamp_33.Color=[.5 .5 .5];


