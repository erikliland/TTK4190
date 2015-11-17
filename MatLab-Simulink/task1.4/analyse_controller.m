close all; clear all; clc; scrsz = get(groot,'ScreenSize'); 
T1 = 130;
T2 = 150;
T3 = 320;
K = 0.03;

sysOL = tf(K*[T3 1],[T1*T2 (T1+T2) 1 0]);
figure(1); bode(sysOL);
[A,B,C,D] = tf2ss(sysOL.num{1},sysOL.den{1});
P = [0 -1 -5];
K = place(A,B,P);
%sysCL = feedback(sysOL
figure(2); bode(sysCL);
