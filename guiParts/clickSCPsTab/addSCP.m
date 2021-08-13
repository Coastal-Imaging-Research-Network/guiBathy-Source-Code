function addSCP(app)
global sUVdClick addSCPValue scpApp 

%% Get Clicking Point
temp = app.UIAxes_7.CurrentPoint; % Returns 2x3 array of points
loc = [temp(1,1) temp(1,2)]; % Gets the (x,y) coordinates 
             
%% Save In UVdClick
if isnan(sUVdClick(1,1))==0
    sUVdClick=cat(1,sUVdClick,[loc 1]);
end

if isnan(sUVdClick(1,1))==1 
    sUVdClick(1,:)= [loc 1];
end



%% Plot In axes
hold(app.UIAxes_7,'on')
plot(sUVdClick(end,1),sUVdClick(end,2),'ro','markersize',10,'linewidth',3,'parent',app.UIAxes_7);


%% Set Flag to End Add GCPS
addSCPValue=0;


%% Pull SCP App
scpApp=scpThreshold;


