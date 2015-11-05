%% Controller for yaw_rate (r)
N=0.1;
Kp_r = 1;
Kd_r = 0;
Ki_r = 0;
sim('PID-controller')


%% Controller for yaw_angle (psi) will be made afterwards












%% OLD crap
% % PID controller
% %Open loop tranfer function for the 2nd Nomoto model
% T1 = 187;
% T2 = 120.2;
% T3 = 275.9;
% K1 = 0.0431;
% figure(4)
% Hs_h = tf([0 0 K1*T3 K1],[T1*T2 T1+T2 1 0])
% bode(Hs_h)
% 
% wb_h = 2*0.022; %|Hs_h|=0dB <-> wc_h
% zeta_h = 1;
% 
% wn_h = 1.56 *wb_h;
% 
% %Kp_h = (T/K *wn_h^2);
% %Kd_h = 2 * zeta_h*T-1;
% %Ki_h = wn_h/10 *Kp_h;
% 
% sim 