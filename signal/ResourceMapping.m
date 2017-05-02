function [RBs] = ResourceMapping(SYSTEM, symbols, SCs, OFDMs)
%Mapping subcarriers symbols to all the RBs
TxNum = SYSTEM.TxNum;
OFDMnum = SYSTEM.totalOFDM;
SCnum = SYSTEM.totalRB * SYSTEM.SCsPerRB;
tmp = zeros(SCnum, OFDMnum);
for OFDMidx = 1 : length(OFDMs);
    OFDM = OFDMs(OFDMidx);
    tmp(SCs(:, OFDMidx)+1, OFDM+1) = symbols(:, OFDMidx);
end 
RBs = tmp;

end 