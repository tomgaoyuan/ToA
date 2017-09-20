function [P, tau] = Inner_MUSIC (U, D, phiIndex)
%Perform MUSIC algorithm without search window
%   U : eigen vectors
%   D : Number of paths 
%   phiIndex : part of the index of vector phi

%obtain noise space G
G = U(:, D+1:end );
tau = linspace(0, 2*pi, 500);
P = zeros(1, length(tau));
%get MUSIC function P
for c = 1:length(tau)
    phi = exp(phiIndex * tau(c));
    P(c) = 1 / real( phi' * (G*G') * phi);
end % end for c

end
