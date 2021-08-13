function extractFramesButton(app)
global mdir fdir

%% Make New Frames Folder

fname=[app.DirectoryNameEditField.Value];
mkdir(fdir,fname)
delete(fullfile(fdir,fname,'*')); 

%% Pull Video List and Order
vlist=app.UITable.Data;
[J I]=size(vlist);
for k=1:J
    
    ind(k)=vlist{k,2};  
    
end
[s i]=sort(ind);
count=0;

for k=1:length(ind)
    if s(k)~=0
        count=count+1;
    mList{count}=vlist{i(k)};
    end
end


%% Pull Framerate Value and Time Value
frameRate=app.FrameRateHzEditField.Value;
tData=app.UITable2.Data;
to=datenum(tData{1},tData{2},tData{3},tData{4},tData{5},tData{6});
to=(to-datenum(1970,1,1)).*24*3600; % Epoch TIme 


%% Enter Processing Status
for k=1:length(mList)
psCell{k,1}=mList{k};
psCell{k,2}=0;
psCell{k,3}=0;
end
app.UITable3.Data=psCell;

%% Start Pulling Frames
% Load Video
Tcount=1;
for j=1:length(mList)

v=VideoReader(fullfile(mdir, strtrim(mList{j})));


% Initialize Loop
k=1;
count=1;
numFrames= v.Duration.*v.FrameRate;



app.UITable3.Data{j,3}=floor(v.Duration.*frameRate);


%app.UITable3.Data{j,3}=round(v.numFrames);

 while k<=((numFrames))
   try 
     % Read Frame
    I=read(v,k);  

     % Get time 
     if k==1
        vto=v.CurrentTime;
    end
    t=v.CurrentTime;
    ts= (t-vto)+to; % Make sure time is referenced to user specified time
                    % useful in case video encoded time is incorrect.
    % Record Time in millisecons (Avoid '.' in file names)
    
    %Because of the way Matlab defines time. 
    if k==numFrames
        ts=ts+1./v.FrameRate;
    end
    ts=round(ts.*1000);
    
  
  
    
  
    
    
    
    % Write Image
    imwrite(I,fullfile(fdir,fname, ['Frame_', num2str(ts), '.jpg']))
           
    % Display Completion Rate
    app.UITable3.Data{j,2}=count;

    % Save timing information
    T(Tcount)=ts/1000; % In Seconds
    count=count+1;
    Tcount=Tcount+1;
    
    % Get Indicie of Next Frame
    k=k+round(v.FrameRate./frameRate);
    
    
   
    % Display Image Comment out for faster performance  
    if count==2
         imshow(I,'Parent',app.UIAxes_3) % Show Example Frame
        pause(.1)
    end
  
    catch
        k=k+round(v.FrameRate./frameRate);
   end
 disp(k)
 end
 to=ts/1000+1./frameRate;
end

%% Display Statistics
dsCell{1}=1./frameRate;
Ttemp = diff(T(1:end-1));
ii = ~isnan(Ttemp);
dsCell{2}=mean(Ttemp(ii));
dsCell{3}=mean(sqrt(var(Ttemp(ii))));
app.UITable3_2.Data=dsCell;

%% Change Status Lamp
app.Lamp_4.Color=[0 1 0];