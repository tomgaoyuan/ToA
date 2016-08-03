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
% %deftypefn {Function File} {@var{retval} =} findMaximas (@var{input1}, @var{input2})
%
% %seealso{}
% %end deftypefn

% Author: gWX280355 <gWX280355%LFGY1GWX2803551>
% Created: 2016-07-27

function [ yM xM ] = findMaximas (y, x)
  dy = diff(y) / ( x(2) - x(1) );
  xM = [];
  yM = [];
  for i = 1: length(dy)-1
    if dy(i) >= 0 && dy(i+1) < 0 
      xM = [ xM x(i+1) ];
      yM = [ yM y(i+1) ];
    end
  end
  [ yM I ] = sort(yM);
  yM = yM(end:-1:1);
  xM = xM(I(end:-1:1));
end


