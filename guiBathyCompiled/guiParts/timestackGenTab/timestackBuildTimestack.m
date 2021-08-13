function timestackBuildTimestack(app)

global ordir gdir stacktran

%% Reset Values
timestackReset(app)

%% Load Grid File 


main_d=fullfile(ordir,app.ListBox_16.Value);
L=dir(main_d);

for k=1:length(L)
    chk=strfind(L(k).name,'.mat');
    if isempty(chk)==0
        load(fullfile(main_d,L(k).name));
    end
end
load(fullfile(gdir,gridFile))


%% Pull Resolution
v=app.ListBox_18.Value;
v=strsplit(v,'x');
res=str2num(v{1});
rmult=round(res./mean(diff(localX(1,:))));

%% Set Up Directory for images
o_d=fullfile(ordir,app.ListBox_16.Value,'Local_Grid','images');
L=dir(o_d);

%% Pull Adapt HistQu Value
if app.Button.Value==1
    aval=0;
end
if app.Button_2.Value==1
    aval=1;
end
if app.Button_3.Value==1
    aval=2;
end
if app.Button_4.Value==1
    aval=3;
end




%% make Grid
x=localX(1:rmult:end,1:rmult:end);
y=localY(1:rmult:end,1:rmult:end);
z=localZ(1:rmult:end,1:rmult:end)+tide;
xyz2=[x(:) y(:) z(:)];


%% Start Loading Images
%initialize Matrix
[r c]=size(x);
tt=length(t);
istack=nan(r,c,tt);

count=0;
for k=3:length(L)
 %% Load Image
if isempty(strfind(L(k).name,'timex.png'))==1 & isempty(strfind(L(k).name,'bright.png'))==1 & isempty(strfind(L(k).name,'.avi'))==1 
  I=rgb2gray(flipud(imread(fullfile(o_d,L(k).name))));   
   I=I(1:rmult:end,1:rmult:end);
 
   %% Apply Adapt HisEQ
   if aval>0
    for j=1:aval
        I=adapthisteq(I);
    end
   end
   count=count+1;
   app.UITable3_5.Data{1,1}=count;

   istack(:,:,count)=I;
end
end

%% Find minim values (black spaces) and make nans so easy to find
mv=10;
bind=find(istack<=mv);
istack(bind)=nan;




%% Get Into Cbathy Format
[xindgrid,yindgrid]=meshgrid(1:c,1:r);
rowIND=yindgrid(:);
colIND=xindgrid(:);
counter=0;
%% Only consider points that have no nan values. 
for i=1:length(rowIND(:))
    data2=reshape(istack(rowIND(i),colIND(i),:),tt,1);
    bind=find(isnan(data2)==1);
    if isempty(bind)==1
        counter=counter+1;
        data(:,counter)=data2;
        xyz(counter,:)=xyz2(i,:);
    end
end



%% Make t into epoch time
t=(t-datenum(1970,1,1)).*24.*3600;
%% Set Up transfer varaiable
stacktran.data=data;
stacktran.t=t;
stacktran.xyz=xyz;
stacktran.stackMeta.AdaptNum=aval;
stacktran.stackMeta.Res=res;
stacktran.stackMeta.Orthoset=app.ListBox_16.Value;
stacktran.x=x;
stacktran.y=y;
stacktran.z=z;
stacktran.tide=tide;
stacktran.stackMeta.Units=initialCamSolutionMeta.worldCoordSysUnits;
stacktran.stackMeta.worldCoordSysH=initialCamSolutionMeta.worldCoordSysH;
stacktran.stackMeta.worldCoordSysV=initialCamSolutionMeta.worldCoordSysV;
stacktran.Io=istack(:,:,1);
%% Change Status Lamp
    app.Lamp_17.Color=[0 1 0];