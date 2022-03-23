function pbToolCBathyEstimate(app)
global pbTran

%% Estimate Depth Offshore

pbTran.ox=app.EditField_2.Value;
[m i]=min(abs(pbTran.X(1,:)-pbTran.ox));

gind=find(isnan(pbTran.Depth(:,i))==0);
do=nanmean(pbTran.Depth(gind,i));
pbTran.od=do;
D{1,1}=abs(do);



%% Estimate Depth Seward of Bar
pbTran.bsx=app.EditField_4.Value;
[m i]=min(abs(pbTran.X(1,:)-pbTran.bsx));
gind=find(isnan(pbTran.Depth(:,i))==0);
db=nanmean(pbTran.Depth(gind,i));
pbTran.bsd=db;
D{1,2}=abs(db);



%% Estimate  Shoreline Slope
% Interpolate the Clicks onto the grid
slxi=interp1(pbTran.sly,pbTran.slx,pbTran.Y(:,1));
slyi=pbTran.Y(:,1);
di=slyi.*0; 

sbxi=interp1(pbTran.sby,pbTran.sbx,pbTran.Y(:,1));
sbyi=pbTran.Y(:,1);

% Find distance between shoreline and sandbar
dis=abs(slxi-sbxi);
% Take a value 25% off the shoreline.
pval=.75;
sbxi=sbxi-pval*dis;
% Esitmate Depths at new line
[i]=knnsearch([pbTran.X(:) pbTran.Y(:)],[sbxi sbyi]);
dib=pbTran.Depth(i);


% Find the Differences in Depth
dd=dib-di;
% Find the Differences in X
dx=dis.*(1-pval);

% Calculate Slope (negative, getting deeper)
chk=dd./dx;
gind=find(isnan(chk)==0);

pbTran.onslope=nanmean(chk);
% Check Quality
p=sum(isnan(dd));

if p./length(dd)>.75
    pbTran.onslope=nan;
end


D{1,4}=abs(pbTran.onslope);




%% Estimate  Offhshore Slope
dd=do-db; %Depth Difference between seward bar and offshore
dx=app.EditField_2.Value-app.EditField_4.Value; % X distance
chk=dd./dx;
gind=find(isnan(chk)==0);

pbTran.offslope=nanmean(chk);

D{1,3}=abs(pbTran.offslope);

%% Put In table
app.UITable11.Data=D;


%% Change Status Lamp
    app.Lamp_24.Color=[0 1 0];