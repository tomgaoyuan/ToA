%cleaning
close all;
clear all;
%setting
p = 80; %receiver number
q = 4; %source  number
Tau = [ 10 11 15 20];
%starting
N = 20; %sampling number
for c = 1: q
  A(:,c) = exp(-1j * [0:(p-1)]/p * 2 * pi * Tau(c)).';
end
SIGMA_S = 10;
SIGMA_E = 5;
Rx = zeros(p,p);
for c = 1:N
  rav = randn(2*q+2*p,1);
  s = SIGMA_S * ( rav(1:q) + 1j * rav(q+1:2*q) ) / sqrt(2);
  e = SIGMA_E * ( rav(2*q+1:2*q+p) + 1j * rav(2*q+p+1:2*q+2*p) ) / sqrt(2);
  x = A * s + e;
  Rx = Rx + x*x';
end
Rx = Rx / N; 
%decomposing
l = eig(Rx);
l = sort(l);
l = l(end:-1:1);
%MDL
theMDL = NaN * ones(1, p);
for k=0:p-1
  likelihood = prod( l(k+1:p).^(1/(p-k)) ) / ( sum( l(k+1:p) )/(p-k) );
  theMDL(k+1) = -((p-k)*N) * log2(likelihood) + 1/2 * k * (2*p-k) * log2(N);
end
[Y I] = min(theMDL);
disp(I-1);
