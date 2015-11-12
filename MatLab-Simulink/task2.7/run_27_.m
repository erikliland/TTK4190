close all; clear all; clc; scrsz = get(groot,'ScreenSize');

load('WP.mat');
w_psi = 0.01;
load('../task1.4/Yaw_PID_controller');
load('../task1.8/Speed controller')

tstart = 0;      %Sim start time
tstop = 2600;    %Sim stop time
tsamp = 10;      %Sampling time (NOT ODE solver time step)

p0 = zeros(2,1); %Initial position (NED)
v0 = [6.63 0]';  %Initial velocity (body)
psi0 = 0;        %Inital yaw angle
r0 = 0;          %Inital yaw rate
c = 0;           %Current on (1)/off (0)

%%%% Design values
R = 1200; %THE LOOKAHEAD DISTANCE (R>692m due to initial state)
Ua_MAX = 1; % [m/s];
DELTA_s = 0.01; % should be > 0

sim task2_6

pathplotter(p(:,1), p(:,2),  psi, tsamp, 1, tstart, tstop, 0, WP)

fig3 = figure('OuterPosition',[0 0 scrsz(3)/2 scrsz(4)/2]);
hold on; xlabel('Time [s]'); ylabel('Angle [deg]');
plot(t,rad2deg(psi_d),'--');
plot(t,rad2deg(psi));
plot(t,rad2deg(chi_d),'--');
plot(t,rad2deg(beta));
plot(t,rad2deg(psi_d_f),'-.');
legend('\psi_d','\psi','\chi_d','\beta','\psi_{d_f}');


fig4 = figure('OuterPosition',[scrsz(3)/2 0 scrsz(3)/2 scrsz(4)/2]);
hold on; xlabel('Time [s]'); ylabel('Speed [m/s]');
plot(t,u_d,'--');
plot(t,U_ship(:,1));
plot(t,U_d);
legend('u_d','u','U_d');