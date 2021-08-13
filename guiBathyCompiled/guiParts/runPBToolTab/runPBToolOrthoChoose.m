function runPBToolOrthoChoose(app)


global ordir gdir prodir pbTran oxline  bsxline oxtext bsxtext slLine sbLine cbpcolor


%% Load Grid File 
main_d=fullfile(ordir,app.ListBox_28.Value);
if strcmp(app.ListBox_28.Value,'-')==0

L=dir(main_d);

for k=1:length(L)
    chk=strfind(L(k).name,'.mat');
    if isempty(chk)==0
        load(fullfile(main_d,L(k).name));
    end
end
load(fullfile(gdir,gridFile))

% Need to Save so not overwritten by cbathy files
pblocalX=localX;
pblocalY=localY;

%% Load Timex
o_d=fullfile(ordir,app.ListBox_28.Value,'Local_Grid','images');
L=dir(o_d);


for k=3:length(L)
    chk=strfind(L(k).name,'timex.png');
    if isempty(chk)==0
        tfile=fullfile(o_d,L(k).name);
    end   
end
I=flipud(imread(tfile));


%% Load Potential Cbathy List
L=dir(prodir);
count=0;
clist={};
for k=3:length(L)
    L2=dir(fullfile(prodir,L(k).name));
    
    for j=1:length(L2)
            chk=strfind(L2(j).name,'cBathyDepthProduct.mat');
            if isempty(chk)==0
               % Check that all units and datums same
            load(fullfile(prodir,L(k).name,L2(j).name));
             chk2=strcmp(gridMeta.worldCoordSysH,worldCoordSysH);
             chk3=strcmp(gridMeta.worldCoordSysV,worldCoordSysV);
             chk4=strcmp(gridMeta.worldCoordSysUnits,worldCoordSysUnits);

             if (chk2+chk3+chk4)==3
                 count=count+1;
                 clist{count}=L(k).name;
             end 
           end 
    end    
end

app.ListBox_29.Items=clist;

%Reset Local Grid Names
localX=pblocalX;
localY=pblocalY;

%% Plot Timex
hold(app.UIAxes_15,'on');
imagesc(localX(1,:),localY(:,1),I,'parent',app.UIAxes_15 )
xlim(app.UIAxes_15,[min(min(localX)) max(max(localX))])
ylim(app.UIAxes_15,[min(min(localY)) max(max(localY))])
set(app.UIAxes_15,'ydir','normal')


%% Initial Guess for Cross shore Coordinates
xE=localX(1,end)-localX(1,1);
app.EditField_2.Value= localX(1,1)+.95*xE;
app.EditField_4.Value= localX(1,1)+.65*xE;

%% Initial Guess for Desired Resolution
app.UITable12.Data{1,1}=nanmean(diff(localX(1,:)))*5;
app.UITable12.Data{1,2}=nanmean(diff(localY(:,1)))*5;


%% Plot Dummy Cbathy
app.cBathySlider.Value=100;
app.ListBox_29.Value={};
cbpcolor=pcolor(pblocalX,pblocalY,pblocalX.*nan,'parent',app.UIAxes_15);
cbpcolor.EdgeColor='none';

%% Plot Initial Guess

oxline=plot([app.EditField_2.Value app.EditField_2.Value],[min(localY(:,1)) max(localY(:,1))],'r','linewidth',2,'parent',app.UIAxes_15);
oxtext=text(app.EditField_2.Value, max(localY(:,1)), 'Offshore ','HorizontalAlignment','right','VerticalAlignment','Top','parent',app.UIAxes_15,'Color','r','Fontweight','bold','FontSize',14);;

bsxline=plot([app.EditField_4.Value app.EditField_4.Value],[min(localY(:,1)) max(localY(:,1))],'b','linewidth',2,'parent',app.UIAxes_15);
bsxtext=text(app.EditField_4.Value, max(localY(:,1)), 'Bar Seaward ','HorizontalAlignment','right','VerticalAlignment','Top','parent',app.UIAxes_15,'Color','b','Fontweight','bold','FontSize',14);;

%% Plot Dummy Shorelines
slLine=plot(nan,nan,'m-*','linewidth',1,'color','m','parent',app.UIAxes_15);
sbLine=plot(nan,nan,'g*-','linewidth',1,'color','g','parent',app.UIAxes_15);

%% Set Up Extrapolation Limits
app.EditField_5.Value=min(min(localY));
app.EditField_6.Value=max(max(localY));



%% Initialize Transfer File
pbTran.slx=[];
pbTran.sly=[];
pbTran.sbx=[];
pbTran.sby=[];
pbTran.I=I;
pbTran.X=localX;
pbTran.Y=localY;
pbTran.ox=app.EditField_2.Value;
pbTran.bsx=app.EditField_4.Value;
pbTran.Units=initialCamSolutionMeta.worldCoordSysUnits;
pbTran.worldCoordSysH=initialCamSolutionMeta.worldCoordSysH;
pbTran.worldCoordSysV=initialCamSolutionMeta.worldCoordSysV;
pbTran.tide=tide;
pbTran.mwlElevation=nanmean(nanmean(localZ));

%% Set Up Saving Name
app.FilenameEditField_12.Value=strcat(app.ListBox_28.Value,'_PBTool');

%% Units
app.Label_334.Text=['[' pbTran.Units ']'];
app.Label_335.Text=['[' pbTran.Units ']'];

app.UITable11.ColumnName{1}=['Offshore Depth' ' ' '[' pbTran.Units ']'];
app.UITable11.ColumnName{2}=['Bar Seaward Depth' ' ' '[' pbTran.Units ']'];
app.UITable11.ColumnName{3}=['Offshore Slope' ' ' '[' pbTran.Units '/' pbTran.Units  ']'];
app.UITable11.ColumnName{4}=['Onshore Slope' ' ' '[' pbTran.Units '/' pbTran.Units  ']'];

xlabel(app.UIAxes_15, ['X' ' ' '[' pbTran.Units ']'])
ylabel(app.UIAxes_15, ['Y' ' ' '[' pbTran.Units ']'])
app.UITable12.ColumnName{1}=['X' ' ' '[' pbTran.Units ']'];
app.UITable12.ColumnName{2}=['Y' ' ' '[' pbTran.Units ']'];

app.YminLabel.Text=['Y min [' pbTran.Units ']'];
app.YmaxLabel.Text=['Y max [' pbTran.Units ']'];

%% Change Lamps
    app.Lamp_23.Color=[.5 .5 .5];
app.Lamp_22.Color=[.5 .5 .5];
    app.Lamp_28.Color=[1 0 0];
    app.Lamp_25.Color=[.5 .5 .5];
    app.Lamp_26.Color=[.5 .5 .5];
    app.Lamp_24.Color==[1 0 0];
 
    
    %% Add Default Values for Cbathy Estimation (necessary to enter values
    app.UITable11.Data{1,1}=0;
        app.UITable11.Data{1,2}=0;
    app.UITable11.Data{1,3}=0;
    app.UITable11.Data{1,4}=0;
end