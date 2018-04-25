% Brain Machine Interfaces
% Decoding Of Spike Trains From A Goal-Oriented Arm Movement By A Monkey
% TEAM BRAINSTORM
% Karim Abou Jaoude, Bence Halpern, Kate Hobbs
% Imperial College London 2018 

function modelParameters = trainLMS(trial, modelParameters)
% Function trains an adaptive least mean square filter
% Output:
% modelParameters - containing the stuff needed for estimation
% Input:
%  trainTrial - training examples

% Parameters

delay = 40;
modelParameters.delay = delay;
maxLength = 1000;

for a=1:8
    coeffsX = zeros(98*(delay+1) + 1, maxLength);
    coeffsY = zeros(98*(delay+1) + 1, maxLength);
    for i=1:80
        mu = 0.05*exp(1/(i+6));
        N = size(trial(i,a).spikes,2);
        
        
        y_hat = zeros(N, 1);
        e = zeros(N, 1);
        y_hat2 = zeros(N, 1);
        e2 = zeros(N, 1);
        
        for j = delay+1:N
            x_hat = reshape(trial(i,a).spikes(1:98,j-delay:j),98*(delay+1),1);
            x_hat = [x_hat; 1];
            % 98*1
            y_hat(j) = coeffsX(:,j)' * x_hat;
            e(j) = trial(i,a).handPos(1,j) - y_hat(j);
            coeffsX(:,j+1) = coeffsX(:,j) + mu * e(j) * x_hat;
            
            y_hat2(j) = coeffsY(:,j)' * x_hat;
            e2(j) = trial(i,a).handPos(2,j) - y_hat2(j);
            coeffsY(:,j+1) = coeffsY(:,j) + mu * e2(j) * x_hat;
            
        end
        
    end
    modelParameters.regressionX{a} = coeffsX;
    modelParameters.regressionY{a} = coeffsY;
end

end
