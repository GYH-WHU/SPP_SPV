% 读取数据文件
filename = 'Calculation_error.txt'; % 请替换为实际文件路径
data = readtable(filename);  % 读取TXT文件为数据表

% 提取相关列
epochTime = data.Var3;
dE = data.Var4;
dN = data.Var5;
dU = data.Var6;
PDOP = data.Var7;
SigmaPos = data.Var8;
SigmaVel = data.Var9;
GPS_Clk = data.Var10;
BDS_Clk = data.Var11;
Rcv_Sft = data.Var12;
GPS_Sats = data.Var13;
BDS_Sats = data.Var14;
Sum_Sats = data.Var15;

% 初始化三个数组来存储提取的数字
extracted_dE = zeros(length(dE), 1);
extracted_dN = zeros(length(dN), 1);
extracted_dU = zeros(length(dU), 1);
extracted_PDOP = zeros(length(PDOP), 1);
extracted_SigmaPos = zeros(length(SigmaPos), 1);
extracted_SigmaVel = zeros(length(SigmaVel), 1);
extracted_GPS_Clk = zeros(length(GPS_Clk), 1);
extracted_BDS_Clk = zeros(length(BDS_Clk), 1);
extracted_Rcv_Sft = zeros(length(Rcv_Sft), 1);
extracted_GPS_Sats = zeros(length(GPS_Sats), 1);
extracted_BDS_Sats = zeros(length(BDS_Sats), 1);
extracted_Sum_Sats = zeros(length(Sum_Sats), 1);

% 循环处理每个字符串并提取冒号后的数字
for i = 1:length(dE)
    % 处理dE
    colon_pos_dE = strfind(dE{i}, '：');
    if ~isempty(colon_pos_dE)
        extracted_dE(i) = str2double(dE{i}(colon_pos_dE+1:end));
    end
    
    % 处理dN
    colon_pos_dN = strfind(dN{i}, '：');
    if ~isempty(colon_pos_dN)
        extracted_dN(i) = str2double(dN{i}(colon_pos_dN+1:end));
    end
    
    % 处理dU
    colon_pos_dU = strfind(dU{i}, '：');
    if ~isempty(colon_pos_dU)
        extracted_dU(i) = str2double(dU{i}(colon_pos_dU+1:end));
    end

    % 处理PDOP
    colon_pos_PDOP = strfind(PDOP{i}, '：');
    if ~isempty(colon_pos_PDOP)
        extracted_PDOP(i) = str2double(PDOP{i}(colon_pos_PDOP+1:end));
    end

    % 处理SigmaPos
    colon_pos_SigmaPos = strfind(SigmaPos{i}, '：');
    if ~isempty(colon_pos_SigmaPos)
        extracted_SigmaPos(i) = str2double(SigmaPos{i}(colon_pos_SigmaPos+1:end));
    end

    % 处理SigmaVel
    colon_pos_SigmaVel = strfind(SigmaVel{i}, '：');
    if ~isempty(colon_pos_SigmaVel)
        extracted_SigmaVel(i) = str2double(SigmaVel{i}(colon_pos_SigmaVel+1:end));
    end

    % 处理GPS_Clk
    colon_pos_GPS_Clk = strfind(GPS_Clk{i}, '：');
    if ~isempty(colon_pos_GPS_Clk)
        extracted_GPS_Clk(i) = str2double(GPS_Clk{i}(colon_pos_GPS_Clk+1:end));
    end

    % 处理BDS_Clk
    colon_pos_BDS_Clk = strfind(BDS_Clk{i}, '：');
    if ~isempty(colon_pos_BDS_Clk)
        extracted_BDS_Clk(i) = str2double(BDS_Clk{i}(colon_pos_BDS_Clk+1:end));
    end

    % 处理Rcv_Sft
    colon_pos_Rcv_Sft = strfind(Rcv_Sft{i}, '：');
    if ~isempty(colon_pos_Rcv_Sft)
        extracted_Rcv_Sft(i) = str2double(Rcv_Sft{i}(colon_pos_Rcv_Sft+1:end));
    end

    % 处理GPS_Sats
    colon_pos_GPS_Sats = strfind(GPS_Sats{i}, '：');
    if ~isempty(colon_pos_GPS_Sats)
        extracted_GPS_Sats(i) = str2double(GPS_Sats{i}(colon_pos_GPS_Sats+1:end));
    end

    % 处理BDS_Sats
    colon_pos_BDS_Sats = strfind(BDS_Sats{i}, '：');
    if ~isempty(colon_pos_BDS_Sats)
        extracted_BDS_Sats(i) = str2double(BDS_Sats{i}(colon_pos_BDS_Sats+1:end));
    end

    % 处理Sum_Sats
    colon_pos_Sum_Sats = strfind(Sum_Sats{i}, '：');
    if ~isempty(colon_pos_Sum_Sats)
        extracted_Sum_Sats(i) = str2double(Sum_Sats{i}(colon_pos_Sum_Sats+1:end));
    end

