function [ToA, D] = MusicLSMmdl_MSamples(SYSTEM, ESTIMATION, sSC, rSC, SC)
% Tackle with multiple samples
% IN:
%   sSC <N_PRS x sample number>

%extract parameters
FFTsize = SYSTEM.FFTsize;
window = ESTIMATION.timeSearchWindow;
range = ESTIMATION.pathSearchRange;
%extract SC pattern
uniqueSC = unique(SC.', 'rows').';
patternSize = size(uniqueSC, 2);
SCGroup = cell(1, patternSize);
rUni = cell(1, patternSize);
for c = 1: patternSize  %same SC within a loop
  SCGroup{c} = uniqueSC(:, c);
  sSCGroup = sSC( :, sum(SC == uniqueSC(c),1) ~= 0 );
  rSCGroup = rSC( :, sum(SC == uniqueSC(c),1) ~= 0 );
  rUni{c} = rSCGroup ./ sSCGroup;
end   %end for patternSize

%merging different SC pattern
DPerSCPattern = zeros(1, patternSize);
ToAPerSCPattern = zeros(1, patternSize);
for c = 1: patternSize
  %get correlation matrix
  NSamples = size(rUni{c}, 2);
  R_N  = zeros( length( SCGroup{c} ) );
  for c1 = 1: NSamples
    %ML estimation of correlation mat
    R_N = R_N + rUni{c}(:, c1) * rUni{c}(:, c1)'; 
  end   %end for sample number Nsample
  R_N = R_N / NSamples;
  %docomposition
  [U, LAMBDA] = EigenSort(R_N);
  %%%%% estimation begin %%%%%
  Dw = zeros(1, length(range) );
  Lw = zeros(1, length(range) );
  ToAw = zeros(1, length(range) );
  for d = range
    %estimate ToA
    phiIndex = -1i * (SCGroup{c}-1) / FFTsize * 2 * pi;
    tau = [ 0 : window(2)- window(1): FFTsize ];
    P = Inner_MUSIC (U, d, phiIndex, tau);
    tauTruncate = tau(tau >= window(1) & tau <= window(end));
    PTruncate = P(tau >= window(1) & tau <= window(end));
    % % test line
    %plot(tauTruncate, PTruncate)
    %find all maximaxs in the search window
    [~, x ] = FindMaximas(PTruncate, tauTruncate);
    if ~isempty(x)
      x = x(1: min([d length(x)]));
      ToAs = sort(x);
    else 
      ToAs = [];
    end   %end if
    if isempty(ToAs) 
      Dw(d) = Inf;  %estimation failuare
      ToAw(d) = NaN;    
      continue;
    else
      ToAw(d) = ToAs(1);
    end  %end if
    %LS channel estimation
    a1 = Inner_LS( rUni{c}, ToAs, phiIndex );
    %MMDL path number estimation
    [DL, DLIdx] = Inner_MMDL(U, LAMBDA, rUni{c}, a1);
    DLIdxMask = DLIdx >= range(1)  &  DLIdx <= range(end); 
    DLIdxMaskIdx = find(DLIdxMask==1);
    [Dw(d), k] = min( DL(DLIdxMask)); 
    Lw(d) = DLIdx( DLIdxMaskIdx(k));
  end % end for range
  [v, k ] = min(Dw);
  if isnan(v) || isinf(v) 
    DPerSCPattern(c) = -1;
    ToAPerSCPattern(c) = -1;
  else
    DPerSCPattern(c) = Lw(k);
    ToAPerSCPattern(c) = ToAw(Lw(k));
  end   %end if
  %%%%% esitmation end %%%%%
end %end for patternSize

ToA = mean(ToAPerSCPattern);
D = mode(DPerSCPattern);
end
