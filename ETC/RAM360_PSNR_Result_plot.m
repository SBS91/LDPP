X = 1:1:140;


UQ = zeros(48,18,8,140);

for i = 1:8

    I_num = string(i);
    file_name = strcat("UQ_RAM_vid",I_num,".mat");

    load(file_name)

    UQ = UQ + Summary_UQ;

    clearvars Summary_UQ

end


UQ_sum = squeeze(sum(UQ));

UQ_S = squeeze(sum(UQ_sum));

UQ_T = UQ_S/8/45;

UQ_M = UQ_T(:,11:130);

% C = UQ_M == NaN;

UQ_M(isnan(UQ_M)) = 65;

for i = 1:8
    UQ_M_T = squeeze(UQ_M(i,:));
    UQ_M_S(i,1) = nanmean(UQ_M_T.');
end

% % 
% % load("UQ_NOMAL.mat");
% % Summary_UQ(39,:,:,:) = 0;
% % Result_NO = sum(sum(Summary_UQ));
% % Result_NO = squeeze(Result_NO)/15/9;
% % 
% % for i = 1:8
% %     NS_S = Result_NO(i,:);
% %     NO_V(i) = var(NS_S);
% %     NO(i) = mean(NS_S,'all');
% % end
% % 
% % load("UQ_NOMAL_SAL.mat");
% % Result_NS = sum(sum(Summary_UQ));
% % Result_NS = squeeze(Result_NS)/48/9;
% % 
% % for i = 1:8
% %     NS_S = Result_NS(i,:);
% %     NS_V(i) = var(NS_S);
% %     NS(i) = mean(NS_S,'all');
% % end
% 
% 
% % load("UQ_LR.mat");
% % Summary_UQ(39,:,:,:) = 0;
% % Result_LR = sum(sum(Summary_UQ));
% % Result_LR = squeeze(Result_LR);
% % 
% % for i = 1:8
% %     NS_S = Result_LR(i,:);
% %     LR_V(i) = var(NS_S);
% %     LR(i) = mean(NS_S,'all');
% % end
% 
% % load("UQ_LR_SAL.mat");
% % Summary_UQ(39,:,:,:) = 0;
% % Result_LS = sum(sum(Summary_UQ));
% % Result_LS = squeeze(Result_LS);
% % for i = 1:8
% %     NS_S = Result_LS(i,:);
% %     LS_V(i) = var(NS_S);
% %     LS(i) = mean(NS_S,'all');
% % end
% % 
% % load("UQ_GT.mat");
% % Summary_UQ(45,:,:,:) = 0;
% % Result_GT = sum(sum(Summary_UQ));
% % Result_GT = squeeze(Result_GT)/44/9;
% % for i = 1:8
% %     NS_S = Result_GT(i,:);
% %     GT_V(i) = var(NS_S);
% %     GT(i) = mean(NS_S,'all');
% % end
% % 
% % load("UQ_GT_SAL.mat");
% % Summary_UQ(42,:,:,:) = 0;
% % Result_GS = sum(sum(Summary_UQ));
% % Result_GS = squeeze(Result_GS)/41/9;
% % for i = 1:8
% %     NS_S = Result_GS(i,:);
% %     GS_V(i) = var(NS_S);
% %     GS(i) = mean(NS_S,'all');
% % end
% 
% figure
% plot(X,Result_LR(2,X),'-*b');
% % plot(X,Result_NS(1,X),'-+g');
% hold on
% xlim([10 120])
% ylim([25 50])
% % plot(X,Result_NO(1,X),'-+b');
% plot(X,Result_LS(2,X),'-*g');
% % plot(X,Result_GT(1,X),'-ob');
% % plot(X,Result_GS(1,X),'-og');
% legend('LS-5M','LR-5M');
% 
% % legend('NS-5M','LR-5M','LS-5M','GT-5M','GS-5M');
% 
% hold off
% 
% figure
% plot(X,Result_LR(8,X),'-*b');
% 
% % plot(X,Result_NS(8,X),'-+g');
% hold on
% xlim([10 120])
% ylim([25 50])
% % plot(X,Result_NO(8,X),'-+b');
% % plot(X,Result_GT(8,X),'-ob');
% % plot(X,Result_GS(8,X),'-og');
% plot(X,Result_LS(8,X),'-*g');
% legend('LS-40M','LR-40M');
% % legend('NS-40M','GT-40M','GS-40M','LR-40M','LS-40M');
% 
% hold off


V = 1:8;
W = V*5;
figure
plot(W(V),UQ_M_S(V,1),"-or");
hold on
title('RAM 360 Algorithm PSNR by network bandwidth');
xlim([0 50])
ylim([34 48])
xlabel('Mbps');
ylabel('PSNR');
legend('RAM360');
hold off

% sigmoid_psnr = (40 ./ (1 + exp(-adjusted_psnr*0.1))) - 20
