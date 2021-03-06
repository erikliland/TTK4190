close all; clear all; clc; scrsz = get(groot,'ScreenSize');

load('WP.mat');
load('../task1.4/Yaw_PID_controller');
load('../task1.8/Speed controller')

tstart = 0;      %Sim start time
tstop = 2700;    %Sim stop time
tsamp = 10;      %Sampling time (NOT ODE solver time step)

p0 = zeros(2,1); %Initial position (NED)
v0 = [6.63 0]';  %Initial velocity (body)
psi0 = 0;        %Inital yaw angle
r0 = 0;          %Inital yaw rate
c = 1;           %Current on (1)/off (0)

%LOS Controler Design Parameters
Delta  = 900;     %Lookahead distance [m]
Ki_LOS = 5e-6;
I_max  = 0.15;

sim task2_3

pathplotter(p(:,1), p(:,2),  psi, tsamp, 10, tstart, tstop, 0, WP)

% fig3 = figure('OuterPosition',[scrsz(3)/3 0 scrsz(3)*2/3 scrsz(4)/2]);
% hold on; xlabel('Time [s]'); ylabel('Angle [deg]');
% plot(t,rad2deg(psi_d),'-.');
% plot(t,rad2deg(psi_d_f),'--');
% plot(t,rad2deg(psi));
% legend('\psi_d','\psi_{d_f}','\psi');
% title('Heading referance following');
% axis tight;
% saveas(fig3,'Task2_3-3','epsc');