function [ d_list , r_list ] = NonLinearAnalysis( delta_c_max , n, compensate, tstop, tsamp)
    tstart=0;      %Sim start time
    p0=zeros(2,1); %Initial position (NED)
    v0=[6.63 0]';  %Initial velocity (body)
    psi0=0;        %Inital yaw angle
    r0=0;          %Inital yaw rate
    c=0;           %Current on (1)/off (0)
    if compensate
        delta_offset = 0.009;
    else
        delta_offset = 0;
    end
    
    d_list = linspace(deg2rad(-delta_c_max),deg2rad(delta_c_max),n);
    r_list = zeros(1,n);

    for  i = 1:n
        delta_c = d_list(i);
        options = simset('SrcWorkspace','current');
        sim('MSFartoystyring',[],options)
        r_list(i) = r(end);
    end
    
    save('Delta_r_data.mat','d_list', 'r_list');
end