% clear;
% clc;
% init_set1220;
% data_set0302
% tile_selection0101;
%% Initial Value
time = 0;
brunch = 0;
V = 0.5;
Xupdate = zeros(T,L,N);
Xopt = zeros(T,L,N);
Update_opi = zeros(N,1);
t = 11;
% Xopt(1,:,:) = ones;
bw = zeros(L,1);
BW_redun = zeros(T,1);
U_before = zeros(T,L);
Util = zeros(L,1);
timingA = 0;
timingB = 0;
BWremain = BWorigin;
Lcount = zeros(L,1);
I = zeros(T,L);

DATA_amount = 0;
%% Optimization

while t < T-15
%     Update_opi = Xopt;
    for l = 1:L
%         Xupdate = Xopt;

        brunch = 0;
        C = zeros(N,1);
        Imq = zeros(N,1);

        brunch = sum(Xopt(t,l,:));

%         U = U_opt;

        Lcount = squeeze(Xopt(t,:,1));

        buffer_amount = nnz(Lcount);

        if brunch == 0
            Xupdate(t,l,:) = 1;
            bw(l,1) = 3200;

            QU_GT;

            I = U - U_opt(t,l);
            
            if bw(l,1)>BWremain
                break;
            end
            
            Util(l,1) = (V*I - 0.2*(buffer_amount))/bw(l,1);
%             Update_opi(t,l,:) = Xupdate(t,l,:);

        elseif max(Xopt(t,l,:),[],'all') < 6
            
            bw(l,1) = 0;
            C = zeros(N,1);

            gt_fov_area = squeeze(tile(t+l-1,:,:));

            gt_fov_tile = gt_fov_area == 0;

            for k = 1:N
                for j = 1:N
                    lon = fix((j-1)/8)+1;
                    lat = rem(j-1,8)+1;
                    if ismember(j,C) | gt_fov_tile(lat,lon)
                        Imq(j) = 0;
                    else
                        b = 0;
                        Xupdate(t,l,j) = 1;
                        
                        QU_GT;
%                         if brunch  == 0 & t == 1
%                             Itest(t,l) = U(t,l);
                   
                        I = U - U_opt(t,l);   
                        Z = Xupdate(t,l,j);
                        b = b + DR(Z);
                        Imq(j) = V*I/b;
                        Xupdate(t,l,j) = 0;
                    end
                end

                if sum(Imq) == 0
                    break;
                else
                    [a c] = max(Imq);
                    Imq = zeros(N,1);
                    % cc = c(1,1);
                    Update_opi(c,1) = 1;
                    Z = Xopt(t,l,c) + 1;
                    bw(l,1) = bw(l,1) + DR(Z);
                    Z = 0;
                    C(k,1) = c; %% 모든 청크에 대해 업데이트

                    if bw(l,1)>BWremain
                        break;
                    end
                end
            end

            clearvars gt_fov_tile,gt_fov_area;
            
            
            Xupdate(t,l,:) = squeeze(Update_opi(:,1));

            QU_GT;

            I = U - U_opt(t,l);

            if bw(l,1)>0
                Util(l,1) = V*I/bw(l,1);
            else
                Util(l,1) = -1000;
            end
        else
            Util(l,1) = -900;

        end

        Update_opi = zeros(N,1);

    end

    [Ua Uc] = max(Util);

    
    if Util(Uc) > -1000

        Util = zeros(L,1);

        Xopt(t,Uc,:) = Xopt(t,Uc,:) +  Xupdate(t,Uc,:);
        Update_tile = squeeze(Xopt(t,:,:));    

        imageQuality_opt;

        Xupdate = zeros(T,L,N);
        Update_opi = zeros(N,1);

        DATA_amount = bw(Uc,1);
        time_A = time;
        timingA = fix(time);
        time = time + DATA_amount/BWorigin;
        time_B = time;
        timingB = fix(time);
    
    end

%     ANS = squeeze(Xopt(t,:,:));
%     
%     tile_vi;

    DATA_amount = 0;

    if time_A == time_B
            BWremain = BWorigin;
        for time_shift = 1:9
            Xopt(t+1,time_shift,:) = Xopt(t,time_shift+1,:);
            U_opt(t+1,time_shift) = U_opt(t,time_shift+1);
        end
        t = t+1;
    elseif timingA ~= timingB
        BWremain = (1-(time-t))*BWorigin;
        for time_shift = 1:9
            Xopt(t+1,time_shift,:) = Xopt(t,time_shift+1,:);
            U_opt(t+1,time_shift) = U_opt(t,time_shift+1);
        end
        t = t+1;
    end
end       