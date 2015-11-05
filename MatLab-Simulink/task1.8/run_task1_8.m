close all; clear all; clc;
tstart=0;      %Sim start time
tstop=3000;    %Sim stop time
tsamp=10;      %Sampling time (NOT ODE solver time step)

%System
p0=zeros(2,1);%Initial position (NED)
v0=[0.00001 0]';  %Initial velocity (body)[m/s]
psi0=0;     %Inital yaw angle [rad]
r0=0;       %Inital yaw rate [rad]
c=0;        %Current on (1)/off (0)
n_c = 8.9;  %Commanced propeller shaft velocity [rad/s](max +-80 rpm =+- 8.9 rad/s)
n_f = 0.01; %n_c sine frequency [rad/s]
d_c = 0;    %Commanded rudder angle [rad] (max +-25deg = +-0.4363rad)

%Yaw rate controller
r_d = deg2rad(0.3);   %Desired yaw rate [rad/s]
b_1 = 10;
b_3 = 5e8;
kp_r = 0;
ki_r = 0;

%Yaw / Heading controller
psi_d = deg2rad(45);  %Desired heading [rad]
K_p = 1;
K_d = 0;
K_i = 0;
N   = 1; %Derivative filter [LPF] cutoff frequency [rad/s]
%bode(tf([N 0],[1 N]));

%Speed controller
u_d = 5;    %Max speed 8.9 m/s
K_p_u = 3;
K_i_u = 1/400;
K_ff_u= 0.8;
K_d_u = 10;
N_u = 1;

%Estimator
% m * y_dot_dot + beta * y_dot = u
% m*y*s2 + beta * y*s = u
% theta = [m,beta]
% psi = [y_dot_dot, y_dot]
Inital_guess = [0; 0]; %[m;beta]
Gamma = diag([10 10]);

sim task1_8

scrsz = get(groot,'ScreenSize');
fig1 = figure('OuterPosition',[scrsz(3)/2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
hold on;
plot(t,rad2deg(psi));
plot(t,rad2deg(r));
%plot(t,rad2deg(dc)/4);
line([0 tstop],[0 0],'LineStyle','--');
xlabel('Time [s]');
ylabel('Heading [deg]');
legend('Yaw angle','Commanded rudder angle /4','Yaw setpoint','Location','Best');
title('Heading control');


fig2 = figure('OuterPosition',[scrsz(3)/2 0 scrsz(3)/2 scrsz(4)/2]);
hold on;
plot(t,v(:,1));             %Surge speed
line([0 tstop],[u_d, u_d],'LineStyle','--'); %Desired surge speed
xlabel('Time [s]');
ylabel('Speed [m/s]');
legend('Surge velocity','Commanded surge velocity','Location','Best');
title('Speed control');
