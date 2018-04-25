% Brain Machine Interfaces
% Decoding Of Spike Trains From A Goal-Oriented Arm Movement By A Monkey
% TEAM BRAINSTORM
% Karim Abou Jaoude, Bence Halpern, Kate Hobbs
% Imperial College London 2018 

function [x,y,modelParameters] = estimateLMS(trial, modelParameters)
% Estimates adaptive least squares steps with the adaption turned off
% Output:
% modelParameters - containing the stuff needed for estimation
% x,y - the pos at the end of estimation
% Input:
%  trainTrial - training examples


% First, fetch the constants
angle = modelParameters.angle;

delay = modelParameters.delay;
coeffsX = modelParameters.regressionX{angle};
coeffsY = modelParameters.regressionY{angle};

% We want to continue where we left off with the estimation so only start
% from beginning if we have exactly 320 spikes

spikeLength = size(trial.spikes,2);
mu = 0.05;
y_hat = zeros(spikeLength, 1);
y_hat2 = zeros(spikeLength, 1);

e = zeros(spikeLength, 1);
e2 = zeros(spikeLength, 1);

if (spikeLength == 320)  
    from = delay+1;
else
    % We receive information batches of 20 so thats how much we step back
    from = spikeLength - 20 + 1;
end
for j = from:spikeLength
    x_hat = reshape(trial.spikes(1:98,j-delay:j),98*(delay+1),1);
    x_hat = [x_hat; 1];
    
    if (j < 500)
        y_hat(j) = coeffsX(:,j)' * x_hat;
        y_hat2(j) = coeffsY(:,j)' * x_hat;
    else
        y_hat(j) = y_hat(j-1);
        y_hat2(j) = y_hat2(j-1);
    end
    if (j < 300)
        e(j) = trial.startHandPos(1,1) - y_hat(j);
        coeffsX(:,j+1) = coeffsX(:,j) + mu * e(j) * x_hat;
        e2(j) = trial.startHandPos(2,1) - y_hat2(j);
        coeffsY(:,j+1) = coeffsY(:,j) + mu * e2(j) * x_hat;
    end
end
% At the end of this batch give back the final values
x = y_hat(spikeLength);
y = y_hat2(spikeLength);
modelParameters.regressionX{angle} = coeffsX;
modelParameters.regressionY{angle} = coeffsY;

end
