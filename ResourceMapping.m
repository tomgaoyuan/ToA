function [RBs] = ResourceMapping(SYSTEM, symbols, SCs, OFDMs)
%Mapping subcarriers symbols to all the RBs
TxNum = SYSTEM.TxNum;
OFDMnum = SYSTEM.totalOFDM;
SCnum = SYSTEM.totalRB * SYSTEM.SCsPerRB;
for NT = 1:TxNum
  tmp = zeros(SCnum, OFDMnum);
  for OFDMidx = 1 : length(OFDMs{NT});
    OFDM = OFDMs{NT}(OFDMidx);
    tmp(SCs{NT}(:, OFDMidx)+1, OFDM+1) = symbols{NT}(:, OFDMidx);
  end 
  RBs{NT} = tmp;
end 
end 