function [A_aug, nodes_adj] = Matrix_Augment(A,Ne)
    
    %Rearrange stiffness matrix for easier augmentation
    A_shuffle = A;
    A_shuffle([3 4],:) = A_shuffle([4 3],:);
    A_shuffle(:,[3 4]) = A_shuffle(:,[4 3]);
    
    %Initialize augmented matrix
    Ah = A_shuffle;
    
    %Keep indexing of top/bottom states for later use
    nodes = [3 4;
             1 2];
    
    %Add 'N' additional elements in the 'y'/vertical direction
    for j = 1:(Ne-1)
        
        Ah = [Ah zeros(size(Ah,2),2);    %Append 2 state's worth of rows/cols of zeros onto matrix
                  zeros(2,size(Ah,2)+2)];

        m = size(Ah,2) - 4 + 1; %index of first place to add augmented stiffness matrix (corresponding to K11)
        n = m + 4 - 1;          %index of last row to add augmented stiffness matrix (corresponding to K14 of shuffle)
        
        Ah(m:n,m:n) = Ah(m:n,m:n) + A_shuffle;

        curr = [(3 + 2*j) (4 + 2*j)];
        nodes = [curr; nodes];
        
    end
    
    %Rearrange state to better suit augmentation in 'x'/horizontal direction
    Ah = RearrangeState(Ah);
    
    %Augment rows into a rectangle
    A_aug = Ah;
    m = size(A_aug,1)/2;  %number of new additional states each time
    for i = 1:(Ne-1)
        
        A_app = Ah;
        n = size(A_aug,1);    %number new states
        
        A_aug = [A_aug      zeros(n,m); %augment zeros for new states (n/2 == # new states)
                 zeros(m,(n+m))];

        %Augment stiffness matrix 'ontop of' the 'm' shared states and 'm'
        %unshared states
        A_aug((m+1+(i-1)*(m)):(n+m),(m+1+(i-1)*(m)):(n+m)) = A_aug((m+1+(i-1)*(m)):(n+m),(m+1+(i-1)*(m)):(n+m)) + A_app;    %Overlapping part of matrices when augmenting
        
    end
    
    %Can define node-to-vector index easily with a matrix
    nodes_adj = zeros(2 + (Ne-1),2 + (Ne-1));
    k = 1;
    for j = 1:size(nodes_adj,2)
        for i = size(nodes_adj,1):-1:1
            nodes_adj(i,j) = k;
            k = k + 1;
        end
    end

end