function [ PRS, SC, OFDMnumber] = GeneratePRS(cellID, subframeID, TXnum, DLRBnum, prsRBnum )
%Generate the PRS according to 36.211 6.10.4
%   return PRS modulation symbols, SC index and correspondinig OFDM
%   symbols which is sent on p=6
%   TXnum : antena port
N = 110; 
N_CP = 1;   %only normal CP supported
N_DL_RB = DLRBnum;
N_PRS_RB = prsRBnum;
PBCHports = TXnum;
N_DL_symb = 7;
if PBCHports <= 2
    OFDMpattern = [3,5,6,8,9,10,12,13];
else
    OFDMpattern = [3,5,6,9,10,12,13];
end
OFDMnumber = OFDMpattern;
PRS = zeros(2*N_PRS_RB, length(OFDMnumber));
SC = zeros(2*N_PRS_RB, length(OFDMnumber));
N_PRS_ID = cellID;
for ofdmIdx = OFDMpattern
    n_s = 2 *subframeID + floor(ofdmIdx/N_DL_symb);   %slot number
    l = mod(ofdmIdx,N_DL_symb);   %OFDM symbol number
    %pseudo-random sequence
    c_init = 2^28 * floor(N_PRS_ID/512) + ...
            2^10 * (7 * (n_s+1) + l + 1) * ( 2 * (mod(N_PRS_ID,512)) +1) +...
            2 * mod(N_PRS_ID,512) + N_CP;
    c = GenerateRandom(4*N, c_init);
    %sequence generation
    r = 1/sqrt(2) * ( (1-2 * c(1:2:end)) + 1j * ( 1 - 2*c(2:2:end) ));
    %resource mapping
    a = r(N-N_PRS_RB+1 : N+N_PRS_RB);
    v_shift = mod(N_PRS_ID,6);
    k = 6 * ( (0:2*N_PRS_RB-1) + N_DL_RB - N_PRS_RB ) + mod(6-l+v_shift,6);
    PRS(:,ofdmIdx == OFDMpattern) = a.';
    SC(:,ofdmIdx == OFDMpattern) = k.';
end
end

