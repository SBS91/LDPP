%% Image Quility


%tile 별 Psnr 값 셋팅
if Xopt(t,l,1) == 0
    Q(t+l-1,:) = 0;
else
    for tile_num = 1:64
        Q(t+l-1,tile_num) = Xopt(t,l,tile_num);
    end
end

%Upgrade Tile 셋팅
for tile_num = 1:64
    Q_U(t+l-1,tile_num) = Xopt(t,l,tile_num) + Xupdate(t,l,tile_num);
end

%Init일떄와 아닐떄 QoE 계산
if brunch == 0
    for i = 0:N-1
        lon = fix(i/8)+1;
        lat = rem(i,8)+1;
        UQn(t,l,i+1) = 64*W(l)*W_S(t+l-1,lat,lon)*E_tile(t-10,l,lat,lon)*Q_U(t+l-1,i+1); 
%         UQn(t,l,i+1) = W(t+l-1,lat,lon)*Q_U(t+l-1,i+1);
    end
    %정확도에 대한 수식이 있는경우 활용
else
    for i = 0:N-1
        lon = fix(i/8)+1;
        lat = rem(i,8)+1;
        UQn(t,l,i+1) = E_tile(t-10,l,lat,lon)*(Q(t+l-1,i+1)+64*W(l)*W_S(t+l-1,lat,lon)*(Q_U(t+l-1,i+1)-Q(t+l-1,i+1)));
    end
end

UQ = sum(UQn(t,l,:));
 
% %이전 UQ 값 계산
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
    UVN = UQ - UQ_opt(t+l-2);
else
    UVN = 0;
end

UVS = std(UQn(t,l,:));

UV = abs(UVN) + UVS;

%Making U
U = UQ - lamda*UV;