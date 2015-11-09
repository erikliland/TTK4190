close all; clear all; clc; load('../task1.4/H_b_curvefitting.mat');

%Yaw rate controller
delta_max=deg2rad(25);      %Ships rudder maximum angle [rad]
delta_dot_max=deg2rad(0.4); %Ships rudder slew rate     [rad/s]
r_max=deg2rad(0.35);        %Ships maximum yaw rate (delta_c = max) [rad]
w_r = deg2rad(0.3);         %r_d 1st order LPF, w_r = -3dB cutoff 
r_d = deg2rad(0.1);         %Desired yaw rate           [rad/s]
k_b0 = 0.009;               %Offset compansation            [rad]
k_b3 = b_2(1);              %Cubic feed forward             [rad/(rad/s)]
k_b1 = b_2(2);              %Linear feed forward            [rad/(rad/s)]
k_b2 = b_2(3);              %Quadratic feed forward         [rad/(rad/s)]
kp_r = 300;                 %Feedback proportional error gain
ki_r = 1/3;                 %Feedback integral error gain
kd_r = 5e3;                 %Feedback derivative error gain
N_r  = deg2rad(0.8);         %Derivative filter [LPF] cutoff frequency [rad/s]
 
%Yaw / Heading controller
w_psi  = 0.04;              %psi_d 1st order LPF, w_psi = -3dB cutoff 
psi_s  = deg2rad(45);       %Desired heading [rad]
psi_t  = 2000;              %Step time
kp_psi = 15e-3;             %Feedback proportional error gain
kd_psi = 3;                 %Feedback derivative error gain
ki_psi = 2e-5;              %Feedback integral error gain
N_psi  = deg2rad(1);        %Derivative filter [LPF] cutoff frequency [rad/s]
save('Yaw_NonLin_controller'); clear all;

%Yaw / Heading controller (PID)
delta_max=deg2rad(25);      %Ships rudder maximum angle [rad]
k_b0 = 0.009;               %Offset compansation [rad]
kp_psi = 1200;              %Feedback proportional error gain
ki_psi = 0.8;               %Feedback integral error gain
kd_psi = 500;               %Feedback derivative error gain
save('Yaw_PID_controller'); clear all;

load('Yaw_NonLin_controller');
load('Yaw_PID_controller');

%Simulink
tstart= 0;                  %Sim start time
tstop = 1500;               %Sim stop time
tsamp = 1;                  %Sampling time (NOT ODE solver time step)

%System
p0  = zeros(2,1);           %Initial position (NED)
v0  = [6.63 0]';            %Initial velocity (body)[m/s]
psi0= 0;                    %Inital yaw angle [rad]
r0  = 0;                    %Inital yaw rate [rad]
c   = 1;                    %Current on (1)/off (0)
n_c = 7.3;                  %Propeller shaft speed [rad/s]

%Model
load('H_b_curvefitting');
load('Nomoto2_curvefitting');

sim task1_4

scrsz = get(groot,'ScreenSize');
fig1 = figure('OuterPosition',[0 0 scrsz(3) scrsz(4)]);
subplot(2,2,1); hold on; xlabel('Time [s]'); ylabel('Heading error [deg]');
plot(t,rad2deg(psi_e_PID));
plot(t,rad2deg(psi_e_PID_m),'-.')
legend('\psi_e','\psi_{e_m}','Location','NorthEast');
title('Yaw error');

subplot(2,2,2); hold on; xlabel('Time [s]'); ylabel('Heading [deg]');
plot(t,rad2deg(psi_d),'--');
plot(t,rad2deg(psi));
plot(t,rad2deg(psi_m),'-.');
legend('\psi_d','\psi','\psi_m','Location','NorthEast');
title('Yaw controller');

subplot(2,2,3); hold on; xlabel('Time [s]'); ylabel('Angle [deg]');
plot(t,rad2deg(r_e_PID));
plot(t,rad2deg(r_e_PID_m),'-.');
legend('r_e','r_{e_m}','Location','NorthEast');
title('Yaw rate error');

subplot(2,2,4); hold on; xlabel('Time [s]'); ylabel('Yaw rate [deg/s]');
plot(t,rad2deg(r_d_PID),'--');
plot(t,rad2deg(r));
plot(t,rad2deg(r_m),'-.');
legend('r_d','r','r_m','Location','NorthEast');
title('Yaw rate controller');
