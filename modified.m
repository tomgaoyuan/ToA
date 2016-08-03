%cleaning
close all;
clear all;
%setting
const_p = 8;   %source number
const_M = 64;   %sensor number
global FFT_SIZE;
global SC;
FFT_SIZE = 64;
SC = [1 : const_M];
Tau = [ 3 4 5 6 7 13 15 18];
%starting
N = 20; %sampling number
for c = 1: const_p
  A(:,c) = exp(-1j * (SC-1) / FFT_SIZE * 2 * pi * Tau(c)).';
end
SIGMA_S = 10 * ones(const_p, 1) ;
SIGMA_N = 1;
Rx = zeros(const_M,const_M);
X = zeros(const_M, N);
for c = 1:N
  rav = randn(2*const_M + const_p,1);
  s = SIGMA_S .* rav(1:const_p);
  n = SIGMA_N * ( rav(const_p+1 : const_p+const_M) + 1j * rav(const_p+const_M+1 : const_p+2*const_M) ) / sqrt(2);
  x = A * s + n;
  X(:, c) = x;
  Rx = Rx + x*x';
end
Rx = Rx / N;
%decomposing
[ V LAMBDA ] = eig(Rx);
LAMBDA = real(LAMBDA);
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
disp('joint');
SPAN = [1:20];
for c = SPAN
  ToAs = innerMUSIC(U, LAMBDA, c);
  if isempty(ToAs) 
      continue;
  end
  S1 = innerLS(X, ToAs);
  [ D(c) b(c) ] = innerMMDL(U, LAMBDA, X, S1);
  ToA(c) = ToAs(1);
end
find(D==SPAN)
ToA(D==SPAN)
b(D==SPAN)
figure;
subplot(4,1,1);
stem(SPAN, D-const_p);
title('\DeltaD');
subplot(4,1,2);
stem(SPAN, D-SPAN);
title('\DeltaDE');
subplot(4,1,3);
plot(SPAN, ToA - Tau(1));
title('\DeltaToA');
subplot(4,1,4);
plot(SPAN, b);
title('length');