end

% 计算综合误差（RMS）
combined_error = sqrt(extracted_dE.^2 + extracted_dN.^2 + extracted_dU.^2);

% 计算统计量
stats_dE = struct(... 
    'max', max(abs(extracted_dE)), ...
    'min', min(abs(extracted_dE)), ...
    'mean', mean(extracted_dE), ...
    'std',std(extracted_dE)...
);

stats_dN = struct(... 
    'max', max(abs(extracted_dN)), ...
    'min', min(abs(extracted_dN)), ...
    'mean', mean(extracted_dN), ...
    'std',std(extracted_dN)...
);

stats_dU = struct(... 
    'max', max(abs(extracted_dU)), ...
    'min', min(abs(extracted_dU)), ...
    'mean', mean(extracted_dU), ...
    'std',std(extracted_dU)...
);

stats_combined = struct(... 
    'max', max(abs(combined_error)), ...
    'min', min(abs(combined_error)), ...
    'mean', mean(combined_error), ...
    'std',std(combined_error)...
);

stats_PDOP = struct(... 
    'max', max(abs(extracted_PDOP)), ...
    'min', min(abs(extracted_PDOP)), ...
    'mean', mean(extracted_PDOP), ...
    'std',std(extracted_PDOP)...
);

stats_SigmaPos = struct(... 
    'max', max(abs(extracted_SigmaPos)), ...
    'min', min(abs(extracted_SigmaPos)), ...
    'mean', mean(extracted_SigmaPos), ...
    'std',std(extracted_SigmaPos)...
);

stats_SigmaVel = struct(... 
    'max', max(abs(extracted_SigmaVel)), ...
    'min', min(abs(extracted_SigmaVel)), ...
    'mean', mean(extracted_SigmaVel), ...
    'std',std(extracted_SigmaVel)...
);

stats_GPS_Clk = struct(... 
    'max', max(abs(extracted_GPS_Clk)), ...
    'min', min(abs(extracted_GPS_Clk)), ...
    'mean', mean(extracted_GPS_Clk), ...
    'std',std(extracted_GPS_Clk)...
);

stats_BDS_Clk = struct(... 
    'max', max(abs(extracted_BDS_Clk)), ...
    'min', min(abs(extracted_BDS_Clk)), ...
    'mean', mean(extracted_BDS_Clk), ...
    'std',std(extracted_BDS_Clk)...
);

stats_GPS_Sats = struct(... 
    'max', max(abs(extracted_GPS_Sats)), ...
    'min', min(abs(extracted_GPS_Sats)), ...
    'mean', mean(extracted_GPS_Sats), ...
    'std',std(extracted_GPS_Sats)...
);

stats_BDS_Sats = struct(... 
    'max', max(abs(extracted_BDS_Sats)), ...
    'min', min(abs(extracted_BDS_Sats)), ...
    'mean', mean(extracted_BDS_Sats), ...
    'std',std(extracted_BDS_Sats)...
);

stats_Sum_Sats = struct(... 
    'max', max(abs(extracted_Sum_Sats)), ...
    'min', min(abs(extracted_Sum_Sats)), ...
    'mean', mean(extracted_Sum_Sats), ...
    'std',std(extracted_Sum_Sats)...
);

