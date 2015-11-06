close all; clear all; clc; load WP;
tstart=1;      %Sim start time
tstop=77500;    %Sim stop time
tsamp=10;      %Sampling time (NOT ODE solver time step)

p0=zeros(2,1); %Initial position (NED)
v0=[6.63 0]';  %Initial velocity (body)
psi0=0;        %Inital yaw angle
r0=0;          %Inital yaw rate
c=0;           %Current on (1)/off (0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wb_h = 2*0.022; %|Hs_h|=0dB <-> wc_h
zeta_h = 1;
% 
wn_h = 1.56 *wb_h;
T = 187;
K = 0.0431;
Kp_heading = (T/K *wn_h^2);
Kd_heading = 2 * zeta_h*T-1;
Ki_heading = wn_h/10 *Kp_heading;

Kp_speed = 2;
Ki_speed = 0;
sim('MSFartoystyring2')
pathplotter(p(:,1),p(:,2),psi,tsamp,1,tstart,tstop,0,WP)