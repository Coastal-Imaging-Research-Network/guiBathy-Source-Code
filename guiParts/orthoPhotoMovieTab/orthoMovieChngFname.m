function orthoMovieChngFname(app)


if app.LocalButton.Value==1 & app.AxesButton.Value==1
dname=strcat(app.ListBox_15.Value,'_LocalAxes_',app.PlaybackSpeedListBox.Value);
           
end

if app.LocalButton.Value==1 & app.AxesButton.Value==0
dname=strcat(app.ListBox_15.Value,'_LocalNoAxes_',app.PlaybackSpeedListBox.Value);
end

if app.LocalButton.Value==0 & app.AxesButton.Value==0
dname=strcat(app.ListBox_15.Value,'_GeoNoAxes_',app.PlaybackSpeedListBox.Value);
end

if app.LocalButton.Value==0 & app.AxesButton.Value==1
dname=strcat(app.ListBox_15.Value,'_GeoAxes_',app.PlaybackSpeedListBox.Value);
end

app.FilenameEditField_9.Value=dname;

