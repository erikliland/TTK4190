close all; clear all; clc; scrsz = get(groot,'ScreenSize'); 
OPT = optimset('Display','off'); load('Delta_r_data');
tstart=0;      %Sim start time
tstop=1500;    %Sim stop time
tsamp=20;      %Sampling time (NOT ODE solver time step)

p0=zeros(2,1); %Initial position (NED)
v0=[6.63 0]';  %Initial velocity (body)
psi0=0;        %Inital yaw angle
r0=0;          %Inital yaw rate
c=0;           %Current on (1)/off (0)

%%%%% Curvefitting %%%%%
delta_offset = 0.009; %Constant delta_c input [rad]

% Nomoto 2. ordens lineær model
fig2 = figure('OuterPosition',[scrsz(3)/2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
hold on; grid off; ylabel('Yaw rate [deg/s]'); xlabel('Time [s]');
title('2st order linear Nomoto model compared to ship response','FontSize',14);
delta_list = 2:5:20; %maks +-25deg
legend_string = cell(length(delta_list),1);
for i = 1:length(delta_list) 
    delta_c = deg2rad(delta_list(i));
    sim MSFartoystyring;
    x0 = [118 7.8 18.5 0.185]';
    F2 = @(x,t) simNomoto2(x, delta_c, tstop, tsamp);
    x = lsqcurvefit(F2, x0, t, r,[100 100 0 0],[300 300 400 0.2],OPT);
    T1 = x(1);
    T2 = x(2);
    T3 = x(3);
    K  = x(4);
    plot(t, rad2deg(r),'o' )
    plot(t, rad2deg(F2(x,t)), 'LineWidth',2);
    text(500+delta_list(i)*40, 0.1,{['\delta=', num2str(delta_list(i))],['T1=',num2str(T1,3)],['T2=',num2str(T2,3)],['T3=',num2str(T3,3)],['K=',num2str(K,3)]});
    legend_string{2*i-1} = strcat('Ship, \delta = ',   int2str(delta_list(i)));
    legend_string{2*i}   = strcat('Nomoto1, \delta = ',int2str(delta_list(i)));
end
axis([0 tstop 0 0.55]);
legend(legend_string);
saveas(fig2,'Task1_4_Nomoto2.eps','epsc');

% Nomoto 1. ordens lineær model
fig3 = figure('OuterPosition',[scrsz(3)/2 0 scrsz(3)/2 scrsz(4)/2]);
hold on; grid off; ylabel('Yaw rate [deg/s]'); xlabel('Time [s]');
title('1st order linear Nomoto model compared to ship response','FontSize',14);
delta_list = 2:5:20; %maks +-25deg
legend_string = cell(length(delta_list),1);
for i = 1:length(delta_list) 
    delta_c = deg2rad(delta_list(i));
    sim MSFartoystyring;
    x0 = [100 0.1];
    F3 = @(x,t,delta_c) r0*exp(-t/x(1)) + x(2)* delta_c *(1 - exp(-t/x(1)));
    F4 = @(x,t) F3(x,t,delta_c);
    x = lsqcurvefit(F4, x0, t, r,[20 0],[500 0.15],OPT);
    T = x(1);
    K = x(2);
    plot(t, rad2deg(r),'o');
    plot(t, rad2deg(F4(x,t)),'LineWidth',2);
    text(500+delta_list(i)*40, 0.1,{['\delta=', num2str(delta_list(i))],['T=',num2str(T,3)],['K=',num2str(K,3)]});
    legend_string{2*i-1} = strcat('Ship, \delta = ',   int2str(delta_list(i)));
    legend_string{2*i}   = strcat('Nomoto1, \delta = ',int2str(delta_list(i)));
end
axis([0 tstop 0 0.55]);
legend(legend_string);
saveas(fig3,'Task1_4_Nomoto1.eps','epsc');