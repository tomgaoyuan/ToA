function [ Rx ] = AWGN(SYSTEM, CHANNEL, Tx)
%AWGN channel
%   No inter-port interference
TxNum = SYSTEM.TxNum;
for NT = 1 : TxNum
  st = Tx{NT};
  rt = PassAWGN(CHANNEL, st);
  rt = PassDelay(CHANNEL, rt);
  Rx{NT} = rt;
end %end TxNum
end

