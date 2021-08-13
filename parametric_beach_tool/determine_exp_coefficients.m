function [output] = determine_exp_coefficients(p,args)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
s = args(1);
ss = args(2);
slope = args(3);

a = p(1);
b = p(2);

output = [a * exp(b*s) - ss;a*b*exp(b*s) - slope];
end

