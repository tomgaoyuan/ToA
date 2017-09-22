function [varargout] = GenerateSubframe(SYSTEM, subframeID)
%Generate a positioning subframe

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
symbols = cell(1, TxNum);

[ PRS, PRSSC, PRSOFDMnumber] = GeneratePRS(cellID, subframeID, SYSTEM.PBCHports, DLRBnum, prsRBnum );
[ CRS, CRSSC, CRSOFDMnumber ] = GenerateCRS(cellID, subframeID, TxNum, DLRBnum );

for NT = 1 : TxNum
  symbols = {CRS{NT}, PRS{1}};
  SCs = {CRSSC{NT}, PRSSC{1}}; %mapping PRS ap (ap6) to CRS aps (ap0,1,2,3)
  OFDMs = {CRSOFDMnumber{NT}, PRSOFDMnumber{1}};
  %mapping to resource block

  RBs{NT} = zeros(subcarrierNum, OFDMnum);
  for i = 1: length(symbols)
    tmp = ResourceMapping(SYSTEM, symbols{i}, SCs{i}, OFDMs{i});
    RBs{NT} = RBs{NT} + tmp;
  end
  %IDFT
  subframe{NT} = zeros(1,chipNum);
  freq = zeros(FFTsize, OFDMnum);
  % RBs(subcarrierNum/2+1) is the DC subcarrier
  freq( mod(-subcarrierNum/2 -1 + [1:subcarrierNum], FFTsize) + 1, :)  = RBs{NT};
  time = sqrt(FFTsize) * ifft(freq);
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
end % end NT
if nargout == 1
  varargout{1} = subframe;
else
  varargout{1} = subframe;
  varargout{2} = RBs;
end %end if
end   %end function 