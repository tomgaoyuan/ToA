function [out] = PassDelay (CHANNEL, in)
%A time delay function

  delay = CHANNEL.timeDelay;
  %make delay over every antenna path 
  out = CircularShift(in, delay);
end
