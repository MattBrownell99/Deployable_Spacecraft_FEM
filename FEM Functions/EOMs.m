function xdot = EOMs(t,tf,x,A,Accel)
    
    n = length(x)/2;
    
    A_tot = [zeros(n,n), eye(n);
            A, zeros(n,n)];
        
    xdot = A_tot*x + Accel;

    t/tf*100
    
end