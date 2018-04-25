% Brain Machine Interfaces
% Decoding Of Spike Trains From A Goal-Oriented Arm Movement By A Monkey
% TEAM BRAINSTORM
% Karim Abou Jaoude, Bence Halpern, Kate Hobbs
% Imperial College London 2018 


function [x,y] = knnSingleTuning(P, spikeLength)
    if (immse(P.fullX(1:500),P.xAvg{P.angle}(1:500)) < P.knnThreshold)
                x = P.fullX(min(spikeLength, length(P.fullX)));
                y = P.fullY(min(spikeLength, length(P.fullY)));
    else
        % Otherwise use average
        x = P.xAvg{P.angle}(spikeLength);
        y = P.yAvg{P.angle}(spikeLength);
    end

end