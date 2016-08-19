function [ D  bit] = innerMDL(U, LAMBDA,N)
  const_M = size(LAMBDA,1);
  l = diag(LAMBDA);
  l = real(l);
  l = sort(l);
  l = l(end:-1:1);
  theMDL = NaN * ones(1, const_M);
  for k=0: const_M-1
    likelihood = prod( real(l(k+1:const_M).^(1/(const_M-k))) ) / ( sum( l(k+1:const_M) )/(const_M-k) );
    if likelihood > 0
      theMDL(k+1) = -((const_M-k)*N) * log2(likelihood) + 1/2 * k * (2*const_M-k) * log2(N);
    end
  end
  [Y I] = min(theMDL);
  if ~isnan(Y) 
    D = I - 1;
    bit = Y;
  else
    D = NaN;
    bit = Inf;
  end  
end
