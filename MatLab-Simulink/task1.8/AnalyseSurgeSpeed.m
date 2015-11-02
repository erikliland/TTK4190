function [ shaft_vs_speed ] = AnalyseSurgeSpeed( n_c_max )
    tstart=0;      %Sim start time
    tstop=3000;    %Sim stop time
    tsamp=10;      %Sampling time (NOT ODE solver time step)
    %System
    p0=zeros(2,1);%Initial position (NED)
    v0=[0.00001 0]';  %Initial velocity (body)[m/s]
    psi0=0;     %Inital yaw angle [rad]
    r0=0;       %Inital yaw rate [rad]
    c=0;        %Current on (1)/off (0)
    n_f = 0.01; %n_c sine frequency [rad/s]
    d_c = 0;    %Commanded rudder angle [rad] (max +-25deg = +-0.4363rad)
    psi_d = 0;  %Desired heading [rad]
    r_d=0;      %Desired yaw rate [rad/s]
    %Heading controller
    K_p = 6;
    K_d = 60;
    K_i = 1/60;
    N   = 0.5; %Derivative filter [LPF] cutoff frequency [rad/s]
    %Estimator
    Inital_guess = [0; 0]; %[m;beta]
    Gamma = diag([10 10]);
    
    if n_c_max>8.9
        n_c_max = 8.9;
    elseif n_c_max <= 0
            error('Need a positive shaft rad/s');
    end
    
    n_c_list = n_c_max*0.1:(n_c_max-n_c_max*0.1)/20:n_c_max;
    
    for elm = n_c_list;
    n_c = elm;  %Commanced propeller shaft velocity [rad/s](max +-80 rpm =+- 8.9 rad/s)
    

    sim task1_8
    
 
    maxSpeed = max(v(:,1));
    shaft_vs_speed = [n_c_max maxSpeed];
    
end

