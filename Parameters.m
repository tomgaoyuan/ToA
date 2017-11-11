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
  SYSTEM.CP1 = 80; 
  SYSTEM.CP2 = 72; 
  %PBCH config 
  SYSTEM.PBCHports = 1; 
  %PRS config
  SYSTEM.totalRB_PRS = 50;  

CHANNEL = struct();
%channel config
  CHANNEL.type = 'ETU'; 
  
SIMULATION = struct();
%simulation config
  SIMULATION.NDrops = 10;
  SIMULATION.NSubframes = 30;
  SIMULATION.withCP = false;
  SIMULATION.wichOFDMSymbol = [3];
  SIMULATION.whichAPUsed = [1];
  
switch CHANNEL.type 

  case 'AWGN' 
    CHANNEL.noisePower = 1;
    CHANNEL.timeDelay = 10;
    CHANNEL.amplify = 1;
  
  case 'Rayleigh'
    CHANNEL.pathPower = 1;
    CHANNEL.timeDelay = 10;
    CHANNEL.noisePower = 1;
  
  case 'ETU'
    CHANNEL.timeDelay = 10;
    CHANNEL.excessDelay = [0 1 2 3 4 8 25 35 77];  %unit: chip
    CHANNEL.pathPowerdB = [-1 -1 -1 0 0 0 -3 -5 -7]; 
    CHANNEL.pathPower = 10.^(CHANNEL.pathPowerdB/10) / ...
                        sum(10.^(CHANNEL.pathPowerdB/10) );  %unit: linear
    CHANNEL.noisePower = 0.1;
 
  otherwise 
    error('Unexpected channel');
  
end  %end switch   

ESTIMATION = struct();
%estimation config
  ESTIMATION.timeSearchWindow = [0 : 0.5 : SYSTEM.CP2];  %unit: sample
  ESTIMATION.pathSearchRange = [1: 15]; %unit: count
  ESTIMATION.SFC.noiseThreshold = 2 * CHANNEL.noisePower;  %threshold for SFC algorithm
  ESTIMATION.TCThr.alpha = 1;    %thresholds for TC-threhold algorithm
  ESTIMATION.TCThr.beta = 0.5; 
  ESTIMATION.TCThr.noiseThreshold = CHANNEL.noisePower; 