clear;
clc;

% addpath(genpath('../..'));

Renewal_init;

for video_type = 1:2
    
    type_num = string(video_type);
    tile_info_name = strcat("tile_",type_num,".mat");
    load(tile_info_name);
    
    for video_index = 1:9
    
        video_num = string(video_index);
        
        video_count = (video_type - 1) * 9 + video_index;
        
        for person = 1:45
        
            person_index = string(person);
            
            file_name = strcat(type_num,"_",video_num);
             %saliency loading
            Saliency_table_location = strcat("saliency/",file_name,".mat");
            
            load(Saliency_table_location);

            for i = 1:160
                W_S(i,:,:) = cell2mat(grid_sums(1,i));
            end
            
            file_video_num = string(video_index-1);

            data_set_name = strcat(type_num,"_",person_index,"_",file_video_num,".mat");
            
            LR_Data_name = strcat("DATA/E_tile/",data_set_name);
            E_FOV_Data_name = strcat("DATA/E_FOV/",data_set_name);
            FOV_Data_name = strcat("DATA/FOV/",data_set_name);

            load(LR_Data_name);
            load(E_FOV_Data_name);
            load(FOV_Data_name); 
                       
            
            %PSNR loading
            Q_PSNR = squeeze(PSNR(video_count,:,:,:,:));
            sque = size(Q_PSNR);
            Q_P = zeros(sque(1,1),64,6);
            
            for iter = 1:N
                Q_P(:,iter,:) = Q_PSNR(:,fix((iter-1)/8)+1,rem(iter-1,8)+1,:);
            end
            
            %view_port GT load
            tile = squeeze(tile_Index((person-1)*9+video_index,1:140,:,:));
            
            for Network = 1:8
                video_count
                person
                Network
                
                BWorigin = Network * 5000;
                BW = BWorigin;
                %%test sequence
                LY_LR;

                Summary_UQ_PSNR(person,Network,:) = UQ_opt;
                Summary_UQ_TILE(person,Network,:) = UQ_LEVEL_opt;

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
    
    clearvars tile_Index;

end

