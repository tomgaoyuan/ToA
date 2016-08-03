function [ D bit] = innerMMDL(U, LAMBDA, X, S1)
  const_M = size(X,1);
  N = size(X,2);
  dSquare = 0;
  rxd = zeros(const_M,1);
  for c = 1:N
      s1 = S1(c);
      x = X(:,c);
      dSquare = dSquare  + s1 * s1';
      rxd = rxd + x * s1';
  end
  dSquare = dSquare / N;
  rxd = rxd / N;
  xi = zeros(1, const_M);
  for k = 1: const_M
    xi(k) = dSquare;
    for c = 1: k
      xi(k) = xi(k) - abs(rxd' * U(:,c)).^2/LAMBDA(c,c);
    end
  end
  theMMDL = N * log(xi) + 1/2 * ( [1:const_M].^2 + [1:const_M] ) *log(N);
  [Y I] = min(theMMDL);
  D = I;
  bit = Y;
end