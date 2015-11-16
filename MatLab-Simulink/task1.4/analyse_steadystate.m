close all; clear all; clc; scrsz = get(groot,'ScreenSize'); OPT = optimset('Display','off');

tstart=0;      %Sim start time
tstop=1000;    %Sim stop time
tsamp=10;      %Sampling time (NOT ODE solver time step)

p0=zeros(2,1); %Initial position (NED)
v0=[6.63 0]';  %Initial velocity (body)
psi0=0;        %Inital yaw angle
r0=0;          %Inital yaw rate
c=0;           %Current on (1)/off (0)

% Delta-R plot
if exist('Delta_r_data.mat','file')~=2
    disp('Kjører Delta-r simuleringer');
    delta_c_max = deg2rad(25);
    n=300;
    compensate = 1;
    Run_Delta_R_Sim( delta_c_max , n, compensate, tstop, tsamp)
end
load('Delta_r_data')
fig1 = figure('OuterPosition',[0 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
hold on; grid on; ylabel('Yaw rate [deg/s]'); xlabel('\delta [deg]');
plot(rad2deg(d_list),rad2deg(r_list));
saveas(fig1,'Task1_4_delta_r_plot.eps','epsc');
close(fig1);