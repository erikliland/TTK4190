function [ dc_list , r_list ] = NonLinearAnalysis( delta_c_max , n)
    tstart=0;      %Sim start time
    tstop=1000;    %Sim stop time
    tsamp=10;      %Sampling time (NOT ODE solver time step)

    p0=zeros(2,1); %Initial position (NED)
    v0=[6.63 0]';  %Initial velocity (body)
    psi0=0;        %Inital yaw angle
    r0=0;          %Inital yaw rate
    c=0;           %Current on (1)/off (0)
    
    dc_list = linspace(deg2rad(-delta_c_max),deg2rad(delta_c_max),n);
    r_list = zeros(1,n);

    for  i = 1:n
        delta_c = dc_list(i);
        options = simset('SrcWorkspace','current');
        sim('MSFartoystyring',[],options)
        r_list(i) = r(end);
    end
end