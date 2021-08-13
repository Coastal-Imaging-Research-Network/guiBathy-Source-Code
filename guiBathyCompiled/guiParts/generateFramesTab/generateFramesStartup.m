function generateFramesStartup(app)
global mdir

%% Check Project Loaded
if isempty(mdir)==1
    return
end

%% Display The list of Movies in The Table
 L=dir(mdir);
 L=L(3:end,:);
 
 % Put in Cell form and dont include frames tif
 count=0;
 for k=1:length(L(:,1))
     if isempty(strfind(L(k).name,'exampleFrame.jpg'))==1
        count=count+1;
        Lcell{count,1}=L(k).name;
     end
 end
                
              % Add Dummy Order Number
 for k=1:length(Lcell)
          LcellO{k,1}=Lcell{k};
          LcellO{k,2}=k;
 end
 app.UITable.Data=LcellO;


 
%% Enter Default Time in Time Entry

to=datevec(now);
app.UITable2.Data= { to(1) to(2) to(3) to(4) to(5) to(6)};



%% Enter Maximum Allowable FrameRate
v=VideoReader(fullfile(mdir,Lcell{1}));
frmax=v.FrameRate;
app.Label_21.Text=strcat('Maximum: ', num2str(frmax),' Hz');



%% Enter Default Saving Directory
app.DirectoryNameEditField.Value='uasFlight_XHz';


%% Enter Default FrameRate
app.FrameRateHzEditField.Value=2;