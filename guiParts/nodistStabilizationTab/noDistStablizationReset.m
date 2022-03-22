function noDistStablizationReset(app)
global R rCount
%% Clear Table
app.ListBox_35.Items={}; 

%% Clear Figures
cla(app.UIAxes_16)
title(app.UIAxes_16,[''])


%% Change Lamps
app.Lamp_32.Color=[.5 .5 .5];
app.Lamp_31.Color=[.5 .5 .5];

%% Reset Value
app.ThresholdEditField.Value='.1';

%% Reset Count
rCount=0;
R=[];
