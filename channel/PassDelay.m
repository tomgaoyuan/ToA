function [out] = PassDelay (CHANNEL, in)
%A time delay function

  delay = CHANNEL.TimeDelay;
  %make delay over every antenna path 
  out = CircularShift(in, delay);
end
