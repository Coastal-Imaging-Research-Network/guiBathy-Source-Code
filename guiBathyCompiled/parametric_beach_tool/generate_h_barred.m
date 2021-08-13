function [h_barred] = generate_h_barred(ss,theta,psi)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

h_barred = -1.0*ss.*cos(theta-psi);
end

