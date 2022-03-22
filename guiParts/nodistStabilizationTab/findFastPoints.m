function findFastPoints(app)

global R pointsA ptThresh


ptThresh = str2num(app.ThresholdEditField.Value);
app.UIAxes_16.Children(end)



pointsA=cornerPoints;
for k=1:length(R)    
    try
    pa=detectFASTFeatures(rgb2gray(app.UIAxes_16.Children(end).CData), 'MinContrast', ptThresh,'ROI',R{k}.Position);

    pointsA=cat(2,pointsA,pa);
    [C, ia, ic]=unique(pointsA.Location,'rows');
    pointsA=pointsA(ia)
     catch
    continue
      end
end

hold(app.UIAxes_16,'on')


for k=1:length(app.UIAxes_16.Children)
    if strcmp(app.UIAxes_16.Children(k).Type,'line')==1
        app.UIAxes_16.Children(k).XData=[];
        app.UIAxes_16.Children(k).YData=[];
    end
end
plot(pointsA.Location(:,1),pointsA.Location(:,2),'g.','parent',app.UIAxes_16);

