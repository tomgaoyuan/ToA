function [out] = PassAWGN ( CHANNEL, in)
% An AWGN channel function 

sigma2 = CHANNEL.noisePower;
% add complex noise
  [ m, n ] = size(in);
  noise = sigma2/sqrt(2) * randn(m, n) + 1j * sigma2/sqrt(2) * randn(m, n);
  out = CHANNEL.amplify * in + noise;

end
