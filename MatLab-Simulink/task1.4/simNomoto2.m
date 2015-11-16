function [ r ] = simNomoto2(x, delta_c, tstop, tsamp )
tstart = 0;
options = simset('SrcWorkspace','current');
sim('Nomoto2',[],options)
end

