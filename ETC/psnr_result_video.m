clear all;
clc;

% load("UQ_GT.mat");
% PSNR_GT = squeeze(sum(Summary_UQ)/10);
% for i = 1: 18
%     for j = 1:7:8
%     mean_gt_psnr(i,j) = mean(squeeze(PSNR_GT(i,j,:)));
%     end
% end
% 
% clearvars Summary_UQ;
% 
% load("UQ_GT_SAL.mat");
% PSNR_GT_SAL = squeeze(sum(Summary_UQ)/10);
% for i = 1: 18
%     for j = 1:7:8
%     mean_gt_sal_psnr(i,j) = mean(squeeze(PSNR_GT_SAL(i,j,:)));
%     end
% end
% 
% clearvars Summary_UQ;

load("UQ_RAM.mat");
PSNR_RAM = squeeze(sum(Summary_UQ)/10);
for i = 1: 18
    for j = 1:7:8
    mean_RAM_psnr(i,j) = mean(squeeze(PSNR_RAM(i,j,15:100)));
    end
end

clearvars Summary_UQ;

load("UQ_LR.mat");
PSNR_LR = squeeze(sum(Summary_UQ)/10);
for i = 1: 18
    for j = 1:7:8
    mean_lr_psnr(i,j) = mean(squeeze(PSNR_LR(i,j,15:100)));
    end
end

clearvars Summary_UQ;

load("UQ_LR_SAL.mat");
PSNR_LR_SAL = squeeze(sum(Summary_UQ)/10);
for i = 1: 18
    for j = 1:7:8
    mean_lr_sal_psnr(i,j) = mean(squeeze(PSNR_LR_SAL(i,j,15:100)));
    end
end

clearvars Summary_UQ;

load("UQ_NOMAL_SAL.mat");
PSNR_NOMAL_SAL = squeeze(sum(Summary_UQ)/10);
for i = 1: 18
    for j = 1:7:8
    mean_nomal_sal_psnr(i,j) = mean(squeeze(PSNR_NOMAL_SAL(i,j,15:100)));
    end
end

clearvars Summary_UQ;


load("UQ_NOMAL.mat");
PSNR_NOMAL = squeeze(sum(Summary_UQ)/10);
for i = 1: 18
    for j = 1:7:8
    mean_nomal_psnr(i,j) = mean(squeeze(PSNR_NOMAL(i,j,15:100)));
    end
end

clearvars Summary_UQ;


DATARATE = 5:5:40;

X = 1:2:140;

forder_name = sprintf('fin_ALL')

mkdir(forder_name);


for i = 1:18
    for j = 1:7:8
        
        title_name = sprintf('Video %d %dM ALL',i,DATARATE(j));
        
        % PSNR_GT_P = squeeze(PSNR_GT(i,:,:));
        % PSNR_GT_SAL_P = squeeze(PSNR_GT_SAL(i,:,:));
        PSNR_RAM_P = squeeze(PSNR_RAM(i,:,:));
        PSNR_LR_P = squeeze(PSNR_LR(i,:,:));
        PSNR_LR_SAL_P = squeeze(PSNR_LR_SAL(i,:,:));
        PSNR_NOMAL_P = squeeze(PSNR_NOMAL(i,:,:));
        PSNR_NOMAL_SAL_P = squeeze(PSNR_NOMAL_SAL(i,:,:));


        file_name = strcat(forder_name,'/',title_name);
        
        figure
        hold on
        xlim([15 120])
        ylim([25 55])
        % plot(X,PSNR_GT_P(j,X),'-og');
        % plot(X,PSNR_GT_SAL_P(j,X),'-ob');
        plot(X,PSNR_RAM_P(j,X),'-*r');
        plot(X,PSNR_LR_P(j,X),'--g');
        plot(X,PSNR_LR_SAL_P(j,X),'--b');
        plot(X,PSNR_NOMAL_P(j,X),'-*g');
        plot(X,PSNR_NOMAL_SAL_P(j,X),'-*b');
        title(title_name)
        xlabel('PSNR') 
        ylabel('time') 
        legend('RAM','LR','LR+SAL','NOMAL','NOMA+SAL');
        hold off
        print(file_name,'-dpng')
    end
end

close all;
