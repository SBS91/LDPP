color_map_load;

tilse_set_s = ANS;
for N = 0:63
    lon = fix(N/8)+1;
    lat = rem(N,8)+1;
    tile_set(:,lat,lon) = tile_set_s(:,N+1);
end

img = zeros(380,1840,3);

for buffer_f = 1:2
    offset_y = (buffer_f-1)*190;
    for buffer_b = 1:5
        offset_x = (buffer_b-1)*370;
        buffer = buffer_b + (buffer_f-1)*5;
        for i = 1:8
            if rem(i,2) == 1
                Lat = fix(i/2)*45+23;
            else
                Lat = fix(i/2)*45;
            end
            for j = 1:8
                Lon = j*45;
                img(Lat-22+offset_y:Lat+offset_y,Lon-44+offset_x:Lon+offset_x,:) = Color_map(tile_set(buffer,i,j),:,:,:);
            end
        end
    end
end

for buffer_f = 1:2
    offset_y = (buffer_f-1)*190;
    for buffer_b = 1:5
        offset_x = (buffer_b-1)*370;
        buffer = buffer_b + (buffer_f-1)*5;
        for i = 1:8
            if rem(i,2) == 1
                Lat = fix(i/2)*45+23;
            else
                Lat = fix(i/2)*45;
            end
            for j = 1:8
                Lon = j*45;
                img(Lat+offset_y,:,:) = 0;
                img(:,Lon+offset_x,:) = 0;
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

        e_fov = E_FOV_AREA{time-1,buffer};
        e_fov(:,2) = e_fov(:,2)+offset_x;
        e_fov(:,1) = e_fov(:,1)+offset_y;
        plot(e_fov(:,2),e_fov(:,1),'g','LineWidth', 2)

        fov = FOV_AREA{1,time+buffer-1};
        fov(:,2) = fov(:,2)+offset_x;
        fov(:,1) = fov(:,1)+offset_y;
        plot(fov(:,2),fov(:,1),'k','LineWidth', 2)
    end
end
hold off
% 
% end