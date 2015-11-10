 close all; clear all; clc; scrsz = get(groot,'ScreenSize'); 
tstart= 0;                  %Sim start time
tstop = 4000;               %Sim stop time
tsamp = 10;                  %Sampling time (NOT ODE solver time step)

n_c_max = 8.9;              %Propeller shaft max velocity [rad/s](85 rpm)
if ~exist('nc_u_data.mat','file')
    disp('Kjører SurgeSpeedTest');
    SurgeSpeedTest(n_c_max, 60, tstop, tsamp);
end
load('../task1.8/nc_u_data.mat');

F = @(x,t) x*t;
n_c_k = lsqcurvefit(F,1,nc_list,u_list,[],[],optimset('Display','off'));
save('Speed_characteristics','n_c_k')

fig1 = figure('OuterPosition',[scrsz(3)/2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
hold on; xlabel('Propeller shaft speed [rad/s]'); ylabel('Speed [m/s]');
plot(nc_list,u_list,'o');
t = linspace(0, n_c_max, 2);
plot(t,F(n_c_k,t));
legend('Steady state test','Curefittet characteristics','Location','best');
title('Speed characteristics');
text(5,1,['u(n_c) = ' num2str(n_c_k,2) ' n_c'],'FontSize',14);
saveas(fig1,'Speed_characteristics.eps','epsc');