function Circles_straight_lines(x,y,r)
    n_x = length(x);
    n_y = length(y);
    n_r = length(r);
    if ~(n_x == n_y && n_r == n_x-2) error('The length of x,y must be equal and r must be n-2!');
    else n=n_x;
    end
    
    WP = [x;y];
    r_bar = zeros(2,0);
    r_center = zeros(2,0);
    WP_c_s = zeros(2,0);
    WP_c_e = zeros(2,0);
    for i=2:n-1
        A = WP(:,i+1)- WP(:,i-1);
        B = WP(:,i)  - WP(:,i-1);
        C = WP(:,i+1)- WP(:,i)  ;
        a = norm(A);
        b = norm(B);
        c = norm(C);
        alpha = 0.5 * acos((b^2+c^2-a^2)/(2*b*c));
        r_bar(i-1) = r(i-1) * tan(alpha);
        WP_c_s(:,i-1) = WP(:,i) - B/norm(B) * r(i-1);
        angle = atan2(C(2),C(1)) - atan2(B(2),B(1));
        r_center(:,i-1) = WP_c_s(:,i-1) + sign(angle) * ((B/norm(B))'*[0 1;-1 0])'*r_bar(i-1);
    end
    
    %scrsz = get(groot,'ScreenSize');
    %fig1 = figure('OuterPosition',[0 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
    %hold on;
    %plot(y,x,'o');
    %plot(y,x,'-');
    %plot(WP_c_s(2,:),WP_c_s(1,:),'o');
    %plot(r_center(2,:),r_center(1,:),'o');
    circle(r_center(2,1),r_center(1,1),r_bar(1));
    circle(r_center(2,2),r_center(1,2),r_bar(2));
    circle(r_center(2,3),r_center(1,3),r_bar(3));
    %axis equal
    %ylabel('x-coordinate (North)');
    %xlabel('y-coordinate (East)');
    %legend('WP_{dots}','WP_{line}','WP_{intermediate}','R_{center}','C_1','C_2','C_3');
end

