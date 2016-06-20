%Detection of Signals by InformationTheoretic Criteria
%Source Number Estimation by MDL
%cleaning
close all;
clear all;
%setting
p = 6; %receiver number
q = 3; %source  number
OMEGA = [ 30 45 180 ] / 180 *pi;
%starting
N = 1000; %sampling number
for c = 1: q
  A(:,c) = exp(-j* OMEGA(c) * [0:(p-1)]).';
end
SIGMA_S = 10;
SIGMA_E = 1;
Rx = zeros(p,p);
for c = 1:N
  rav = randn(2*q+2*p,1);
  s = SIGMA_S * ( rav(1:q) + j * rav(q+1:2*q) ) / sqrt(2);
  e = SIGMA_E * ( rav(2*q+1:2*q+p) + j * rav(2*q+p+1:2*q+2*p) ) / sqrt(2);
  x = A * s + e;
  Rx = Rx + x*x';
end
Rx = Rx / N; 
%decomposing
l = eig(Rx);
l = sort(l);
l = l(end:-1:1);
%MDL
MDL = NaN * ones(1, p);
for k=0:p-1
  likelihood = prod( l(k+1:p).^(1/(p-k)) ) / ( sum( l(k+1:p) )/(p-k) );
  MDL(k+1) = -((p-k)*N) * log2(likelihood) + 1/2 * k * (2*p-k) * log2(N);
end
[Y I] = min(MDL);
disp('Out=');
disp(I-1);
