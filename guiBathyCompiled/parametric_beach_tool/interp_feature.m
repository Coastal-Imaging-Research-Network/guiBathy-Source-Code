function [x_feature] = interp_feature(feature,y_new)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
x = feature(:,1);
y = feature(:,2);
[~,idx] = sort(y);
x = x(idx);
y = y(idx);
x_feature = spline(y,x,y_new);

end

