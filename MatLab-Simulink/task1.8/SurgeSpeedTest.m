function SurgeSpeedTest( n_c_max, n, tstop, tsamp )
    if n_c_max <= 0
            error('Need a positive shaft rad/s');
    end
    
    load('../task1.4/Yaw_PID_controller');
    
    %System
    tstart=0;                   %Sim start time
    p0  = zeros(2,1);           %Initial position (NED)
    v0  = [1e-9 0]';            %Initial velocity (body)[m/s]
    psi0= 0;                    %Inital yaw angle [rad]
    r0  = 0;                    %Inital yaw rate [rad]
    c   = 0;                    %Current on (1)/off (0)

    nc_list = linspace(n_c_max*0.01, n_c_max, n);
    u_list = zeros(1,n);
    for i =1:n;
        n_c = nc_list(i);
        options = simset('SrcWorkspace','current');
        sim('SurgeSpeed',[],options)
        u_list(i) = v(end,1);
    end
    save('nc_u_data.mat','nc_list','u_list');
end
