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
% Nomoto 1. ordens line�r model
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

% Nomoto 2. ordens line�r model
fig2 = figure('OuterPosition',[scrsz(3)/2 0 scrsz(3)/2 scrsz(4)/2]);
hold on; grid off; ylabel('Yaw rate [deg/s]'); xlabel('Time [s]');
title('2st order linear Nomoto model compared to ship response','FontSize',14);

for delta = 5:10:25
    delta_c = deg2rad(delta); %maks +-25deg
    sim MSFartoystyring;
    x0 = [2000 100 3000 50]';
    F_3 = @(x,t,delta_c) delta_c*(x(4) - (x(4)*exp(-t/x(1))*(x(1) - x(3)))/(x(1) - x(2)) + (x(4)*exp(-t/x(2))*(x(2) - x(3)))/(x(1) - x(2)));
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

%% 

% Nomoto 2. ordens uline�r model (Norbin?)
[dc, r] = NonLinearAnalysis(25, 150,1);
fig3 = figure('OuterPosition',[0 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
hold on; grid off; xlabel('Rudder [deg]'); ylabel('Yaw rate [deg/s]');
title('Non-linear maneuvering characteristics compared to ship response','FontSize',14);
plot(rad2deg(dc),rad2deg(r),'--');
b_0 = [800e3 10];
F_5 = @(b,xdata) b(1) * xdata.^3 + b(2)*xdata;
b = lsqcurvefit(F_5, b_0, r, dc,[0 0 ],[inf inf],OPT);
t = linspace(-0.0075118, 0.0075118, 100);
plot(rad2deg(F_5(b,t)),rad2deg(t));
line([0 -25; 0 25],[-0.45 0; 0.45 0],'Color','black','LineStyle','--');
axis([-25 25 -0.45 0.45]);
legend('Ship characteristics','3.degree approximation','Location','best');
saveas(fig3,'Task1_4_Nomoto2_delta_r.eps','epsc');

fig4 = figure('OuterPosition',[scrsz(3)/2 0 scrsz(3)/2 scrsz(4)/2]);
hold on; grid off; ylabel('Yaw rate [deg/s]'); xlabel('Time [s]');
title('2st order non-linear Nomoto model compared to ship response','FontSize',14);

for delta = 5:10:25
    delta_c = deg2rad(delta); %maks +-25deg
    sim MSFartoystyring;
    b_3 = b(1);
    b_1 = b(2);
    x0 = [70 80 168 0.1 b_3 b_1]';
    F_6 = @(x,t) simNonLinear_Nomoto2( x(1), x(2), x(3), x(4), x(5), x(6), delta_c, tstop, tsamp );
    x = lsqcurvefit(F_6, x0, t, r,[],[],OPT);
    T1 = x(1);
    T2 = x(2);
    T3 = x(3);
    K  = x(4);
    plot(t, rad2deg(r),'--' )
    plot(t, rad2deg(F_6(x,t)));
end
axis([0 tstop 0 0.55]);
legend( 'Ship, \delta = 5' ,'Nomoto2, \delta = 5', ...
        'Ship, \delta = 15','Nomoto2, \delta = 15',...
        'Ship, \delta = 25','Nomoto2, \delta = 25'); 
saveas(fig4,'Task1_4_Nomoto2_curvefit.eps','epsc');



%% Nomoto 1. ordens uline�r model
fig5 = figure('OuterPosition',[0 0 scrsz(3)/2 scrsz(4)/2]);
hold on; grid off; xlabel('Rudder [deg]'); ylabel('Yaw rate [deg/s]');
title('1st order non-linear Nomoto model compared to ship response','FontSize',14);
for delta = 5:10:25 %maks +-25deg
    delta_c = deg2rad(delta);
    sim MSFartoystyring;
    x0 = [50 0.1]';
    F_7 = @(x,t) simNonLinear_Nomoto1(x(1), x(2), delta_c, tstop, tsamp);
    x = lsqcurvefit(F_7, x0, t, r,[],[],OPT);
    T = x(1);
    K = x(2);
    plot(t, rad2deg(r),'--');
    plot(t, rad2deg(F_7(x,t)));
end
axis([0 tstop 0 0.55]);
legend( 'Ship, \delta = 5' ,'Nomoto1 Non-linear, \delta = 5', ...
        'Ship, \delta = 15','Nomoto1 Non-linear, \delta = 15',...
        'Ship, \delta = 25','Nomoto1 Non-linear, \delta = 25'); 
saveas(fig5,'Task1_4_Nomoto1_curvefit.eps','epsc');