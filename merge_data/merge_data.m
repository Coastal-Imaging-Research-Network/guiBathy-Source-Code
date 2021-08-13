function [data] = merge_data(prior,obs,options)
PRIOR_STD_MIN = 1.e-2; %1 cm min noise for prior
OBS_STD_MIN   = 1.e-1; %10 cm min noise for obs

length_scale = options.length_scale;
scale_factor = options.scale_factor;
scale_factor = max(0.,min(1.,scale_factor));


if size(prior.x,1) == 1
    [xp,yp] = meshgrid(prior.x,prior.y);
    hp = griddata(prior.x,prior.y,prior.h,xp,yp);
    x_s = prior.x;
    y_s = prior.y;
else
    %xp = prior.x;
    %yp = prior.y;
    hp = prior.h;
    x_s = prior.x(1,:);
    y_s = prior.y(:,1);
end
if size(obs.x,1) > 1
    obs.x = obs.x(1,:);
    obs.y = obs.y(:,1)';
end


%nx = length(xp);
%ny = length(yp);
h_s = hp;


ipnan = ~isnan(hp);

[~,idmin] = min(abs(obs.y - y_s(1)));
[~,idmax] = min(abs(obs.y - y_s(end)));

x_s_cb = obs.x;
y_s_cb = obs.y(1,idmin:idmax-1);
h_s_cb = obs.h(idmin:idmax-1,:);
disp(['PB extents for y = [',num2str(y_s(1)),' ',num2str(y_s(end)),'] ', ...
    'Cbathy extents [',num2str(y_s_cb(1)),' ',num2str(y_s_cb(end)),']']);



%figure(1);
%pb_slice = 15;
%[~,cb_slice] = min(abs(y_s(pb_slice) - y_s_cb));
%plot(x_s_cb,-h_s_cb(cb_slice,:),'ko',x_s,-h_s(pb_slice,:),'b')
%legend(['fCom y=',num2str(y_s_cb(cb_slice))],['PB y=',num2str(y_s(pb_slice))]);

[X,Y] = meshgrid(x_s,y_s);
[X_cb,Y_cb] = meshgrid(x_s_cb,y_s_cb);

zi  = griddata(x_s,y_s,h_s,X_cb,Y_cb);
%find zero
for iy = 1:length(y_s_cb)
    idd = zi(iy,:) == 0;
    [~,shore] = max(x_s_cb(idd));
    h_s_cb(iy,idd) = 0.0;
end

x_max = x_s(end);
x_min = x_s(1);
y_max = y_s(end);
y_min = y_s(1);

inside = X_cb < x_max & X_cb > x_min & Y_cb < y_max & Y_cb > y_min;

h_cb = h_s_cb(inside);
X_cb = X_cb(inside);
Y_cb = Y_cb(inside);

goodvals = ~isnan(h_cb);
h_cb = h_cb(goodvals);
X_cb = X_cb(goodvals);
Y_cb = Y_cb(goodvals);

% figure(1)
% scatter(X_cb,Y_cb,300,h_cb,'.')
% colorbar

% to transform or not
pts = [reshape(X,[],1),reshape(Y,[],1)];
pts_cb = [X_cb,Y_cb];

h = reshape(h_s,[],1);

% for ii = 1:length(pts_cb)
%    distance(ii,:) = sqrt( (pts_cb(ii,1)-pts(:,1)).^2 + (pts_cb(ii,2)-pts(:,2)).^2 );
% end
distance = euclidean_dist(pts_cb,pts);
[~,nearest_indices] = min(distance,[],2);
cb_bounds = ~isnan(h(nearest_indices));

pts_cb = pts_cb(cb_bounds,:);
h_cb = h_cb(cb_bounds);

pb_mask = ipnan;
pb_mask = reshape(pb_mask,[],1);

h = h(pb_mask);
pts = pts(pb_mask,:);


%figure(1)
%scatter(pts(:,1),pts(:,2),300,h,'.')
%colorbar

% for ii = 1:length(pts_cb)
%    distance2(ii,:) = sqrt( (pts_cb(ii,1)-pts(:,1)).^2 + (pts_cb(ii,2)-pts(:,2)).^2 );
% end
distance2 = euclidean_dist(pts_cb,pts);
[~,nearest_indices2] = min(distance2,[],2);

Hx = pts(sort(nearest_indices2),:);
Hh = h(sort(nearest_indices2));

%mwf try different scalings for variances
%obs_var = (1-scale_factor)^2;
%prior_var = (scale_factor)^2;
obs_var   = (OBS_STD_MIN + 1.-scale_factor)^2;
prior_var = (PRIOR_STD_MIN + scale_factor)^2; 

nobs = length(pts_cb);
R = diag(ones(1,nobs)).*obs_var;

prior_length_scale = length_scale;

%prior_mean = h;
PB = prior_var.*RBF(pts,pts,prior_length_scale);
HPbHT = prior_var.*RBF(Hx,Hx,prior_length_scale);
PbHT = prior_var.*RBF(pts,Hx,prior_length_scale);

A = HPbHT + R;
K = linsolve(A,PbHT')';
Pa = PB - K*PbHT';

innovation = h_cb - Hh; %need to recheck h_cb coordinate

h_a = h + K * innovation;
sigma_a = sqrt(diag(Pa));

% figure(1)
% scatter(pts(:,1),pts(:,2),300,h_a,'.')
% colorbar
 
 h_a_grid = nan(size(h_s));
sigma_a_grid = nan(size(h_s));

h_a_grid = reshape(h_a_grid,[],1);
sigma_a_grid = reshape(sigma_a_grid,[],1);
h_a_grid(pb_mask) = h_a;
sigma_a_grid(pb_mask) = sigma_a;
h_a_grid = reshape(h_a_grid,size(h_s));
sigma_a_grid = reshape(sigma_a_grid,size(h_s));

% figure(2)
% hh = pcolor(X,Y,h_a_grid);
% set(hh,'edgecolor','none')
% colorbar
% 
% pb_slice = 14;
% [~,cb_slice] = min(abs(y_s(pb_slice) - y_s_cb));
% figure(3)
% hold on
% plot(x_s_cb,-h_s_cb(cb_slice,:),'ko')
% plot(x_s,-h_s(pb_slice,:),'b')
% plot(x_s,-h_a_grid(pb_slice,:),'g')
% plot(x_s,-h_a_grid(pb_slice,:)-2.*sigma_a_grid(pb_slice,:),'g--', ...
%     x_s,-h_a_grid(pb_slice,:)+sigma_a_grid(pb_slice,:),'g--')
% legend(['fCom y=',num2str(y_s_cb(cb_slice))], ...
%     ['Prior y=',num2str(y_s(pb_slice))], ...
%     ['Post y=',num2str(y_s(pb_slice))]);
% hold off
data = struct('x',X,'y',Y,'h',-h_a_grid,'hErr',sigma_a_grid,'obs',pts_cb);
