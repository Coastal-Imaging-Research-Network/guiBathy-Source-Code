function distance = sqeuclidean_dist(xx,yy)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%
u = xx(:,1) - yy(:,1)';
if size(xx,2) > 1
    v = xx(:,2) - yy(:,2)';
    distance = u.^2 + v.^2;
else
    distance = u.^2;
end
%weight = var(vertcat(xx,yy));
% for ii = 1:length(xx)
%   u = xx(ii,1) - yy(:,1);
%   if size(xx,2) > 1
%       v = xx(ii,2) - yy(:,2);
%       distance(ii,:) = u.^2 + v.^2;
%   else
%       distance(ii,:) = u.^2;
%   end
% end

end

