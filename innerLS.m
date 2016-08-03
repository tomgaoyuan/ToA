function [ S1 ] = innerLS(X, ToAs)
  global FFT_SIZE;
  global SC;
  const_M = size(X,1);
  N = size(X,2); %samples
  D = length(ToAs);
  for c = 1: D
    A_1(:,c) = exp(-1j * (SC-1) / FFT_SIZE * 2 * pi * ToAs(c)).';
  end
  A_tmp = inv( A_1' * A_1 ) * A_1';
  S1 = zeros(1, N);
  for c = 1:N
    S1(c) = A_tmp(1, :) * X(:, c); 
  end
end