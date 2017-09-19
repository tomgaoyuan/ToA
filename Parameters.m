SYSTEM = struct();...
%system config 
  %Bandwidth 10MHz ~ 50RB
  SYSTEM.BW = 10e6; 
  %cell config
  SYSTEM.cellID = 0; 
  %physical antenna config
  SYSTEM.TxNum = 2;  %Ports used for CRS 1:4 for ap 0:3
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
  CHANNEL.noisePower = 1;
  CHANNEL.timeDelay = 10;
  CHANNEL.amplify = 1;
  
ESTIMATION = struct();
%estimation config
  ESTIMATION.timeSearchWindow = [0 : 100];  %unit: sample
  ESTIMATION.pathSearchRange = [1: 15];
  
SIMULATION = struct();
% simulation config
  SIMULATION.NSubframes = 4;
  SIMULATION.withCP = false;
  SIMULATION.wichOFDMSymbol = [3];
  SIMULATION.whichAPUsed = [1];