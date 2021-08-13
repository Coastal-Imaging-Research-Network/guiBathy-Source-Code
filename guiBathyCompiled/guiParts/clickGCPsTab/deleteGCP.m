function deleteGCP(app)
global UVdClick   deleteGCPValue

%% Get Clicking Point
temp = app.UIAxes_4.CurrentPoint; % Returns 2x3 array of points
loc = [temp(1,1) temp(1,2)]; % Gets the (x,y) coordinates 
display(loc)
             

%% Get Closest Point
Idx = knnsearch(UVdClick(:,1:2),loc);



%% Remove Point Visually and Make a Marker That is Bad
N=length(UVdClick(:,1,1))+1; 
app.UIAxes_4.Children(N-(Idx)).Visible='off';
UVdClick(Idx,3)=0;
display(UVdClick)


%% Set Flag to End Add GCPS
deleteGCPValue=0;

