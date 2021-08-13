function distance = euclidean_dist(xx,yy)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%
u = xx(:,1) - yy(:,1)';
if size(xx,2) > 1
    v = xx(:,2) - yy(:,2)';
    distance = sqrt(u.^2 + v.^2);
    %distance = vecnorm([u,v],2);
else
    distance = sqrt(u.^2);
    %distance = norm(u,2);
end

% for ii = 1:length(xx)
%   u = xx(ii,1) - yy(:,1);
%   if size(xx,2) > 1
%       v = xx(ii,2) - yy(:,2);
%       distance(ii,:) = vecnorm([u,v],2,2);
%   else
%       distance(ii,:) = norm(u,2);
%   end
%   % distance(ii,:) = sqrt( (pts1(ii,1)-pts2(:,1)).^2 + (pts1(ii,2)-pts2(:,2)).^2 );
% %end
% 
 end

