function runPBToolChangeOffshoreX(app)
global oxtext oxline pbTran
if app.Lamp_24.Color==[.5 .5 .5] | app.Lamp_24.Color==[0 1 0]
    app.Lamp_24.Color==[.5 .5 .5]
end

app.Lamp_25.Color=[.5 .5 .5];
app.Lamp_26.Color=[.5 .5 .5];

oxtext.Position=[ app.EditField_2.Value, max(pbTran.Y(:,1)) 0];
oxline.XData=[app.EditField_2.Value app.EditField_2.Value];

