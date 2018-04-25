% Brain Machine Interfaces
% Decoding Of Spike Trains From A Goal-Oriented Arm Movement By A Monkey
% TEAM BRAINSTORM
% Karim Abou Jaoude, Bence Halpern, Kate Hobbs
% Imperial College London 2018 


% Parameter sweep
clc;
clear;

tuning = zeros(1,2);
% CSV Path
csvPath = [pwd ,'/results/filterSweep2.csv'];
fileID = fopen(csvPath, 'a');
title = ['Window,Std,Classification accuracy,RMSE', newline];
fwrite(fileID, title);

warning('off','all')

for i=2:2:500
    for j=145:2:500
    tuning(1) = i;
    tuning(2) = j;
    [RMSE, classificationAccuracy, ~, ~,~] = testFunction_for_students_MTb('brainstorm', tuning);
    newRow = [num2str(i), ',' num2str(j), ',', ...,
        num2str(classificationAccuracy), ',' num2str(RMSE), newline];
    fwrite(fileID, newRow);
    end
end

fclose(fileID);