% test merge data
tic

%% original test
load('uasFlight_2Hz_Orthos_Timestack_cbathy.mat')
obs.x = bathy.xm;
obs.y = bathy.ym;
indx = bathy.fCombined.hErr > 0.5;
obs.h = bathy.fCombined.h;
obs.h(indx) = NaN;

load('uasFlight_2Hz_Orthos_PBTool.mat')
prior.x = pbData.x;
prior.y = pbData.y;
prior.h = pbData.h;

%obs.x = prior.x;
%obs.y = prior.y;
%obs.h = prior.h + 0.5;

% %% large array test removing nans
% load('cBathyDepthProduct.mat')
% nn = 0;
% for iy = 1:length(localY(:,1))
%     indx = ~isnan(localDepth(iy,:));
%     if ~isempty(localX(1,indx))
%         nn = nn + 1;
%         obs.y(1,nn) = localY(iy,1);
%         obs.h(nn,:) = -1.0*localDepth(iy,:);
%     end
% end
% obs.x = localX(1,:);
% 
% 
% load('PBToolCombinedDepthProduct.mat')
% nn = 0;
% for iy = 1:length(localY(:,1))
%     indx = ~isnan(localDepth(iy,:));
%     if ~isempty(localX(1,indx))
%         nn = nn + 1;
%         prior.y(1,nn) = localY(iy,1);
%         prior.h(nn,:) = -1.0*localDepth(iy,:);
%     end
% end
% prior.x = localX(1,:);

%% test array input
% load('cBathyDepthProduct.mat')
% obs.x = localX(1:5:end,1:5:end);
% obs.y = localY(1:5:end,1:5:end);
% obs.h = -1.0*localDepth(1:5:end,1:5:end);
% 
% 
% load('PBToolCombinedDepthProduct.mat')
% prior.x = localX(1:5:end,1:5:end);
% prior.y = localY(1:5:end,1:5:end);
% prior.h = -1.0*localDepth(1:5:end,1:5:end);

%%
length_scale = [40,50];
scale_factor = 0.5;

options = struct('length_scale',length_scale,'scale_factor',scale_factor);
data = merge_data(prior,obs,options);

% plotting results

figure(1)
hh = pcolor(data.x,data.y,data.h);
set(hh,'edgecolor','none')
aa = colorbar;
hold on
plot(data.obs(:,1),data.obs(:,2),'o')
aa.Label.String = 'Elevation (m)';
xlabel('Distance offshore (m)')
ylabel('Distance alongshore (m)')

pb_slice = 15;
[~,cb_slice] = min(abs(data.y(pb_slice) - obs.y));
figure(2)
hold on
plot(obs.x,-1*obs.h(cb_slice,:),'ko')
plot(prior.x,-1.*prior.h(pb_slice,:),'b-')
plot(data.x,data.h(pb_slice,:),'g')
plot(data.x,data.h(pb_slice,:)-2.*data.hErr(pb_slice,:),'g--', ...
    data.x,data.h(pb_slice,:)+2.*data.hErr(pb_slice,:),'g--')
legend(['fCom y=',num2str(obs.y(cb_slice))], ...
   ['Prior y=',num2str(prior.y(pb_slice))], ...
   ['Post y=',num2str(data.y(pb_slice))]);
xlabel('Distance offshore (m)')
ylabel('Elevation (m)')
hold off
toc