function phi = getAssumedModes_anal(m,n,a,b)

    syms x y

    for i = 1:m
        for j = 1:n
            phi(i,j) = sin(i*pi*x/a)*sin(j*pi*y/b);
        end
    end
    
end

