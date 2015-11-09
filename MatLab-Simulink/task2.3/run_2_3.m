close all; clear all; clc;

load('WP.mat');
load('../task1.4/Yaw and Yaw-rate controller');
load('../task1.8/Speed controller')

tstart = 0;      %Sim start time
tstop = 4000;    %Sim stop time
tsamp = 10;      %Sampling time (NOT ODE solver time step)

p0 = zeros(2,1); %Initial position (NED)
v0 = [6.63 0]';  %Initial velocity (body)
psi0 = 0;        %Inital yaw angle
r0 = 0;          %Inital yaw rate
c = 0;           %Current on (1)/off (0)

sim task2_3

%pathplotter(p(:,1), p(:,2),  psi, tsamp, 1, tstart, tstop, 0, WP)

fig1 = figure(3); 
hold on;
plot(t,psi_d_f);
plot(t,psi);
