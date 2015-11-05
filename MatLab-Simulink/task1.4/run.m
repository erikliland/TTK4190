close all; clear all; clc; scrsz = get(groot,'ScreenSize'); OPT = optimset('Display','off');

tstart=0;      %Sim start time
tstop=1500;    %Sim stop time
tsamp=10;      %Sampling time (NOT ODE solver time step)

p0=zeros(2,1); %Initial position (NED)
v0=[6.63 0]';  %Initial velocity (body)
psi0=0;        %Inital yaw angle
r0=0;          %Inital yaw rate
c=0;           %Current on (1)/off (0)

%%%%% Curvefitting %%%%%
delta_offset = 0.009; %Constant delta_c input [rad]

% Nomoto 2. ordens lineær model
fig2 = figure('OuterPosition',[scrsz(3)/2 0 scrsz(3)/2 scrsz(4)/2]);
hold on; grid off; ylabel('Yaw rate [deg/s]'); xlabel('Time [s]');
title('2st order linear Nomoto model compared to ship response','FontSize',14);

for delta = 5:10:25
    delta_c = deg2rad(delta); %maks +-25deg
    sim MSFartoystyring;
    x0 = [2000 100 3000 50]';
    F_3 = @(x,t,delta_c) delta_c*(x(4)-(x(4)*exp(-t/x(1))*(x(1)-x(3)))/(x(1)-x(2))+(x(4)*exp(-t/x(2))*(x(2)-x(3)))/(x(1)-x(2)));
    F_4 = @(x,t) F_3(x,t,delta_c);
    x = lsqcurvefit(F_4, x0, t, r,[],[],OPT);
    T1 = x(1);
    T2 = x(2);
    T3 = x(3);
    K1 = x(4);
    nomoto2 = delta_c * (K1 - (K1*exp(-t/T1)*(T1 - T3))/(T1 - T2) + (K1*exp(-t/T2)*(T2 - T3))/(T1 - T2));
    plot(t, rad2deg(r),'--' )
    plot(t, rad2deg(nomoto2));
end
axis([0 tstop 0 0.55]);
legend( 'Ship, \delta = 5' ,'Nomoto2, \delta = 5', ...
        'Ship, \delta = 15','Nomoto2, \delta = 15',...
        'Ship, \delta = 25','Nomoto2, \delta = 25'); 
saveas(fig2,'Task1_4_Nomoto2.eps','epsc');

