close all; clear all; clc; 

%Speed controller
w_u = 0.011;                    %u_d LPF -9dB frequency
load('Speed_characteristics');  %Propeller force feed forwar koefficient
n_c_max = 8.9;                  %Propeller shaft max velocity [rad/s](85 rpm)
n_dot_max = deg2rad(2.5);       %Propeller shaft max acceleration [rad/s2]               
Kp_u = 20;                      %Feedback proportional error gain
Ki_u = 0.1;                     %Feedback integral error gain
save('Speed controller')        %Store tuning for later tasks

load('../task1.4/Yaw_PID_controller'); 
scrsz = get(groot,'ScreenSize');

%Simulation
tstart= 0;                  %Sim start time
tstop = 2000;               %Sim stop time
tsamp = 10;                  %Sampling time (NOT ODE solver time step)

%System
p0  = zeros(2,1);           %Initial position (NED)
v0  = [4 0]';               %Initial velocity (body)[m/s]
psi0= 0;                    %Inital yaw angle [rad]
r0  = 0;                    %Inital yaw rate [rad]
c   = 1;                    %Current on (1)/off (0)

sim task1_8

fig1 = figure('OuterPosition',[0 scrsz(4)/2 scrsz(3)/2 scrsz(4)]);
subplot(2,1,1); hold on; xlabel('Time [s]'); ylabel('Speed [m/s]');
plot(t,u_e);
legend('u_e','Location','Best');

subplot(2,1,2); hold on; xlabel('Time [s]'); ylabel('Speed [m/s]');
plot(t,u_d,'-.');
plot(t,u_d_f,'--');
plot(t,v(:,1));
legend('u_d','u_{d_f}','u','Location','Best');
saveas(fig1,'Task1_8_sim.eps','epsc');