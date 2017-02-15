function [ l ] = circularCorrelation( r1, r2 )
%calculation the circular correlation
%   l == r1 CC r2;
assert(length(r1)==length(r2));
Ka = length(r1);
l = zeros(1,Ka);
for i = 1:Ka
   l(i) = sum(r2(mod((0:Ka-1)-i+1,Ka)+1).'' .* r1); 
end
end

