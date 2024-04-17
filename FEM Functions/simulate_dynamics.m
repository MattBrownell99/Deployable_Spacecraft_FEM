function [x, states_fig] = simulate_dynamics(tspan,A,w0,wd0,Accel)
    
    F_tot = [zeros(size(Accel)); Accel];    %append zeros for setup of 2nd order ODE state = [u; u-dot];
    
    x0 = [w0; wd0];
    opts = odeset('RelTol',1e-12,'AbsTol',1e-14);
    [t,x] = ode45(@(t,x) EOMs(t,tspan(end),x,A,F_tot), tspan, x0, opts);
    
    states_fig = figure();
    %Check if any boundary conditions are applied
    for i = 1:length(x0)/2
        plot(t,x(:,i))
        hold on;
    end
    xlabel('Time [s]')
    ylabel('Nodal Displacement')
    set(gcf,'color','w');
end