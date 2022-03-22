function timestackPlotRes(app)
global ordir gdir

%% Load Grid File and Pull Appropriate Resolutions
main_d=fullfile(ordir,app.ListBox_16.Value);
L=dir(main_d);

for k=1:length(L)
    chk=strfind(L(k).name,'.mat');
    if isempty(chk)==0
        load(fullfile(main_d,L(k).name));
    end
end

load(fullfile(gdir,gridFile))


%% Clear Axes
cla(app.UIAxes_13)
xlabel(app.UIAxes_13, ['X' ' ' '[' initialCamSolutionMeta.worldCoordSysUnits ']'])
ylabel(app.UIAxes_13, ['Y' ' ' '[' initialCamSolutionMeta.worldCoordSysUnits ']'])

%% Plot Resolution
v=app.ListBox_18.Value;
v=strsplit(v,'x');
res=str2num(v{1});
rmult=(res./mean(diff(localX(1,:))));

%% Set Up Directory for images
o_d=fullfile(ordir,app.ListBox_16.Value,'Local_Grid','images');
L=dir(o_d);

flag=1;
while flag==1;
for k=3:length(L)
    
 %% Load Image
if isempty(strfind(L(k).name,'timex.png'))==1 & isempty(strfind(L(k).name,'bright.png'))==1 & isempty(strfind(L(k).name,'.avi'))==1 
   I=imread(fullfile(o_d,L(k).name));
   flag=0;
end
end
end

%% Apply Adapt HistEq
Iready=flipud(rgb2gray(I(1:rmult:end,1:rmult:end,:)));

if app.Button.Value==1
    K=0;
end
if app.Button_2.Value==1
    K=1;
end
if app.Button_3.Value==1
    K=2;
end
if app.Button_4.Value==1
    K=3;
end

if K>0
    for k=1:K
        Iready=adapthisteq(Iready);
    end
end
%% Plot Image
imagesc(localX(1,1:rmult:end),localY(1:rmult:end,1),Iready,'parent',app.UIAxes_13)
colormap(app.UIAxes_13,'gray')
set(app.UIAxes_13,'ydir','normal')
axis(app.UIAxes_13,'equal')
 xlim(app.UIAxes_13, [min(min(localX)) max(max(localX))])
ylim(app.UIAxes_13, [min(min(localY)) max(max(localY))])
app.UIAxes_13.XTick=[min(min(localX)): nanmean(diff(app.UIAxes_13.YTick)):max(max(localX))]; %weird bug- not sure why it does this 