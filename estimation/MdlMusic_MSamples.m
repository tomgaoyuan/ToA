function [ToA, D] = MdlMusic_MSamples(SYSTEM, ESTIMATION, sSC, rSC, SC)
% Tackle with multiple samples
% IN:
%   sSC <N x sample number>

%extract parameters
FFTsize = SYSTEM.FFTsize;
range = ESTIMATION.pathSearchRange;
window = ESTIMATION.timeSearchWindow;
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
  %estimate path number 
  [DL, DLIdx] = Inner_MDL(LAMBDA, NSamples);
  DLIdxMask = DLIdx >= range(1)  &  DLIdx <= range(end);
  [v, k] = min( DL(DLIdxMask));
  if isnan(v) || isinf(v)
    DPerSCPattern(c) = -1;  %estimation failuare
    ToAPerSCPattern(c) = -1; 
    continue;
  end
  DLIdxMaskIdx = find(DLIdxMask==1);
  DPerSCPattern(c) = DLIdx( DLIdxMaskIdx(k));
  %estimate ToA
  phiIndex = -1i * (SCGroup{c}-1) / FFTsize * 2 * pi;  
  tau = [ 0 : window(2)- window(1): FFTsize ];
  P = Inner_MUSIC (U, DPerSCPattern(c), phiIndex, tau);
  tauTruncate = tau(tau >= window(1) & tau <= window(end));
  PTruncate = P(tau >= window(1) & tau <= window(end));
  % % test line
  %plot(tauTruncate, PTruncate)
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
  %%%%% estimation end %%%%%
end   %end for patternSize
%last mean
ToA = mean(ToAPerSCPattern);
D = mode(DPerSCPattern);
end
