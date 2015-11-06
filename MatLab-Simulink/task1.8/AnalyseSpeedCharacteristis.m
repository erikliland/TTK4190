close all; clear all; clc; scrsz = get(groot,'ScreenSize'); 
tstart= 0;                  %Sim start time
tstop = 5000;               %Sim stop time
tsamp = 10;                  %Sampling time (NOT ODE solver time step)

n_c_max = 8.9;              %Propeller shaft max velocity [rad/s](85 rpm)
%[nc_list,u_list] = SurgeSpeedTest(n_c_max, 50, tstop, tsamp);
load('../task1.8/nc_u_data.mat');

F = @(x,t) x*t;
n_c_k = lsqcurvefit(F,1,nc_list,u_list,[],[],optimset('Display','off'));
save('Speed_characteristics','n_c_k')

fig1 = figure('OuterPosition',[scrsz(3)/2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
hold on; xlabel('Propeller shaft speed [rpm]'); ylabel('Speed [m/s]');
plot(nc_list*60/(2*pi),u_list,'o');
t = linspace(0, n_c_max, 100);
plot(t*60/(2*pi),F(n_c_k,t));
legend('Steady state test','Curefittet characteristics');
title('Speed characteristics');
text(50,1,['u(n_c) = ' num2str(n_c_k,2) ' n_c'],'FontSize',14);
saveas(fig1,'Speed_characteristics.eps','epsc');