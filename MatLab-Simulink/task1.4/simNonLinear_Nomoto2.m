function [ r_nomoto ] = simNonLinear_Nomoto2(T1, T2, T3, K, b_3, b_1, delta_c, tstop, tsamp )
options = simset('SrcWorkspace','current');
sim('NonLinear_Nomoto2',[],options)
end

