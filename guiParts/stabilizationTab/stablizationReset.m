function stablizationReset(app)

%% Clear Table
[r c]=size(app.UITable9.Data);
for k=1:r
    for j=1:c
        app.UITable9.Data{k,j}=[];
    end
end

%% Change Lamps
app.Lamp_12.Color=[.5 .5 .5];
app.Lamp_13.Color=[.5 .5 .5];
