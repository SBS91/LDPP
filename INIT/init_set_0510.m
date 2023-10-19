% clear;
% clc;
%%기본셋팅%%

%buffer setting
%k = time counting indicator
%K = total video length
t = 1;
%Lk = 다운로드되는 비디오 청크 최대 길이, 10s
%t = 비디오 당 재생 시간, 1s
%N = 비디오당 Tile 수, 8*8
%M = 비디오 당 퀄리티 Level 수, 6

T = 140;
L = 10;
N = 64;
M = 6;

%Q = 버퍼슬롯 당 가지고 있는 Tile 의 퀄리티
%X = 타일을 다운로드 할지 유무

Q = zeros(T,8,8,N);
X = zeros(T,L,N);


%W = 타일별 보인다/안보인다 예측 정확도, min 0.5, max 1

W = [0.75, 0.68, 0.63, 0.60, 0.58, 0.56, 0.54, 0.53, 0.51, 0.50];
% W = zeros(160,8,8);
% Q_P = [23, 30, 35, 39, 42, 44];

Uc = 0;
Ua = 0;

% BWorigin = 40000;

% BW = BWorigin;

% B = 150;
DR = [50,150,250,400,600,850];


UQn = zeros(T,L,N);
Q = zeros(T+L,N);
I = zeros(T,L);
% Itest = zeros(T,L);
U = zeros(T+L,1);
UQ = zeros(T,L,1);
UV = 0;
% U_before = zeros(T,L);
% U_after = zeros(T,L);
% Uopt_before = zeros(T,L);
% Uopt_after = zeros(T,L);
UQ_opt = zeros(T,1);
UQ_LEVEL_opt = zeros(T,1);


% %image _opi init
% UV_opi = zeros(T,L);
% UVN_opi = zeros(T,L,N);
% UQn_opi = zeros(T,L,N);
% 
% 
% %image _opt init
% UV_opt = zeros(T,L);
% UVN_opt = zeros(T,L,N);
% UQn_opt = zeros(T,L,N);

U_opt = zeros(T,L);
U_before = zeros(T+L,1);
%a std 값의 반영 비율 조정
%b UV 값의 반영 비율 조정

alpha = 0.5;
lamda = 0.5;

time = 0;
Util = 0;
MaxUtil = 0;
brunch = 0;
V = 0.5;
Xtest = zeros(T,L,N);
Xopt = zeros(T,L,N);
t = 1;
% Xopt(1,:,:) = ones;
bw = zeros(L,1);
Util = zeros(L,1);
timingA = 0;
timingB = 0;
%BWremain = BWorigin;
Lcount = zeros(L,1);

DATA_amount = 0;

