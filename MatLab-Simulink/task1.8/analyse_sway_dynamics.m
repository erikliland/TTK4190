close all; clear all; clc; scrsz = get(groot,'ScreenSize'); 
OPT = optimset('Display','off');
tstart=0;      %Sim start time
tstop=1300;    %Sim stop time
tsamp=20;      %Sampling time (NOT ODE solver time step)

p0=zeros(2,1); %Initial position (NED)
v0=[6.63 0]';  %Initial velocity (body)
psi0=0;        %Inital yaw angle
r0=0;          %Inital yaw rate
c=0;           %Current on (1)/off (0)

%%%%% Curvefitting %%%%%
delta_offset = 0.009; %Constant delta_c input [rad]
load('../task1.4/Heading_model.mat');
load('../task1.8/Speed controller.mat');

% Nomoto 2. ordens lineær sway model
fig1 = figure('OuterPosition',[0 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
hold on; grid off; ylabel('Sway velocity [m/s]'); xlabel('Time [s]');
title('2st order linear Nomoto sway model compared to ship response','FontSize',14);
delta_list = 2:4:16; %maks +-25deg
legend_string = cell(length(delta_list),1);
coeff_mtx = zeros(2,length(delta_list));
for i = 1:length(delta_list) 
    delta_c = deg2rad(delta_list(i));
    sim MSFartoystyring_sine;
    x0 = [10 198]';
    F2 = @(x,t) simNomoto2_sway(x,T1,T2,delta_c, tstop, tsamp );
    x = lsqcurvefit(F2, x0, t, v,[0 0],[],OPT);
    T_v = x(1);
    K_v = x(2);
    plot(t, v,'o' )
    plot(t, F2(x,t), 'LineWidth',2);
    coeff_mtx(:,i) = [T_v K_v]';
    text(450+delta_list(i)*40, 0.4,{['\delta=', num2str(delta_list(i))],['T_v=',num2str(T_v,3)],['K_v=',num2str(K_v,3)]});
    legend_string{2*i-1} = strcat('Ship, \delta = ',   int2str(delta_list(i)));
    legend_string{2*i}   = strcat('Nomoto2-v, \delta = ',int2str(delta_list(i)));
end
legend(legend_string);
saveas(fig1,'Task2_3_Nomoto2_sway.eps','epsc');
coeff_mean = mean(coeff_mtx,2);
T_v = coeff_mtx(1,1);
K_v = coeff_mtx(2,2);
save('Sway_model','T_v','K_v');
