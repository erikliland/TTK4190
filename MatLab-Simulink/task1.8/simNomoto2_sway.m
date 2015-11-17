function [ v ] = simNomoto2_sway(x,T1,T2,delta_c, tstop, tsamp )
tstart = 0;
options = simset('SrcWorkspace','current');
sim('Nomoto2_sway',[],options)
end

