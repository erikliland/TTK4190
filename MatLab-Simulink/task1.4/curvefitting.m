%% Curvefitting

close all;


%% Nomoto 1. ordens model

scrsz = get(groot,'ScreenSize');

fig1 = figure('OuterPosition',[scrsz(3)*2/3 scrsz(4)/2 scrsz(3)/3 scrsz(4)/2]);
x0 = [100 0.1]';
F = inline('exp(-t/x(1))*0 + x(2)*25*(1 - exp(-t/x(1)))','x','t');
x = lsqcurvefit(F, x0, t, r);

T = x(1);
K = x(2);

nomoto1 = r0*exp(-t/T) + K*delta_c*(1 - exp(-t/T));
plot(t, r, 'g', t, nomoto1, 'r')
grid on

ylabel('r')
xlabel('time (s)')
legend('Nonlinear model','Estimated 1st-order Nomoto model', 'Location', 'southeast')

%% Nomoto 2. ordens model

fig2 = figure('OuterPosition',[scrsz(3)*2/3 0 scrsz(3)/3 scrsz(4)/2]);
x0 = [550 100 1000 550]';
F = inline('x(4) - (x(4)*exp(-t/x(1))*(x(1) - x(3)))/(x(1) - x(2)) + (x(4)*exp(-t/x(2))*(x(2) - x(3)))/(x(1) - x(2))', 'x', 't');
x = lsqcurvefit(F, x0, t, r);

% estimated parameters
T1 = x(1);
T2 = x(2);
T3 = x(3);
K1 = x(4);

nomoto2 = x(4) - (x(4)*exp(-t/x(1))*(x(1) - x(3)))/(x(1) - x(2)) + (x(4)*exp(-t/x(2))*(x(2) - x(3)))/(x(1) - x(2));
plot(t, r, 'g', t,nomoto2 , 'r')
grid on

ylabel('r')
xlabel('time (s)')
legend('Nonlinear model','Estimated 1st-order Nomoto model', 'Location', 'southeast')