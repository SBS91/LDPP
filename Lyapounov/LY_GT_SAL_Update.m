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

while time < T-20
    
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
    exist BASE var

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
    
            QU_GT_sal;
    
            I = U - U_opt(t+l-1);
                
            if bw(l,1)>BWremain
                break;
            end
                
            Util(l,1) = (V*I - 0.2*(buffer_amount))/bw(l,1)*1000;
    %             Update_opi(t,l,:) = Xupdate(t,l,:);
        end
    
        [Ua Uc] = max(Util);

    end
    
    exist ENHANCE var
    
    if ans ==1

        for l = ENHANCE
    
            % if max(Xopt(t,l,:),[],'all') < 6
            bw_up = zeros(L,1);
            % bw(l,N) = 0;
            C = zeros(l,N);
    
            % for k = 1:N
            for j = 1:N
                lon = fix((j-1)/8)+1;
                lat = rem(j-1,8)+1;
                if tile(t+l,lon,lat)==0
                    Imq(l,j) = 0;
                elseif Xopt(t,l,j) == 6
                    Imq(l,j) = -1000;
                else
                    b = 0;
                    Xupdate(t,l,j) = 1;
                    
                    QU_GT_sal;
    %                         if brunch  == 0 & t == 1
    %                             Itest(t,l) = U(t,l);
               
                    I = U - U_opt(t+l-1);   
                    Z = Xupdate(t,l,j);
                    b = b + DR(Z);
                    Imq(l,j) = V*I/b;
                    Xupdate(t,l,j) = 0;
                end
            end
        end
    end
        % if sum(Imq) == 0
        %     break;
        % else
        %     [a c] = max(Imq);
        %     Imq = zeros(N,1);
        %     cc = c(1,1);
        %     Update_opi(cc,1) = 1;
        %     Z = Xopt(t,l,cc) + 1;
        %     bw(l,1) = bw(l,1) + DR(Z);
        %     Z = 0;
        %     C(k,1) = cc; %% 모든 청크에 대해 업데이트
        % 
        %     if bw(l,1)>BWremain
        %         break;
        %     end
        % end
        % end

        if max(Imq,[],"all") < Util(Uc)

            Xopt(t,Uc,:) = Xopt(t,Uc,:) +  Xupdate(t,Uc,:);
            DATA_amount = bw(Uc,1);

        else

            while  max(Imq,[],'all') > Util(Uc)
    
                [a, max_index] = max(Imq,[],'all','linear');
                c_tile = fix((max_index-1)/10)+1;
                c_buffer = rem(max_index-1,10) + 1;
                Imq(c_buffer,c_tile) = 0;
                % Update_opi(cc,1) = 1;
                Z = Xopt(t,c_buffer,c_tile) + 1;
                bw_up(c_buffer) = bw_up(c_buffer) + DR(Z);
            
                Xupdate(t,c_buffer,c_tile) = 1;
            
                QU_GT_sal_test;
            
                I_sal = U_sal - U_opt(t+c_buffer-1);
            
                Util_up(c_buffer,1) = V*I_sal/bw_up(c_buffer);
                % else
                %     Util(l,1) = -1000;
                % end
            
                counter = counter +1;
    
                for update_util_id = 1:L
                    update_util = update_util + Util_up(update_util_id)*bw_up(update_util_id);
                end

                update_util = update_util / sum(bw_up);
    
                if update_util < Util(Uc) | sum(bw_up)>BWremain
                    break;
                end
    
            end
            
            Xopt(t,:,:) = Xopt(t,:,:) +  Xupdate(t,:,:);
            DATA_amount = sum(bw_up);

        end
    
    Util = zeros(L,1);
    Util_up = zeros(L,1);
    update_util = 0;
    
    imageQuality_opt;

    Xupdate = zeros(T,L,N);
    Update_opi = zeros(N,1);

    timingA = fix(time);
    time = time + DATA_amount/BWorigin;
    timingB = fix(time);

    DATA_amount = 0;


    % if timingA == timingB
    %     BWremain = BWorigin;
    %     BW_redun(t) = (t+1-time)*BWorigin;
    %     for time_shift = 1:9
    %         Xopt(t+1,time_shift,:) = Xopt(t,time_shift+1,:);
    %     end
    %     t = t+1;
    if timingA ~= timingB
        BWremain = (1-(time-t))*BWorigin;
        for time_shift = 1:9
            Xopt(t+1,time_shift,:) = Xopt(t,time_shift+1,:);
        end
        t = t+1;
    end
end