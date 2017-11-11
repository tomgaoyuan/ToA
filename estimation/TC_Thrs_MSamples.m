function [retval] = TC_Thrs_MSamples(SYSTEM, ESTIMATION, st, rt)
%Using a noise threshold to estimate ToA, tackling with multiple samples
% IN:
%   st <N x sample number> symbols sent in time domain
%   rt <N x sample number> symbols received in time domain

%extract parameters
window = ESTIMATION.timeSearchWindow;
alpha = ESTIMATION.TCThr.alpha;
beta = ESTIMATION.TCThr.beta;
timeNoiseThr = ESTIMATION.TCThr.noiseThreshold;
NSamples = size(st, 2);
tau = [0 : size(st, 1) - 1];
tauInterp = window;
assert(max(tauInterp) <= max(tau));
%get expected R
RAvg = zeros(size(window));
for c = 1: NSamples
    r = CircularCorrelation(rt(:, c), st(:, c));
    R = abs(r).^2;
    Rinterp = interp1( tau, R, tauInterp);
    RAvg = RAvg + Rinterp;
end %end for samples
RAvg = RAvg / NSamples;
%debug
%plot(window, RAvg);
%determinde adpative threshold
P_s = sum(abs(st(:,1)).^2);
N_f = P_s * 1 * timeNoiseThr;
thrs = alpha * ( beta * max(RAvg) + (1 - beta) * N_f );
retval = -1;
%search
for c = 1: length(window)
    if RAvg(c) >= thrs
        retval = window(c);
        break; 
    end   %end if
end %end for window

end  %end function 