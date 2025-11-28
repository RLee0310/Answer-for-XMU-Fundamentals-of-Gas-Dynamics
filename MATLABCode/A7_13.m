clc; clear; close all;

% -------------------------------------------------------
% 数据（你的计算部分保持不变）
% -------------------------------------------------------
T0 = 392;
T1 = 518;
T2 = 822;

pt1_pt0 = 0.929;     % 斜激波
pt2_pt1 = 0.78;      % 正激波

% -------------------------------------------------------
% 熵变（单位：btu/(lbm·R)）
% -------------------------------------------------------
ds1 = -53.3 * log(pt1_pt0) / 778.2;
ds2 = -53.3 * log(pt2_pt1) / 778.2;

% -------------------------------------------------------
% 生成 T–s 直线段
% -------------------------------------------------------
% 第一段：斜激波
s_seg1 = linspace(0, ds1, 150);
T_seg1 = linspace(T0, T1, 150);

% 第二段：正激波
% s 必须从 ds1 到 ds1+ds2（不是 only ds2）
s_seg2 = linspace(ds1, ds1 + ds2, 150);
T_seg2 = linspace(T1, T2, 150);

% 拼接完整曲线
s_line = [s_seg1, s_seg2];
T_line = [T_seg1, T_seg2];

% -------------------------------------------------------
% 绘图（s 横轴，T 纵轴）
% -------------------------------------------------------
figure; hold on;

plot(s_seg1, T_seg1, 'LineWidth', 2, 'Color', [0.1 0.45 0.85]);
plot(s_seg2, T_seg2, 'LineWidth', 2, 'Color', [0.85 0.33 0.1]);

% 状态点标记
scatter([0, ds1, ds1+ds2], [T0, T1, T2], 70, 'filled',...
    'MarkerFaceColor', 'k');

% 标注
text(0,      T0, sprintf('  State 0\n  (%.0f °R)',T0), 'FontSize', 11);
text(ds1,    T1, sprintf('  State 1\n  (%.0f °R)',T1), 'FontSize', 11);
text(ds1+ds2,T2, sprintf('  State 2\n  (%.0f °R)',T2), 'FontSize', 11);

xlabel('s (btu/(lbm-°R))');
ylabel('T (°R)');
title('T-s Diagram for Supersonic Inlet with Shock System');

grid on; box on;

legend({'Oblique shock','Normal shock','Key points'}, ...
    'Location','northwest');

set(gca,'FontSize',12);
