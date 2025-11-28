clc; clear; close all;

%% ------------------- 常量 -------------------
gamma = 1.4;
R = 287;       % J/(kg·K)
Tt = 370;      % 总温 K

%% ------------------- Fanno 流 M 范围 -------------------
M_fanno = linspace(2.28678, 2.8, 300); 
M_ref = 1;

%% ------------------- Fanno 曲线计算 -------------------
term1 = (gamma/(gamma-1)) .* log((1+(gamma-1)/2*M_ref^2)./(1+(gamma-1)/2*M_fanno.^2));
term2 = log((M_ref./M_fanno) .* sqrt((1+(gamma-1)/2*M_ref^2)./(1+(gamma-1)/2*M_fanno.^2)));
s_fanno = R*(term1 - term2);  
T_fanno = Tt ./ (1 + (gamma - 1)/2 * M_fanno.^2);

%% ------------------- 特定截面 -------------------
M_sec1 = 2.28678; 

T_sec1 = Tt / (1 + (gamma - 1)/2 * M_sec1^2);

term1_1 = (gamma/(gamma-1)) * log((1+(gamma-1)/2*M_ref^2)/(1+(gamma-1)/2*M_sec1^2));
term2_1 = log((M_ref/M_sec1) * sqrt((1+(gamma-1)/2*M_ref^2)/(1+(gamma-1)/2*M_sec1^2)));
s_sec1 = R*(term1_1 - term2_1);


%% ------------------- 等熵段 -------------------
M_iso = [0, 1, 2.8];                   
T_iso = Tt./(1 + (gamma-1)/2*M_iso.^2); 
s_iso = ones(size(M_iso)) * s_fanno(end);  

%% ------------------- 正激波段 -------------------
pt5_pt4 = 0.58913;
T5_T4 = 1.9347;

[~, idx_M4] = min(abs(M_fanno - 2.28678));
s4 = s_fanno(idx_M4);
T4 = T_fanno(idx_M4);

s5 = s4 - R*log(pt5_pt4);
T5 = T4 * T5_T4;
s_shock = [s4, s5];
T_shock = [T4, T5];

%% ------------------- 绘图 -------------------
figure('Color','w'); hold on;

% 颜色设置
col_fanno = [0.45 0.55 0.75];  
col_iso = [0.45 0.55 0.75];             % 蓝色等熵段
col_sec = [0 0 0];             % 黑色标记点
col_shock = [0.8 0.2 0.2];     
col_Tt = [0 0 0];              % 总温线黑色

% 绘制 Fanno 曲线
plot(s_fanno, T_fanno, 'LineWidth', 2.2, 'Color', col_fanno);

% 绘制等熵段
plot(s_iso, T_iso, '-', 'LineWidth', 2, 'Color', col_iso);

% 绘制正激波
plot(s_shock, T_shock, '--', 'LineWidth', 2, 'Color', col_shock);

% 绘制总温水平线
plot([-400, 100], [Tt, Tt], ':', 'LineWidth', 1.5, 'Color', col_Tt);
text(4, Tt+20, 'T_t=370K', 'Color', 'k', 'FontSize',12);

% 绘制截面点
plot(s_sec1, T_sec1, 'o', 'MarkerFaceColor', col_sec, 'MarkerEdgeColor', col_sec, 'MarkerSize',7);
text(s_sec1+10, T_sec1, 'M_4=2.28','Color','k','FontSize',12);

% 绘制等熵段关键点标记
plot(s_iso, T_iso, 'o', 'MarkerFaceColor', col_sec, 'MarkerEdgeColor', col_sec, 'MarkerSize',6);
text(s_iso(1)+10, T_iso(1)-15, 'M_1=0','Color','k','FontSize',12);
text(s_iso(2)+10, T_iso(2)-4, 'M_2=1','Color','k','FontSize',12);
text(s_iso(3)+5, T_iso(3)-10, 'M_3=2.8','Color','k','FontSize',12);

% 激波后点标记
plot(s5, T5, 'o', 'MarkerFaceColor', col_sec, 'MarkerEdgeColor', col_sec, 'MarkerSize',7);
text(s5+5, T5-20, 'M_5=0.54','Color','k','FontSize',12);

% 坐标轴设置
xlim([-400 100]);
ylim([0, Tt+50]);
set(gca,'XTick',[],'YTick',[]);  % 去掉刻度
xlabel('s ','FontSize',12);
ylabel('T (K)','FontSize',12);
