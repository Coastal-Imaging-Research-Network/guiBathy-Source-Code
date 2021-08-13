function extrinsicsResetSolve(app)
global gcpie

%% Lamp Reset
%Reset Saving Lamp
app.Lamp_10.Color=[.5 .5 .5];
%Reset Solving Lamp
app.Lamp_9.Color=[.5 .5 .5];


%% Reset Fig
m=length(app.UIAxes_6.Children);
n=(4+length(gcpie)*2);
if m>n
    for k=(n+1):m
app.UIAxes_6.Children(m-k+1).Visible='off';
    end
end


%% Reset Soltuion metrics
for k=1:6
    for j=2:3
        app.UITable7.Data{k,j}=[];
    end
end

[r c]=size(app.UITable7_2.Data);
for k=1:r
    for j=2:3
        app.UITable7_2.Data{k,j}=[];
    end
end


