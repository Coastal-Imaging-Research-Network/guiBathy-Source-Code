function  clickGCPsUVdChoose(app)
global fdir gcudir

%% Grab Value
gcname=app.ListBox_2.Value;


if strcmp(gcname,'-')==0

%% Load Mat File UvD
load(fullfile(gcudir,gcname));


%% Load Images
% Get Frame Set
fname=gcp(1).frameSet;
L=dir(fullfile(fdir,fname));

% Load First Imate
I=imread(fullfile(fdir,fname,L(3).name)); %might need a bracket tjh
imshow(I,'Parent',app.UIAxes_5)
hold(app.UIAxes_5,'on')


%% Plot GCPs
for k=1:length(gcp)
    plot(gcp(k).UVd(1),gcp(k).UVd(2),'ro','markersize',10,'linewidth',3,'parent',app.UIAxes_5);
    text(gcp(k).UVd(1),gcp(k).UVd(2),num2str(gcp(k).num),'parent',app.UIAxes_5,'color','y','fontweight','bold','fontsize',15);

end


%% Enter GCPs into Table


for k=1:length(gcp)
    tdata{k,1}=gcp(k).num;
    tdata{k,2}=0;
    tdata{k,3}=0;
    tdata{k,4}=0;
end
app.UITable5.Data=tdata;



%% Change Default Value to Save AS
gcname=strsplit(gcname,'.mat');
 app.FilenameEditField_4.Value=string(strcat(gcname{1},'XYZ'));
end