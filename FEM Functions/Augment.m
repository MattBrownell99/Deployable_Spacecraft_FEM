function [A_aug, nodes_tot] = Augment(A,Ne,nodes_e)
    
    %Check if a vector was passed for later conditionals
    if size(A,1) == 1 || size(A,2) == 1
        vector = 1;
    else
        vector = 0;
    end
    
    %Initialize augmented matrix
    Av = A;
    
    %Relevant constants
    m = (size(nodes_e,2)-1)*size(nodes_e,1);  %number of new additional nodes per vertical augmentation
    h = (size(nodes_e,2))*size(nodes_e,1);    %number of nodes per element
    
    %Add 'Ne-1' additional elements in the 'y'/vertical direction
    nodes_v = nodes_e;
    for j = 1:(Ne-1)
        
        %Augment 'm' new states
        if vector == 0
            Av = [Av zeros(size(Av,2),m);           
                      zeros(m,size(Av,2)+m)];
            p = size(Av,1) - h + 1; %index where augmentation begins
            Av(p:end,p:end) = Av(p:end,p:end) + A;
        else
            Av = [Av;zeros(m,1)];
            p = size(Av,1) - h + 1; %index where augmentation begins
            Av(p:end) = Av(p:end) + A;
        end

        %Update node index matrix with new appended nodes
        temp = nodes_v(1:(size(nodes_e,2)-1),:) + m*ones(size(nodes_v(1:(size(nodes_e,2)-1),:)));
        nodes_v = [temp; nodes_v];
        
    end
    
    %Rearrange state to better suit augmentation in 'x'/horizontal direction
    [Av,nodes_v_re] = RearrangeState(Av,nodes_v);
    
    %Augment 'Ne-1' additional vertical 'strips' (Av) in the 'x'/horizontal direction
    A_aug = Av;
    m = (size(nodes_v_re,2)-1)*size(nodes_v_re,1);  %number of new additional states each time (with vertical augmentation)
    nodes_tot = nodes_v_re;
    for i = 1:(Ne-1)
        
        n = size(A_aug,1) + m; %new number of total states
        
        %Augment 'm' new states
        if vector == 0
            A_aug = [A_aug; zeros(m,n-m)];
            A_aug = [A_aug zeros(n,m)];
            A_aug((m+1+(i-1)*(m)):end,(m+1+(i-1)*(m)):end) = A_aug((m+1+(i-1)*(m)):end,(m+1+(i-1)*(m)):end) + Av;
        else
            A_aug = [A_aug; zeros(m,1)];
            A_aug((m+1+(i-1)*(m)):end) = A_aug((m+1+(i-1)*(m)):end) + Av;
        end

        temp = nodes_tot(:,(end-(size(nodes_e,2)-1)+1):end) + m*ones(size(nodes_tot(:,(end-(size(nodes_e,2)-1)+1):end)));
        nodes_tot = [nodes_tot temp];
        
    end

end