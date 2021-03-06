function resetIOEOFig(app)
global fdir gcuxdir

%% Grab Value
gcname=app.ListBox_3.Value;

%% Load Mat File UvD
load(fullfile(gcuxdir,gcname));

%% Load Images
% Get Frame Set
fname=gcp(1).frameSet;
L=dir(fullfile(fdir,fname));
I=imread(fullfile(fdir,fname,L(3).name));


%% Load Images
cla(app.UIAxes_6)
imshow(I,'Parent',app.UIAxes_6)
hold(app.UIAxes_6,'on')

%% Add legend to Figure
% h= legend(app.UIAxes_6,'Clicked','Reprojected')
% Put Fake GCP Valuies
  h(1)=plot(nan,nan,'ro','markersize',10,'linewidth',3,'parent',app.UIAxes_6);
   h(2)=plot(nan,nan,'yo','markersize',10,'linewidth',3,'parent',app.UIAxes_6);
  h(3)=plot(nan,nan,'gx','markersize',10,'linewidth',3,'parent',app.UIAxes_6);
 r=legend(app.UIAxes_6,h,{'Clicked GCPs','Used GCPs',' Reprojected GCPs'});
 r.AutoUpdate='off';
r.Location='NorthOutside';
 r.Orientation='horizontal';

 %% Find Which Ones to Will be used
if length(app.GCPNumbersEditField.Value)>0
C=strsplit(app.GCPNumbersEditField.Value,',');

for k=1:length(C)
    gcpsUsed(k)=str2num(C{k});
end
else
    gcpsUsed=[];
end

 %% Plot GCPs
for k=1:length(gcp)
    if ismember(gcp(k).num,gcpsUsed)==0
    plot(gcp(k).UVd(1),gcp(k).UVd(2),'ro','markersize',10,'linewidth',3,'parent',app.UIAxes_6);
    text(gcp(k).UVd(1),gcp(k).UVd(2),num2str(gcp(k).num),'parent',app.UIAxes_6,'color','w','fontweight','bold','fontsize',15);
    end
    
       if ismember(gcp(k).num,gcpsUsed)==1
    plot(gcp(k).UVd(1),gcp(k).UVd(2),'yo','markersize',10,'linewidth',3,'parent',app.UIAxes_6);
    text(gcp(k).UVd(1),gcp(k).UVd(2),num2str(gcp(k).num),'parent',app.UIAxes_6,'color','w','fontweight','bold','fontsize',15);
    end
end
