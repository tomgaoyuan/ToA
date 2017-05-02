function [ l ] = CircularShift( s, tau )
%Calculating thw circular shift
l = zeros(size(s));
l(1 : tau) = s( (end-tau+1) : end ) ;
l(1+tau : end) =s(1: (end-tau));

end   %end function