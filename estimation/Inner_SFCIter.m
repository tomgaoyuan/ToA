function [ newTau, newAlpha ] = Inner_SFCIter(tau, alpha, l, H, phiIndex, window)
%Interation part in SFC algorithm
%Substract (l-1)-th multipath components, then SAGE newTau, newAlpha of l-th components 
% IN: 
%    tau, alpha: <1 x Range> tau at last iteration
%    l: <1 x 1> multipath components orderfields
%    H: <N_PRS x 1> channel estimation in FD
%    phiIndex: <N_PRS x 1> some parameters at the index, -i2\pi{}f_n
%    window: <1 x window_length> search window for 
% OUT:
%    newTau, newAlpha: <1 x 1> new estimation of l-th components

%calculate X
X = H;  %X_1 = H
for c = 1 : (l-1)
    X = X - alpha(c) * exp(phiIndex * tau(c)); 
end  % end for c
%calculate z
z = zeros(size(window));
for c = 1: length(window)
    z(c) = exp(phiIndex * window(c))' * X;
end
%estimation 
%debug 
plot(window, abs(z).^2);
[~, K] = max(abs(z).^2);
newTau = window(K);
newAlpha = z(K) / length(X);

end    %end function 

