function [ r_nomoto_disc ] = simNonLinear_Nomoto1(T , K , delta_c, tstop, tsamp )
options = simset('SrcWorkspace','current');
sim('NonLinear_Nomoto1',[],options)
end

