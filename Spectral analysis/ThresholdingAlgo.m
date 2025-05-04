
function [signals,avgFilter,stdFilter] = ThresholdingAlgo(y,lag,threshold,influence)
%%Z-SCORE THRESHOLDING ALGORITHM https://stackoverflow.com/questions/22583391/peak-signal-detection-in-realtime-timeseries-data/54507329#54507329


% Initialise signal results
signals = zeros(length(y),1);
% Initialise filtered series
filteredY = y(1:lag);
% Initialise filters
avgFilter(lag,1) = mean(y(1:lag));
stdFilter(lag,1) = std(y(1:lag));
% Loop over all datapoints y(lag+2),...,y(t)
for i=lag+1:length(y)
    % If new value is a specified number of deviations away
    if abs(y(i)-avgFilter(i-1)) >threshold*stdFilter(i-1)
        if y(i) > avgFilter(i-1) 
            % Positive signal
            signals(i) = 1;
        else
            % Negative signal
            signals(i) = -1;
        end
        % Make influence lower
        filteredY(i) = influence*y(i)+(1-influence)*filteredY(i-1);
    else
        % No signal
        signals(i) = 0;
        filteredY(i) = y(i);
    end
    % Adjust the filters
    avgFilter(i) = mean(filteredY(i-lag:i));
    stdFilter(i) = std(filteredY(i-lag:i));
end
% Done, now return results
end