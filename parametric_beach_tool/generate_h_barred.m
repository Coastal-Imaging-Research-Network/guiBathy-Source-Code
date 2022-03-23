function [h_barred] = generate_h_barred(ss,theta,psi)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
%func = zeros(size(theta));
%func(460:1163) = cos(theta(460:1163)-psi);
%h_barred = -1.0*ss.*func;
h_barred = -1.0*ss.*cos(theta-psi);
end

