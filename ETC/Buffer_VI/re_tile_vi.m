color_map_load;

load('2_LR_SAL_tile_set.mat');
load("DATA/FOV/1_1_0.mat");
load("tile_1.mat");

tile = squeeze(tile_Index(1,1:140,:,:));

S = tile>0;
tile(S) = 1;
tile = tile +1;

% tile_set_t = squeeze(fix(sum(Summary_tile_set(:,:,:,:,:))/45));
% tile_set_t = squeeze(Summary_tile_set(1,:,:,:,:)));
% 
% tile_set_t = squeeze(tile_set_t(8,:,:,:));
% 
% 
for time = 11:130
% tile_set_s = squeeze(tile_set_t(time,:,:,:)) +1;
% 
% for div = 0:63
%     lon = fix(div/8)+1;
%     lat = rem(div,8)+1;
%     tile_set(:,lat,lon) = tile_set_s(:,div+1);
% end

tile_set = tile(time:time+9,:,:);

img = zeros(380,1840,3);

for buffer_f = 1:2
    offset_y = (buffer_f-1)*190;
    for buffer_b = 1:5
        offset_x = (buffer_b-1)*370;
        buffer = buffer_b + (buffer_f-1)*5;
        for index_i = 1:8
            if rem(index_i,2) == 1
                Lat_img = fix(index_i/2)*45+23;
            else
                Lat_img = fix(index_i/2)*45;
            end
            for index_j = 1:8
                Lon_img = index_j*45;
                img(Lat_img-22+offset_y:Lat_img+offset_y,Lon_img-44+offset_x:Lon_img+offset_x,:) = Color_map(tile_set(buffer,index_i,index_j),:,:,:);
            end
        end
    end
end

for buffer_f = 1:2
    offset_y = (buffer_f-1)*190;
    for buffer_b = 1:5
        offset_x = (buffer_b-1)*370;
        buffer = buffer_b + (buffer_f-1)*5;
        for index_i = 1:8
            if rem(index_i,2) == 1
                Lat_img = fix(index_i/2)*45+23;
            else
                Lat_img = fix(index_i/2)*45;
            end
            for index_j = 1:8
                Lon_img = index_j*45;
                img(Lat_img+offset_y,:,:) = 0;
                img(:,Lon_img+offset_x,:) = 0;
            end
        end
    end
end

img = uint8(img);
imshow(img);
hold on
for buffer_f = 1:2
    offset_y = (buffer_f-1)*190;
    for buffer_b = 1:5
        offset_x = (buffer_b-1)*370;
        buffer = buffer_b + (buffer_f-1)*5;

        % e_fov = E_FOV_AREA{time-10,buffer};
        % e_fov(:,2) = e_fov(:,2)+offset_x;
        % e_fov(:,1) = e_fov(:,1)+offset_y;
        % plot(e_fov(:,2),e_fov(:,1),'g','LineWidth', 2)

        fov = FOV_AREA{1,time+buffer-1};
        fov(:,2) = fov(:,2)+offset_x;
        fov(:,1) = fov(:,1)+offset_y;
        plot(fov(:,2),fov(:,1),'k','LineWidth', 2)
    end
end
hold off

clearvars tile_set;

end
