function [ slope ] = quick_regress(yvals)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

y1 = ones(length(yvals),1);
y = [y1 yvals'];

x1 = (1:length(yvals))';
b0 = x1\y;

slope = b0(1);
end

