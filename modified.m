%cleaning
close all;
clear all;
%setting
const_p = 4;   %source number
const_M = 80;   %sensor number
Tau = [ 3 5 10 15];
%sub-function

%strting
N = 20; %sampling number
for c = 1: const_p
  A(:,c) = exp(-1j * [0:(const_M-1)]/const_M * 2 * pi * Tau(c)).';
end
SIGMA_S = 100;
SIGMA_N = 1;
Rx = zeros(const_M,const_M);
X = zeros(const_M, N);
for c = 1:N
  rav = randn(2*const_M + const_p,1);
  s = SIGMA_S * rav(1:const_p);
  n = SIGMA_N * ( rav(const_p+1 : const_p+const_M) + 1j * rav(const_p+const_M+1 : const_p+2*const_M) ) / sqrt(2);
  x = A * s + n;
  X(:, c) = x;
  Rx = Rx + x*x';
end
Rx = Rx / N;
%decomposing
[ V LAMBDA ] = eig(Rx);
%sorting 
for c1 = 2:size(LAMBDA,1)
  key = LAMBDA(c1,c1);
  keyV = V(:,c1);
  for c2 = 1: c1-1
    if key > LAMBDA(c2,c2)
        break;
    end
  end
  for c3 = c1:-1:c2+1   
    LAMBDA(c3,c3) = LAMBDA(c3-1,c3-1);
    V(:,c3) = V(:,c3-1);
  end
  LAMBDA(c2,c2) = key;
  V(:,c2) = keyV;
end
U = V;
%joint
clc;
ToA = innerMUSIC(U, LAMBDA, 1)
S1 = innerLS(X, ToA);
[D b] = innerMMDL(U, LAMBDA, X, S1)
ToA = innerMUSIC(U, LAMBDA, D)
S1 = innerLS(X, ToA);
[D b] = innerMMDL(U, LAMBDA, X, S1)
ToA = innerMUSIC(U, LAMBDA, D)
