close all; clear all; clc; scrsz = get(groot,'ScreenSize'); 

% %%% r-delta plot

[dc, r] = NonLinearAnalysis(25, 150);
fig = figure('OuterPosition',[0 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
hold on; grid on; ylabel('Yaw rate [deg/s]'); xlabel('\delta [deg]');
plot(rad2deg(dc),rad2deg(r));
saveas(fig,'Task1_4_delta_r_plot.eps','epsc');