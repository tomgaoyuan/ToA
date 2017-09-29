function [Rx] = Channel_main (SYSTEM, CHANNEL, Tx)
%main function of channel component
%  call different sub-function depends on CHANNEL

switch CHANNEL.type 

  case 'AWGN' 
    Rx = AWGN(SYSTEM, CHANNEL, Tx);
  
  case 'Rayleigh'
    Rx = Rayleigh(SYSTEM, CHANNEL, Tx);
  
  case 'ETU'
    Rx = ETU(SYSTEM, CHANNEL, Tx);
 
  otherwise 
    error('Unexpected channel');
  
end  %end switch  

end
