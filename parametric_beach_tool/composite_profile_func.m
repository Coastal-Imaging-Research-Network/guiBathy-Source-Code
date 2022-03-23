function [h0] = composite_profile_func(s,beta_offshore,gamma,kappa)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%if gamma > 0
%    gamma = 0.0;
%end
h0 = gamma * (exp(-kappa*s) - 1) + beta_offshore*s;
%h0 = 0.1*s.^(2/3);
%h0 = 0.113*s.^(0.644);
end

