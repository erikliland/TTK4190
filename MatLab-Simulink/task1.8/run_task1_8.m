close all; clear all; clc; scrsz = get(groot,'ScreenSize'); load('../task1.4/H_b_curvefitting.mat');
tstart= 0;                  %Sim start time
tstop = 5000;               %Sim stop time
tsamp = 10;                  %Sampling time (NOT ODE solver time step)

%System
p0  = zeros(2,1);           %Initial position (NED)
v0  = [0.001 0]';           %Initial velocity (body)[m/s]
psi0= 0;                    %Inital yaw angle [rad]
r0  = 0;                    %Inital yaw rate [rad]
c   = 0;                    %Current on (1)/off (0)

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
w_psi  = deg2rad(0.2);      %psi_d 1st order LPF, w_psi = -3dB cutoff 
psi_s  = deg2rad(45);       %Desired heading [rad]
psi_t  = 2000;              %Step time
kp_psi = 15e-3;             %Feedback proportional error gain
kd_psi = 3;                 %Feedback derivative error gain
ki_psi = 2e-5;              %Feedback integral error gain
N_psi  = deg2rad(1);        %Derivative filter [LPF] cutoff frequency [rad/s]

%Speed controller
n_c_max = 8.9;              %Propeller shaft max velocity [rad/s](85 rpm)
n_dot_max = deg2rad(2.5);   %Propeller shaft max acceleration [rad/s2]
u_max = 8.9;                %Ship´s max speed [m/s]
w_u = deg2rad(0.2);         %u_d 1st order LPF, w_u = -3dB cutoff 
u_d = 5;                    %Max speed ~ 8.9 m/s
K_ff_u= 1.1;                %Feed forward proportional gain
K_p_u = 5;                  %Feedback proportional error gain
K_i_u = 1e-3;               %Feedback integral error gain
K_d_u = 0;                  %Feedback derivative error gain
N_u = deg2rad(1);           %Derivative filter [LPF] cutoff frequency [rad/s]

sim task1_8

fig1 = figure('OuterPosition',[scrsz(3)/2 scrsz(4)/2 scrsz(3)/2 scrsz(4)]);
subplot(3,1,1); hold on; xlabel('Time [s]'); ylabel('Heading [deg]');
plot(t,rad2deg(psi_d),'--');
plot(t,rad2deg(psi));
legend('\psi_d','\psi','Location','Best');
title('Yaw controller');

subplot(3,1,2); hold on; xlabel('Time [s]'); ylabel('Yaw rate [deg/s]');
plot(t,rad2deg(rd),'--');
plot(t,rad2deg(r));
legend('r_d','r','Location','Best');
title('Yaw rate controller');

subplot(3,1,3); hold on; xlabel('Time [s]'); ylabel('Angle [deg]');
plot(t,rad2deg(-dc));
legend('\delta_c','Location','Best');
title('Rudder');

fig2 = figure('OuterPosition',[0 scrsz(4)/2 scrsz(3)/2 scrsz(4)]);
subplot(2,1,1); hold on; xlabel('Time [s]'); ylabel('Speed [m/s]');
plot(t,ud,'--');
plot(t,v(:,1));
legend('u_d','u','Location','Best');
title('Speed control');

subplot(2,1,2); hold on; xlabel('Time [s]'); ylabel('Shaft speed [rpm]');
plot(t,nc*60/(2*pi));
legend('n_c','Location','Best');
title('Propeller');