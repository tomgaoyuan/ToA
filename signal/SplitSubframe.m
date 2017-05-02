function [ OFDMSymbols] = SplitSubframe(SYSTEM, subframe)
%Split subframe into OFDM symbols and CP
TxNum = SYSTEM.TxNum;
FFTsize = SYSTEM.FFTsize;
OFDMnum = SYSTEM.totalOFDM;
CPs = [SYSTEM.CP1 SYSTEM.CP2];

OFDMSymbols = cell(1, TxNum);
for NT = 1: TxNum
    OFDMSymbols{NT} = cell(2,OFDMnum);
    top = 0;
    for OFDMidx = 0: OFDMnum -1
        if mod(OFDMidx, OFDMnum/2) == 0
            cpFlag = 1;
        else
            cpFlag = 2;
        end
        cp = subframe{NT}(top+[1:CPs(cpFlag)]);
        OFDMSymbols{NT}{2,OFDMidx+1} = cp;      %CP here
        top = top + CPs(cpFlag);
        time = subframe{NT}(top+[1:FFTsize]);
        OFDMSymbols{NT}{1,OFDMidx+1} = time;    %OFDM symbol here
        top = top + FFTsize;
    end 
end

end     %end function