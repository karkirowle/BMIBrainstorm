

tuning = [0:0.1:10];
for i=1:length(tuning)
    [RMSE, classificationAccuracy] = testFunction_for_students_MTb('brainstorm', tuning(i));
    error(i) = RMSE;
    
end

figure;
plot(tuning,error,'LineWidth', 1.5);
xlabel('\lambda tuning parameter', 'FontSize', 20);
ylabel('RMSE', 'FontSize', 20);
title('KNN consistently makes RMSE performance worse', 'FontSize', 20);
run('figureFormatter');
