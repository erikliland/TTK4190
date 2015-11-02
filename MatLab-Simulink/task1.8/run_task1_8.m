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
psi_d = 0;  %Desired heading [rad]
r_d=0;      %Desired yaw rate [rad/s]

%Heading controller
K_p = 6;
K_d = 60;
K_i = 1/60;
N   = 0.5; %Derivative filter [LPF] cutoff frequency [rad/s]
%bode(tf([N 0],[1 N]));

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
plot(t,rad2deg(dc)/4);
line([0 tstop],[0 0],'LineStyle','--');
xlabel('Time [s]');
ylabel('Heading [deg]');
legend('Yaw angle','Commanded rudder angle /4','Yaw setpoint','Location','Best');
title('Heading control');


fig2 = figure('OuterPosition',[scrsz(3)/2 0 scrsz(3)/2 scrsz(4)/2]);
hold on;
plot(t,v(:,1)); %Surge
plot(t,v(:,2)); %Sway
plot(t,nc);     %Commanded shaft velocity
maxSpeed = max(v(:,1));
line([0 tstop],[maxSpeed maxSpeed],'LineStyle','--');
text(50,maxSpeed*0.95,['Max speed = ' num2str(maxSpeed,2) ' m/s'],'FontSize',14);
xlabel('Time [s]');
ylabel('Speed [m/s]');
legend('Surge velocity','Sway velocity','Commanded shaft velocity','Max speed','Location','Best');
title('Speed control');

% fig3 = figure('OuterPosition',[0 0 scrsz(3)/2 scrsz(4)]);
% subplot(2,1,1);
% plot(theta_hat(:,1));
% xlabel('Time [s]');
% ylabel('Value');
% legend('Mass estimate','Location','Best');
% subplot(2,1,2);
% plot(theta_hat(:,2));
% xlabel('Time [s]');
% ylabel('Value');
% legend('\beta estimate','Location','Best');
