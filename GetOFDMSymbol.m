function [ symbol ] = GetOFDMSymbol( SYSTEM, subframe, index, AP, hasCP )
% return the OFDM symmbol asked

tmp = SplitSubframe(SYSTEM, subframe);
if ~hasCP
    symbol = tmp{AP}{1,index+1};
else
    symbol = [tmp{AP}{2,index+1} tmp{AP}{1,index+1}];
end

end

