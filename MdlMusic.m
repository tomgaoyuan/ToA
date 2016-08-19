% Copyright (C) 2016 gWX280355
% 
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

% -*- texinfo -*- 
% @deftypefn {Function File} {[@var{PathNumber} @var{ToA}]=} MdlMusic (@var{Rx}, @var{sampleN})
%
% @seealso{}
% @end deftypefn

% Author: gWX280355 <gWX280355@LFGY1GWX2803551>
% Created: 2016-08-19

function [PathNumber ToA] = MdlMusic (Rx, sampleN )
%decomposing
[ V LAMBDA ] = eig(Rx);
LAMBDA = real(LAMBDA);
%sorting 
[ V LAMBDA ] = eig(Rx);
LAMBDA = real(LAMBDA);
%sorting 
for c1 = 2:size(LAMBDA,1)
  key = LAMBDA(c1,c1);
  keyV = V(:,c1);
  for c2 = 1: c1-1
    if key > LAMBDA(c2,c2)
        break;
    end
  end
  for c3 = c1:-1:c2+1   
    LAMBDA(c3,c3) = LAMBDA(c3-1,c3-1);
    V(:,c3) = V(:,c3-1);
  end
  LAMBDA(c2,c2) = key;
  V(:,c2) = keyV;
end
U = V;
%joint
[D b] = innerMDL(U, LAMBDA, sampleN);
if isnan(D) 
  ToAs = [];
else
  ToAs = innerMUSIC(U, LAMBDA, D);
end
if isempty(ToAs) 
  PathNumber = -1;
  ToA = NaN;
else
  PathNumber = D;
  ToA = ToAs(1);
end
end
