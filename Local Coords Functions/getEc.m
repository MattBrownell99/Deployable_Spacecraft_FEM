function E_c = getEc(E,h,nu)

    E_c = (E*h^3/(12*(1-nu^2)))*[1 nu 0;
                        nu 1 0;
                        0 0 (1-nu)/2];

end