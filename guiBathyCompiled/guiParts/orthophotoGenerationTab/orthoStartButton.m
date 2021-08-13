function orthoStartButton(app)
global ordir  fdir  gdir vedir

%% Make New Directories
  main_d=string(fullfile(ordir,app.OutputDirectoryNameEditField.Value ));
  geo_d=string(fullfile(main_d,'Geo_Grid'));
  ig_d=string(fullfile(geo_d,'images'));
  pg_d=string(fullfile(geo_d,'plots'));
  
    loco_d=string(fullfile(main_d,'Local_Grid'));
  il_d=string(fullfile(loco_d,'images'));
  pl_d=string(fullfile(loco_d,'plots'));
  
  mkdir(main_d)
  mkdir(geo_d)
  mkdir(ig_d)
  mkdir(pg_d)
  mkdir(loco_d)
  mkdir(il_d)
  mkdir(pl_d)
  
  
  %% Load Necesssary Files  
%% Load Grid
gname=app.ListBox_12.Value;
load(fullfile(gdir,gname));
ixlim=[min(min(localX)) max(max(localX))];
iylim=[min(min(localY)) max(max(localY))];

localT=double(cat(3,localX.*0,localX.*0,localX.*0));
localB=double(cat(3,localX.*0,localX.*0,localX.*0));
geoT=double(cat(3,X.*0,X.*0,X.*0));
geoB=double(cat(3,X.*0,X.*0,X.*0));

%% Load Solution
vename=app.ListBox_14.Value;
load(fullfile(vedir,vename));

%% Load Image List
fname=app.ListBox_13.Value;
L=dir(fullfile(fdir,fname));

%% Load Tide
tide=app.EditField.Value;

%% Start Loop
for k=3:length(L);
    
%% Load Image
I=imread(fullfile(fdir,fname,L(k).name));

%% Rectify Local Image

localExtrinsics = localTransformExtrinsics(localOrigin,localAngle,1,extrinsicsVariable(k-2,:));
[localIr]= imageRectifier(I,intrinsics,localExtrinsics,localX,localY,localZ+tide,0);

    % Construct Timex
    localT=localT+double(localIr);

    % Construct Bright
    chk=cat(4,localB,double(localIr));
    localB=max(chk,[],4);

    %Write Image
    iname=strsplit(string(L(k).name),'.');
    iname=strsplit(iname{1},'_');
    imwrite(flipud(localIr),fullfile(il_d,['ortho_local_image_',iname{2},'.png']));

    
 %% Rectify Georectified Image
[geoIr]= imageRectifier(I,intrinsics,extrinsicsVariable(k-2,:),X,Y,Z+tide,0);

    % Construct Timex
    geoT=geoT+double(geoIr);

    % Construct Bright
    chk=cat(4,geoB,double(geoIr));
    geoB=max(chk,[],4);

    %Write Image
    iname=strsplit(string(L(k).name),'.');
    iname=strsplit(iname{1},'_');
    imwrite(flipud(geoIr),fullfile(ig_d,['ortho_geo_image_',iname{2},'.png']));
    
    %% Make Plot
    set(0,'DefaultFigureVisible','off')
    f1=figure;
    imagesc(localX(1,:),localY(:,1),localIr);
    hold('on')
    axis('equal')
    xlim(ixlim)
    ylim(iylim)
    set(gca,'ydir','normal')
   xlabel(['X', ' ','[' initialCamSolutionMeta.worldCoordSysUnits,']'])
    ylabel(['Y', ' ','[' initialCamSolutionMeta.worldCoordSysUnits,']'])
    title(datestr(t(k-2),'mmm dd, yyyy -- HH:MM:SS.FFF'))
    F=getframe(f1);
    imwrite(F.cdata,fullfile(pl_d,['ortho_local_plot_',iname{2},'.png']));
    close(f1)
    
    %% Make Plot
    set(0,'DefaultFigureVisible','off')
    f1=figure;
    imagesc(X(1,:),Y(:,1),geoIr);
    hold('on')
    axis('equal')
    xlim([min(min(X)) max(max(X))])
    ylim([min(min(Y)) max(max(Y))])
    set(gca,'ydir','normal')
   xlabel(['E', ' ','[' initialCamSolutionMeta.worldCoordSysUnits,']'])
    ylabel(['N', ' ','[' initialCamSolutionMeta.worldCoordSysUnits,']'])
    title(datestr(t(k-2),'mmm dd, yyyy -- HH:MM:SS.FFF'))
    F=getframe(f1);
    imwrite(F.cdata,fullfile(pg_d,['ortho_geo_plot_',iname{2},'.png']));
    close(f1)
    
