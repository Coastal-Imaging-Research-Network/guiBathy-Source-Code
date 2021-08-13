function clearFramesTab(app)

% Reset lamp
app.Lamp_4.Color=[.5 .5 .5];
[r c]=(size(app.UITable.Data));
% Reset Tables
for k=1:r
    app.UITable3.Data{k,2}=[];
end

app.UITable3_2.Data{1,1}=[];
app.UITable3_2.Data{1,2}=[];
app.UITable3_2.Data{1,3}=[];
