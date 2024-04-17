function [phi, phi_f] = getAssumedModes()

    syms x y
    %phi = [1 x y x*y x^2 y^2 x^2*y y^3 x^3].';
    phi = [1 x y x*y].';
    phi = simplify(phi);
    phi_f = matlabFunction(phi);
    
end