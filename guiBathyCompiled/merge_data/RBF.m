function [K] = RBF(xx,yy,length_scale)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

pts1 = xx./length_scale;
pts2 = yy./length_scale;
% weight = var([pts1;pts2]);
% %
% for ii = 1:length(pts1)
%    u = pts1(ii,1) - pts2(:,1);
%    v = pts1(ii,2) - pts2(:,2);
%    distance(ii,:) = vecnorm(sqrt(1./weight).*[u,v],2,2);
%   % distance(ii,:) = sqrt( (pts1(ii,1)-pts2(:,1)).^2 + (pts1(ii,2)-pts2(:,2)).^2 );
% end
distance = sqeuclidean_dist(pts1,pts2);
K = exp(-.5*distance);
end

