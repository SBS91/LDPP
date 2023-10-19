% clear;
% clc;
% init_set1220;
% data_set0302
% tile_selection0101;
%% Initial Value
UQ_opt = zeros(T,1);
UQ_LEVEL_opt = zeros(T,1);
time = 0;
brunch = 0;
V = 0.5;
Xupdate = zeros(T,L,N);
Xopt = zeros(T,L,N);
Update_opi = zeros(N,1);
t = 11;
% Xopt(1,:,:) = ones;
bw = zeros(L,1);
Util = zeros(L,1);
timingA = 0;
timingB = 0;
U_before = zeros(T,L);

BWremain = BWorigin;
Lcount = zeros(L,1);
I = zeros(T,L);
brunch = zeros(L,1);

DATA_amount = 0;

base_count = 0;
enhance_count = 0;
Util_up = 100;

%% Optimization

while t < T-20
    
    Lcount = squeeze(Xopt(t,:,1));
    Imq = zeros(L,N);

    base_count = 0;
    enhance_count = 0;

    clearvars BASE ENHANCE;
    
    for init_up = 1:L
        if Lcount(init_up) == 0
            base_count = base_count +1;
            BASE(base_count) = init_up;
        else
            enhance_count = enhance_count +1;
            ENHANCE(enhance_count) = init_up;
        end
    end
%     Update_opi = Xopt;
    exist BASE var;

    if ans == 1

        for l = BASE
    %         Xupdate = Xopt;
    
            brunch = 0;
            C = zeros(N,1);
            % Imq = zeros(L,N);
    
            % brunch(:,1) = sum(Xopt(t,:,:));
    
    %         U = U_opt;
    
            Lcount = squeeze(Xopt(t,:,1));
    
            buffer_amount = nnz(Lcount);
    
            Xupdate(t,l,:) = 1;
            bw(l,1) = 3200;
    
            time_weight_QU_LR_SAL_L;
    
            I = U - U_before(t,l);
                
            % if bw(l,1)>BWremain
            %     break;
            % end
                
            Util(l,1) = (V*I - 0.2*(buffer_amount))/bw(l,1);
    %             Update_opi(t,l,:) = Xupdate(t,l,:);
        end
    
        [Ua Uc] = max(Util);

    end
    
    exist ENHANCE var;
    
    if ans ==1

        for l = ENHANCE

            brunch = 64;
    
            % if max(Xopt(t,l,:),[],'all') < 6
            bw_up = zeros(L,1);
            % bw(l,N) = 0;
            C = zeros(l,N);
    
            % for k = 1:N
            for j = 1:N
                lon = fix((j-1)/8)+1;
                lat = rem(j-1,8)+1;
                if E_tile(t-10,l,lat,lon)==0
                    Imq(l,j) = -1000;
                elseif Xopt(t,l,j) == 6
                    Imq(l,j) = -1000;
                else
                    b = 0;
                    Xupdate(t,l,j) = 1;
                    
                    time_weight_QU_LR_SAL_L;
               
                    I = U - U_before(t,l);   
                    Z = Xupdate(t,l,j);
                    b = b + DR(Z);
                    Imq(l,j) = V*I/b;
                    Xupdate(t,l,j) = 0;
                end
            end
        end
    end

    exist BASE var;

    if ans ==1
    Imq(BASE,:) = -1000;
    end

    if max(Imq,[],"all") < Util(Uc) && Util(Uc) ~= 0

        Xopt(t,Uc,:) = Xopt(t,Uc,:) +  Xupdate(t,Uc,:);
        DATA_amount = bw(Uc,1);
        
        imageQuality_opt;
        imageQuality_est;

    else

        while  DATA_amount < BWremain

            [a, max_index] = max(Imq,[],'all','linear');

            if a == -1000
                break;
            end

            c_tile = fix((max_index-1)/10)+1;
            c_buffer = rem(max_index-1,10) + 1;
            Imq(c_buffer,c_tile) = -1000;

            Z = Xopt(t,c_buffer,c_tile) + 1;
            
            bw_up = DR(Z);
        
            Xupdate(t,c_buffer,c_tile) = 1;

            Xopt(t,c_buffer,c_tile) = Xopt(t,c_buffer,c_tile) +  Xupdate(t,c_buffer,c_tile);
            DATA_amount = DATA_amount + bw_up;

            Xupdate(t,c_buffer,c_tile) = 0;

            if Xopt(t,c_buffer,c_tile) < 6
                b = 0;
               
                Xupdate(t,c_buffer,c_tile) = 1;
                
                time_weight_QU_LR_SAL_C;
           
                I = U - U_before(t,c_buffer);
                
                Z = Xopt(t,c_buffer,c_tile) + Xupdate(t,c_buffer,c_tile);

                b = DR(Z);
                Imq(c_buffer,c_tile) = V*I/b;
                Xupdate(t,c_buffer,c_tile) = 0;
            end

            Uc = c_buffer;

            imageQuality_opt;
            imageQuality_est;

            % ANS = squeeze(Xopt(t,:,:));
            % 
            % tile_vi;
        end
    end

    Util = zeros(L,1);
    Util_up = zeros(L,1);
    update_util = 0;

    Xupdate = zeros(T,L,N);
    Update_opi = zeros(N,1);

    % ANS = squeeze(Xopt(t,:,:));
    % 
    % tile_vi;

    timeA = time;

    timingA = fix(time);
    time = time + DATA_amount/BWorigin;
    timingB = floor(time+0.0001);

    BWremain = BWremain - DATA_amount;

    DATA_amount = 0;

    offset_time = timingB - timingA;

    if timingA ~= timingB
        BWremain = BWremain + offset_time*BWorigin;
        for time_shift = 1:9
            Xopt(t+offset_time,time_shift,:) = Xopt(t,time_shift+1,:);
        end
        t = t + offset_time;
    elseif time == timeA
        BWremain = BWremain + BWorigin;
        for time_shift = 1:9
            Xopt(t+1,time_shift,:) = Xopt(t,time_shift+1,:);
        end
        t = t + 1;
    end
end