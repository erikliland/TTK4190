close all; clear all; clc;
tstart=0;      %Sim start time
tstop=1000;    %Sim stop time
tsamp=10;      %Sampling time (NOT ODE solver time step)


p0=zeros(2,1);%Initial position (NED)
v0=[0.00001 0]';  %Initial velocity (body)[m/s]
psi0=0;     %Inital yaw angle [rad]
r0=0;       %Inital yaw rate [rad]
c=0;        %Current on (1)/off (0)
n_c = 8.9;   %propeller shaft velocity [rad/s] (max +- 8.9)
sim task1_8

scrsz = get(groot,'ScreenSize');
fig1 = figure('OuterPosition',[0 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
plot(p(:,2),p(:,1));

fig1 = figure('OuterPosition',[scrsz(3)/2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
plot(t,v(:,1));