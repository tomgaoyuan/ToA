function [out] = PassAWGN ( a, sigma2, in)
% An AWGN channel function 

% add complex noise
  [ m, n ] = size(in);
  noise = sqrt(sigma2 / 2) * randn(m, n) + 1j * sqrt(sigma2 / 2) * randn(m, n);
  out = a * in + noise;

end