%% Display Stuff   
    % Display Timex
    cla(app.UIAxes_10)
    imagesc(localX(1,:),localY(:,1),uint8((localT)/(k-2)),'parent',app.UIAxes_10);
    hold(app.UIAxes_10,'on')
    axis(app.UIAxes_10,'equal')
    xlim(app.UIAxes_10,ixlim)
    ylim(app.UIAxes_10,iylim)
    set(app.UIAxes_10,'ydir','normal')
    
    
    % Display Bright
    cla(app.UIAxes_11)

    imagesc(localX(1,:),localY(:,1),uint8((localB)),'parent',app.UIAxes_11);
    hold(app.UIAxes_11,'on')
    axis(app.UIAxes_11,'equal')
    xlim(app.UIAxes_11,ixlim)
    ylim(app.UIAxes_11,iylim)
    set(app.UIAxes_11,'ydir','normal')
    
    % Update Counter
    app.UITable3_3.Data{1,1}=k-2;
    % Pause to Plot
     pause(.001)
end

%% Save Timex and Brightest
    imwrite(flipud(uint8((localT)/(k-2))),fullfile(il_d,'ortho_local_image_timex.png'));
    imwrite(flipud(uint8((geoT)/(k-2))),fullfile(ig_d,'ortho_geo_image_timex.png'));
    imwrite(flipud(uint8((geoB))),fullfile(ig_d,'ortho_geo_image_bright.png'));
    imwrite(flipud(uint8((localB))),fullfile(il_d,'ortho_local_image_bright.png'));
    
    
    set(0,'DefaultFigureVisible','off')
    f1=figure;
    imagesc(X(1,:),Y(:,1),uint8((geoT)/(k-2)));
    hold('on')
    axis('equal')
    xlim([min(min(X)) max(max(X))])
    ylim([min(min(Y)) max(max(Y))])
    set(gca,'ydir','normal')
   xlabel(['E', ' ','[' initialCamSolutionMeta.worldCoordSysUnits,']'])
    ylabel(['N', ' ','[' initialCamSolutionMeta.worldCoordSysUnits,']'])
    title('Timex')
    F=getframe(f1);
    imwrite(F.cdata,fullfile(pg_d,'ortho_geo_plot_timex.png'));
    close(f1)
    
    set(0,'DefaultFigureVisible','off')
    f1=figure;
    imagesc(X(1,:),Y(:,1),uint8((geoB)));
    hold('on')
    axis('equal')
    xlim([min(min(X)) max(max(X))])
    ylim([min(min(Y)) max(max(Y))])
    set(gca,'ydir','normal')
   xlabel(['E', ' ','[' initialCamSolutionMeta.worldCoordSysUnits,']'])
    ylabel(['N', ' ','[' initialCamSolutionMeta.worldCoordSysUnits,']'])
    title('Bright')
    F=getframe(f1);
    imwrite(F.cdata,fullfile(pg_d,'ortho_geo_plot_bright.png'));
    close(f1)

    set(0,'DefaultFigureVisible','off')
    f1=figure;
    imagesc(localX(1,:),localY(:,1),uint8((localT)/(k-2)));
    hold('on')
    axis('equal')
     xlim([min(min(localX)) max(max(localX))])
    ylim([min(min(localY)) max(max(localY))])
    set(gca,'ydir','normal')
       xlabel(['X', ' ','[' initialCamSolutionMeta.worldCoordSysUnits,']'])
    ylabel(['Y', ' ','[' initialCamSolutionMeta.worldCoordSysUnits,']'])
    title('Timex')
    F=getframe(f1);
    imwrite(F.cdata,fullfile(pl_d,'ortho_local_plot_timex.png'));
    close(f1)
    
    set(0,'DefaultFigureVisible','off')
    f1=figure;
    imagesc(localX(1,:),localY(:,1),uint8((localB)));
    hold('on')
    axis('equal')
    xlim([min(min(localX)) max(max(localX))])
    ylim([min(min(localY)) max(max(localY))])
    set(gca,'ydir','normal')
    xlabel(['X', ' ','[' initialCamSolutionMeta.worldCoordSysUnits,']'])
    ylabel(['Y', ' ','[' initialCamSolutionMeta.worldCoordSysUnits,']'])
    title('Bright')
    F=getframe(f1);
    imwrite(F.cdata,fullfile(pl_d,'ortho_local_plot_bright.png'));
    close(f1)
    set(0,'DefaultFigureVisible','on')

    %% Save Meta Data
    gridFile=gname;
    save(fullfile(main_d,[app.OutputDirectoryNameEditField.Value,'_meta']),'t','initialCamSolutionMeta','variableCamSolutionMeta','gridFile','tide')
    
    
    %% Change Status Lamp
    app.Lamp_15.Color=[0 1 0];