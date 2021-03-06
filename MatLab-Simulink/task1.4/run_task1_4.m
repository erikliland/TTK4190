close all; clear all; clc;

%Yaw / Heading controller (PID)
w_psi = 0.05;               %Ships yaw_d 3.order LPF -9db frequency(-3dB = 0.0253)
delta_max=deg2rad(25);      %Ships rudder maximum angle [rad]
k_b0 = 0.009;               %Offset compansation [rad]
kp_psi = 50;                %Feedback proportional error gain
ki_psi = 0.7;               %Feedback integral error gain
kd_psi = 350;               %Feedback derivative error gain
save('Yaw_PID_controller');

%System
p0  = zeros(2,1);           %Initial position (NED)
v0  = [6.63 0]';            %Initial velocity (body)[m/s]
psi0= 0;                    %Inital yaw angle [rad]
r0  = 0;                    %Inital yaw rate [rad]
c   = 1;                    %Current on (1)/off (0)
n_c = 7.3;                  %Propeller shaft speed [rad/s]

%Model
load('H_b_curvefitting');
k_b3 = b_2(1);
k_b1 = b_2(2);
k_b2 = b_2(3);
load('Nomoto2_curvefitting');


for i = 0:1
    %Simulink
    IN = i;                     %0 = Step, 1 = Sine wave
    tstart= 0;                  %Sim start time
    tstop = 500;                %Sim stop time
    if i==1
        tstop = 2000;
    end
    tsamp = 1;                  %Sampling time (NOT ODE solver time step)
    sim task1_4

    scrsz = get(groot,'ScreenSize');
    fig1 = figure('OuterPosition',[0 0 scrsz(3) scrsz(4)]);
    subplot(2,2,1); hold on; xlabel('Time [s]'); ylabel('Heading error [deg]');
    plot(t,rad2deg(psi_e_PID));
    legend('\psi_e','Location','NorthEast');
    title('Yaw error');

    subplot(2,2,2); hold on; xlabel('Time [s]'); ylabel('Heading [deg]');
    plot(t,rad2deg(psi_d_f),'--');
    plot(t,rad2deg(psi));
    legend('\psi_{d_f}','\psi','Location','NorthEast');
    title('Yaw controller');

    subplot(2,2,3); hold on; xlabel('Time [s]'); ylabel('Yaw rate error [deg/s]');
    plot(t,rad2deg(r_e_PID));
    legend('r_e','Location','NorthEast');
    title('Yaw rate error');

    subplot(2,2,4); hold on; xlabel('Time [s]'); ylabel('Yaw rate [deg/s]');
    plot(t,rad2deg(r_d_PID),'--');
    plot(t,rad2deg(r));
    legend('r_d','r','Location','NorthEast');
    title('Yaw rate controller');
    
    if i == 0
        saveas(fig1,'Task1_4_step.eps','epsc');
    elseif i==1
        saveas(fig1,'Task1_4_sine.eps','epsc');
    end
end