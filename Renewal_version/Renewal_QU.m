%% Image Quility

%tile 별 Psnr 값 셋팅
if brunch == 0
    Q(t+l-1,:) = 0;
else
    for tile_num = 1:64
        Q(t+l-1,tile_num) = Q_P(t+l-1,tile_num,Xopt(t,l,tile_num));
    end
end

%Upgrade Tile 셋팅
for tile_num = 1:64
    Q_U(t+l-1,tile_num) = Q_P(t+l-1,tile_num,Xopt(t,l,tile_num) + Xupdate(t,l,tile_num));
end

%% flag 에 따른 계산식 변경

%Init일떄와 아닐떄 QoE 계산
for i = 0:N-1
    lon = fix(i/8)+1;
    lat = rem(i,8)+1;
    UQn(t,l,i+1) = tile(t+l-1,lat,lon)*(Q(t+l-1,i+1)+W(l)*(Q_U(t+l-1,i+1)-Q(t+l-1,i+1)));
end

UQ = sum(UQn(t,l,:));
 
%% 이전 UQ 값 계산
% if l > 1
%     if Xopt(t,l-1,1) == 0
%         Q(t,l-1,:) = 0;
%     else
%         Q(t,l-1,:) = Q_P(Xopt(t,l-1,:));
%     end
% 
%     for i = 0:N-1
%         lon = fix(i/8)+1;
%         lat = rem(i,8)+1;
%         UQn(t,l-1,i+1) = tile(t+l-1,lat,lon)*Q(t,l-1,i+1);
%     end
% 
%     UQ(t,l-1) = sum(UQn(t,l-1,:));
% end

%making UV
if t+l > 2;
    UVN = UQ - UQ_opt(t+l-1);
else
    UVN = 0;
end

UVS = std(UQn(t,l,:));

UV = abs(UVN) + UVS;

%Making U
U = UQ - lamda*UV;