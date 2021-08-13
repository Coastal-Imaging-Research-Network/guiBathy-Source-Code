function [theta] = phase_structure_func(s,h0,s_off)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
a_L = 100;
b_L = 0.27;
pi = 3.14;
theta = zeros(size(s));
local_bar_wavelength = a_L * exp(b_L*h0);
integrand = 2.0*pi./local_bar_wavelength;
for idx = 1:length(s)-1
    integration_range = s(idx:end)+1;
    theta(idx) = trapz(integration_range,integrand(integration_range)) * -1.0;
end
theta(idx+1) = theta(idx);
end

