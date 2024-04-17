function xdot = EOMs(t,tf,x,A,F)
    
    n = length(x)/2;
    
    A_tot = [zeros(n,n), eye(n);
            A, zeros(n,n)];

    xdot = A_tot*x + F;

    t/tf*100
    
end