% 创建文件夹保存结果，如果文件夹不存在则创建
outputFolder = 'Result';  % 输出文件夹
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% ================== dE 误差图 ==================
figure;
plot(epochTime, extracted_dE, 'r-', 'LineWidth', 1);
title('东向误差 (dE)', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('周内秒', 'FontSize', 10);
ylabel('误差 (m)', 'FontSize', 10);
grid on;
box on;
xlim([min(epochTime), max(epochTime)]);
yline(stats_dE.mean, '--g', 'LineWidth', 2.0);  % 添加虚线
annotation('textbox', [0.15, 0.80, 0.1, 0.04], 'String', ...
    sprintf('Max: %.3f m\nMin: %.3f m\nMean: %.3f m\nStd: %.3f m', ...
    stats_dE.max, stats_dE.min, stats_dE.mean,stats_dE.std), ...
    'FitBoxToText', 'on', 'BackgroundColor', [1, 0.9, 0.9], ...
    'EdgeColor', 'none', 'FontSize', 7);
% saveas(gcf, fullfile(outputFolder, 'dE_Error_Plot.jpg'));

% ================== dN 误差图 ==================
figure;
plot(epochTime, extracted_dN, 'g-', 'LineWidth', 1);
title('北向误差 (dN)', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('周内秒', 'FontSize', 10);
ylabel('误差 (m)', 'FontSize', 10);
grid on;
box on;
xlim([min(epochTime), max(epochTime)]);
yline(stats_dN.mean, '--r', 'LineWidth', 2.0);  % 添加虚线
annotation('textbox', [0.15, 0.80, 0.1, 0.04], 'String', ...
    sprintf('Max: %.3f m\nMin: %.3f m\nMean: %.3f m\nStd: %.3f m', ...
    stats_dN.max, stats_dN.min, stats_dN.mean,stats_dN.std), ...
    'FitBoxToText', 'on', 'BackgroundColor', [0.9, 1, 0.9], ...
    'EdgeColor', 'none', 'FontSize', 7);
% saveas(gcf, fullfile(outputFolder, 'dN_Error_Plot.jpg'));

% ================== dU 误差图 ==================
figure;
plot(epochTime, extracted_dU, 'b-', 'LineWidth', 1);
title('天顶误差 (dU)', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('周内秒', 'FontSize', 10);
ylabel('误差 (m)', 'FontSize', 10);
grid on;
box on;
xlim([min(epochTime), max(epochTime)]);
yline(stats_dU.mean, '--g', 'LineWidth', 2.0);  % 添加虚线
annotation('textbox', [0.15, 0.80, 0.1, 0.04], 'String', ...
    sprintf('Max: %.3f m\nMin: %.3f m\nMean: %.3f m\nStd: %.3f m', ...
    stats_dU.max, stats_dU.min, stats_dU.mean,stats_dU.std), ...
    'FitBoxToText', 'on', 'BackgroundColor', [0.9, 0.9, 1], ...
    'EdgeColor', 'none', 'FontSize', 7);
% saveas(gcf, fullfile(outputFolder, 'dU_Error_Plot.jpg'));

% ============== 综合误差图 ==============
figure;
plot(epochTime, combined_error, 'k-', 'LineWidth', 1);
title('综合误差 ', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('周内秒', 'FontSize', 10);
ylabel('RMS误差 (m)', 'FontSize', 10);
grid on;
box on;
xlim([min(epochTime), max(epochTime)]);
yline(stats_combined.mean, '--g', 'LineWidth', 2.0);  % 添加虚线
annotation('textbox', [0.15, 0.80, 0.1, 0.04], 'String', ...
    sprintf('Max: %.3f m\nMin: %.3f m\nMean: %.3f m\nStd: %.3f m', ...
    stats_combined.max, stats_combined.min, stats_combined.mean,stats_combined.std), ...
    'FitBoxToText', 'on', 'BackgroundColor', [0.95, 0.95, 0.95], ...
    'EdgeColor', 'none', 'FontSize', 7);
% saveas(gcf, fullfile(outputFolder, 'Combined_Error_Plot.jpg'));

% ================== PDOP 图 ==================
figure;
plot(epochTime, extracted_PDOP, 'b-', 'LineWidth', 1);
title('几何精度 (PDOP)', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('周内秒', 'FontSize', 10);
ylabel('PDOP', 'FontSize', 10);
grid on;
box on;
xlim([min(epochTime), max(epochTime)]);
yline(stats_PDOP.mean, '--g', 'LineWidth', 2.0);  % 添加虚线
annotation('textbox', [0.15, 0.80, 0.1, 0.04], 'String', ...
    sprintf('Max: %.3f\nMin: %.3f\nMean: %.3f\nStd: %.3f', ...
    stats_PDOP.max, stats_PDOP.min, stats_PDOP.mean,stats_PDOP.std), ...
    'FitBoxToText', 'on', 'BackgroundColor', [0.9, 0.9, 1], ...
    'EdgeColor', 'none', 'FontSize', 7);
% saveas(gcf, fullfile(outputFolder, 'PDOP_Plot.jpg'));

% ================== GPS接收机钟差图 ==================
figure;
plot(epochTime, extracted_GPS_Clk, 'b-', 'LineWidth', 1);
title('GPS接收机钟差 (GPSRcv ClkOft)', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('周内秒', 'FontSize', 10);
ylabel('GPS接收机钟差', 'FontSize', 10);
grid on;
box on;
xlim([min(epochTime), max(epochTime)]);
yline(stats_GPS_Clk.mean, '--g', 'LineWidth', 2.0);  % 添加虚线
annotation('textbox', [0.15, 0.80, 0.1, 0.04], 'String', ...
    sprintf('Max: %.3f s\nMin: %.3f s\nMean: %.3f s\nStd: %.3f s', ...
    stats_GPS_Clk.max, stats_GPS_Clk.min, stats_GPS_Clk.mean,stats_GPS_Clk.std), ...
    'FitBoxToText', 'on', 'BackgroundColor', [0.9, 0.9, 1], ...
    'EdgeColor', 'none', 'FontSize', 7);
% saveas(gcf, fullfile(outputFolder, 'GPS_Clk_Plot.jpg'));

% ================== BDS接收机钟差图 ==================
figure;
plot(epochTime, extracted_BDS_Clk, 'b-', 'LineWidth', 1);
title('BDS接收机钟差 (BDSRcv ClkOft)', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('周内秒', 'FontSize', 10);
ylabel('BDS接收机钟差', 'FontSize', 10);
grid on;
box on;
xlim([min(epochTime), max(epochTime)]);
yline(stats_BDS_Clk.mean, '--g', 'LineWidth', 2.0);  % 添加虚线
annotation('textbox', [0.15, 0.80, 0.1, 0.04], 'String', ...
    sprintf('Max: %.3f s\nMin: %.3f s\nMean: %.3f s\nStd: %.3f s', ...
    stats_BDS_Clk.max, stats_BDS_Clk.min, stats_BDS_Clk.mean,stats_BDS_Clk.std), ...
    'FitBoxToText', 'on', 'BackgroundColor', [0.9, 0.9, 1], ...
    'EdgeColor', 'none', 'FontSize', 7);
% saveas(gcf, fullfile(outputFolder, 'BDS_Clk_Plot.jpg'));

% ================== SigmaPos和SigmaVel图合并 ==================

% 创建一个2行1列的子图，第一行绘制SigmaPos图
figure;
subplot(2, 1, 1);  % 2行1列，当前是第1个子图
plot(epochTime, extracted_SigmaPos, 'b-', 'LineWidth', 1);
title('定位标准差 (SigmaPos)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('定位标准差', 'FontSize', 10);
grid on;
box on;
xlim([min(epochTime), max(epochTime)]);
yline(stats_SigmaPos.mean, '--g', 'LineWidth', 2.0);  % 添加虚线

% 调整Max、Min、Mean文本框位置和大小
annotation('textbox', [0.15, 0.80, 0.2, 0.08], 'String', ...
    sprintf('Max: %.3f m\nMin: %.3f m\nMean: %.3f m\nStd: %.3f m', ...
    stats_SigmaPos.max, stats_SigmaPos.min, stats_SigmaPos.mean,stats_SigmaPos.std), ...
    'FitBoxToText', 'on', 'BackgroundColor', [0.9, 0.9, 1], ...
    'EdgeColor', 'none', 'FontSize', 7);

% 创建第二个子图（绘制SigmaVel图）
subplot(2, 1, 2);  % 2行1列，当前是第2个子图
plot(epochTime, extracted_SigmaVel, 'b-', 'LineWidth', 1);
title('速度标准差 (SigmaVel)', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('周内秒', 'FontSize', 10);
ylabel('速度标准差', 'FontSize', 10);
grid on;
box on;
xlim([min(epochTime), max(epochTime)]);
yline(stats_SigmaVel.mean, '--g', 'LineWidth', 2.0);  % 添加虚线

% 调整Max、Min、Mean文本框位置和大小
annotation('textbox', [0.15, 0.35, 0.2, 0.08], 'String', ...
    sprintf('Max: %.3f m\nMin: %.3f m\nMean: %.3f m\nStd: %.3f m', ...
    stats_SigmaVel.max, stats_SigmaVel.min, stats_SigmaVel.mean,stats_SigmaVel.std), ...
    'FitBoxToText', 'on', 'BackgroundColor', [0.9, 0.9, 1], ...
    'EdgeColor', 'none', 'FontSize', 7);

% 保存所有图像
% saveas(gcf, fullfile(outputFolder, 'SigmaPos_SigmaVel_Plot.jpg'));


% ================== 卫星数量图 ==================
% 创建图形窗口
figure;

% 创建第一个子图（显示GPS卫星数量）
subplot(3, 1, 1);  % 3行1列，当前是第1个子图
plot(epochTime, extracted_GPS_Sats, 'r-', 'LineWidth', 1, 'DisplayName', 'GPS Satellites');
title('GPS卫星数量', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('卫星数量', 'FontSize', 10);
grid on;
box on;
xlim([min(epochTime), max(epochTime)]);
legend('show', 'Location', 'Best');

% 调整Max、Min、Mean文本框位置和大小
annotation('textbox', [0.15, 0.88, 0.1, 0.04], 'String', ...
    sprintf('Max: %.0f\nMin: %.0f\nMean: %.0f,\nStd: %.0f', ...
    stats_GPS_Sats.max, stats_GPS_Sats.min, stats_GPS_Sats.mean,stats_GPS_Sats.std), ...
    'FitBoxToText', 'on', 'BackgroundColor', [1, 0.9, 0.9], ...
    'EdgeColor', 'none', 'FontSize', 6);

% 创建第二个子图（显示BDS卫星数量）
subplot(3, 1, 2);  % 3行1列，当前是第2个子图
plot(epochTime, extracted_BDS_Sats, 'g-', 'LineWidth', 1, 'DisplayName', 'BDS Satellites');
title('BDS卫星数量', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('卫星数量', 'FontSize', 10);
grid on;
box on;
xlim([min(epochTime), max(epochTime)]);
legend('show', 'Location', 'Best');

% 调整Max、Min、Mean文本框位置和大小
annotation('textbox', [0.15, 0.56, 0.1, 0.04], 'String', ...
    sprintf('Max: %.0f\nMin: %.0f\nMean: %.0f\nStd: %.0f', ...
    stats_BDS_Sats.max, stats_BDS_Sats.min, stats_BDS_Sats.mean,stats_BDS_Sats.std), ...
    'FitBoxToText', 'on', 'BackgroundColor', [0.9, 1, 0.9], ...
    'EdgeColor', 'none', 'FontSize', 6);

% 创建第三个子图（显示总卫星数量）
subplot(3, 1, 3);  % 3行1列，当前是第3个子图
plot(epochTime, extracted_Sum_Sats, 'b-', 'LineWidth', 1, 'DisplayName', 'Total Satellites');
title('总卫星数量', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('周内秒', 'FontSize', 10);
ylabel('卫星数量', 'FontSize', 10);
grid on;
box on;
xlim([min(epochTime), max(epochTime)]);
legend('show', 'Location', 'Best');

% 调整Max、Min、Mean文本框位置和大小
annotation('textbox', [0.15, 0.24, 0.1, 0.04], 'String', ...
    sprintf('Max: %.0f\nMin: %.0f\nMean: %.0f\nStd: %.0f', ...
    stats_Sum_Sats.max, stats_Sum_Sats.min, stats_Sum_Sats.mean,stats_Sum_Sats.std), ...
    'FitBoxToText', 'on', 'BackgroundColor', [0.9, 0.9, 1], ...
    'EdgeColor', 'none', 'FontSize', 6);

% 保存图形到指定的文件夹，并使用 .jpg 格式
% saveas(gcf, fullfile(outputFolder, 'Satellite_Count_Plot.jpg'));

disp('所有图形已成功保存到Result文件夹');