function [slope] = compute_discontinuity_slope(s,ss,s_discontinuity)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
dss = ss(s == s_discontinuity) - ss(s == s_discontinuity - 1);
dx = s_discontinuity - s(s == s_discontinuity - 1);
slope = dss/dx;
end

