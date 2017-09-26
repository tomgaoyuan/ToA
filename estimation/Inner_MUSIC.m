function [P] = Inner_MUSIC (U, D, phiIndex, tau)
%Perform MUSIC algorithm without search window
%   U : eigen vectors
%   D : Number of paths 
%   phiIndex : part of the index of vector phi

%obtain noise space G
G = U(:, D+1:end );
P = zeros(1, length(tau));
%get MUSIC function P
for c = 1:length(tau)
    phi = exp(phiIndex * tau(c));
    P(c) = 1 / abs( phi' * (G*G') * phi); %abs() is required for calculating error
end % end for c

end
