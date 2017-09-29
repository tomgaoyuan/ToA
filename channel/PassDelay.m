function [out] = PassDelay (delay, in)
%A time delay function

  %make delay over every antenna path 
  out = CircularShift(in, delay);
end
