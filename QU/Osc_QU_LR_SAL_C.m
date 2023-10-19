%% Image Quility


%tile 별 Psnr 값 셋팅
if Xopt(t,c_buffer,1) == 0
    Q(t+c_buffer-1,:) = 0;
else
    for tile_num = 1:64
        Q(t+c_buffer-1,tile_num) = Q_P(t+c_buffer-1,tile_num,Xopt(t,c_buffer,tile_num));
    end
end

%Upgrade Tile 셋팅
for tile_num = 1:64
    Q_U(t+c_buffer-1,tile_num) = Q_P(t+c_buffer-1,tile_num,Xopt(t,c_buffer,tile_num) + Xupdate(t,c_buffer,tile_num));
end

%Init일떄와 아닐떄 QoE 계산
if brunch == 0
    for i = 0:N-1
        lon = fix(i/8)+1;
        lat = rem(i,8)+1;
        UQn(t,c_buffer,i+1) = 64*W(c_buffer)*W_S(t+c_buffer-1,lat,lon)*E_tile(t-10,c_buffer,lat,lon)*Q_U(t+c_buffer-1,i+1); 
%         UQn(t,c_buffer,i+1) = W(t+c_buffer-1,lat,lon)*Q_U(t+c_buffer-1,i+1);
    end
    %정확도에 대한 수식이 있는경우 활용
else
    for i = 0:N-1
        lon = fix(i/8)+1;
        lat = rem(i,8)+1;
        UQn(t,c_buffer,i+1) = E_tile(t-10,c_buffer,lat,lon)*(Q(t+c_buffer-1,i+1)+W(c_buffer)*64*W_S(t+c_buffer-1,lat,lon)*(Q_U(t+c_buffer-1,i+1)-Q(t+c_buffer-1,i+1)));
    end
end

UQ = sum(UQn(t,c_buffer,:));
 
% %이전 UQ 값 계산
% if c_buffer > 1
%     if Xopt(t,c_buffer-1,1) == 0
%         Q(t,c_buffer-1,:) = 0;
%     else
%         Q(t,c_buffer-1,:) = Q_P(Xopt(t,c_buffer-1,:));
%     end
% 
%     for i = 0:N-1
%         lon = fix(i/8)+1;
%         lat = rem(i,8)+1;
%         UQn(t,c_buffer-1,i+1) = tile(t+c_buffer-1,lat,lon)*Q(t,c_buffer-1,i+1);
%     end
% 
%     UQ(t,c_buffer-1) = sum(UQn(t,c_buffer-1,:));
% end

%making UV
if t+c_buffer > 2;
    UVN = UQ - UQ_opt(t+c_buffer-2);
else
    UVN = 0;
end

UVS = std(UQn(t,c_buffer,:));

UV = abs(UVN) + UVS;

%Making U
U_sal = UQ - 2*lamda*UV;