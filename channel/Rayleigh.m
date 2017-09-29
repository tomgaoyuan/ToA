function [ Rx ] = Rayleigh (SYSTEM, CHANNEL, Tx)
%Rayleigh fading channel with a single path
%   No inter-port interference, multi-layer transmission
%   Every ap has different noise
%   Every ap has different fading

TxNum = SYSTEM.TxNum;
Rx = cell(1, TxNum);
pathPower = CHANNEL.pathPower;
delay = CHANNEL.timeDelay;
sigma2 = CHANNEL.noisePower;
for NT = 1 : TxNum
  a = sqrt(pathPower/2) * (randn(1,2) * [1; 1i]);
  st = Tx{NT};
  rt = PassAWGN(a, sigma2, st);
  rt = PassDelay(delay, rt);
  Rx{NT} = rt;
end %end TxNum

end
