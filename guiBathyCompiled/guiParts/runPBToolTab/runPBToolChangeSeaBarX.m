function runPBToolChangeSeaBarX(app)
global bsxtext bsxline pbTran
if app.Lamp_24.Color==[.5 .5 .5] | app.Lamp_24.Color==[0 1 0]
    app.Lamp_24.Color==[.5 .5 .5]
end
app.Lamp_25.Color=[.5 .5 .5];
app.Lamp_26.Color=[.5 .5 .5];

bsxtext.Position=[ app.EditField_4.Value, max(pbTran.Y(:,1)) 0];
bsxline.XData=[app.EditField_4.Value app.EditField_4.Value];

