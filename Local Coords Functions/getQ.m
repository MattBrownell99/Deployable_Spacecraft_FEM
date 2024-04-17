function Q = getQ(a,b)

    syms x y xi eta xc yc
    Q = [0 0 0 2 0 0 6*x 2*y 0 0 6*x*y 0;
         0 0 0 0 0 2 0 0 2*x 6*y 0 6*x*y;
         0 0 0 0 2 0 0 4*x 4*y 0 6*x^2 6*y^2];
    Q = subs(Q, x, (a*xi + xc));
    Q = subs(Q, y, (b*eta + yc));
    Q = simplify(Q);
    
end