%a classic ML estimator
%cleaning
close all;
clear all;
%starting
M = 6; %receiver number
D = 3; %source  number
OMEGA = [ 0 45 180 ] / 180 *pi;
LOOP = 1000;
for c = 1: D
  A(:,c) = exp(-j* OMEGA(c) * [0:(M-1)]).';
end
SIGMA_S = 10;
SIGMA_E = 1;
Rx = zeros(M,M);
for c = 1:LOOP
  rav = randn(2*D+2*M,1);
  s = SIGMA_S * ( rav(1:D) + j * rav(D+1:2*D) ) / sqrt(2);
  e = SIGMA_E * ( rav(2*D+1:2*D+M) + j * rav(2*D+M+1:2*D+2*M) ) / sqrt(2);
  x = A * s + e;
  Rx = Rx + x*x';
end
Rx = Rx / LOOP; 
%D is known
%estimating \theta
%searching
omega = linspace(0,2*pi,30);
F = zeros(length(omega),length(omega),length(omega));
tmp = Inf;
for c1 = 1:length(omega)
  for c2 = 1:length(omega)
    for c3 = 1:length(omega)
      A_S(:,1) = exp(-j* omega(c1) * [0:(M-1)]).';
      A_S(:,2) = exp(-j* omega(c2) * [0:(M-1)]).';
      A_S(:,3) = exp(-j* omega(c3) * [0:(M-1)]).';
      F(c1,c2,c3) = real( trace( ( eye(M) - A_S * inv(A_S'*A_S) * A_S') * Rx )); 
    end
  end    
end
  
