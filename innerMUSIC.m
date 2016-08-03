function [ ToA ] = innerMUSIC(U, ~, D )
  const_M = size(U,1);
  %obtaining noise space G
  G = U(:, D+1:end );
  %searching
  TAU = linspace(0,const_M,500);
  P = zeros(1,length(TAU));
  for c = 1:length(TAU)
    a = exp(-1j* [0:(const_M-1)]/const_M * 2 * pi * TAU(c)).';
    P(c) = 1 / real( (a'*( G*G')*a) );
  end
  plot(TAU,P);
  dP = diff(P) / ( TAU(2) - TAU(1) );
  thr = mean(P);
  ToA = NaN;
  for i = 1: length(dP)-1
    if dP(i) >= 0 && dP(i+1) < 0 && P(i) > thr
      ToA = TAU(i+1);
      break;
    end
  end
end
