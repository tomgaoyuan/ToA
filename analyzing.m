clear;
close all;

%add packages
addpath('./analysis');

%settings
path = './results/';
name = 're*.mat';
observation = 'CHANNEL.noisePower';
files = dir([ path name ]);
Nmethods = 7;
percents = [0.33 0.5 0.67 0.8];
ipers = zeros(length(files), Nmethods, length(percents) );
ivalid = zeros(length(files), Nmethods);
imean = zeros(length(files), Nmethods);
ivar = zeros(length(files), Nmethods);
ite = zeros(1, Nmethods);
Mmethods = 2;
bins = 1:10;
icounts = zeros(length(files), Mmethods, length(bins));

obs = zeros(1,  length(files));
for c = 1: length(files)
    load([ path files(c).name ]);
    disp([ files(c).name ' is loaded.' ]);
    %const parameters
    NDrops = SIMULATION.NDrops;
    timeDelay = CHANNEL.timeDelay;
    ite = ite + TE;
    eval(['obs(' num2str(c) ')=' observation ';']);
    for c1 = 1: Nmethods 
        toa = ToA(c1, :);
        ivalid(c, c1) = sum(toa >= 0) / NDrops;
        imean(c, c1) = mean(toa(toa >= 0) - timeDelay);
        ivar(c, c1) = var(toa(toa >= 0) - timeDelay );
        toa(toa < 0 ) = Inf;
        error = abs(ToA(c1, :) - timeDelay);
        for c2 = 1: length(percents)
            ipers(c, c1, c2) = percentiles( toa, percents(c2) );
        end  %end for c2
    end %end for c1
    for c1 = 1: Mmethods
        for c2 = 1: length(bins)
            icounts(c, c1, c2) = countNumber( D(c1, :), bins(c2) );
        end  %end for c2
    end  %end for c1
end  %end for
ite = ite / length(files);

save('plot.mat','observation', 'obs', 'ToAVar', 'DVar', ...
    'percents', 'ipers', 'ivalid', 'ivalid','imean', 'ivar', 'ite', ...
    'bins', 'icounts');
