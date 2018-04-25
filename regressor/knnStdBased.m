% Brain Machine Interfaces
% Decoding Of Spike Trains From A Goal-Oriented Arm Movement By A Monkey
% TEAM BRAINSTORM
% Karim Abou Jaoude, Bence Halpern, Kate Hobbs
% Imperial College London 2018 



function [x,y] = knnStdBased(P, spikeLength)
% If mean square error is lower than some threshold -> use KNN

if (length(P.fullX) >= spikeLength)
    if (P.trainKNN && abs(P.fullX(spikeLength) - P.xAvg{P.angle}(spikeLength)) ...,
            < 1*P.xStd{P.angle}(spikeLength) && ~isnan(P.xStd{P.angle}(spikeLength)))
        x = P.fullX(spikeLength);
        y = P.fullY(spikeLength);
    else
        % Otherwise use average
        x = P.xAvg{P.angle}(spikeLength);
        y = P.yAvg{P.angle}(spikeLength);
    end
else
    % Otherwise use average
    x = P.xAvg{P.angle}(spikeLength);
    y = P.yAvg{P.angle}(spikeLength);
end
end