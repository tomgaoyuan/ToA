function [ToA, D] = MdlMusic_MSamples(SYSTEM, ESTIMATION, sSC, rSC, SC)
% Tackle with multiple samples
% IN:
%   sSC <N x sample number>

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
    R_N = rUni{c}(:, c1) * rUni{c}(:, c1)';
  end   %end for sample number Nsample
  R_N = R_N / NSamples;
  %docomposition
  [U, LAMBDA] = EigenSort(R_N);
  %estimate path number 
  [DL, DLIdx] = Inner_MDL(LAMBDA, NSamples);
  range = ESTIMATION.pathSearchRange;
  DLIdxMask = DLIdx >= range(1)  &  DLIdx <= range(end);
  [v, k] = min( DL(DLIdxMask));
  if isnan(v) 
    DPerSCPattern(c) = -1;  %estimation failuare
    ToAPerSCPattern(c) = -1; 
    continue;
  end
  DLIdxMaskIdx = find(DLIdxMask==1);
  DPerSCPattern(c) = DLIdx( DLIdxMaskIdx(k));
  %estimate ToA
  FFTsize = SYSTEM.FFTsize;
  phiIndex = -1i * (SCGroup{c}-1) / FFTsize * 2 * pi;
  tau = linspace(0, FFTsize, FFTsize * 10);
  P = Inner_MUSIC (U, DPerSCPattern(c), phiIndex, tau);
  window = ESTIMATION.timeSearchWindow;
  tauTruncate = tau(tau >= window(1) & tau <= window(end));
  PTruncate = P(tau >= window(1) & tau <= window(end));
  %find all maximaxs in the search window
  [~, x ] = FindMaximas(PTruncate, tauTruncate);
  if ~isempty(x)
    x = x(1: min([DPerSCPattern(c) length(x)]));
    ToAs = sort(x);
  else 
    ToAs = [];
  end   %end if
  if ~isempty(ToAs) 
    ToAPerSCPattern(c) = ToAs(1);
  else
    ToAPerSCPattern(c) = -1;    %estimation failure
  end %end if
end   %end for patternSize

ToA = mean(ToAPerSCPattern);
D = mode(DPerSCPattern);
end
