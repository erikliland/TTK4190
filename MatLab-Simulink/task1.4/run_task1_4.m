close all; clear all; clc; load('../task1.4/H_b_curvefitting.mat'); 

%Yaw / Heading controller (PID)
w_psi = 0.01;               %Ships yaw_d 3.order LPF cut-off frequency
delta_max=deg2rad(25);      %Ships rudder maximum angle [rad]
k_b0 = 0.009;               %Offset compansation [rad]
kp_psi = 90;                %Feedback proportional error gain
ki_psi = 0.8;               %Feedback integral error gain
kd_psi = 500;               %Feedback derivative error gain
%bode(tf([w_d 0],[1 alpha*w_d]),{0.001 1});
save('Yaw_PID_controller'); clear all;

load('Yaw_NonLin_controller');
load('Yaw_PID_controller');

%Simulink
tstart= 0;                  %Sim start time
tstop = 1000;               %Sim stop time
tsamp = 1;                  %Sampling time (NOT ODE solver time step)

%System
p0  = zeros(2,1);           %Initial position (NED)
v0  = [6.63 0]';            %Initial velocity (body)[m/s]
psi0= 0;                    %Inital yaw angle [rad]
r0  = 0;                    %Inital yaw rate [rad]
c   = 0;                    %Current on (1)/off (0)
n_c = 7.3;                  %Propeller shaft speed [rad/s]

%Model
load('H_b_curvefitting');
load('Nomoto2_curvefitting');

sim task1_4

scrsz = get(groot,'ScreenSize');
fig1 = figure('OuterPosition',[0 0 scrsz(3) scrsz(4)]);
subplot(2,2,1); hold on; xlabel('Time [s]'); ylabel('Heading error [deg]');
plot(t,rad2deg(psi_e_PID));
%plot(t,rad2deg(psi_e_PID_m),'-.')
legend('\psi_e','\psi_{e_m}','Location','NorthEast');
title('Yaw error');

subplot(2,2,2); hold on; xlabel('Time [s]'); ylabel('Heading [deg]');
plot(t,rad2deg(psi_d),'-.');
plot(t,rad2deg(psi_d_f),'--');
plot(t,rad2deg(psi));
%plot(t,rad2deg(psi_m),'-.');
legend('\psi_d','\psi_{d_f}','\psi','\psi_m','Location','NorthEast');
title('Yaw controller');

subplot(2,2,3); hold on; xlabel('Time [s]'); ylabel('Angle [deg]');
plot(t,rad2deg(r_e_PID));
%plot(t,rad2deg(r_e_PID_m),'-.');
legend('r_e','r_{e_m}','Location','NorthEast');
title('Yaw rate error');

subplot(2,2,4); hold on; xlabel('Time [s]'); ylabel('Yaw rate [deg/s]');
plot(t,rad2deg(r_d_PID),'--');
plot(t,rad2deg(r));
%plot(t,rad2deg(r_m),'-.');
legend('r_d','r','r_m','Location','NorthEast');
title('Yaw rate controller');
