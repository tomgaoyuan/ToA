function [ RBs] = ResolveSubframe(SYSTEM, subframe)
%resolve a positioning subframe in RBs
TxNum = SYSTEM.TxNum;
FFTsize = SYSTEM.FFTsize;
OFDMnum = SYSTEM.totalOFDM;
subcarrierNum = SYSTEM.totalRB * SYSTEM.SCsPerRB;
CPs = [SYSTEM.CP1 SYSTEM.CP2];

RBs = cell(1, TxNum);

for NT = 1: TxNum
    RBs{NT} = zeros(subcarrierNum, OFDMnum);
    top = 0;
    for OFDMidx = 0: OFDMnum -1
        if mod(OFDMidx, OFDMnum/2) == 0
            cpFlag = 1;
        else
            cpFlag = 2;
        end
        top = top + CPs(cpFlag);
        time = subframe{NT}(top+[1:FFTsize]);
        top = top + FFTsize;
        freq = fft(time) /sqrt(FFTsize);
        RBs{NT}(:, OFDMidx+1) = freq( mod(-subcarrierNum/2 -1 + [1:subcarrierNum], FFTsize) + 1);
    end     %end OFDMidx
end     %end NT
end     %end function