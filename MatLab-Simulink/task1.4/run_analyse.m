close all; clear all; clc; scrsz = get(groot,'ScreenSize'); OPT = optimset('Display','off');

tstart=0;      %Sim start time
tstop=1000;    %Sim stop time
tsamp=10;      %Sampling time (NOT ODE solver time step)

p0=zeros(2,1); %Initial position (NED)
v0=[6.63 0]';  %Initial velocity (body)
psi0=0;        %Inital yaw angle
r0=0;          %Inital yaw rate
c=0;           %Current on (1)/off (0)

% Delta-R plot
if exist('Delta_r_data.mat','file')~=2
    disp('Kjører Delta-r simuleringer');
    delta_c_max = deg2rad(25);
    n=300;
    compensate = 1;
    Run_Delta_R_Sim( delta_c_max , n, compensate, tstop, tsamp)
end
load('Delta_r_data')
fig1 = figure('OuterPosition',[0 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
hold on; grid on; ylabel('Yaw rate [deg/s]'); xlabel('\delta [deg]');
plot(rad2deg(d_list),rad2deg(r_list));
saveas(fig1,'Task1_4_delta_r_plot.eps','epsc');
close(fig1);

%%%%% Curvefitting %%%%%
delta_offset = 0.009; %Constant delta_c input [rad]

% Nomoto 2. ordens lineær model
fig2 = figure('OuterPosition',[scrsz(3)/2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
hold on; grid off; ylabel('Yaw rate [deg/s]'); xlabel('Time [s]');
title('2st order linear Nomoto model compared to ship response','FontSize',14);

for delta = 5:10:25
    delta_c = deg2rad(delta); %maks +-25deg
    sim MSFartoystyring;
    x0 = [2000 100 3000 50]';
    F1 = @(x,t,delta_c) delta_c*(x(4)-(x(4)*exp(-t/x(1))*(x(1)-x(3)))/(x(1)-x(2))+(x(4)*exp(-t/x(2))*(x(2)-x(3)))/(x(1)-x(2)));
    F2 = @(x,t) F1(x,t,delta_c);
    x = lsqcurvefit(F2, x0, t, r,[],[],OPT);
    T1 = x(1);
    T2 = x(2);
    T3 = x(3);
    K  = x(4);
    plot(t, rad2deg(r),'o' )
    plot(t, rad2deg(F2(x,t)), 'LineWidth',2);
end
axis([0 tstop 0 0.55]);
legend( 'Ship, \delta = 5' ,'Nomoto2, \delta = 5', ...
        'Ship, \delta = 15','Nomoto2, \delta = 15',...
        'Ship, \delta = 25','Nomoto2, \delta = 25'); 
saveas(fig2,'Task1_4_Nomoto2.eps','epsc');

% Nomoto 1. ordens lineær model
fig3 = figure('OuterPosition',[scrsz(3)/2 0 scrsz(3)/2 scrsz(4)/2]);
hold on; grid off; ylabel('Yaw rate [deg/s]'); xlabel('Time [s]');
title('1st order linear Nomoto model compared to ship response','FontSize',14);

for delta = 5:10:25 %maks +-25deg
    delta_c = deg2rad(delta);
    sim MSFartoystyring;
    x0 = [50 0.1];
    F3 = @(x,t,delta_c) r0*exp(-t/x(1)) + x(2)* delta_c *(1 - exp(-t/x(1)));
    F4 = @(x,t) F3(x,t,delta_c);
    x = lsqcurvefit(F4, x0, t, r,[],[],OPT);
    T = x(1);
    K = x(2);
    plot(t, rad2deg(r),'o');
    plot(t, rad2deg(F4(x,t)),'LineWidth',2);
end
axis([0 tstop 0 0.55]);
legend( 'Ship, \delta = 5' ,'Nomoto1, \delta = 5', ...
        'Ship, \delta = 15','Nomoto1, \delta = 15',...
        'Ship, \delta = 25','Nomoto1, \delta = 25'); 
saveas(fig3,'Task1_4_Nomoto1.eps','epsc');

% Nomoto 2. ordens ulineær model [delta-r steady state]
if ~exist('d_list','var')
    load('Delta_r_data.mat');
end
b_1_0 = [800e3 12];
F5 = @(b,xdata) b(1) * xdata.^3 + b(2) * xdata;
b_1 = lsqcurvefit(F5, b_1_0, r_list, d_list,[],[],OPT);

b_2_0 = [800e3 1 10];
F6 = @(b,xdata) b(1) * xdata.^3 + b(2) * xdata + b(3) * xdata.^2;
b_2 = lsqcurvefit(F6, b_2_0, r_list, d_list,[0 0 0],[],OPT);
save('H_b_curvefitting','b_1','b_2');

fig4 = figure('OuterPosition',[0 0 scrsz(3)/2 scrsz(4)/2]);
hold on; title('Non-linear maneuvering characteristics model compared to ship response','FontSize',14);
t = linspace(-0.0075118, 0.0075118, 300);
plot(rad2deg(d_list),rad2deg(r_list),'--'); %plot(rad2deg(d_list),rad2deg(r_list),'o');
plot(rad2deg(F5(b_1,t)),rad2deg(t));        %plot(rad2deg(F5(b_1,t)),rad2deg(t) ,'o');
plot(rad2deg(F6(b_2,t)),rad2deg(t));        %plot(rad2deg(F6(b_2,t)),rad2deg(t) ,'o');
xlabel('Rudder [deg]'); ylabel('Yaw rate [deg/s]');
line([0 -25; 0 25],[-0.45 0; 0.45 0],'Color','black','LineStyle','--');
axis([-25 25 -0.45 0.45]);
legend('Ship characteristics','1. and 3.degree approximation','1. 2. and 3.degree approximation','Location','best');
text(-15,0.2,{'1. and 3. degree coefficients', ['b_3=' num2str(b_1(1),3)], ['b_1=' num2str(b_1(2),3)] });
text(10,-0.2,{'1., 2. and 3. degree coefficients', ['b_3=' num2str(b_2(1),3)], ['b_2=' num2str(b_2(3),3)], ['b_1=' num2str(b_2(2),3)] });
saveas(fig4,'Task1_4_Nomoto2_delta_r.eps','epsc');

%fig5 = figure('OuterPosition',[0 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
%hold on; title('Linearization function r -> \delta','FontSize',14);
%plot(rad2deg(r_list),rad2deg(d_list),'--');     plot(rad2deg(r_list),rad2deg(d_list)            ,'o');
%plot(rad2deg(t),rad2deg(F5(b_1,t))); plot(rad2deg(t),rad2deg(F5(b_1,t))   ,'o');
%plot(rad2deg(t),rad2deg(F6(b_2,t))); plot(rad2deg(t),rad2deg(F6(b_2,t))   ,'o');
%ylabel('Rudder [deg]'); xlabel('Yaw rate [deg/s]');

% Nomoto 2. ordens ulineær model [step response]
fig6 = figure('OuterPosition',[0 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
hold on; grid off; ylabel('Yaw rate [deg/s]'); xlabel('Time [s]');
title('2st order non-linear Nomoto model compared to ship response','FontSize',14);

for delta = 5:10:25
    delta_c = deg2rad(delta); %maks +-25deg
    sim MSFartoystyring;
    x0 = [70 80 168 0.1 b_1(1) b_1(2)]';
    F7 = @(x,t) simNonLinear_Nomoto2( x(1), x(2), x(3), x(4), x(5), x(6), delta_c, tstop, tsamp );
    x = lsqcurvefit(F7, x0, t, r,[],[],OPT);
    T1 = x(1);
    T2 = x(2);
    T3 = x(3);
    K  = x(4);
    plot(t, rad2deg(r),'o' )
    plot(t, rad2deg(F7(x,t)),'LineWidth',2);
end
axis([0 tstop 0 0.55]);
legend( 'Ship, \delta = 5' ,'Nomoto2, \delta = 5', ...
        'Ship, \delta = 15','Nomoto2, \delta = 15',...
        'Ship, \delta = 25','Nomoto2, \delta = 25'); 
saveas(fig6,'Task1_4_Nomoto2_curvefit.eps','epsc');

save('Nomoto2_curvefitting','T1','T2','T3','K');

% Nomoto 1. ordens ulineær model
fig7 = figure('OuterPosition',[0 0 scrsz(3)/2 scrsz(4)/2]);
hold on; grid off; xlabel('Rudder [deg]'); ylabel('Yaw rate [deg/s]');
title('1st order non-linear Nomoto model compared to ship response','FontSize',14);
for delta = 5:10:25 %maks +-25deg
    delta_c = deg2rad(delta);
    sim MSFartoystyring;
    x0 = [50 0.1]';
    F8 = @(x,t) simNonLinear_Nomoto1(x(1), x(2), delta_c, tstop, tsamp);
    x = lsqcurvefit(F8, x0, t, r,[],[],OPT);
    T = x(1);
    K = x(2);
    plot(t, rad2deg(r),'o');
    plot(t, rad2deg(F8(x,t)),'LineWidth',2);
end
axis([0 tstop 0 0.55]);
legend( 'Ship, \delta = 5' ,'Nomoto1 Non-linear, \delta = 5', ...
        'Ship, \delta = 15','Nomoto1 Non-linear, \delta = 15',...
        'Ship, \delta = 25','Nomoto1 Non-linear, \delta = 25'); 
saveas(fig7,'Task1_4_Nomoto1_curvefit.eps','epsc');