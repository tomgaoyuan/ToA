function [ retval ] = countNumber( y, aim )
%count the number of the samples which equal to the aim

retval = zeros(length(aim));
for c = 1: length(aim)
  retval(c) = sum(y == aim(c));
end     %end if

end

