function [ retval ] = SFC_1Sample( SYSTEM, ESTIMATION, sSym, rSym, SC )
%SIC(serial interference cacellatioin)- FC (frenquncy correlation) algorithm implemention
% IN:
%   sSym <N_PRS x 1> subcarrier symbols with PRS
%   rSym <N_PRS x 1> subcarrier symbols with PRS
%   rSym <N_PRS x 1> subcarrier index  
% OUT:
%   ToA estimation

%extract parameters
FFTsize = SYSTEM.FFTsize;
range = ESTIMATION.pathSearchRange;
window = ESTIMATION.timeSearchWindow;
freqNoiseThr = ESTIMATION.SFC.noiseThreshold;

%variable preperation
H =  rSym .* sSym.'' ./ abs(sSym).^2;
phiIndex = -1i * (SC-1) / FFTsize * 2 * pi; 
 
%resource allocation
Tau = zeros(size(range));
Alpha = zeros(size(range));

%SIC stage
X = H;
for c = 1: length(range)
    l = range(c);
    [ Tau(c), Alpha(c) ] = Inner_SFCIter(Tau, Alpha, l, H, phiIndex, window);
    X = X - Alpha(c) * exp(phiIndex * Tau(c)); 
    if sum(abs(X).^2)/length(X) < freqNoiseThr
        break;
    end %end if
end   %end for range
%D = range(c);
retval = min(Tau(1:c));

end   %end function 

