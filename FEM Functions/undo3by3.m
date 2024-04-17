%Inverse of 'get3by3' function that divides matrix into 3x3 sub matrices
function A = undo3by3(A33)
    
    n = size(A33{1,1},1);
    m = size(A33{1,1},2);
    if n > 1 && m > 1
        A = zeros(3*size(A33));
    else
        A = zeros(3*size(A33,1),1);
    end
    
    for i = 1:size(A33,1)
        for j = 1:size(A33,2)
            if size(A,1) > 1 && size(A,2) > 1
                A((3*i-2):3*i, (3*j-2):3*j) = A33{i,j};
            else
                A((3*i-2):3*i) = A33{i,j};
            end
        end
    end

end