function [ u ] = simQuadSurge(x, n_c, tstop, tsamp )
tstart = 0;
options = simset('SrcWorkspace','current');
sim('QuadSurge',[],options)
end

