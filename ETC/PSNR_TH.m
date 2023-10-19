% % Given PSNR value is in array psnr
% sigmoid_threshold = 45;  % Value at which to start applying sigmoid
% adjusted_psnr = max(0, PSNR - sigmoid_threshold);  % Subtract the threshold, and clip at 0
% sigmoid_psnr = (40 ./ (1 + exp(-adjusted_psnr*0.1))) - 20;  % Apply sigmoid, and add the threshold back
% 
% % Combine the original and sigmoid-adjusted values

load("UQ_LR_SAL_1.mat");
SUM = Summary_UQ;
load("UQ_LR_SAL_2.mat");
for i = 1:48
    for j = 10:18
        SUM(i,j,:,:) = Summary_UQ(i,j,:,:);
    end
end


Summary_UQ = SUM;

save("UQ_LR_SAL","Summary_UQ");
