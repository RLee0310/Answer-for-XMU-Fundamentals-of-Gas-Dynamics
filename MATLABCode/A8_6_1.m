clc; clear; close all;

% -----------------------------
% 参数设置
% -----------------------------
gamma = 1.4;         % 空气比热比
T0 = 300;            % 初始温度（高马赫数端）
s0 = 0;              % 熵基准

% 马赫数从 5 逐渐减小到 1（收缩 → 温度升高）
M = linspace(5, 1, 300);

% 总温保持不变（等熵）
Tt = T0 * (1 + (gamma-1)/2 * 5^2);

% 对应静温（等熵关系）
T = Tt ./ (1 + (gamma-1)/2 .* M.^2);

% 调整刻度，使起点温度即为 T0
T = T * (T0 / T(1));

% 熵恒定
s = s0 * ones(size(M));

% -----------------------------
% 绘图（柔和配色）
% -----------------------------
figure('Color','w');

plot(s, T, 'Color',[0.95 0.6 0.3], 'LineWidth', 2.5); hold on;

% 起点：高马赫（左下）
plot(s(1), T(1), 'o', 'MarkerSize',8, ...
    'MarkerFaceColor',[0.85 0.4 0.2], 'MarkerEdgeColor','none');
text(s(1), T(1), '  M=4.0','FontSize',12,'FontName','SimHei');

% 终点：低马赫（右上）
plot(s(end), T(end), 'o', 'MarkerSize',8, ...
    'MarkerFaceColor',[0.4 0.6 0.8], 'MarkerEdgeColor','none');
text(s(end), T(end), '  M=2.36','FontSize',12,'FontName','SimHei');

xlabel('s','FontSize',12,'FontName','SimHei');
ylabel('T','FontSize',12,'FontName','SimHei');

% 去掉坐标刻度
set(gca,'XTick',[],'YTick',[]);
grid on;
box on;