% Nomoto 1. ordens lineær model
fig1 = figure('OuterPosition',[scrsz(3)/2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
hold on; grid off; ylabel('Yaw rate [deg/s]'); xlabel('Time [s]');
title('1st order linear Nomoto model compared to ship response','FontSize',14);

for delta = 5:10:25 %maks +-25deg
    delta_c = deg2rad(delta);
    sim MSFartoystyring;
    x0 = [50 0.1]';
    F_1 = @(x,t,delta_c) x(2)*delta_c*(1 - exp(-t/x(1)));
    F_2 = @(x,t) F_1(x,t,delta_c);
    x = lsqcurvefit(F_2, x0, t, r,[],[],OPT);
    T = x(1);
    K = x(2);
    nomoto1 = r0*exp(-t/T) + K*delta_c*(1 - exp(-t/T));
    plot(t, rad2deg(r),'--');
    plot(t, rad2deg(nomoto1));
end
axis([0 tstop 0 0.55]);
legend( 'Ship, \delta = 5' ,'Nomoto1, \delta = 5', ...
        'Ship, \delta = 15','Nomoto1, \delta = 15',...
        'Ship, \delta = 25','Nomoto1, \delta = 25'); 
saveas(fig1,'Task1_4_Nomoto1.eps','epsc');

%%
close all; clc;
% Nomoto 2. ordens ulineær model (Norbin?)
% %%[d_list, r_list] = NonLinearAnalysis(25, 300,1, tstop, tsamp);
load('Delta_r_data.mat');
b_1_0 = [800e3 12];
F_5 = @(b,xdata) b(1) * xdata.^3 + b(2)*xdata;
b_1 = lsqcurvefit(F_5, b_1_0, r_list, d_list,[-inf 0],[inf inf],OPT)

b_2_0 = [800e3 1 10];
F_6 = @(b,xdata) b(1)*xdata.^3 + b(2)*xdata.^2 + b(3)*xdata;
b_2 = lsqcurvefit(F_6, b_2_0, r_list, d_list,[-inf -inf 0],[inf inf inf],OPT)

fig3 = figure('OuterPosition',[0 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
hold on; title('Non-linear maneuvering characteristics compared to ship response','FontSize',14);
t = linspace(-0.0075118, 0.0075118, 300);
plot(rad2deg(d_list),rad2deg(r_list),'--'); %plot(rad2deg(d_list),rad2deg(r_list),'o');
plot(rad2deg(F_5(b_1,t)),rad2deg(t));       %plot(rad2deg(F_5(b_1,t)),rad2deg(t) ,'o');
plot(rad2deg(F_6(b_2,t)),rad2deg(t));       %plot(rad2deg(F_6(b_2,t)),rad2deg(t) ,'o');
xlabel('Rudder [deg]'); ylabel('Yaw rate [deg/s]');
line([0 -25; 0 25],[-0.45 0; 0.45 0],'Color','black','LineStyle','--');
axis([-25 25 -0.45 0.45]);
legend('Ship characteristics','1. and 3.degree approximation','1. 2. and 3.degree approximation','Location','best');
saveas(fig3,'Task1_4_Nomoto2_delta_r.eps','epsc');

fig6 = figure('OuterPosition',[scrsz(3)/2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
hold on; title('Non-linear maneuvering characteristics compared to ship response','FontSize',14);
plot(rad2deg(r_list),rad2deg(d_list),'--');     plot(rad2deg(r_list),rad2deg(d_list)            ,'o');
plot(rad2deg(t),rad2deg(F_5(b_1,t))); plot(rad2deg(t),rad2deg(F_5(b_1,t))   ,'o');
plot(rad2deg(t),rad2deg(F_6(b_2,t))); plot(rad2deg(t),rad2deg(F_6(b_2,t))   ,'o');
ylabel('Rudder [deg]'); xlabel('Yaw rate [deg/s]');

%%
fig4 = figure('OuterPosition',[scrsz(3)/2 0 scrsz(3)/2 scrsz(4)/2]);
hold on; grid off; ylabel('Yaw rate [deg/s]'); xlabel('Time [s]');
title('2st order non-linear Nomoto model compared to ship response','FontSize',14);

for delta = 5:10:25
    delta_c = deg2rad(delta); %maks +-25deg
    sim MSFartoystyring;
    x0 = [70 80 168 0.1 b_1(1) b_1(2)]';
    F_7 = @(x,t) simNonLinear_Nomoto2( x(1), x(2), x(3), x(4), x(5), x(6), delta_c, tstop, tsamp );
    x = lsqcurvefit(F_7, x0, t, r,[],[],OPT);
    T1 = x(1);
    T2 = x(2);
    T3 = x(3);
    K  = x(4);
    plot(t, rad2deg(r),'--' )
    plot(t, rad2deg(F_7(x,t)));
end
axis([0 tstop 0 0.55]);
legend( 'Ship, \delta = 5' ,'Nomoto2, \delta = 5', ...
        'Ship, \delta = 15','Nomoto2, \delta = 15',...
        'Ship, \delta = 25','Nomoto2, \delta = 25'); 
saveas(fig4,'Task1_4_Nomoto2_curvefit.eps','epsc');



%% Nomoto 1. ordens ulineær model
fig5 = figure('OuterPosition',[0 0 scrsz(3)/2 scrsz(4)/2]);
hold on; grid off; xlabel('Rudder [deg]'); ylabel('Yaw rate [deg/s]');
title('1st order non-linear Nomoto model compared to ship response','FontSize',14);
for delta = 5:10:25 %maks +-25deg
    delta_c = deg2rad(delta);
    sim MSFartoystyring;
    x0 = [50 0.1]';
    F_8 = @(x,t) simNonLinear_Nomoto1(x(1), x(2), delta_c, tstop, tsamp);
    x = lsqcurvefit(F_8, x0, t, r,[],[],OPT);
    T = x(1);
    K = x(2);
    plot(t, rad2deg(r),'--');
    plot(t, rad2deg(F_8(x,t)));
end
axis([0 tstop 0 0.55]);
legend( 'Ship, \delta = 5' ,'Nomoto1 Non-linear, \delta = 5', ...
        'Ship, \delta = 15','Nomoto1 Non-linear, \delta = 15',...
        'Ship, \delta = 25','Nomoto1 Non-linear, \delta = 25'); 
saveas(fig5,'Task1_4_Nomoto1_curvefit.eps','epsc');