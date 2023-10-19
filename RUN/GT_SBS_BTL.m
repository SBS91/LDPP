% clear;
% clc;
Summary_UQ = zeros(48,18,8,140);
Summary_reden = zeros(48,18,8,140);
init_set_0510;

counter = 1

Xopt_sum = zeros(300,384);

load("PSNR.mat");

W_S = zeros(160,8,8);

for video_type = 1:2
    
    type_num = string(video_type);
    tile_info_name = strcat("tile_",type_num,".mat");
    load(tile_info_name);
    
    for video_index = 1:9

    video_num = string(video_index);
        
    for persion = 1:15
            
        I_I = string(persion);
        
        file_name = strcat(type_num,"_",video_num);
             %saliency loading
            Saliency_table_location = strcat("saliency/",file_name,".mat");

            load(Saliency_table_location);

            % W_S = cell2mat(grid_sums)

            for i = 1:160
                W_S(i,:,:) = cell2mat(grid_sums(1,i));
            end

            video_count = (video_type - 1) * 9 + video_index;
            
            %PSNR loading
            Q_PSNR = squeeze(PSNR(video_count,:,:,:,:));
            sque = size(Q_PSNR);
            Q_P = zeros(sque(1,1),64,6);

            for iter = 1:N
                Q_P(:,iter,:) = Q_PSNR(:,fix((iter-1)/8)+1,rem(iter-1,8)+1,:);
            end

            %view_port GT load
            tile = squeeze(tile_Index((persion-1)*9+video_index,1:140,:,:));

        for Network = 6:8
            BWorigin = Network * 5000
            BW = BWorigin;
            LY_GT_SAL_Update;

            Summary_UQ(persion,(video_type-1)*9+video_index,Network,:) = UQ_LEVEL_opt;
            % Summary_reden(persion,(video_type-1)*9+video_index,Network,:) = BW_redun;
            Summary_tile_set(persion,Network,:,:,:) = Xopt;
        end
            counter = counter +1

        end

        video_count_name = string(video_count);
        tile_set_name = strcat("Result/Updated_tile/",video_count_name,"_GT_tile_set");
        save(tile_set_name,"Summary_tile_set");

        clearvars Summary_tile_set;
        
     end

end

save("Result/fov_level/GT","Summary_UQ");


