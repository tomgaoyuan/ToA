function [ a1 ] = Inner_LS( R, ToAs, phiIndex )
%INNER_LS  ineer part of MusicLSMmdl algorithm

N = size(R, 2);
D = length(ToAs);
phiOftau = zeros(size(R,1), D);
for c = 1: D
    phiOftau(:, c) = exp(phiIndex * ToAs(c));
end %end for
Tmp = (phiOftau'* phiOftau) \ phiOftau';
a1 = zeros(N, 1);
for c = 1: N
   a1(c) = Tmp(1, :) * R(:, c); 
end 

end

