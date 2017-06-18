function [retval] = TC_AWGN (SYSTEM, ESTIMATION, st, rt)
% Estimation ToA using correlation peak
% r(t) = \alpha s(t-\tau) + w(t)
% where \alpha is a constant but known
r = CircularCorrelation(rt, st);
R = abs(r).^2;
tau = [0 : length(R)-1];
tauInterp = ESTIMATION.TimeSearchWindow;
assert(max(tauInterp) <= max(tau));
Rinterp = interp1( tau, R, tauInterp);
% plot(tauInterp, Rinterp);

[ x ix ] =max( Rinterp );
retval = tauInterp(ix);
end
