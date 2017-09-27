function [ retval ] = percentiles( y, percents )
%return the percentiles of ECDF of samples y
%   y : samples
%   percents: which percent you want to observe

retval = zeros(1, length(percents));
[ F, X]  = ecdf(y);

for c1 = 1 : length(percents)
  p = percents(c1);
  for c2 = 1: length(X)
    f = F(c2);
    if f >= p
      retval(c1) = X(c2);
      break;
    end  %end if
  end  %end for i
end   %enf for p

end

