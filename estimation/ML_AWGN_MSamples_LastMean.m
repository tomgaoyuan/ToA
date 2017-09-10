function [retval] = ML_AWGN_MSamples_LastMean (SYSTEM, ESTIMATION, sSym, rSym, SC)
% Tackle with multiple samples
% IN:
%   sSym <N x sample number>

tmp = zeros(1, size(sSym,2));
for c = 1: size(sSym,2)
  tmp(c) = ML_AWGN_1Sample (SYSTEM, ESTIMATION, sSym(:, c), rSym(:, c), SC(:, c));
end
retval = mean(tmp);

end
