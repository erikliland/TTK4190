close all; clear all; clc; OPT = optimset('Display','off');
tstart = 0;       %Sim start time
tstop  = 5000;    %Sim stop time
tsamp  = 50;      %Sampling time (NOT ODE solver time step)

%System
p0  = zeros(2,1);           %Initial position (NED)
v0  = [1e-7 0]';            %Initial velocity (body)[m/s]
psi0= 0;                    %Inital yaw angle [rad]
r0  = 0;                    %Inital yaw rate [rad]
c   = 0;                    %Current on (1)/off (0)

load('../task1.4/Yaw_PID_controller');
scrsz = get(groot,'ScreenSize');


fig1 = figure('OuterPosition',[0 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
hold on; grid off; xlabel('Time [s]'); ylabel('Speed [m/s]'); 
title('1st order linear speed model compared to ship response','FontSize',14);

nc_list = [30 55 80]/60*2*pi;
legend_string = cell(length(nc_list),1);
for i =1:length(nc_list);
    n_c = nc_list(i);
    sim 'SurgeSpeed';
    x0 = [600 1];
    F1 = @(x,t,n_c) x(2)*n_c*(1 - exp(-t/x(1)));
    F2 = @(x,t) F1(x,t,n_c);
    x = lsqcurvefit(F2, x0, t, v(:,1),[],[],OPT);
    plot(t,v(:,1),'o');
    plot(t,F2(x,t),'LineWidth',2);
    text(3000, v(end,1)-0.6, ['T=' num2str(x(1),4) ', K=' num2str(x(2),2)],'FontSize',14);
    legend_string{2*i-1} = strcat('Ship, n_c = ', int2str(nc_list(i)), ' rpm');
    legend_string{2*i}   = strcat('Model n_c = ', int2str(nc_list(i)), ' rpm');
end
legend(legend_string,'Location','NorthWest');
saveas(fig1,'Task1_8_speed_model.eps','epsc');