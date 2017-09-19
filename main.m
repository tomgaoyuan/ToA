%do some cleaningclear all;close all;%add packagesaddpath('./signal');addpath('./channel');addpath('./estimation');%initializationParameters;NSubframes = SIMULATION.NSubframes;wichOFDMSymbol = SIMULATION.wichOFDMSymbol;whichAPUsed =  SIMULATION.whichAPUsed;OFDMId = SIMULATION.wichOFDMSymbol;%space preparingsSCLength = SYSTEM.totalRB_PRS * 2;sSCAll = zeros(sSCLength, NSubframes);rSCAll = zeros(sSCLength, NSubframes);SCAll = zeros(sSCLength, NSubframes);NSamples = NSubframes * length( wichOFDMSymbol) * length( whichAPUsed);if SIMULATION.withCP   sOFDMLength = SYSTEM.FFTsize + SYSTEM.CP1;else  sOFDMLength = SYSTEM.FFTsize;endsOFDMAll = zeros(sOFDMLength, NSubframes);rOFDMAll = zeros(sOFDMLength, NSubframes);%start a dropcnt= 1;for id = 0 : NSubframes-1   %a subframe  st = GenerateSubframe(SYSTEM, id);  rt = AWGN(SYSTEM, CHANNEL, st);  for ofdm = wichOFDMSymbol   %a symbol    for ap = whichAPUsed    %an ap      [ sSCAll(:, cnt) SCAll(:, cnt)] = GetSCSymbol( SYSTEM, st, id, ofdm, ap );      rSCAll(:, cnt) = GetSCSymbol( SYSTEM, rt, id, ofdm, ap );      %% A validation line, supposed to be 0 if without noise      %max( abs( rSym - sSym .* exp(-j * 2 * pi / 1024 * 10 * (SC-1)) ) );      sOFDMAll(:, cnt) = GetOFDMSymbol( SYSTEM, st, ofdm, ap, false );      rOFDMAll(:, cnt) = GetOFDMSymbol( SYSTEM, rt, ofdm, ap, false );      cnt = cnt + 1;      end % end ap  end  %end ofdmend ML_AWGN_MSamples_LastMean( SYSTEM, ESTIMATION, sSCAll, rSCAll, SCAll);TC_AWGN_MSamples_LastMean( SYSTEM, ESTIMATION, sOFDMAll, rOFDMAll);MdlMusic_MSamples( SYSTEM, ESTIMATION, sSCAll, rSCAll, SCAll)