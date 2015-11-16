function [ r ] = simNomoto1(x, delta_c, tstop, tsamp )
tstart = 0;
options = simset('SrcWorkspace','current');
sim('Nomoto1',[],options)
end

