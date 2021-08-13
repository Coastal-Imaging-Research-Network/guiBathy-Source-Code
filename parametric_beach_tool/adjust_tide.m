function [new_shoreline]= adjust_tide(shoreline,beta_shoreline,tide)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
delx = tide/beta_shoreline;
new_shoreline = shoreline + delx;

end

