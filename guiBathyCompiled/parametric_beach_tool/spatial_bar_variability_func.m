function [ss] = spatial_bar_variability_func(s,h0,s_max,s_off,h_sea)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
delta = 0.3;
a = 0.53;
b = 0.57;
c = 0.09;
h_shore = 0;

ss = zeros(size(h0));
ss_max = 0.2*h_sea;

h_norm = (h0 - h_shore) / (h_sea - h_shore);

ss(h_norm < 1) = delta * s(h_norm < 1) / s_off + ...
    (ss_max - delta*s_max/s_off)* exp(-1*((1-h_norm(h_norm < 1)).^a - b).^2/c);
end

