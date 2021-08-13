function distance = seuclidean_dist(xx,yy)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%
%weight = var(vertcat(xx,yy));
%for ii = 1:length(xx)
%   u = xx(ii,1) - yy(:,1);
%   if size(xx,2) > 1
%       v = xx(ii,2) - yy(:,2);
       %temp1 = [repmat(xx(ii,1),[length(yy),1]),yy(:,1)];
       %temp2 = [repmat(xx(ii,2),[length(yy),1]),yy(:,2)];
       %weight = [var(temp1,0,2),var(temp2,0,2)];
%       distance(ii,:) = u.^2 + v.^2;
%   else
%       weight = var([xx(ii,1);yy(:,1)]);
%       distance(ii,:) = norm(1./sqrt(weight).*u,2);
%   end
%end

end

