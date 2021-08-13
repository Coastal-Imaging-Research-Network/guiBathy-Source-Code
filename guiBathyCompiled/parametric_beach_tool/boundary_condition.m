function result = boundary_condition(p,args)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
beta_offshore = args(1);
beta_shoreline = args(2);
h_prime = args(3);
s_prime = args(4);

gamma = p(1);
kappa = p(2);

result(1,1) = h_prime - gamma * (exp(-kappa*s_prime) - 1) - ...
    beta_offshore*s_prime;
result(2,1) = beta_shoreline + gamma*kappa - beta_offshore;
end

