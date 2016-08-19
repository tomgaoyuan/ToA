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
% @deftypefn {Function File} {[@var{PathNumber} @var{ToA}] =} MusicLSMmdl (@var{Rx}, @var{MatX}, @var{sampleN})
%
% @seealso{}
% @end deftypefn

% Author: gWX280355 <gWX280355@LFGY1GWX2803551>
% Created: 2016-08-19

function [PathNumber ToA] = MusicLSMmdl (Rx, MatX, sampleN )
%decomposing
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
SPAN = [1:20];
for c = SPAN
  ToAs = innerMUSIC(U, LAMBDA, c);
  if isempty(ToAs)
    tmpToA(c) = NaN;
    D(c) = NaN;
    b(c) = NaN;
  else
    tmpToA(c) = ToAs(1);
    S1 = innerLS(MatX, ToAs);
    [ D(c) b(c) ] = innerMMDL(U, LAMBDA, MatX, S1);
  end
end
tmp = find(D==SPAN);
if isempty(tmp) 
  PathNumber = -1;
  ToA = NaN;
else  %here we use the first result
  PathNumber = tmp(1);
  ToA= tmpToA(tmp(1));
end
end
