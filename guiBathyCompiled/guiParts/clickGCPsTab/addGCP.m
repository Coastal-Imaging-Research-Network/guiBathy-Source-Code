function addGCP(app)
global UVdClick addGCPValue 
%% Get Clicking Point
temp = app.UIAxes_4.CurrentPoint; % Returns 2x3 array of points
loc = [temp(1,1) temp(1,2)]; % Gets the (x,y) coordinates 
             

%% Save In UVdClick
if isnan(UVdClick(1,1))==0
    UVdClick=cat(1,UVdClick,[loc 1]);
end

if isnan(UVdClick(1,1))==1 
    UVdClick(1,:)= [loc 1];
end



%% Plot In axes
hold(app.UIAxes_4,'on')
plot(UVdClick(end,1),UVdClick(end,2),'ro','markersize',10,'linewidth',3,'parent',app.UIAxes_4);


%% Set Flag to End Add GCPS
addGCPValue=0;