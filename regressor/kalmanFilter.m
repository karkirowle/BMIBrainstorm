% Brain Machine Interfaces
% Decoding Of Spike Trains From A Goal-Oriented Arm Movement By A Monkey
% TEAM BRAINSTORM
% Karim Abou Jaoude, Bence Halpern, Kate Hobbs
% Imperial College London 2018 


% Kalman Filter
function [x,y, modelParameters] = kalmanFilter(spikes, modelParameters, trial)

% spikes - filtered spikes
% A - state transition model
% W - process noise
% Q - measurement (sensory noise)
% H - signal scaling

spikeLength = length(spikes);

k = modelParameters.angle;
A = modelParameters.A{k};
W = modelParameters.W{k};
H = modelParameters.H{k};
Q = modelParameters.Q{k};
P = modelParameters.P;
if (spikeLength==320)
    % Initialise Kalman Filter
    modelParameters.endTime = 1;
    maxTime = 1000;
    state = zeros(2,maxTime);
    state(1:2,1) = trial.startHandPos(1:2,:);

else

    G = modelParameters.G;
    state = modelParameters.state;
end

t=(modelParameters.endTime+1):spikeLength;
    
    % Prediction step

    state(:,t) =  A * state(:,t-1); % Update the prediction with state transition model
    P = A * P * A' + W; % Squared error + process noise
        
    % Update
    % High observation noise -> low Kalman Gain
    G = P * H' * pinv(H * P * H' + Q);
    % Updating prediction error estimate
    P = (eye(size(A,1)) - G * H) * P;
    %G = eye(size(spikes(:,t),1));
    % Trading of between the estimation and the actual value
    % C is scaling of observation
   state(:,t) = state(:,t) + G*(spikes(:,t) - H * state(:,t)); 
%state(:,t) = G * (H * state(:,t));

x = state(1,length(spikes));
y = state(2,length(spikes));
modelParameters.endTime = length(spikes);
modelParameters.P = P;
modelParameters.G = G;
modelParameters.state = state;

end