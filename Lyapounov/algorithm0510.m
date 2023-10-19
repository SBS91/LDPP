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
t = 1;
% Xopt(1,:,:) = ones;
bw = zeros(L,1);
Util = zeros(L,1);
timingA = 0;
timingB = 0;
BWremain = BWorigin;
Lcount = zeros(L,1);
I = zeros(T,L);

DATA_amount = 0;
%% Optimization

while time < T-10
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

            imageQuality;

            I = U - U_opt(t+l-1);
            
            if bw(l,1)>BWremain
                break;
            end
            
            Util(l,1) = (V*I - 0.2*(buffer_amount))/bw(l,1);
%             Update_opi(t,l,:) = Xupdate(t,l,:);

        elseif max(Xopt(t,l,:),[],'all') < 6
            
            bw(l,1) = 0;
            C = zeros(N,1);

            for k = 1:N
                for j = 1:N
                    lon = fix((j-1)/8)+1;
                    lat = rem(j-1,8)+1;
                    if ismember(j,C) | tile(t+l,lon,lat)
                        Imq(j) = 0;
                    else
                        b = 0;
                        Xupdate(t,l,j) = 1;
                        
                        imageQuality;
%                         if brunch  == 0 & t == 1
%                             Itest(t,l) = U(t,l);
                   
                        I = U - U_opt(t+l-1);   
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
                    cc = c(1,1);
                    Update_opi(cc,1) = 1;
                    Z = Xopt(t,l,cc) + 1;
                    bw(l,1) = bw(l,1) + DR(Z);
                    Z = 0;
                    C(k,1) = cc; %% 모든 청크에 대해 업데이트

                    if bw(l,1)>BWremain
                        break;
                    end
                end
            end
            
            Xupdate(t,l,:) = squeeze(Update_opi(:,1));

            imageQuality;

            I = U - U_opt(t+l-1);

            Util(l,1) = V*I/bw(l,1);
        else
            Util(l,1) = -1000;
        end

    end

    [Ua Uc] = max(Util);

    
    if Util(Uc) > -100

        Util = zeros(L,1);

        Xopt(t,Uc,:) = Xopt(t,Uc,:) +  Xupdate(t,Uc,:);
        
        imageQuality_Opt;

        Xupdate = zeros(T,L,N);
        Update_opi = zeros(N,1);

        DATA_amount = bw(Uc,1);

        timingA = fix(time);
        time = time + DATA_amount/BWorigin;
        timingB = fix(time);
    end

    DATA_amount = 0;


    if timingA ~= timingB
        BWremain = (1-(time-t))*BWorigin;
        t = t+1;
    end
end       