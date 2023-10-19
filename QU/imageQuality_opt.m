%% Image Quility
%초기 값 설정

for tile_num = 1:64
    Q_opt(t,Uc,tile_num) = Q_P(t+Uc-1,tile_num,Xopt(t,Uc,tile_num));
end

%making UQ
for i = 0:N-1
    lon = fix(i/8)+1;
    lat = rem(i,8)+1;
    
    UQn_opt(t,Uc,i+1) = tile(t+Uc-1,lat,lon)*Q_opt(t,Uc,i+1);
    UQn_Level_opt(t,Uc,i+1) = tile(t+Uc-1,lat,lon)*Xopt(t,Uc,i+1);
end

UQ_opt(t+Uc-1) = sum(UQn_opt(t,Uc,:));
UQ_LEVEL_opt(t+Uc-1) = sum(UQn_Level_opt(t,Uc,:));

%making UV
if t+Uc > 2;
    UVN_opt = UQ_opt(t+Uc-1) - UQ_opt(t+Uc-2);
else
    UVN_opt = 0;
end

UVS_opt = std(UQn_opt(t,Uc,:));

UV_opt = abs(UVN_opt) + UVS_opt;

%Making U
U_opt(t,Uc) = UQ_opt(t+Uc-1) - lamda*UV_opt;