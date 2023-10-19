% clear;
% clc;
Summary_UQ = zeros(48,18,8,130);
init_set_0510;

counter = 1

Xopt_sum = zeros(300,384);

load("PSNR.mat");

W_S = zeros(160,8,8);

for video_type = 1:1
    
    type_num = string(video_type);
    tile_info_name = strcat("tile_",type_num,".mat");
    load(tile_info_name);
    
    for video_index = 1:9
        
        for persion = 1:10
        
            I_I = string(persion);

            video_num = string(video_index);

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

        for Network = 1:5:6
            BWorigin = Network * 5000
            BW = BWorigin;
            algorithm_GT_sal;
            % Summary_UQ(persion,(video_type-1)*9+video_index,Network,time_index) = UQ_opt(time_index);
            Summary_UQ(persion,video_count,Network,:) = UQ_LEVEL_opt;
        end

        counter = counter +1

        end
        
     end

end

save("UQ_GT_SAL","Summary_UQ");

