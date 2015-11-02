close all; clear all; clc; load WP;
x = WP(1,:);
y = WP(2,:);
t = min(x):(max(x)-min(x))/10000:max(x);
PP_pchip = pchip(x,y,t);

PP_spline = spline(x,y,t);

scrsz = get(groot,'ScreenSize');
fig1 = figure('OuterPosition',[0 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
hold on;
plot(y,x,'o');
plot(PP_pchip, t);
plot(PP_spline, t);
plot(y,x);
Circles_straight_lines(x,y,[700 500 400]);
axis equal
legend('WP','pchip','splines','straight line');
saveas(fig1,'Task2_1.eps','epsc');
ylabel('x-coordinate (North)');
xlabel('y-coordinate (East)');