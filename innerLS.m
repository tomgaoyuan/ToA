function [ S1 ] = innerLS(X, ToA)
  const_M = size(X,1);
  N = size(X,2);
  S1 = zeros(1, N);
  for c = 1:N
    S1(c) = exp(-1j * [0:(const_M-1)]/const_M * 2 * pi * ToA).'' * X(:, c)/const_M; 
  end
end