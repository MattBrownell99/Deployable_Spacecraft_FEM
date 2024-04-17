function A33 = get3by3(A)
    
    if size(A,1) > 1 && size(A,2) > 1
        
        A33 = cell(4);

        %Loop over the singular-element 12x12 stiffness matrix
        for i = 1:3:size(A,1)
            for j = 1:3:size(A,1)

                A33((i+2)/3, (j+2)/3) = {A(i:i+2,j:j+2)};

            end
        end
        
    else
        
        A33 = cell(4,1);

        %Loop over the singular-element 12x1 force vector
        for i = 1:3:size(A,1)

                A33((i+2)/3, 1) = {A(i:i+2,1)};

        end
        
    end

end