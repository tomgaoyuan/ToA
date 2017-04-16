function [subframe RBs] = GenerateSubframe(SYSTEM, subframeID)

TxNum = SYSTEM.TxNum;
DLRBnum = SYSTEM.totalRB;
cellID = SYSTEM.cellID;
prsRBnum = SYSTEM.totalRB_PRS;
FFTsize = SYSTEM.FFTsize;
OFDMnum = SYSTEM.totalOFDM;
subcarrierNum = SYSTEM.totalRB * SYSTEM.SCsPerRB;
chipNum = 2 * (SYSTEM.totalOFDM/2*(SYSTEM.FFTsize+SYSTEM.CP2) + SYSTEM.CP1 - SYSTEM.CP2);
CPs = [SYSTEM.CP1 SYSTEM.CP2];

RBs = cell(1, TxNum);
subframe = cell(1, TxNum);

[ PRS, PRSSC, PRSOFDMnumber] = GeneratePRS(cellID, subframeID, SYSTEM.PBCHports, DLRBnum, prsRBnum );
[ CRS, CRSSC, CRSOFDMnumber ] = GenerateCRS(cellID, subframeID, TxNum, DLRBnum );

%Mapping to physical antenna
%Only 1 Antenna is supproted at present
assert(TxNum == 1);
symbols = {{CRS{1}, PRS{1}}};
SCs = {{CRSSC{1}, PRSSC{1}}};
OFDMs = {{CRSOFDMnumber{1}, PRSOFDMnumber{1}}};

for NT = 1: TxNum
RBs{NT} = zeros(subcarrierNum, OFDMnum);
  for i = 1: length(symbols{NT})
    tmp = ResourceMapping(SYSTEM, symbols{NT}{i}, SCs{NT}{i}, OFDMs{NT}{i});
    RBs{NT} = RBs{NT} + tmp;
  end
end

for NT = 1: TxNum
  subframe{NT} = zeros(1,chipNum);
  freq = zeros(FFTsize, OFDMnum);
  % RBs(subcarrierNum/2+1) is the DC subcarrier
  freq( mod(-subcarrierNum/2 -1 + [1:subcarrierNum], FFTsize) + 1, :)  = RBs{NT};
  time = ifft(freq);
  top = 0;
  for OFDMidx = 0: OFDMnum -1
    tmp = time(:, OFDMidx+1);
    if mod(OFDMidx, OFDMnum/2) == 0
      cpFlag = 1;
    else
      cpFlag = 2;
    end
    subframe{NT}(top+[1:CPs(cpFlag)]) = tmp(end-CPs(cpFlag)+1 : end);
    top = top + CPs(cpFlag);
    subframe{NT}(top+[1:FFTsize]) = tmp;
    top = top + FFTsize;
  end   %end OFDMidx
end   %end TxNum

end   %end function 