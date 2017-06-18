SYSTEM = struct();...
%system config 
  %Bandwidth 10MHz ~ 50RB
  SYSTEM.DW = 10e6; 
  %cell config
  SYSTEM.cellID = 0; 
  %physical antenna config
  SYSTEM.TxNum = 1; 
  SYSTEM.RxNum = 2; 
  %subframe config
  SYSTEM.totalRB = 50; 
  SYSTEM.totalOFDM = 14; 
  SYSTEM.SCsPerRB = 12; 
  SYSTEM.FFTsize =  1024; 
  SYSTEM.CP1 = 80; ...
  SYSTEM.CP2 = 72; ...
  %PBCH config 
  SYSTEM.PBCHports = 1; 
  %PRS config
  SYSTEM.totalRB_PRS = 50;  

CHANNEL = struct();
%channel config
  CHANNEL.type = 'AWGN'; 
  CHANNEL.NoisePower = 1;
  CHANNEL.TimeDelay = 10;
  CHANNEL.Amplify = 1;
  
ESTIMATION = struct();
%estimation config
  ESTIMATION.TimeSearchWindow = [0 : 100];  %unit: sample