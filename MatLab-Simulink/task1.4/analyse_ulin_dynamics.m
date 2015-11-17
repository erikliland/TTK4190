close all; clear all; clc; scrsz = get(groot,'ScreenSize'); 
OPT = optimset('Display','off'); load('Delta_r_data');
tstart=0;      %Sim start time
tstop=1200;    %Sim stop time
tsamp=10;      %Sampling time (NOT ODE solver time step)

p0=zeros(2,1); %Initial position (NED)
v0=[6.63 0]';  %Initial velocity (body)
psi0=0;        %Inital yaw angle
r0=0;          %Inital yaw rate
c=0;           %Current on (1)/off (0)

%%%%% Curvefitting %%%%%
delta_offset = 0.009; %Constant delta_c input [rad]

% Delta-r steady state
if ~exist('r_list_c','var')
    disp('Laster inn Delta_r_data_c');
    load('Delta_r_data_c.mat');
end
b_1_0 = [800e3 12];
F5 = @(b,xdata) b(1) * xdata.^3 + b(2) * xdata;
b_1 = lsqcurvefit(F5, b_1_0, r_list_c, d_list,[1e5 0],[inf inf],OPT);

b_2_0 = [800e3 1 10];
F6 = @(b,xdata) b(1) * xdata.^3 + b(2) * xdata + b(3) * xdata.^2;
b_2 = lsqcurvefit(F6, b_2_0, r_list_c, d_list,[1e5 0 0],[inf inf inf],OPT);
save('H_b_curvefitting','b_1','b_2');

fig4 = figure('OuterPosition',[scrsz(3)/2 0 scrsz(3)/2 scrsz(4)/2]);
hold on; title('Non-linear maneuvering characteristics model compared to ship response','FontSize',14);
t = linspace(-0.0075118, 0.0075118, 300);
plot(rad2deg(d_list),rad2deg(r_list_c),'--'); 
plot(rad2deg(F5(b_1,t)),rad2deg(t));        
plot(rad2deg(F6(b_2,t)),rad2deg(t));
xlabel('Rudder [deg]'); ylabel('Yaw rate [deg/s]');
line([0 -25; 0 25],[-0.45 0; 0.45 0],'Color','black','LineStyle','--');
axis([-25 25 -0.45 0.45]);
legend('Ship characteristics','1. and 3.degree approximation','1. 2. and 3.degree approximation','Location','best');
text(-15,0.2,{'1. and 3. degree coefficients', ['b_3=' num2str(b_1(1),3)], ['b_1=' num2str(b_1(2),3)] });
text(10,-0.2,{'1., 2. and 3. degree coefficients', ['b_3=' num2str(b_2(1),3)], ['b_2=' num2str(b_2(3),3)], ['b_1=' num2str(b_2(2),3)] });
saveas(fig4,'Task1_4_Nomoto2_delta_r.eps','epsc');

% Nomoto 2. ordens ulineær model [step response]
fig6 = figure('OuterPosition',[0 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
hold on; grid off; ylabel('Yaw rate [deg/s]'); xlabel('Time [s]');
title('2st order non-linear Nomoto model compared to ship response','FontSize',14);

delta_list = 2:5:20; %maks +-25deg
legend_string = cell(length(delta_list),1);
for i = 1:length(delta_list)
    delta_c = deg2rad(delta_list(i));
    sim MSFartoystyring;
    x0 = [100 100 0.1]';
    F7 = @(x,t) simNonLinNomoto2(x,b_2(1),b_2(3),b_2(2), delta_c, tstop, tsamp );
    x = lsqcurvefit(F7, x0, t, r,[30 30 0],[500 500 0.3],OPT);
    T1 = x(1);
    T2 = x(2);
    K  = x(3);
    plot(t, rad2deg(r),'o' )
    plot(t, rad2deg(F7(x,t)),'LineWidth',2);
    text(300+delta_list(i)*40, 0.1,{['\delta=', num2str(delta_list(i))],['T1=',num2str(T1,3)],['T2=',num2str(T2,3)],['K=',num2str(K,3)]});
    legend_string{2*i-1} = strcat('Ship, \delta = ',   int2str(delta_list(i)));
    legend_string{2*i}   = strcat('NonLinNomoto2, \delta = ',int2str(delta_list(i)));
end
axis([0 tstop 0 0.55]);
legend(legend_string);
saveas(fig6,'Task1_4_Nomoto2_curvefit.eps','epsc');
save('Nomoto2_curvefitting','T1','T2','K');

%% Nomoto 1. ordens ulineær model
fig7 = figure('OuterPosition',[0 0 scrsz(3)/2 scrsz(4)/2]);
hold on; grid off; xlabel('Rudder [deg]'); ylabel('Yaw rate [deg/s]');
title('1st order non-linear Nomoto model compared to ship response','FontSize',14);

delta_list = 2:5:20; %maks +-25deg
legend_string = cell(length(delta_list),1);
for i = 1:length(delta_list)
    delta_c = deg2rad(delta_list(i));
    sim MSFartoystyring;
    x0 = [50 0.1]';
    F8 = @(x,t) simNonLinNomoto1(x, delta_c, tstop, tsamp);
    x = lsqcurvefit(F8, x0, t, r,[0 0],[400 1],OPT);
    T = x(1);
    K = x(2);
    plot(t, rad2deg(r),'o');
    plot(t, rad2deg(F8(x,t)),'LineWidth',2);
    text(300+delta_list(i)*40, 0.1,{['\delta=', num2str(delta_list(i))],['T=',num2str(T,3)],['K=',num2str(K,3)]});
    legend_string{2*i-1} = strcat('Ship, \delta = ',   int2str(delta_list(i)));
    legend_string{2*i}   = strcat('NonLinNomoto1, \delta = ',int2str(delta_list(i)));
end
axis([0 tstop 0 0.55]);
legend(legend_string); 
saveas(fig7,'Task1_4_Nomoto1_curvefit.eps','epsc');