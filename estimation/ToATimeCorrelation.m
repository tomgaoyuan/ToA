function [retval] = ToATimeCorrelation (ESTIMATION, st, rt)
% Estimation ToA using correlation peak
r = CircularCorrelation(rt, st);
R = abs(r).^2;
wnd = R(ESTIMATION.TimeSearchWindow );
[ x ix ] =max( wnd );
plot(wnd);
retval = ix-1;
end
