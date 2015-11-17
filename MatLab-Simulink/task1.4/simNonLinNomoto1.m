function [ r_nomoto_disc ] = simNonLinNomoto1(x, delta_c, tstop, tsamp )
options = simset('SrcWorkspace','current');
sim('NonLinNomoto1',[],options)
end

