clc; clear; close all;

% -----------------------------
% 已知斜激波参数
% -----------------------------
T1 = 300;                 % 激波前温度（可任意）
T2 = T1 * 2.49494;        % 激波后温度
pt2_pt1 = 0.3766;         % 给定总压比

ds = -53.3 * log(pt2_pt1) / 778.2;

s1 = 1;                   % 熵基准
s2 = s1 + ds;              % 激波后熵升高（示意）

% 构造激波曲线（温度与熵单调跃升）
s = linspace(s1, s2, 200);
T = linspace(T1, T2, 200);

% -----------------------------
% 绘图：完整 T–s 区域布局
% -----------------------------
figure('Color','w');

% 设置整体区域范围，让激波线不贴边
Ts_min = T1 * 0.2;
Ts_max = T2 * 1.3;
Ss_min = s1 - 0.1;
Ss_max = s2 + 0.1;

% 绘制背景框 (只是显示区域，不填充)
plot([Ss_min Ss_max Ss_max Ss_min Ss_min], ...
     [Ts_min Ts_min Ts_max Ts_max Ts_min], ...
     'Color',[0.85 0.85 0.85], 'LineWidth',1.0); 
hold on;

% 绘制激波跃迁曲线
plot(s, T, 'Color',[0.7 0.5 0.8], 'LineWidth', 2.8); hold on;

% 起点：激波前
plot(s1, T1, 'o', 'MarkerSize',9, ...
    'MarkerFaceColor',[0.55 0.35 0.7], 'MarkerEdgeColor','none');
text(s1, T1, '  M=4.0','FontSize',12,'FontName','SimHei');

% 终点：激波后
plot(s2, T2, 'o', 'MarkerSize',9, ...
    'MarkerFaceColor',[0.4 0.6 0.85], 'MarkerEdgeColor','none');
text(s2, T2, '  M=1.85','FontSize',12,'FontName','SimHei');

xlabel('s','FontSize',12,'FontName','SimHei');
ylabel('T','FontSize',12,'FontName','SimHei');


% 去除刻度，让图更像示意图
set(gca,'XTick',[],'YTick',[]);
axis([Ss_min Ss_max Ts_min Ts_max]);
grid on;
box on;
