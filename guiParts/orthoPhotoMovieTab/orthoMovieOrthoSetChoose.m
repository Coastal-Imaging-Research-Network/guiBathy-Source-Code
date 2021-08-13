function orthoMovieOrthoSetChoose(app)

global ordir dlist

%% Make Directory Lists
main_d=string(fullfile(ordir,app.ListBox_15.Value));
if strcmp(main_d,'-')==0


  geo_d=string(fullfile(main_d,'Geo_Grid'));
  ig_d=string(fullfile(geo_d,'images'));
  pg_d=string(fullfile(geo_d,'plots'));
  
  loco_d=string(fullfile(main_d,'Local_Grid'));
  il_d=string(fullfile(loco_d,'images'));
  pl_d=string(fullfile(loco_d,'plots'));
  
 dlist.ig_d=ig_d;
 dlist.pg_d=pg_d;

 dlist.il_d=il_d;
 dlist.pl_d=pl_d;
 
 
 %% Plot 
 orthoMovieTypeSelect(app)
 
 %% Change Output
 orthoMovieChngFname(app)
 
 %% Change  Table
 %% Change Table


orthoMovieReset(app)
app.UITable3_4.Data{1,1}=[];
app.UITable3_4.Data{1,2}=[];
end