function [ Rx ] = AWGN(SYSTEM, CHANNEL, Tx)
%AWGN channel
%   No inter-port interference, multi-layer transmission
%   Every ap has different noise

TxNum = SYSTEM.TxNum;
Rx = cell(1, TxNum);
a = CHANNEL.amplify;
delay = CHANNEL.timeDelay;
sigma2 = CHANNEL.noisePower;

for NT = 1 : TxNum
  st = Tx{NT};
  rt = PassAWGN(a, sigma2, st);
  rt = PassDelay(delay, rt);
  Rx{NT} = rt;
end %end TxNum
end

