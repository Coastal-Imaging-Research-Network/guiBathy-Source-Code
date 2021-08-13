function orthoMovieTypeSelect(app)
global dlist

%% Pull Correct Directory

if app.LocalButton.Value==1 & app.AxesButton.Value==1
    duse=dlist.pl_d;
           
end

if app.LocalButton.Value==1 & app.AxesButton.Value==0
    duse=dlist.il_d;
end

if app.LocalButton.Value==0 & app.AxesButton.Value==0
    duse=dlist.ig_d;
end

if app.LocalButton.Value==0 & app.AxesButton.Value==1
    duse=dlist.pg_d;
end


%% Plot Image
L=dir(duse);
I=imread(fullfile(duse,L(3).name));
imshow(I,'parent',app.UIAxes_12)

%% Change Output Name
orthoMovieChngFname(app)

%% Reset
orthoMovieReset(app)