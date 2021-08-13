function chngOrigin(app)
global originValue

%% Get Clicking Point
temp = app.UIAxes.CurrentPoint; % Returns 2x3 array of points
loc = [temp(1,1) temp(1,2)]; % Gets the (x,y) coordinates 

app.UITable10.Data{1,1}=loc(1);
app.UITable10.Data{1,2}=loc(2);

replotGridOrtho(app)
%% Set Flag to End Add GCPS
originValue=0;

