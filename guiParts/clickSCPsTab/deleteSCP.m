function deleteSCP(app)
global sUVdClick   deleteSCPValue

%% Get Clicking Point
temp = app.UIAxes_7.CurrentPoint; % Returns 2x3 array of points
loc = [temp(1,1) temp(1,2)]; % Gets the (x,y) coordinates 
             

%% Get Closest Point
Idx = knnsearch(sUVdClick(:,1:2),loc);



%% Remove Point Visually and Make a Marker That is Bad
N=length(sUVdClick(:,1,1))+1; 
app.UIAxes_7.Children(N-(Idx)).Visible='off';
sUVdClick(Idx,3)=0;


%% Set Flag to End Add GCPS
deleteSCPValue=0;


