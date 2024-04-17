function F_aug = Vector_Augment(F,Ne)
    
    %Rearrange vector for easier augmentation
    F_shuffle = F;
    
    %Initialize augmented vector
    Fh = F_shuffle;
    
    nodes = [7 8 9;
             4 5 6;
             1 2 3];
    
    m = (size(nodes,2)-1)*size(nodes,1);
    n = (size(nodes,2))*size(nodes,1);
    for i = 1:(Ne-1)
        Fh = [Fh; zeros(m,1)];
        Fh(end-n+1:end) = Fh(end-n+1:end) + F_shuffle;
    end
    
    %rearrange state according to how nodes were redefined in the matrix
    %augmentation process for consistency of state order
    Fh = RearrangeState(Fh);
    
    %Augment all rows into rectangle
    F_aug = Fh;
    n = size(F_aug,1);
    m = (size(F_aug,1)/(size(nodes,2)))*(size(nodes,2)-1);
    for i = 1:(Ne-1)
        F_aug = [F_aug; zeros(m,1)];
        F_aug(end-n+1:end) = F_aug(end-n+1:end) + Fh;
    end

end