clear all
clc

syms s T K K1 T1 T2 T3

f1 = K / (1 + T*s);
ilaplace(f1)

f2 = K / (s * (1 + T*s));
ilaplace(f2)

f3 = (K1*(1 + T3*s)) / (s*((1 + T1*s) * (1 + T2*s)));

ilaplace(f3)