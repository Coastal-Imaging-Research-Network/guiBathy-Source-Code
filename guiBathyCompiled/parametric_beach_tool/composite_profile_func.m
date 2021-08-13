function [h0] = composite_profile_func(s,beta_offshore,gamma,kappa)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
h0 = gamma * (exp(-kappa*s) - 1) + beta_offshore*s;
end

