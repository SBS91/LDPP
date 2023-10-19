clear;
clc;

addpath(genpath('../..'));

color_map_load;

Summary_UQ = zeros(48,18,8,140);
Summary_tile_set = zeros(48,8,140,10,64);
init_set_0510;

Summary_UQ_PSNR = zeros(48,8,140);
Summary_UQ_TILE = zeros(48,8,140);

Xopt_sum = zeros(300,384);

load("N_PSNR.mat");

W_S = zeros(160,8,8);

for video_type = 1:2
    
    type_num = string(video_type);
    tile_info_name = strcat("tile_",type_num,".mat");
    load(tile_info_name);
    
    for video_index = 6:9
    
        video_num = string(video_index);
        
        video_count = (video_type - 1) * 9 + video_index;
        
        for persion = 1:45
        
            I_I = string(persion);
            
            file_name = strcat(type_num,"_",video_num);
             %saliency loading
            Saliency_table_location = strcat("saliency/",file_name,".mat");
            
            load(Saliency_table_location);
            
            video_num2 = string(video_index-1);
            
            LR_Data_name = strcat("DATA/E_tile/",type_num,"_",I_I,"_",video_num2,".mat");
            load(LR_Data_name);
            
            E_FOV_Data_name = strcat("DATA/E_FOV/",type_num,"_",I_I,"_",video_num2,".mat");
            load(E_FOV_Data_name);
            
            FOV_Data_name = strcat("DATA/FOV/",type_num,"_",I_I,"_",video_num2,".mat");
            load(FOV_Data_name);
                        
            for i = 1:160
                W_S(i,:,:) = cell2mat(grid_sums(1,i));
            end
            
            %PSNR loading
            Q_PSNR = squeeze(PSNR(video_count,:,:,:,:));
            sque = size(Q_PSNR);
            Q_P = zeros(sque(1,1),64,6);
            
            for iter = 1:N
                Q_P(:,iter,:) = Q_PSNR(:,fix((iter-1)/8)+1,rem(iter-1,8)+1,:);
            end
            
            %view_port GT load
            tile = squeeze(tile_Index((persion-1)*9+video_index,1:140,:,:));
            
            for Network = 1:8
                video_count
                persion
                Network
                
                BWorigin = Network * 5000;
                BW = BWorigin;
                %%test sequence
                LY_LR;

                Summary_UQ_PSNR(persion,Network,:) = UQ_opt;
                Summary_UQ_TILE(persion,Network,:) = UQ_LEVEL_opt;

                clearvars UQ_opt UQ_LEVEL_opt;
            end
        end
        
        video_count_name = string(video_count);
        tile_set_name = strcat(video_count_name,"_LR_tile");
        psnr_set_name = strcat(video_count_name,"_LR_psnr");
        save(tile_set_name,"Summary_UQ_TILE");
        save(psnr_set_name,"Summary_UQ_PSNR");
        
        clearvars Summary_UQ_PSNR Summary_UQ_TILE;
            
    end
end

