function [ z ] = forward_prop( a,w2,w3,b2,b3 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[w2_rows, w2_cols] = size(w2); %just an error check
[a_rows, a_cols] = size(a); %just an error check

sum_y(:,1) = w2*a + b2;

[z_rows,z_cols] = size(sum_y); %just an error check
[b2_rows, b2_cols] = size(b2); %just an error check

y = sigmf(sum_y,[1,0]);

%output column
sum_z(:,1) = w3*y + b3;

z = sigmf(sum_z,[1,0]);


end

