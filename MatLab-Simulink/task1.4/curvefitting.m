
figure(1)
x0 = [0.01 0.1]';
F = inline('x(2)*(1-exp(-t*x(1)))','x','t');
x = lsqcurvefit(F,x0, t, r);

% estimated parameters
T = 1/x(1)
K = x(2)

plot(t, r, 'g', t, x(2)*(1-exp(-t*x(1))), 'r')
grid on

title('Nonlinear least-squares fit of Mariner model for \delta = 5 (deg)')
xlabel('time (s)')
legend('Nonlinear model','Estimated 1st-order Nomoto model', 'Location', 'southeast')

figure(2)
x0 = [550 100 1000 550]';
F = inline('x(4) - (x(4)*exp(-t/x(1))*(x(1) - x(3)))/(x(1) - x(2)) + (x(4)*exp(-t/x(2))*(x(2) - x(3)))/(x(1) - x(2))', 'x', 't');
x = lsqcurvefit(F, x0, t, r);

% estimated parameters
T1 = x(1)
T2 = x(2)
T3 = x(3)
K = x(4)

figure(2),
plot(t, r, 'g', t, x(4) - (x(4)*exp(-t/x(1))*(x(1) - x(3)))/(x(1) - x(2)) + (x(4)*exp(-t/x(2))*(x(2) - x(3)))/(x(1) - x(2)), 'r')
grid on

title('Nonlinear least-squares fit of Mariner model for \delta = 5 (deg)')
xlabel('time (s)')
legend('   Nonlinear model','Estimated 1st-order Nomoto model', 'Location', 'southeast')