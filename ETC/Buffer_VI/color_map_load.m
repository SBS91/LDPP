Color_map = zeros(7,23,45,3);
I = zeros(45,90,3);
tile_set = zeros(10,8,8);
tile_set_s = zeros(10,64);
for i = 1:7
    file_name = string(i-1);
    filename = strcat(file_name,".png");
    I_img = imread(filename);
    % imshow(filename);
    Color_map(i,:,:,:) = imresize(I_img,0.5);
    % imshow(uint8(squeeze(Color_map(i,:,:,:))));
end
