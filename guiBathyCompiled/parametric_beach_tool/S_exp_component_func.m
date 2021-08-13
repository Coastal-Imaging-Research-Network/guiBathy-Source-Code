function [exp_values] = S_exp_component_func(h0,hsea)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
a = 0.53;
b = 0.57;
c = 0.09;

h_shore = 0;

exp_values = zeros(size(h0));
h_norm = (h0 - h_shore) / (hsea - h_shore);
exp_values(h_norm < 1) = exp(-1*((1-h_norm(h_norm < 1)).^a - b).^2 /c);
end

