function [retval] = TC_Thrs_MSamples_LastMean (SYSTEM, ESTIMATION, st, rt)
% Tackle with multiple samples
% IN:
%   st <N x sample number> 1 symbol in time domain
%   rt <N x sample number> 1 symbol in time domain

tmp = zeros(1, size(st,2));
for c = 1: size(st,2)
  tmp(c) = TC_AWGN_1Sample (SYSTEM, ESTIMATION, st(:, c), rt(:, c));
end
retval = mean(tmp);

end
