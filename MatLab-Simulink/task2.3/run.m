clear all
close all
clc

tstart = 0;      %Sim start time
tstop = 2900;    %Sim stop time
tsamp = 10;      %Sampling time (NOT ODE solver time step)

p0 = zeros(2,1); %Initial position (NED)
v0 = [6.63 0]';  %Initial velocity (body)
psi0 = 0;        %Inital yaw angle
r0 = 0;          %Inital yaw rate
c = 0;           %Current on (1)/off (0)

load('WP.mat');

Ki_speed = -3;
Kp_speed = -100;

Ki = 0.8;
Kp = 90;
Kd = 500;

sim MSFartoystyring

pathplotter(p(:,1), p(:,2),  psi, tsamp, 1, tstart, tstop, 0, WP)
