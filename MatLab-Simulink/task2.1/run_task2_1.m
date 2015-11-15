close all; clear all; clc; load WP;
x = WP(1,:);
y = WP(2,:);
t = min(x):(max(x)-min(x))/10000:max(x);
R = [700 500 400];
PP_pchip = pchip(x,y,t);

PP_spline = spline(x,y,t);

scrsz = get(groot,'ScreenSize');
fig1 = figure('OuterPosition',[0 0 scrsz(3)/2.8 scrsz(4)]);
hold on; ylabel('x-coordinate (North)'); xlabel('y-coordinate (East)');
plot(y,x,'o');
plot(PP_pchip, t);
plot(PP_spline, t);
plot(y,x,'LineWidth',2);
Circles_straight_lines(x,y,R);
axis equal
legend('WP','pchip','splines','straight line','Location','best');
for i = 1:length(R)
    text(WP(2,i+1)*1.2,WP(1,i+1),['R = ' num2str(R(i),3)],'FontSize',14);
end
saveas(fig1,'Task2_1.eps','epsc');