close all; clear all; clc; load WP;

scrsz = get(groot,'ScreenSize');
fig1 = figure('OuterPosition',[0 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
hold on;
x = WP(1,:);
y = WP(2,:);
t = min(x):(max(x)-min(x))/10000:max(x);
PP_pchip = pchip(x,y,t);
PP_spline = spline(x,y,t);
plot(x,y,'o');
plot(t,PP_pchip);
plot(t,PP_spline);
plot(x,y);
legend('WP','pchip','splines','straight line');
saveas(fig1,'Task2_1.eps','epsc');