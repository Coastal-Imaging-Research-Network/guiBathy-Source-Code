function [exp_decay_coefficients] = solve_exp_coefficients(ss,s,s_discontinuity,discontinuity_slope)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
REF = [s_discontinuity,ss(s == s_discontinuity),discontinuity_slope];
f = @(p) determine_exp_coefficients(p,REF);
exp_decay_coefficients = LMFsolve(f,[1000,-0.01]);

end

