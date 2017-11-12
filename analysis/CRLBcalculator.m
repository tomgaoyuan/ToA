%a sub-process for calculating CRLB
%do some cleaning
clear all;
close all;
%add packages
addpath('./signal');

%initialization
Parameters;
disp(SIMULATION);
FFTsize = SYSTEM.FFTsize;
NSubframes = SIMULATION.NSubframes;
wichOFDMSymbol = SIMULATION.wichOFDMSymbol;
whichAPUsed =  SIMULATION.whichAPUsed;
sigma2 = CHANNEL.noisePower;
%constant calculation
NSamples = NSubframes * length( wichOFDMSymbol) * length( whichAPUsed);
delta_f = 15e3;   %subcarrier spacing
Ts = 1e-3 / 2048 / 15;

%transmitter
part = zeros(1, NSamples);
cnt = 1;
for id = 0 : NSubframes-1   %a subframe
  st = GenerateSubframe(SYSTEM, id);
  for ofdm = wichOFDMSymbol   %a symbol
    for ap = whichAPUsed    %an ap
      [ sSC, SC] = GetSCSymbol( SYSTEM, st, id, ofdm, ap );
      for c = 1: length(SC) 
        if SC(c) < FFTsize / 2
          part(cnt) = part(cnt) + SC(c)^2 * abs(sSC(c))^2;
        else
          part(cnt) = part(cnt) + (SC(c) - FFTsize)^2 * abs(sSC(c))^2;
        end  %end if 
      end   %end for SC
      cnt = cnt + 1;
    end % end ap
  end  %end ofdm
end   %end subframes
%calculating CRLB
%unit Ts^2
%CRLB for first sample
CRLB1Sample = sigma2 / ( 8*pi^2*delta_f^2* part(1) ) / Ts^2;
%CRLB for all samples
CRLBAllSamples = sigma2 / ( 8*pi^2*delta_f^2* sum(part) ) / Ts^2;
