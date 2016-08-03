%cleaning
close all;
clear all;
%setting
const_p = 4;   %source number
const_M = 80;   %sensor number
Tau = [ 10 11 15 20];
%starting
N = 20; %sampling number
for c = 1: const_p
  A(:,c) = exp(-1j * [0:(const_M-1)]/const_M * 2 * pi * Tau(c)).';
end
SIGMA_S = 10;
SIGMA_N = 5;
Rx = zeros(const_M,const_M);
dSquare = 0;
rxd = zeros(const_M,1);
for c = 1:N
  rav = randn(2*const_M + const_p,1);
  s = SIGMA_S * rav(1:const_p);
  n = SIGMA_N * ( rav(const_p+1 : const_p+const_M) + 1j * rav(const_p+const_M+1 : const_p+2*const_M) ) / sqrt(2);
  x = A * s + n;
  Rx = Rx + x*x';
  dSquare = dSquare  + s(1) * s(1).';
  rxd = rxd + x * s(1).'';
end
Rx = Rx / N;
dSquare = dSquare / N;
rxd = rxd / N;
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
%MMDL
xi = zeros(1, const_M);
for k = 1: const_M
  xi(k) = dSquare;
  for c = 1: k
    xi(k) = xi(k) - abs(rxd' * U(:,c)).^2/LAMBDA(c,c);
  end
end
theMMDL = N * log(xi) + 1/2 * ( [1:const_M].^2 + [1:const_M] ) *log(N);
[Y I] = min(theMMDL);
disp(I);
