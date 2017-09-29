function [ Rx ] = ETU (SYSTEM, CHANNEL, Tx)
%ETU channel with additive noise
%   No inter-port interference, multi-layer transmission
%   Every ap has different noise
%   Every ap has different fading
TxNum = SYSTEM.TxNum;
Rx = cell(1, TxNum);
pathPower = CHANNEL.pathPower;
delay = CHANNEL.timeDelay;
exDelay = CHANNEL.excessDelay;
pathNumber = length(pathPower);
sigma2 = CHANNEL.noisePower;
for NT = 1 : TxNum
  st = Tx{NT};
  a = sqrt(pathPower/2) .* ([1 1i] * randn(2, pathNumber) );
  Rx{NT} = zeros(size(st));
  for d = 1: pathNumber
    rt = PassAWGN(a(d), sigma2, st);
    rt = PassDelay(delay + exDelay(d), rt);
    Rx{NT} = Rx{NT} + rt;
  end  %end for path
end %end TxNum 
end
