function [ r_nomoto ] = simNonLinNomoto2(x, b_3,b_2,b_1, delta_c, tstop, tsamp )
options = simset('SrcWorkspace','current');
sim('NonLinNomoto2',[],options)
end

