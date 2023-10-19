clear;
init_set1220;
%%실험데이터생성
% clear;
% clc;

% init_set;

FoVLon = 110;
FoVLat = 90;

% tileView = [0.55,0.67,0.78,0.90,0.90,0.78,0.67,0.55];

FoV = zeros(FoVLon,FoVLat);
viewlon = round(rand * 180);
viewlat = round(rand * 360);
Viewpoint = zeros(T,2);
viewed_tile = zeros(T,1);
%fov flow
for t = 1:180
    a = round((normrnd(0,1))*20);
    b = round((normrnd(0,1))*40);
    la = viewlon + b;
    lb = viewlat + a;
    Viewpoint(t,1) = rem(la,360);
    Viewpoint(t,2) = rem(lb,180);
end

% Viewpoint(:,1) = round(HMDdata(:,1)/pi*180+180);
% Viewpoint(:,2) = round(HMDdata(:,2)/pi*90+90);
% 
% Viewpointsize = size(Viewpoint);
% 
% T = Viewpointsize(1);

%%fov to ERP
% img = zeros(180,360);
TileArea = zeros(T,180,360);
for t = 1:T
    for i = -FoVLat/2:1:FoVLat/2
    
        Lat = Viewpoint(t,2) + i;
        
        Longleft = round((Viewpoint(t,1) - FoVLon/2/sin(Lat/180*pi)));
        LongRight = round((Viewpoint(t,1) + FoVLon/2/sin(Lat/180*pi)));
    
        if Lat > 180
            Lat = rem(Lat,180);
        elseif Lat < 0
            Lat = -Lat;
        elseif Lat == 0
            Lat = 1;
        end
    
        if Longleft <= 0
            if Longleft == 0
                Longleft = -1;
            end
            if LongRight > 360
                TileArea(t,Lat,:) = 1;
            else
                for j = 1:1:LongRight
                    TileArea(t,Lat,j) = 1;
                end
                for j = 360+Longleft:1:360
                    if j <= 0
                        j = 1;
                    end
                    TileArea(t,Lat,j) = 1;
                end
            end
        else
            if LongRight > 360
                for j = 1:1:LongRight-360
                    TileArea(t,Lat,j) = 1;
                end
                for j = Longleft:1:360
                    TileArea(t,Lat,j) = 1;
                end
            else
                for j = Longleft:1:LongRight
                    TileArea(t,Lat,j) = 1;
                end
            end
        end
    end
% img(:,:) = TileArea(t,:,:);
% imshow(img);
end

TileA = zeros(23,45);
TileB = zeros(22,45);
tile = zeros(T,8,8);
for t = 1:T
for i = 1:8
    if rem(i,2) == 1
        for j = 1:8
            x = fix(i/2)*45+1;
            y = (j-1)*45+1;
            TileA(:,:) = TileArea(t,x:x+22,y:j*45);
            A = sum(TileA,"all")/1035;
%             if A >= 0.7
%                 A = 1;
%             elseif A < 0.3
%                 A = 0;
%             else
%                 A = 0.5;
%             end
            tile(t,i,j) = A;
        end
    else
        for j = 1:8
            x = fix(i/2)*45;
            y = (j-1)*45+1;
            TileB(:,:) = TileArea(t,x-21:x,y:j*45);
            B = sum(TileB,"all")/1035;
%             if B >= 0.7
%                 B = 1;
%             elseif B < 0.3
%                 B = 0;
%             else
%                 B = 0.5;
%             end
            tile(t,i,j) = B;
        end
    end
end
tile(t,:,:) = tile(t,:,:)./sum(tile(t,:,:),'all');
% viewed_tile(t,1) = sum(tile(t,:,:),'all');
% nn(t) = nnz(tile(t,:,:))
end


