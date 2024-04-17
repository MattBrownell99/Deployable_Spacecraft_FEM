%Rearrange the vertically augmented state vector in a new form that makes 
%horzontal augmentation easier
function [A_re, nodes_re] = RearrangeState(A,nodes)

    A_re = A;
    
    %Define desired version of node state
    nodes_re = zeros(size(nodes));
    k = 1;
    for j = 1:size(nodes,2)
        for i = size(nodes,1):-1:1
            nodes_re(i,j) = k;
            k = k + 1;
        end
    end
    
    %Define node arrays as vectors
    order = [];
    order_re = [];
    nodes_T = nodes';
    for i = size(nodes,1):-1:1
        order = [order nodes(i,:)];
    end
    for i = 1:size(nodes,2)
        order_re = [order_re flip(nodes(:,i)')];
    end
    
    
    %Rearrange state to desired and swap rows/columns
    for i = 1:length(order)
        if order(i) ~= order_re(i)
            j = find(order == order_re(i));
            if size(A_re,2) > 1
                A_re(:,[i j])= A_re(:,[j i]);
            end
            A_re([i j],:)= A_re([j i],:);
            order(:,[i j])= order(:,[j i]);
        end
    end

end