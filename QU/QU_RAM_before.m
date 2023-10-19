%% Image Quility

%tile 별 Psnr 값 셋팅
if Xopt(t,Uc,1) == 0
    Q(t+Uc-1,:) = 0;
else
    for tile_num = 1:64
        Q(t+Uc-1,tile_num) = squeeze(Q_P(t+Uc-1,tile_num,Xopt(t,Uc,tile_num)));
    end
end

%Upgrade Tile 셋팅
for tile_num = 1:64
    Q_U(t+Uc-1,tile_num) = Q_P(t+Uc-1,tile_num,Xopt(t,Uc,tile_num));
end

%Init일떄와 아닐떄 QoE 계산
% if brunch == 0
    for i = 0:N-1
        lat = rem(i,8)+1;
        lon = fix(i/8)+1;
        UQn(t,Uc,i+1) = W(Uc)*E_tile(t-10,Uc,lat,lon)*Q_U(t+Uc-1,i+1);
%         UQn(t,Uc,i+1) = W(t+Uc-1,lat,lon)*Q_U(t+Uc-1,i+1);
    end
    %정확도에 대한 수식이 있는경우 활용
% else
%     for i = 0:N-1
%         lon = fix(i/8)+1;
%         lat = rem(i,8)+1;
%         UQn(t,Uc,i+1) = E_tile(t-10,Uc,lat,lon)*(Q(t+Uc-1,i+1)+W(Uc)*(Q_U(t+Uc-1,i+1)-Q(t+Uc-1,i+1)));
%     end
% end

UQ = sum(UQn(t,Uc,:));
 
%이전 UQ 값 계산
% if Uc > 1
% 
%     for i = 0:N-1
%         lon = fix(i/8)+1;
%         lat = rem(i,8)+1;
%         UQn_before(t,Uc-1,i+1) = E_tile(t+Uc-1,lat,lon)*Q(t,Uc-1,i+1);
%     end
% 
%     UQ_before = sum(UQn_before(t,Uc-1,:));
% end

%making UV
if t+Uc > 2;
    UVN = UQ - UQ_opt(t+Uc-2);
else
    UVN = 0;
end

UVS = std(UQn(t,Uc,:));

UV = abs(UVN) + UVS;


%Making U
U_before(t,Uc) = UQ - lamda*UV;