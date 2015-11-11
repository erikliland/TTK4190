close all; clear all; clc; scrsz = get(groot,'ScreenSize');

load('WP.mat');
load('../task1.4/Yaw_PID_controller');
load('../task1.8/Speed controller')

tstart = 0;      %Sim start time
tstop = 4000;    %Sim stop time
tsamp = 10;      %Sampling time (NOT ODE solver time step)

p0 = zeros(2,1); %Initial position (NED)
v0 = [6.63 0]';  %Initial velocity (body)
psi0 = 0;        %Inital yaw angle
r0 = 0;          %Inital yaw rate
c = 1;           %Current on (1)/off (0)

sim task2_3

pathplotter(p(:,1), p(:,2),  psi, tsamp, 1, tstart, tstop, 0, WP)

fig3 = figure('OuterPosition',[0 0 scrsz(3)/2 scrsz(4)/2]);
hold on; xlabel('Time [s]'); ylabel('Angle [deg]');
plot(t,rad2deg(psi_d),'--');
plot(t,rad2deg(psi));
legend('\psi_d','\psi');
