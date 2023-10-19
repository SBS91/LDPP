for i = 1:2
    video_cat = string(i);
    for j = 1:9
        video_num = string(j);
        video_count = (i-1)*9 + j;
        file_name = strcat(video_cat,"_",video_num,".xlsx");
        psnr_info = readtable(file_name);
        psnr_dnfo = table2array(psnr_info(:,4));
        A = iscell(psnr_dnfo)
        if A == 1
        for time = 1:160
            for lat = 1:8
                for lon = 1:8
                    for bitrate = 1:6
                        Cell_count = (time-1)*384 + (lat-1)*48 + (lon-1)*6 + bitrate;            
                        psnr_dnfo(Cell_count,1);
                        cell2mat(ans);
                        B = convertCharsToStrings(ans);
                        if B == "inf"
                            N_PSNR(video_count,time,lat,lon,bitrate) = 120;
                        else
                            N_PSNR(video_count,time,lat,lon,bitrate) = str2double(B);
                        end
                        clearvars ans B;
                    end
                end
            end
        end
        else
            for time = 1:160
            for lat = 1:8
                for lon = 1:8
                    for bitrate = 1:6
                        Cell_count = (time-1)*384 + (lat-1)*48 + (lon-1)*6 + bitrate;            
                        % psnr_dnfo(Cell_count,1);
                        % cell2mat(ans);
                        % B = convertCharsToStrings(ans);
                        if psnr_dnfo(Cell_count,1) == inf
                            N_PSNR(video_count,time,lat,lon,bitrate) = 120;
                        else
                            N_PSNR(video_count,time,lat,lon,bitrate) = psnr_dnfo(Cell_count,1);
                        end
                        % clearvars ans B;
                    end
                end
            end
        end
        clearvars psnr_dnfo;
        end
    end
end


% Given PSNR value is in array psnr
sigmoid_threshold = 45;  % Value at which to start applying sigmoid
ad_psnr = min(sigmoid_threshold,N_PSNR);
adjusted_psnr = max(0, N_PSNR - sigmoid_threshold);  % Subtract the threshold, and clip at 0
sigmoid_psnr = (40 ./ (1 + exp(-adjusted_psnr*0.1))) - 20;  % Apply sigmoid, and add the threshold back
PSNR = ad_psnr + sigmoid_psnr;
save("N_PSNR","PSNR");