close all; clear all; clc; scrsz = get(groot,'ScreenSize'); 

tstart=0;      %Sim start time
tstop=1000;    %Sim stop time
tsamp=10;      %Sampling time (NOT ODE solver time step)

p0=zeros(2,1); %Initial position (NED)
v0=[6.63 0]';  %Initial velocity (body)
psi0=0;        %Inital yaw angle
r0=0;          %Inital yaw rate
c=0;           %Current on (1)/off (0)

% %%% r-delta plot
[dc, r] = NonLinearAnalysis(25, 90);
fig3 = figure('OuterPosition',[0 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
hold on; grid on; ylabel('Yaw rate [deg/s]'); xlabel('\delta [deg]');
plot(rad2deg(dc),rad2deg(r));
saveas(fig3,'Task1_4 delta_r_plot.eps','epsc');

%% %%% Curvefitting %%%%%
tstart=0;      %Sim start time
tstop=2000;    %Sim stop time
tsamp=10;      %Sampling time (NOT ODE solver time step)

delta_c = deg2rad(20); %maks +-25deg
sim MSFartoystyring;

% Nomoto 1. ordens model
x0 = [100 0.1]';
F_1 = @(x,t,delta_c) x(2)*delta_c*(1 - exp(-t/x(1)));
F_2 = @(x,t) F_1(x,t,delta_c);
x = lsqcurvefit(F_2, x0, t, r);
T = x(1);
K = x(2);
nomoto1 = r0*exp(-t/T) + K*delta_c*(1 - exp(-t/T));

fig1 = figure('OuterPosition',[scrsz(3)*2/3 scrsz(4)/2 scrsz(3)/3 scrsz(4)/2]);
hold on; grid on; ylabel('Yaw rate [deg/s]'); xlabel('Time [s]');
plot(t, rad2deg(r)); 
plot(t, rad2deg(nomoto1));
legend('Ship','Estimated 1st-order Nomoto model', 'Location', 'southeast');

% Nomoto 2. ordens model
fig2 = figure('OuterPosition',[scrsz(3)*2/3 0 scrsz(3)/3 scrsz(4)/2]);
hold on; grid on; ylabel('Yaw rate [deg/s]'); xlabel('Time [s]');
for delta = 5:10:25
    delta_c = deg2rad(delta); %maks +-25deg
    sim MSFartoystyring;
    
    x0 = [2000 100 3000 50]';
    F_3 = @(x,t,delta_c) delta_c*(x(4) - (x(4)*exp(-t/x(1))*(x(1) - x(3)))/(x(1) - x(2)) + (x(4)*exp(-t/x(2))*(x(2) - x(3)))/(x(1) - x(2)));
    F_4 = @(x,t) F_3(x,t,delta_c);
    x = lsqcurvefit(F_4, x0, t, r);
    T1 = x(1);
    T2 = x(2);
    T3 = x(3);
    K1 = x(4);
    nomoto2 = delta_c * (K1 - (K1*exp(-t/T1)*(T1 - T3))/(T1 - T2) + (K1*exp(-t/T2)*(T2 - T3))/(T1 - T2));
    
    plot(t, rad2deg(r))
    plot(t,rad2deg(nomoto2));
    legend('Ship','Estimated 2st-order Nomoto model', 'Location', 'southeast')
end

