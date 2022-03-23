function [gamma,kappa] = solve_boundary_equations(data,s_prime)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
h_prime = data.hoff;
p0 = [-2.0;0.04];
REF = [data.beta_off,data.beta_shore,h_prime,s_prime];
f = @(p)boundary_condition(p,REF); % function of dummy variable p
out = LMFsolve(f,p0);

gamma = out(1);
kappa = out(2);
end

