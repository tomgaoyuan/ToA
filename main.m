% do some cleaningclear all;close all;addpath('./signal');addpath('./channel');addpath('./estimation');% initializationParameters;%start a dropst = GenerateSubframe(SYSTEM, 0 );CHANNEL.NoisePower = 0.1;rt = SISO_AWGN(CHANNEL, st);[ sSym SC] = GetSCSymbol( SYSTEM, st, 0,3, 1 );rSym = GetSCSymbol( SYSTEM, rt, 0,3, 1 );%max( abs( rSym - sSym .* exp(-j * 2 * pi / 1024 * 10 * (SC-1)) ) );ML_AWGN( SYSTEM, ESTIMATION, sSym, rSym, SC)sOFDM = GetOFDMSymbol( SYSTEM, st, 3, 1, false );rOFDM = GetOFDMSymbol( SYSTEM, rt, 3, 1, false );TC_AWGN( SYSTEM, ESTIMATION, sOFDM, rOFDM)