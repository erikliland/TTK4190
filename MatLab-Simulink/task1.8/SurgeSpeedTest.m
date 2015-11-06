function [ nc_list u_list ] = SurgeSpeedTest( n_c_max, n, tstop, tsamp )
    if n_c_max <= 0
            error('Need a positive shaft rad/s');
    end

    load('../task1.4/H_b_curvefitting');
    %System
    tstart=0;                   %Sim start time
    p0  = zeros(2,1);           %Initial position (NED)
    v0  = [1e-7 0]';            %Initial velocity (body)[m/s]
    psi0= 0;                    %Inital yaw angle [rad]
    r0  = 0;                    %Inital yaw rate [rad]
    c   = 0;                    %Current on (1)/off (0)
    
    %Yaw rate controller
    delta_max=deg2rad(25);      %Ships rudder maximum angle [rad]
    delta_dot_max=deg2rad(0.4); %Ships rudder slew rate     [rad/s]
    r_max=deg2rad(0.35);        %Ships maximum yaw rate (delta_c = max) [rad]
    w_r = deg2rad(0.3);         %r_d 1st order LPF, w_r = -3dB cutoff 
    r_d = deg2rad(0.1);         %Desired yaw rate           [rad/s]
    k_b0 = 0.009;               %Offset compansation            [rad]
    k_b3 = b_2(1);              %Cubic feed forward             [rad/(rad/s)]
    k_b1 = b_2(2);              %Linear feed forward            [rad/(rad/s)]
    k_b2 = b_2(3);              %Quadratic feed forward         [rad/(rad/s)]
    kp_r = 300;                 %Feedback proportional error gain
    ki_r = 1/3;                 %Feedback integral error gain
    kd_r = 5e3;                 %Feedback derivative error gain
    N_r  = deg2rad(0.8);         %Derivatve filter [LPF] cutoff frequency [rad/s]

    %Yaw / Heading controller
    w_psi  = 0.04;              %psi_d 1st order LPF, w_psi = -3dB cutoff 
    psi_s  = deg2rad(45);       %Desired heading [rad]
    psi_t  = 2000;              %Step time
    kp_psi = 15e-3;             %Feedback proportional error gain
    kd_psi = 3;                 %Feedback derivative error gain
    ki_psi = 2e-5;              %Feedback integral error gain
    N_psi  = deg2rad(1);        %Derivative filter [LPF] cutoff frequency [rad/s]
    
    
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
