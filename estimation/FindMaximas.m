function [yM, xM] = FindMaximas (y, x)
% find maximas of function y(x) ane reording

dy = diff(y) / ( x(2) - x(1) );
xM = [];
yM = [];
for i = 1: length(dy)-1
  if dy(i) >= 0 && dy(i+1) < 0
    xM = [xM x(i+1)];
    yM = [yM y(i+1)];
  end 
end   %end for
%ordering by yM
[yM, I ] = sort(yM);
yM = yM(end:-1:1);
xM = xM(I(end:-1:1));
end