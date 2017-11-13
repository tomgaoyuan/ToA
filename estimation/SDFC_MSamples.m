function [ToA] = SDFC_MSamples (SYSTEM, ESTIMATION, sSC, rSC, SC)
% SIC-Defference FC algorithm implemention 
% Tackle with multiple samples
% IN:
%   sSC <N_PRS x sample number> sent RS subcarrier symbols
%   rSC <N_PRS x sample number> received RS subcarrier symbols
%   SC <N_PRS x sample number> RS subcarrier index 
% OUT:
%   ToA <1 x 1> ToA estimation

%extract parameters
FFTsize = SYSTEM.FFTsize;
range = ESTIMATION.pathSearchRange;
window = ESTIMATION.timeSearchWindow;
thr1 =   ESTIMATION.SDFC.lowerThreshold;
thr2 =   ESTIMATION.SDFC.upperThreshold;
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
ToAPerSCPattern = zeros(1, patternSize);
for c = 1: patternSize
    NSamples = size(rUni{c}, 2);
    NSC = length(SCGroup{c});
    DH = zeros(NSC, 1);
    DSC = zeros(NSC, 1);
    SCIdx = SCGroup{c};
    [~, SCIdxRef] = min(SCIdx);
    %get difference SC index
    for c1 = 1: length(SCIdx)
      DSC(c1) = SC(c1) - SC(SCIdxRef);
    end %end for SCIdx      
    %get difference channel coefficients     
    for c1 = 1: NSamples
      H = rUni{c}(:, c1);
      for c2 = 1: length(SCIdx)
        if c2 == SCIdxRef 
          continue;
        else 
          DH(c2) = DH(c2) + H(c2) * H(SCIdxRef)';
        end  %end if
      end  %end for SCIdx
    end  %end for NSamples
    DH = DH / NSamples;
    %resource allocation
    Tau = zeros(size(range));
    Alpha = zeros(size(range));
    %variable preperation
    phiIndex = -1i * DSC / FFTsize * 2 * pi;
    for c1 = 1: length(range)
      l = range(c1);
      [ Tau(c1), Alpha(c1) ] = Inner_SDFCIter(Tau, Alpha, l, DH, phiIndex, SCIdxRef, window);
      if real(Alpha(c1)) < thr1
          c1 = c1 - 1;
          break;
       elseif sum(abs(Alpha)) > thr2
          break;
      end %end if
    end  %end for range 
    if c1 > 0
      ToAPerSCPattern(c) = min(Tau(1:c1));
    else
      ToAPerSCPattern(c) = -1;
    end %end if 
end   %end for patternSize
%last mean
ToA = mean(ToAPerSCPattern(ToAPerSCPattern>0));

end  %end function 
