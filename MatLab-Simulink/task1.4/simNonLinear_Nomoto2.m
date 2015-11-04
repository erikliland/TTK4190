function [ r_nomoto ] = simNonLinear_Nomoto2(T_1, T_2, T_3, K, b_3, b_1, delta_c, tstop, tsamp )
options = simset('SrcWorkspace','current');
sim('NonLinear_Nomoto2',[],options)
end

