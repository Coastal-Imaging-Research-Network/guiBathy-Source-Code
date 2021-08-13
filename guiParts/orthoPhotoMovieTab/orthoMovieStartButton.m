function orthoMovieStartButton(app)
global dlist ordir prodir


%% Get Correct FrameRate
main_d=string(fullfile(ordir,app.ListBox_15.Value));
L=dir(main_d);

for k=1:length(L)
    chk=strfind(L(k).name,'.mat');
    if isempty(chk)==0
        load(fullfile(main_d, L(k).name))
    end
end

ttemp = diff(t.*24*3600);
ii = ~isnan(ttemp);
fr=1./mean(ttemp(ii));

chk=strsplit(app.PlaybackSpeedListBox.Value,'x');

if length(chk)==1
    fr=fr;
end
if length(chk)>1
      mu=str2num(chk{1});
    fr=mu.*fr;  
end


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

L=dir(duse);
app.UITable3_4.Data{1,1}=0;

app.UITable3_4.Data{1,2}=(length(t));


%% Pull Name Save
oname=app.FilenameEditField_9.Value;

%% Pull Quality
chk=strsplit(app.QualityAffectsMovieSizeListBox.Value,'%');
qua=str2num(chk{1});



%% Start Movie
v=VideoWriter(fullfile(prodir,[oname,'.avi']));
v.Quality=qua;
v.FrameRate=fr;

open(v)
count=0;
for k=3:length(L)
    
   %% Check if Timex or bright
   if isempty(strfind(L(k).name,'timex.png'))==1 & isempty(strfind(L(k).name,'bright.png'))==1 & isempty(strfind(L(k).name,'.avi'))==1
   count=count+1;
    %% Load Image
   I=imread(fullfile(duse,L(k).name));
    app.UITable3_4.Data{1,1}=count;
    writeVideo(v,I);
    

   end
    
    
    
    
end
close(v)

    %% Change Status Lamp
    app.Lamp_16.Color=[0 1 0];