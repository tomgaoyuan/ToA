function [ retval ] = SS_1Sample( SYSTEM, ESTIMATION, sSym, rSym, SC )
%SIC-SAGEM algorithm implemention
% IN:
%   sSym <N_PRS x 1> subcarrier symbols with PRS
%   rSym <N_PRS x 1> subcarrier symbols with PRS
%   rSym <N_PRS x 1> subcarrier index  

%extract parameters
FFTsize = SYSTEM.FFTsize;
range = ESTIMATION.pathSearchRange;
window = ESTIMATION.timeSearchWindow;
H =  rSym .* sSym.'' ./ abs(sSym).^2;
phiIndex = -1i * (SC-1) / FFTsize * 2 * pi;  

%SIC stage
for l = range
    [ newTau, newAlpha ] = Inner_SAGEIter(tau, alpha, l, H, phiIndex, window);
    
end     %end for range
%SAGEM stage
while true 
    
end     %end while

end

