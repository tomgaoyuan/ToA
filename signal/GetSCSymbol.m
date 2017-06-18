function [varargout] = GetSCSymbol (SYSTEM, subframe, subframeID, index, AP )
% return the RS Sc symmbol / corresponding Scs asked
%   subframe is the signal in time domain within a subframe duration
%   index is the index of OFDM  symbol 0,1,2 
%   AP is the index of physical antenna 1, 2, ...

tmp = ResolveSubframe(SYSTEM, subframe);
RBs = tmp{AP}(:, index+1);

[ PRS, PRSSC, PRSOFDMnumber] = GeneratePRS(SYSTEM.cellID, subframeID, SYSTEM.PBCHports, SYSTEM.totalRB, SYSTEM.totalRB_PRS);
[ CRS, CRSSC, CRSOFDMnumber ] = GenerateCRS(SYSTEM.cellID, subframeID, SYSTEM.TxNum, SYSTEM.totalRB );

assert(AP == 1);

tmp = PRSSC{AP}(:, PRSOFDMnumber{AP} == index);
tmp2 = CRSSC{AP}(:, CRSOFDMnumber{AP} == index);
tmp = cat(2, tmp+1, tmp2+1);
syms = RBs(tmp);

if nargout == 1
  varargout{1} = syms;
  return;
end

subcarrierNum = SYSTEM.totalRB * SYSTEM.SCsPerRB;
FFTsize = SYSTEM.FFTsize;
SCs = mod(-subcarrierNum/2 -1 + [1:subcarrierNum], FFTsize) + 1;
SCs = SCs(tmp).';

varargout{1} = syms;
varargout{2} = SCs;

end
