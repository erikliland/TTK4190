close all; clear all; clc; scrsz = get(groot,'ScreenSize');

load('WP.mat');
load('../task1.4/Yaw_PID_controller');
load('../task1.8/Speed controller')

tstart  = 0;      %Sim start time
tstop   = 4000;   %Sim stop time
tsamp   = 10;     %Sampling time (NOT ODE solver time step)

p0 = zeros(2,1); %Initial position (NED)
v0 = [6.63 0]';  %Initial velocity (body)
psi0 = 0;        %Inital yaw angle
r0 = 0;          %Inital yaw rate
c = 1;           %Current on (1)/off (0)
U_t = 3;         %Surge speed of the target [m/s]
psi_T = atan2(WP(2,2)-WP(2,1),WP(1,2)-WP(1,1)); %Target course angle
V_t = [3*cos(psi_T) ; 3*sin(psi_T)];

%LOS Controler Design Parameters
R       = 1200;  %Lookhahead distance [m]
Ki_LOS  = 2e-6;  %Integral gain in heading compensator
I_max   = 0.06;  %Maximum effect of integral heading compensator
U_a_max = 4;   %The maximum approach speed towards the target [m/s]
w_u = 0.06;
DELTA_p = 1300;  %Transient interceptor-target rendevuz behavior
D2T     = 500;   %The desired distance between target and interceptor  [m]

sim task2_7

pathplotter(p(:,1), p(:,2),  psi, tsamp, 20, tstart, tstop, 1, WP)

% fig3 = figure('OuterPosition',[0 0 scrsz(3)/2 scrsz(4)/2]);
% hold on; xlabel('Time [s]'); ylabel('Angle [deg]');
% plot(t,rad2deg(chi_d),'--');
% plot(t,rad2deg(psi_d),'--');
% plot(t,rad2deg(psi_d_f),'-.');
% plot(t,rad2deg(psi));
% plot(t,rad2deg(beta_f));
% legend('\chi_d','\psi_d','\psi_{d_f}','\psi','\beta_f');

% fig4 = figure('OuterPosition',[scrsz(3)/2 0 scrsz(3)/2 scrsz(4)/2]);
% hold on; xlabel('Time [s]'); ylabel('Speed [m/s]');
% plot(t,U_d);
% plot(t,u_d,'-.');
% plot(t,u_d_f,'--');
% plot(t,U_ship(:,1));
% legend('U_d','u_d','u_d_f','u','Location','best');