function [retval] = MdlMusic_MSamples(SYSTEM, ESTIMATION, sSC, rSC, SC)
% Tackle with multiple samples
% IN:
%   sSC <N x sample number>

%extract SC pattern
uniqueSC = unique(SC.', 'rows').';
patternSize = size(uniqueSC, 2);
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
  NSamples = size(rUni{c}, 3);
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
  [v, k] = min( DL( DLIdx == range ) );
  if isnan(v) 
    DPerSCPattern(c) = -1;
    ToAPerSCPattern(c) = NaN;
    continue;
  end
  DPerSCPattern(c) = DLIdx(k);
  %estimate ToA
  FFTsize = SYSTEM.FFTsize;
  phiIndex = -1i * (SCGroup{c}-1) / FFTsize * 2 * pi;
  [P, tau] = Inner_MUSIC (U, DPerSCPattern(c), phiIndex);
  
  
  
  
end   %end for patternSize
retval = 0;
end
