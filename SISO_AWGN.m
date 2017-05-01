function [ Rx ] = SISO_AWGN(CHANNEL, Tx)
% AWGN in SISO

st = Tx{1};
rt = PassAWGN(CHANNEL, st);
rt = PassDelay(CHANNEL, rt);
Rx = {rt};

end

