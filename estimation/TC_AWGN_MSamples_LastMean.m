function [retval] = TC_AWGN_MSamples_LastMean (SYSTEM, ESTIMATION, st, rt)
% Tackle with multiple samples
% IN:
%   sSym <N x sample number>

tmp = zeros(1, size(st,2));
for c = 1: size(st,2)
  tmp(c) = TC_AWGN_1Sample (SYSTEM, ESTIMATION, st(:, c), rt(:, c));
end
retval = mean(tmp);

end
