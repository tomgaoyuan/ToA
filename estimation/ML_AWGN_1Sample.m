function [retval] = ML_AWGN_1Sample (SYSTEM, ESTIMATION, sSym, rSym, SC)
% r(t) = \alpha s(t-\tau) + w(t)
% where \alpha is a constant but known

N = SYSTEM.FFTsize;
ref = rSym .* sSym.'' ./ abs(sSym).^2;
R = ones(size(sSym));
TAU = ESTIMATION.TimeSearchWindow;
Q = zeros(size(TAU));
for i = 1: length(TAU)
  G =  diag( exp(-j * 2 * pi / N * TAU(i) * (SC-1)) );
  Q(i) = ref'* G * R * R.' * G' * ref;
end
% plot(TAU, Q);
[x, ix] = max( Q );
retval = TAU(ix);

end
