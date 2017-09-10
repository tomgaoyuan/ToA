function [ varargout] = GetOFDMSymbol( SYSTEM, subframe, index, AP, hasCP )
% return the OFDM symmbol / RBs asked
%   index = 0,1,2 
%   AP is the index of physical antenna 1, 2, ...

tmp = SplitSubframe(SYSTEM, subframe);
if ~hasCP
    symbol = tmp{AP}{1,index+1};
else
    symbol = [tmp{AP}{2,index+1} tmp{AP}{1,index+1}];
end
symbol = symbol.';

tmp = ResolveSubframe(SYSTEM, subframe);
RBs = tmp{AP}(:, index+1);

if nargout == 1
  varargout{1} = symbol;
else
  varargout{1} = symbol;
  varargout{2} = RBs;
end

end

